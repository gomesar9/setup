# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Propósito

Automação pessoal com Ansible para instalar e manter configurações em máquinas Linux (Debian/Ubuntu). O entry-point é `ansible/main.yml`, que aplica o role `gar.user`. Há também um role `srv1` para configuração de servidor.

## Comandos principais

### Executar o playbook na máquina local

```bash
# Pré-requisito: criar o venv e instalar dependências
export PYTHON_SYS_TMP_VENV="$HOME/.system-tmp-venv"
python3 -m venv "$PYTHON_SYS_TMP_VENV"
"${PYTHON_SYS_TMP_VENV}/bin/pip3" install ansible-core ansible-dev-tools python-debian

# Executar
"${PYTHON_SYS_TMP_VENV}/bin/ansible-playbook" -i ~/inventory.yml ansible/main.yml
```

### Testar com Docker (fluxo principal de desenvolvimento)

```bash
./run.sh          # sobe o container e abre shell interativo (derruba ao sair)
```

Dentro do container, o alias para re-executar o playbook é:

```bash
alias ansync="ansible-playbook -i ${HOME}/inventory.yml /opt/ansible/main.yml"
ansync
```

O `compose.yml` monta `./v_home` como `/home/userx/` e `./ansible/` como `/opt/ansible`, então alterações no playbook refletem imediatamente sem rebuild.

Para rebuild completo da imagem:

```bash
docker compose build
```

### Executar uma task específica por tag

```bash
ansync --tags go        # exemplo: reinstalar só o Go
```

## Arquitetura

### Estrutura do role `gar.user`

```
ansible/gar.user/
  tasks/
    main.yml                        # Orquestrador principal — inclui todas as sub-tasks
    install/
      apt/default.yml               # Pacotes via APT (bat, ripgrep, zsh, tmux, etc.)
      from-gh/install_release.yml   # Instalador genérico de releases do GitHub
      go.yml / pyenv.yml / nvm.yml  # Instaladores específicos com lógica própria
      discord.yml / lens.yml / ...  # Outros instaladores pontuais
    config/
      eza.yml / fzf.yml / nvm.yml / pyenv.yml  # Tasks de configuração pós-install
      apt.yml                       # Garante apt-transport-https
    voice/                          # Stack de ditado por voz local (main.yml orquestra)
      deps.yml / whisper-cpp.yml / model.yml / vocab.yml / ollama.yml /
      daemon.yml / piper.yml / claude-hook.yml / hotkey.yml
  files/home/user/                  # Dotfiles e configs copiados para ~/
    config/{bash,nvim,zsh,eza,voice-stack,...}
    rcfiles/gomesrc.sh / zshrc.sh
    local/bin/                      # Scripts de usuário (ex: change-eza-theme, voice-*)
  templates/home/user/             # Templates Jinja (ex: unit systemd da voz)
  vars/tool_config.yml / voice.yml  # Variáveis de configuração
```

### Stack de ditado por voz (`tasks/voice/`)

Ditado local p/ Claude Code (spec: `plans/voice-dev-stack-spec.md`). Entrada: mic → Silero VAD → whisper.cpp (`pt`) → refino Ollama → `xdotool`. Saída: hook Stop → Piper TTS. Vars em `vars/voice.yml`; rode isolado com `ansync --tags voice`. Portabilidade CPU→GPU por variável (`voice_device`, `whisper_model`, `torch_version`).

**Convenção de tags:** `include_tasks` **não** propaga as tags da diretiva às tasks incluídas. Para que `--tags X` execute o conteúdo de um include, use `apply:` — não basta `tags:` no include:

```yaml
- name: "..."
  ansible.builtin.include_tasks:
    file: voice/deps.yml
    apply:
      tags: [voice, install]
  tags: [voice, install]
```

### Instalador genérico do GitHub (`install_release.yml`)

Todas as ferramentas baixadas do GitHub usam o mesmo template. As variáveis obrigatórias são:

