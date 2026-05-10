FROM debian:12

ENV PYTHON_SYS_TMP_VENV="/opt/system-tmp-venv"
COPY ./ansible /opt/ansible
COPY ./base_v_home/inventory.yml /opt/ansible/

# Atualiza o sistema e instala pacotes básicos
COPY init.sh .
RUN ./init.sh

# Cria o usuário 'userx' e o adiciona ao grupo sudo
RUN useradd -m -s /bin/bash userx \
    && echo 'userx ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/userx \
    && chmod 0440 /etc/sudoers.d/userx


# Troca para o usuário 'userx' por padrão
USER userx
WORKDIR /home/userx

# Executa ansible-playbook bootstrap
RUN "${PYTHON_SYS_TMP_VENV}/bin/ansible-playbook" -i /opt/ansible/inventory.yml /opt/ansible/main.yml

# Comando padrão
CMD [ "bash" ]
