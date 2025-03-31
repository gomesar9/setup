FROM debian:12

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

# Comando padrão
CMD [ "bash" ]
