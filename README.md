# SETUP


## Pacotes gerenciados:
- neovim
- pyenv
  - pyenv-virtualenv
  - global python set to 3.12.8
- lua
- luarocks
- flameshot (via apt)
- kubectl
- fzf


### Pacotes a serem adicionados:
- [tree-sitter-cli][gh-tree-sitter-cli]
- go
- sdk-manager
- minikube
  - cert-manager
- lens
- discord
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
