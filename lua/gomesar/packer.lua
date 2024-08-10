-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd(
  "BufWritePost",
  {
      pattern = "packer.lua",
      group = "packer_user_config",
      command = "source <afile> | PackerSync"
    }
)

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({ 'rose-pine/neovim', as = 'rose-pine' })
  --use({ 'retrobox' )

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

  --use('nvim-treesitter/playground')
  
  -- cmp plugins
  use({
--    "hrsh7th/cmp-buffer",
--    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
--    "hrsh7th/cmp-path",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
--    "saadparwaiz1/cmp_luasnip",
  })

  -- LSP
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     -- Required
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'L3MON4D3/LuaSnip'},     -- Required
    }
  }
  use({
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "tamago324/nlsp-settings.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    "iamcco/markdown-preview.nvim",
  })
  
  use('theprimeagen/harpoon')

  use('mbbill/undotree')

  use('tpope/vim-fugitive')

  use {
    "nvim-neorg/neorg",
    run = ":Neorg sync-parsers",
    requires = "nvim-lua/plenary.nvim",
  }
end)
