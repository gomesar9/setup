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

# Teste

Para facilitar utilize o script `./run.sh`, ao conectar no container execute os comandos:
```
alias ansync="ansible-playbook -i ${HOME}/inventory.yml /opt/ansible/main.yml"
ansync
```

[gh-tree-sitter-cli]: https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md
