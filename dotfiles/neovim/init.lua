-- ################################
-- ### PLUGINS                  ###
-- ################################

-- Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  -- Treesitter
  {
     "nvim-treesitter/nvim-treesitter",
     build = ":TSUpdate",
     config = function () 
     local configs = require("nvim-treesitter.configs")

     configs.setup({
       ensure_installed = { "c", "lua", "vim", "vimdoc", "query", },
       sync_install = false,
       auto_install = true,
       highlight = { enable = true },
       indent = { enable = true },  
     })
     end
  },

  -- Nerdtree
  {
    'preservim/nerdtree',
  },

  -- Icons
  {
    'ryanoasis/vim-devicons',
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Dracula colorscheme
  {
    "Mofiqul/dracula.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme dracula]])
    end,
  },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  -- WhichKey
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here. Leave it empty to use the default settings
    }
  }
})


-- ################################
-- ### OPTIONS                  ###
-- ################################

-- Use 'set' for vim options
local set = vim.opt

-- Tabs
set.tabstop     = 2
set.shiftwidth  = 2
set.softtabstop = 2
set.expandtab   = true

-- Display
set.cursorline = true
set.number     = true
set.wrap       = false


-- ################################
-- ### KEYBINDS                 ###
-- ################################

-- Set leader key to <space>
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Require which-key and add existing mappings
local wk = require("which-key")
wk.register(mappings, opts)

-- Extra mappings with which-key
wk.register({
  w = { "<cmd>w<cr>", "Write" },
  q = { "<cmd>q<cr>", "Quit" },
  h = { "<cmd>noh<cr>", "Cancel highlight" },
  e = { "<cmd>NERDTreeToggle<cr>", "Explorer" },
  f = {
    name = "Find",
    f = { "<cmd>Telescope find_files hidden=true<cr>", "File" },
    b = { "<cmd>Telescope buffers<cr>", "Buffer" },
    g = { "<cmd>Telescope git_files<cr>", "Git file" },
--      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap=false, buffer = 123 }, -- additional options for creating the keymap
--      n = { "New File" }, -- just a label. don't create any mapping
--      e = "Edit File", -- same as above
--      b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
  },
}, { prefix = "<leader>" })
