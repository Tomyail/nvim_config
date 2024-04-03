return {
  {
    "folke/which-key.nvim",
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.register({
        w = { "<cmd>w!<cr>", "Save" },
      }, { mode = "n", prefix = "<leader>" })
    end,
  },
}
