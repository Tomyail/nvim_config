return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
  /^--^\     /^--^\     /^--^\
  \____/     \____/     \____/
/      \   /      \   /      \
|        | |        | |        |
\__  __/   \__  __/   \__  __/
|^|^|^|^|^|^|^|^|^|^|^|^\ \^|^|^|^/ /^|^|^|^|^\ \^|^|^|^|^|^|^|^|^|^|^|^|
| | | | | | | | | | | | |\ \| | |/ /| | | | | | \ \ | | | | | | | | | | |
| | | | | | | | | | | | / / | | |\ \| | | | | |/ /| | | | | | | | | | | |
| | | | | | | | | | | | \/| | | | \/| | | | | |\/ | | | | | | | | | | | |
#########################################################################
| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
 ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {},
    keys = {
      { "<leader>t", desc = "+Terminal" },
      { "<leader>tt", ":0ToggleTerm direction=float<cr>", desc = "ToggleTermToggleAll" },
      { "<leader>t1", ":1ToggleTerm direction=horizontal<cr>", desc = "ToggleTerm 1" },
      { "<leader>t2", ":2ToggleTerm direction=horizontal<cr>", desc = "ToggleTerm 2" },
      { "<leader>t3", ":3ToggleTerm<cr>", desc = "ToggleTerm 3" },
      { "<leader>t4", ":4ToggleTerm<cr>", desc = "ToggleTerm 4" },
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        show_prompt = false,
        hint = "floating-big-letter",
        filter_rules = {

          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "NvimTree", "neo-tree", "notify" },

            -- if the file type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = "copilot-chat",
        title = "Copilot Chat",
        size = { width = 20 },
      })
    end,
  },
}
