return {
  -- override default plguns
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>w"] = {
          "<cmd>w!<cr>",
          "Save",
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },

  -- below are custom plugin
  {
    lazy = false,
    "tomyail/yasi.nvim",
    dependencies = {
      "uga-rosa/utf8.nvim",
    },
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
    config = function(_, opts)
      require("yasi").setup(opts)
      vim.api.nvim_create_autocmd("CmdlineEnter", {
        callback = function()
          local yasi = require("yasi")
          yasi.change_to_default()
        end,
      })
    end,
    dir = vim.fn.stdpath("config") .. "/yasi",
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
}
