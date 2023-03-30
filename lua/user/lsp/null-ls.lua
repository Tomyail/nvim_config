local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
-- local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		null_ls.builtins.formatting.rustywind,
		null_ls.builtins.diagnostics.eslint_d.with({
			--[[ todo sames to work ,no all eslint disabled ]]
			condition = function(utils)
				--[[ print("hello", utils.root_has_file({ ".eslintrc.js" })) ]]
				return utils.root_has_file({ ".eslintrc.js" })
			end,
			--[[ todo sames to work ,no all eslint disabled ]]
			--[[ runtime_condition = function(params) ]]
			--[[ 	print("hello2") ]]
			--[[ 	return params.root:match("my-monorepo-subdir") ~= nil ]]
			--[[ end, ]]
		}),
		formatting.prettier.with({
			prefer_local = true,
		}),
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		null_ls.builtins.formatting.shfmt,
	},
})
