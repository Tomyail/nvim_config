return {

  {
    "stevearc/conform.nvim",

    opts = function()
      return {
        format = {
          -- 当没有配置额外的 formatter 时, 默认不会用lsp的format. 这个选项将打开默认的lsp, 但是只有filter 是true 才会执行
          lsp_fallback = true,
          filter = function(client)
            local fallback_list = { "elixirls" }
            return vim.tbl_contains(fallback_list, client.name)
          end,
        },

        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- Use a sub-list to run only the first available formatter
          javascript = { { "prettierd", "prettier" } },
          vue = { { "prettierd", "prettier" } },
          markdown = { "prettierd", "markdownlint-cli2" },
        },
      }
    end,
  },
}
