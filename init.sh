#!/bin/bash

# Sair caso encontre erro
set -e

# Atualizar pacotes e instalar dependências
apt update
apt install -y software-properties-common gpg curl sudo python3-pip python3-venv

################################################################################
# Adicionar repositório do Ansible
# https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html
# Forma de instalação alterada devido a necessidade de ansible-core>=2.14.0
# Instalando via pip, com dependências

if [ -z "$PYTHON_SYS_TMP_VENV" ]; then
    echo "PYTHON_SYS_TMP_VENV not defined"
    exit 1
fi
# Instalar Ansible e dependências (precisam estar no role também)
python3 -m venv "$PYTHON_SYS_TMP_VENV"
"${PYTHON_SYS_TMP_VENV}/bin/pip3" install ansible-core ansible-dev-tools python-debian

################################################################################

# Limpar cache (Desabilitado porque no geral vamos precisar instalar pacotes)
# apt-get clean
# rm -rf /var/lib/apt/lists/*

# Verificar versão do Ansible
"${PYTHON_SYS_TMP_VENV}/bin/ansible" --version
