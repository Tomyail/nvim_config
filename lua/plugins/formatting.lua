return {
  {
    "stevearc/conform.nvim",
    opts = function()
      return {
        defaut_format_opts = {
          timeout_ms = 3000,
          -- 当没有配置额外的 formatter 时, 默认不会用lsp的format. 这个选项将打开默认的lsp, 但是只有filter 是true 才会执行
          lsp_format = "fallback",
          lsp_fallback = true,
          filter = function(client)
            local fallback_list = { "elixirls", "jsonls" }
            return vim.tbl_contains(fallback_list, client.name)
          end,
        },
        formatters = {
          --  用来格式化内嵌的代码块
          injected = {
            options = {
              ignore_errors = false,
              lang_to_ext = {
                bash = "sh",
                c_sharp = "cs",
                elixir = "exs",
                javascript = "js",
                julia = "jl",
                latex = "tex",
                markdown = "md",
                python = "py",
                ruby = "rb",
                rust = "rs",
                teal = "tl",
                typescript = "ts",
                plaintex = "tex",
              },
            },
          },
          --
          autocorrect = function(_)
            return {
              {
                -- https://github.com/huacnlee/autocorrect
                command = require("conform.util").find_executable({
                  "/usr/local/bin/autocorrect --stdin",
                }, "autocorrect"),
              },
            }
          end,
        },
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- Use a sub-list to run only the first available formatter
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          vue = { "prettierd", "prettier", stop_after_first = true },
          markdown = {
            "prettierd",
            "injected",
            "autocorrect",
            "markdownlint-cli2",
          },
        },
      }
    end,
  },
}
