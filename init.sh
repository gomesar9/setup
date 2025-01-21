#!/bin/bash

# Sair caso encontre erro
set -e

# Atualizar pacotes e instalar dependências
apt update
apt install -y software-properties-common gpg curl sudo python3-pip

################################################################################
# Adicionar repositório do Ansible
# https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html
# Forma de instalação alterada devido a necessidade de ansible-core>=2.14.0
# Instalando via pip, com dependências

# Instalar Ansible e dependências (precisam estar no role também)
pip3 install ansible-core ansible-dev-tools python-debian

################################################################################

# Limpar cache
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verificar versão do Ansible
ansible --version