| Variável | Descrição |
|---|---|
| `gh_tool_name` | Nome legível |
| `gh_tool_repo` | URL do repositório |
| `gh_tool_version_command` | Shell command que retorna a versão instalada |
| `gh_tool_final_path` | Destino do binário |
| `gh_tool_download_file_name` | Nome do arquivo no release (suporta `${VERSION}`) |
| `gh_tool_extracted_rel_file_path` | Caminho do binário dentro do tar |

Opcionais: `gh_tool_desired_version` (fixa versão), `gh_tool_symlink_path`, `gh_tool_unarchive_options`, `support_files`.

A lógica: consulta a versão mais recente via redirect do GitHub → compara com a versão local → baixa e instala apenas se necessário.

### Ambiente de teste Docker

- `Dockerfile`: imagem Debian 12, roda `init.sh` para instalar Ansible, cria usuário `userx`, executa o playbook.
- `compose.yml`: usa volumes para `./v_home` e `./ansible/` — permite iterar sem rebuild.
- `base_v_home/inventory.yml`: inventory usado no build da imagem.
- `v_home/inventory.yml`: inventory usado em tempo de execução (via volume).

**Nunca rode o playbook no host — só no container.**

**Gotchas ao testar (aprendidos na marca):**

1. **`ansible-playbook` não está no PATH** dentro do container — fica em `/opt/system-tmp-venv/bin/`. Chamar `ansible-playbook` pelado dá `command not found` (vira no-op silencioso). Use o caminho completo ou o alias `ansync`.
2. **O build full do Dockerfile quebra no Debian 12** porque `install/apt/default.yml` lista pacotes Qt6 `t64` (`libqt6core6t64`, etc.) que só existem no Ubuntu 24.04+. No host real (Linux Mint/Ubuntu) funciona. Para testar **só uma parte** sem o bootstrap completo, use uma imagem throwaway que copia `./ansible` + roda `init.sh` mas **omite** o `RUN ansible-playbook`, depois `docker exec ... --tags <X>`.
3. **Capture o exit code direto**, sem pipe: `docker run ... bash -lc '...'; echo "EXIT=$?"`. Encadear `| tail`/`| grep` mascara o código de saída do ansible (`PIPESTATUS`). Confie no `PLAY RECAP` (`failed=N`) e no exit do `ansible-playbook`.
4. **Idempotência**: rode 2×; a 2ª deve dar `changed=0`. `pip: state=latest` sempre reporta `changed` — use `state=present` quando quiser idempotência.
5. **torch/torchaudio CPU**: instale o par **casado** (mesma versão, ex. `2.8.0`) do índice `download.pytorch.org/whl/cpu` **com** `--extra-index-url https://pypi.org/simple` (o índice pytorch serve `typing-extensions` com metadata inconsistente e quebra a resolução). Sem o par casado, a ABI do `_torchaudio.so` quebra (`undefined symbol: aoti_torch_abi_version`).

### Problemas conhecidos

- Em Ubuntu 24.04+ o pacote `libasound2` foi renomeado para `libasound2t64` (mudança do "Ano 2038"). Se o Discord falhar, alterar em `tasks/install/discord.yml`.
- Os pacotes Qt6 `t64` em `install/apt/default.yml` (Synergy deps) só existem no Ubuntu 24.04+ — impedem o build da imagem de teste Debian 12 (ver Gotcha 2 acima).

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- ALWAYS read graphify-out/GRAPH_REPORT.md before reading any source files, running grep/glob searches, or answering codebase questions. The graph is your primary map of the codebase.
- IF graphify-out/wiki/index.md EXISTS, navigate it instead of reading raw files
- For cross-module "how does X relate to Y" questions, prefer `graphify query "<question>"`, `graphify path "<A>" "<B>"`, or `graphify explain "<concept>"` over grep — these traverse the graph's EXTRACTED + INFERRED edges instead of scanning files
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
