local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok2, mason_lsp = pcall(require, "mason-lspconfig")
if not status_ok2 then
	return
end

local utils = require("user.functions")

local supported_server = {
	basic = {
		--[[ "jsonls", ]]
		--[[ "lua_ls", ]]
		--[[ "yamlls", ]]
		"vuels", -- for vue 2
		"tsserver",
		"elixirls",
		"tailwindcss",
	},
	enhanced = {
		"cssls",
		"cssmodules_ls",
		-- "emmet_ls",
		"html",
		-- "jdtls",
		"jsonls",
		"lua_ls",
		"tflint",
		"tsserver",
		"pyright",
		"yamlls",
		-- "bashls",
		"clangd",
		"eslint",
		-- "volar", -- for vue 3
		"vuels", -- for vue 2
		"elixirls",
		"tailwindcss",
	},
	deluxe = {},
}
mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
		},
	},
})

mason_lsp.setup({
	ensure_installed = supported_server[utils.get_running_mode()],
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end
mason_lsp.setup_handlers({
	function(server) -- default handler (optional)
		local opts = {}
		opts = {
			on_attach = require("user.lsp.handlers").on_attach,
			capabilities = require("user.lsp.handlers").capabilities,
		}

		local ok, cfg = pcall(require, "user.lsp.settings." .. server)
		if not ok then
			cfg = nil
		end
		if cfg then
			opts = vim.tbl_deep_extend("force", cfg, opts)
		end
		--[[ print('init server' .. server) ]]
		lspconfig[server].setup(opts)
	end,
})

local _status_ok, dapjs = pcall(require, "dap-vscode-js")
if _status_ok then
	local path = require("mason-core.path")
	local debugger_path = path.package_prefix("js-debug-adapter")
	dapjs.setup({
		-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
		-- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
		debugger_path = debugger_path,
		-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
		adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
		-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
		-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
		-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
	})

	for _, language in ipairs({ "typescript", "javascript" }) do
		require("dap").configurations[language] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
		}
	end
end

local status_ok, dapvirtualtext = pcall(require, "nvim-dap-virtual-text")
if status_ok then
	dapvirtualtext.setup()
end

local status_ok, dapui = pcall(require, "dapui")
if status_ok then
	dapui.setup()
end
