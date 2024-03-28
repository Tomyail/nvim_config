local M = {
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- Use a sub-list to run only the first available formatter
		javascript = { { "prettierd", "prettier" } },
		vue = { { "prettierd", "prettier" } },
		markdown = { "prettierd", "markdownlint-cli2" },
	},
	format_on_save = {
		timeout_ms = 800,
		lsp_fallback = true,
	},
}

return M
