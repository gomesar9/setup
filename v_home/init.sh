#!/bin/bash

# Sair caso encontre erro
set -e

# Atualizar pacotes e instalar dependências
sudo apt update
sudo apt install -y software-properties-common gpg curl

################################################################################
# Adicionar repositório do Ansible
# https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html
debianRelease="$(lsb_release --release | grep -o '[0-9]*')"
if [ "$debianRelease" == "11" ]; then
    UBUNTU_CODENAME=focal
elif [ "$debianRelease" == "12" ]; then
    UBUNTU_CODENAME=jammy
else
    echo "Debian version \"$debianRelease\" not supported"
    exit 1
fi

curl -sL "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" |
    sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" |
    sudo tee /etc/apt/sources.list.d/ansible.list

# Instalar Ansible
sudo apt update && sudo apt install -y ansible
################################################################################

# Limpar cache
# apt-get clean
# rm -rf /var/lib/apt/lists/*

# Verificar versão do Ansible
ansible --version
