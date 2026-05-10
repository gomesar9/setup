require("utils.keymap")

require("config.maps")
-- Certifica que termguicolors está ligado para correta aplicação do colorschema,
-- caso não tenhasido setado antes, geralmente pelo oh-my-zsh theme.
vim.opt.termguicolors = true
require("config.lazy")

-- Precise ser depois do Lazy para garantir telescope
require("config.lsp")

-- Precisa vir depois, para sobrescrever opções de plugins
require("config.options")
