# Keybind
# cat -v pode ajudar a descobrir/certificar teclas

# ZSH
# Zellij actions: https://zellij.dev/documentation/cli-actions
change-zellij-tab-by-name() {
    zellij action go-to-tab-name "$(zellij action query-tab-names | fzf)"
}

# Registra a função change-zellij-tab-by-name como um novo widget do Zsh
zle -N change-zellij-tab-by-name

# Associa com tecla ALT+t
bindkey '\et' change-zellij-tab-by-name
# bindkey -M emacs '\et' change-zellij-tab-by-name
# bindkey -M vicmd '\et' change-zellij-tab-by-name
# bindkey -M viins '\et' change-zellij-tab-by-name
