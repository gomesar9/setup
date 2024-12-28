################################################################################
# Alias
if command -v eza >/dev/null 2>&1; then
    # ls será um link simbólico para eza, e o parâmetro -h no
    # Eza adiciona headers, por isso não faz sentido aqui
    alias çl='clear; ls -lF'
    alias çla='clear; ls -laF'
    alias t='ls -L 3' # Usa o próprio eza para árvore de diretório
else
    alias çl='clear; ls -lhF'
    alias çla='clear; ls -lhaF'
    alias t='tree -L 3'
fi
alias çgit='cd /git'
alias çtmp='cd /home/gomes/code/tmp/'

# Kubernetes
alias k='kubectl'
alias kst='kubectl kustomize'

# Vim
alias v=vim
alias f=fzf

# personal info: emails, numbers, perfis, etc
alias çcrono='see ~/.personal_crono.png'
alias çnotes='vim ~/notes/gomes/'
alias çnvim='cd ~/.config/nvim/ && vim . && cd -'

if command -v yq >/dev/null 2>&1; then
    alias me='yq ~/.me.yaml | fzf'
else
    alias me='cat ~/.me.yaml | fzf'
fi
# Arquivo criptografado
alias mepriv='gpg -d ~/.mepriv.yaml.gpg 2>-'

# Git
alias gs='git status'
alias gfa='git fetch --all'
alias gc='git commit'
alias gps='git push'
alias gpl='git pull'

if command -v zellij >dev/null 2>&1; then
    alias zgomes='zellij a gomes 2>/dev/null || zellij --layout gomes --session gomes'
fi

################################################################################
# Manipulação de variáveis de ambiente
export EDITOR=vim

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

# Path
export PATH="$PATH:/home/gomes/.cargo/bin:/usr/local/go/bin"
export PATH="${PATH}:/usr/share/logstash/bin"
export PATH="${PATH}:/opt/flutter/bin"
export PATH="${PATH}:/home/gomes/.local/bin"
export PATH="${PATH}:/opt/go/bin"
export PATH="${PATH}:$(go env GOPATH)/bin"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
