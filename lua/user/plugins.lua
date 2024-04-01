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
  {
    lazy = false,
    "tomyail/smart-im",
    opts = {
      lang = {
        cjk = {
          methods = {
            {
              os = "darwin",
              cmd = "im-select",
              input = "im.rime.inputmethod.Squirrel.Hans", -- I use [Rime](https://github.com/rime/squirrel)
            },
          },
        },
      },
    },
    dir = vim.fn.stdpath("config") .. "/smart-im",
  },
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
    dependencies = {
      {
        "brenoprata10/nvim-highlight-colors",
        opts = {
          render = "foreground",
          enable_named_colors = true,
          enable_tailwind = true,
        },
      },
    },
  },

  "uga-rosa/utf8.nvim",
  {
    "williamboman/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "williamboman/mason-lspconfig.nvim" },
      {
        "stevearc/conform.nvim",
        opts = require("user.lsp.conform"),
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.3",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    event = "VeryLazy",
  },

  {

    "kyazdani42/nvim-tree.lua",
    event = "VeryLazy",
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    lazy = false,
    config = function()
      local prompts = require("CopilotChat.prompts")
      local select = require("CopilotChat.select")
      require("CopilotChat").setup({
        model = "gpt-4",
        --[[ model = 'gpt-3.5-turbo', ]]
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN 将上述代码的解释写为文本段落",
          },
          CommitStaged = {
            prompt = "使用 commitizen convention 编写更改的提交标题。确保标题最多包含 50 个字符。 使用 gitcommit 语言将整个消息包装在代码块中,并用中文返回",
            selection = function(source)
              return select.gitdiff(source, true)
            end,
          },
        },
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          local ft = vim.bo.filetype
          if ft == "copilot-chat" then
            vim.bo.filetype = "markdown"
          end
        end,
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          yaml = true,
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- neodev.nvim 的作用是给nvim 的api增加代码提示
      { "folke/neodev.nvim", opts = {} },
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",

      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },

      "windwp/nvim-autopairs",
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
      {
        "numToStr/Comment.nvim", -- Easily comment stuff
        dependencies = {
          "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
          require("Comment").setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
          })
        end,
      },
    },
    event = "VeryLazy",
  },

  {
    event = "VeryLazy",
    "folke/which-key.nvim",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
  },

  {
    "kdheepak/lazygit.nvim",
    event = "VeryLazy",
  },
  {

    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
    lazy = false,
  },

  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
  },

  {
    "gbprod/yanky.nvim",
    opts = {},
    event = "VeryLazy",
  },

  "akinsho/bufferline.nvim",

  "rafamadriz/friendly-snippets",

  --[[ "MunifTanjim/nui.nvim", ]]

  "b0o/SchemaStore.nvim",
  "echasnovski/mini.nvim",

  { "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" } },
  "theHamsta/nvim-dap-virtual-text",
  "rcarriga/nvim-dap-ui",

  "hoob3rt/lualine.nvim",

  {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = {},
    config = function()
      vim.notify = require("notify")
    end,
    init = function()
      vim.opt.termguicolors = true
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      {
        "SmiteshP/nvim-navic",
        opts = {
          highlight = true,
          depth_limit = 3,
        },
      },
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    event = "VeryLazy",
  },
  {
    event = "VeryLazy",
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}

local plugins = {}

plugins = basic

local opts = {
  defaults = {
    lazy = true, -- should plugins be lazy-loaded?
  },
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}
require("lazy").setup(plugins, opts)
