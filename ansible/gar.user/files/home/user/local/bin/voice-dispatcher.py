#!/usr/bin/env python3
"""Daemon de ditado por voz local (voice-to-code).

Pipeline (spec plans/voice-dev-stack-spec.md §3.1):
    mic -> Silero VAD (segmenta fala) -> whisper.cpp (pt travado, vocab custom)
        -> refino via Ollama -> xdotool type (injeta no terminal em foco)

Controle de sessão (push-to-talk): SIGUSR1 liga/desliga a captura. No modo
`continuous` a captura fica sempre ligada. Configuração toda por variáveis de
ambiente, injetadas pela unit systemd (ver voice-dictation.service.j2).
"""

import os
import queue
import signal
import subprocess
import sys
import tempfile
import wave

import numpy as np
import requests
import sounddevice as sd
from silero_vad import VADIterator, load_silero_vad

SAMPLE_RATE = 16000
FRAME = 512  # amostras por janela do VAD (~32ms @ 16kHz)


def env(name, default=None):
    return os.environ.get(name, default)


CFG = {
    "whisper_bin": env("VOICE_WHISPER_BIN", "/usr/local/bin/whisper-cli"),
    "model": env("VOICE_WHISPER_MODEL", os.path.expanduser(
        "~/.local/share/whisper/ggml-small.bin")),
    "language": env("VOICE_LANGUAGE", "pt"),
    "vocab_path": env("VOICE_VOCAB_PATH", os.path.expanduser(
        "~/.config/voice-stack/vocab.txt")),
    "refine_prompt_path": env("VOICE_REFINE_PROMPT_PATH", os.path.expanduser(
        "~/.config/voice-stack/refine_prompt.txt")),
    "ollama_url": env("VOICE_OLLAMA_URL", "http://localhost:11434"),
    "ollama_model": env("VOICE_OLLAMA_MODEL", "qwen2.5:3b"),
    "activation": env("VOICE_ACTIVATION", "push_to_talk"),
    "trigger_enabled": env("VOICE_TRIGGER_ENABLED", "false").lower() == "true",
    "trigger_word": env("VOICE_TRIGGER_WORD", "").strip().lower(),
    "pidfile": env("VOICE_PIDFILE", os.path.expanduser(
        "~/.local/share/voice-stack/dispatcher.pid")),
}

# Sessão ligada por padrão no modo continuous; desligada no push-to-talk.
session_active = CFG["activation"] == "continuous"
audio_q: "queue.Queue[np.ndarray]" = queue.Queue()


def log(*a):
    print("[voice]", *a, file=sys.stderr, flush=True)


def toggle_session(signum, frame):
    global session_active
    session_active = not session_active
    log("sessão", "ON" if session_active else "OFF")


def read_file(path, default=""):
    try:
        with open(path, encoding="utf-8") as fh:
            return fh.read().strip()
    except OSError:
        return default


def transcribe(samples: np.ndarray) -> str:
    """Roda whisper.cpp em um trecho de fala e devolve o texto."""
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        wav_path = tmp.name
    try:
        pcm = np.clip(samples * 32768.0, -32768, 32767).astype(np.int16)
        with wave.open(wav_path, "wb") as wf:
            wf.setnchannels(1)
            wf.setsampwidth(2)
            wf.setframerate(SAMPLE_RATE)
            wf.writeframes(pcm.tobytes())

        cmd = [
            CFG["whisper_bin"], "-m", CFG["model"],
            "-l", CFG["language"], "-nt", "-f", wav_path,
        ]
        vocab = read_file(CFG["vocab_path"])
        if vocab:
            cmd += ["--prompt", vocab]
        out = subprocess.run(cmd, capture_output=True, text=True, check=False)
        if out.returncode != 0:
            log("whisper erro:", out.stderr.strip()[:300])
            return ""
        return out.stdout.strip()
    finally:
        try:
            os.unlink(wav_path)
        except OSError:
            pass


def refine(text: str) -> str:
    """Refina a transcrição via Ollama (símbolos falados -> caracteres)."""
    prompt_tmpl = read_file(CFG["refine_prompt_path"])
    if not prompt_tmpl:
        return text
    try:
        resp = requests.post(
            f"{CFG['ollama_url']}/api/generate",
            json={
                "model": CFG["ollama_model"],
                "prompt": f"{prompt_tmpl}\n\nTexto:\n{text}",
                "stream": False,
            },
            timeout=60,
        )
        resp.raise_for_status()
        return resp.json().get("response", text).strip() or text
    except requests.RequestException as exc:
        log("ollama indisponível, usando texto cru:", exc)
        return text


def apply_trigger(text: str):
    """Aplica salvaguarda de palavra-gatilho (spec §3.3)."""
    if not CFG["trigger_enabled"] or not CFG["trigger_word"]:
        return text
    low = text.lower()
    tw = CFG["trigger_word"]
    if not low.startswith(tw):
        return None
    return text[len(tw):].lstrip(" ,.:")


def inject(text: str):
    subprocess.run(["xdotool", "type", "--clearmodifiers", "--", text],
                   check=False)


def handle_segment(samples: np.ndarray):
    raw = transcribe(samples)
    if not raw:
        return
    log("raw:", raw)
    text = refine(raw)
    text = apply_trigger(text)
    if not text:
        log("descartado (sem trigger)")
        return
    log("inject:", text)
    inject(text + " ")


def audio_cb(indata, frames, time_info, status):
    if status:
        log("audio status:", status)
    audio_q.put(indata[:, 0].copy())


def main():
    os.makedirs(os.path.dirname(CFG["pidfile"]), exist_ok=True)
    with open(CFG["pidfile"], "w", encoding="utf-8") as fh:
        fh.write(str(os.getpid()))
    signal.signal(signal.SIGUSR1, toggle_session)

    log("carregando Silero VAD…")
    model = load_silero_vad()
    vad = VADIterator(model, sampling_rate=SAMPLE_RATE)

    speech = []
    collecting = False
    log(f"pronto (modo={CFG['activation']}). SIGUSR1 alterna sessão.")

    with sd.InputStream(samplerate=SAMPLE_RATE, channels=1, dtype="float32",
                        blocksize=FRAME, callback=audio_cb):
        while True:
            chunk = audio_q.get()
            if not session_active:
                if collecting:  # sessão desligada no meio: descarta buffer
                    speech, collecting = [], False
                continue
            ev = vad(chunk, return_seconds=False)
            if ev and "start" in ev:
                collecting = True
                speech = [chunk]
            elif collecting:
                speech.append(chunk)
                if ev and "end" in ev:
                    handle_segment(np.concatenate(speech))
                    speech, collecting = [], False


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
