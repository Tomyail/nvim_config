return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- preset = "default",
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      local node_path = vim.fn.expand("$HOME") .. "/.asdf/installs/nodejs/18.19.0/bin/node"
      local copilot_node_command = "node"
      if vim.fn.filereadable(node_path) == 1 then
        copilot_node_command = node_path -- Node.js version must be > 18.x
      end
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          yaml = true,
        },
        copilot_node_command = copilot_node_command,
      })
    end,
  },
}
