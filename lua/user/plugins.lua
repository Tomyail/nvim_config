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


local basic = {
  "uga-rosa/utf8.nvim",
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.3',
    dependencies = { 'nvim-lua/plenary.nvim' }

  },
  "kyazdani42/nvim-tree.lua",
  "neovim/nvim-lspconfig",
  "jose-elias-alvarez/null-ls.nvim",
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp-signature-help",

  "folke/which-key.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
  "JoosepAlviste/nvim-ts-context-commentstring",
  "windwp/nvim-autopairs",
  "windwp/nvim-ts-autotag",
  "RRethy/nvim-treesitter-endwise",

  "numToStr/Comment.nvim", -- Easily comment stuff

  "kdheepak/lazygit.nvim",
  "lewis6991/gitsigns.nvim",

  "ggandor/leap.nvim",

  "gbprod/yanky.nvim",
  "akinsho/bufferline.nvim",

  "rafamadriz/friendly-snippets",

  "MunifTanjim/nui.nvim",
  "jackMort/ChatGPT.nvim",


  "b0o/SchemaStore.nvim",
  "echasnovski/mini.nvim",
  "github/copilot.vim",

  { "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" } },
  "theHamsta/nvim-dap-virtual-text",
  "rcarriga/nvim-dap-ui",

  "brenoprata10/nvim-highlight-colors",
  "hoob3rt/lualine.nvim",

  "rcarriga/nvim-notify",
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
    },
  },

}



local plugins = {}

plugins = basic


local opts = {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}
require("lazy").setup(plugins, opts)

