return {
  {

    "stevearc/dressing.nvim",
    opts = {
      -- TODO mapping not working
      input = {
        mappings = {
          n = {
            ["<Esc>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          i = {
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<C-j>"] = "HistoryPrev",
            ["<C-k>"] = "HistoryNext",
          },
        },
      },
      select = {
        builtin = {
          mappings = {
            ["<Esc>"] = "Close",
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<C-j>"] = "HistoryPrev",
            ["<C-k>"] = "HistoryNext",
          },
        },
      },
    },
  },
}
