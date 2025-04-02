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

# Teste

Para facilitar utilize o script `./run.sh`, ao conectar no container execute os comandos:
```
alias ansync="ansible-playbook -i ${HOME}/inventory.yml /opt/ansible/main.yml"
ansync
```


[gh-tree-sitter-cli]: https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md
