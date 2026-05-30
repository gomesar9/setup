# SETUP

## Pacotes gerenciados:

- discord
- flameshot (via apt)
- fzf
- go
- kubectl
- lens
- lua
- luarocks
- neovim
  - config de plugins
- pyenv
  - global python set to 3.12.8
  - pyenv-virtualenv

### Pacotes a serem adicionados:

- [tree-sitter-cli][gh-tree-sitter-cli]
- sdk-manager
- minikube
  - cert-manager
- telegram
- synergy
- app launcher (krunner, rofi..)?
- dbeaver-ce
- zellij

- script para upgrade automatico de dbeaver (https://dbeaver.io/download/?start&os=linux&arch=x86_64&dist=deb)

# Uso

```
sudo apt install -y software-properties-common gpg curl sudo python3-pip python3-venv
python3 -m venv ./
./bin/pip3 install ansible-core ansible-dev-tools python-debian
ansible-playbook ./ansible
```

## Problemas conhecidos

Em S.Os mais novos pode ser que as libs requeridas pelo Discord não estejam mais disponíveis. No Ubuntu 24.04, por exemplo, o pacote libasound2 foi substituído por libasound2t64. Essa mudança foi implementada para resolver o problema do "Ano 2038", atualizando diversas bibliotecas para suportarem valores de tempo de 64 bits. Nesse caso utilizar as libs com `t64` no final, como mostra o diff:

```
--- a/ansible/gar.user/tasks/install/discord.yml
+++ b/ansible/gar.user/tasks/install/discord.yml
@@ -13,8 +13,8 @@
     - name: "Install Discord dependencies"
       ansible.builtin.apt:
         name:
-          - libasound2
+          - libasound2t64
           - libnotify4
         state: present
         update_cache: true
```

# Voice-to-code (ditado local)

Stack de ditado por voz **100% local** integrada ao Claude Code no terminal (Linux Mint / Cinnamon / X11). Spec completo em `plans/voice-dev-stack-spec.md`.

**Fluxo:** mic → Silero VAD → whisper.cpp (`pt` travado) → refino via Ollama → `xdotool` injeta no terminal. Saída: respostas do Claude Code lidas pelo Piper TTS (voz pt-BR).

```
ansync --tags voice          # instala/configura só a stack de voz
```

- **Pré-requisitos:** Ollama já instalado e rodando (não é instalado pela stack). Microfone e DBus de usuário (não funciona no container — tasks de áudio/systemd/atalho são puladas).
- **Variáveis:** tudo em `ansible/gar.user/vars/voice.yml` (modelo, idioma, device, modelo do Ollama, atalho, palavra-gatilho).
- **Personalização** (não sobrescrita em re-runs):
  - `~/.config/voice-stack/vocab.txt` — vocabulário (`initial_prompt` do whisper).
  - `~/.config/voice-stack/refine_prompt.txt` — prompt de refino do Ollama.
- **Uso:** atalho global (`<Super>v` por padrão) liga/desliga a sessão de ditado via `voice-toggle`.
- **Migração CPU → GPU (RTX 5070):** em `vars/voice.yml` troque `voice_device: cuda`, `whisper_model: large-v3`, `ollama_refine_model` por um maior e rode `ansync --tags voice`. O whisper.cpp recompila sozinho (marker de build) e o modelo maior é baixado. Requer CUDA Toolkit ≥ 12.8 (Blackwell `sm_120`) e troca manual do wheel do `torch` pela variante CUDA no venv.

**Limitações** (spec §8): ditado denso de símbolos ainda pode exigir correção manual; escuta contínua capta ruído do ambiente (mitigado pela palavra-gatilho); blocos de código são pulados por padrão no TTS.

# Teste

Para facilitar utilize o script `./run.sh`, ao conectar no container execute os comandos:

```
alias ansync="ansible-playbook -i ${HOME}/inventory.yml /opt/ansible/main.yml"
ansync
```

[gh-tree-sitter-cli]: https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md
