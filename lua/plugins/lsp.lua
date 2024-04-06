return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local function get_servers()
        local servers = {}

        local files = vim.api.nvim_get_runtime_file("lua/user/lsp/settings/*", true)
        for _, filepath in ipairs(files) do
          local name = filepath:match(".+/([^/]+)%..+$") -- 提取文件名并去掉扩展名
          servers[name] = require("user.lsp.settings." .. name) -- 加载文件内容
        end

        -- vim.notify("Loaded servers count " .. vim.tbl_count(servers))

        return servers
      end
      local custom_ops = {
        servers = get_servers(),
      }

      return vim.tbl_deep_extend("force", custom_ops, opts)
    end,
  },
}
