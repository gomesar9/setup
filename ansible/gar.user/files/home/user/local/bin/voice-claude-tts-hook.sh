#!/usr/bin/env bash
# Hook de saída do Claude Code (evento Stop): lê a última resposta do assistente
# do transcript e a envia ao Piper (voice-speak). Spec §7.7.
#
# O Claude Code chama este script com um JSON em stdin contendo, entre outros,
# "transcript_path" (JSONL das mensagens). Extraímos o último texto do assistant.
# ⚠️ Schema de hooks muda com frequência — ajuste se necessário (spec §9).
set -euo pipefail

payload="$(cat)"

# jq é dependência leve; se ausente, sai silenciosamente.
command -v jq >/dev/null 2>&1 || exit 0

transcript="$(printf '%s' "$payload" | jq -r '.transcript_path // empty')"
[[ -z "$transcript" || ! -f "$transcript" ]] && exit 0

# Pega a última linha cuja mensagem é do assistant e concatena os blocos de texto.
text="$(jq -rs '
    map(select(.message.role == "assistant"))
    | last
    | (.message.content // [])
    | if type == "array" then
        map(select(.type == "text") | .text) | join("\n")
      else . end
' "$transcript" 2>/dev/null || true)"

[[ -z "$text" || "$text" == "null" ]] && exit 0

printf '%s' "$text" | "$HOME/.local/bin/voice-speak" || true
