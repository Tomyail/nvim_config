return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opt)
    local custom = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
          },
        },
      },
    }
    return vim.tbl_deep_extend("force", custom, opt)
  end,
  keys = {
    { "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text" },
    { "<leader><leader>", '"zy:Telescope live_grep default_text=<C-r>z<CR>', mode = { "v" }, desc = "Find Text" },
  },
}
