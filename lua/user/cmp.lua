local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	enabled = function()
		local context = require("cmp.config.context")
		-- keep command mode completion enabled when cursor is in a comment
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
		end
		-- or cmp_dap.is_dap_buffer()
	end,
	sorting = {
		priority_weight = 2,
		comparators = {
			require("copilot_cmp.comparators").prioritize,

			-- Below is the default comparitor list and order for nvim-cmp
			cmp.config.compare.offset,
			-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
		["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-x>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<ESC>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping({
			-- 在插入模式, 如果当前没有选择, 按下回车后是回车,如果当前有选择, 按下回车后是确认选择
			i = function(fallback)
				if cmp.visible() and cmp.get_active_entry() then
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
				else
					fallback()
				end
			end,
			-- 在选择模式, 按下回车后是确认选择
			s = cmp.mapping.confirm({ select = true }),
			-- 在命令模式, 按下回车后是确认选择, 并且会替换
			c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
		}),
	}),
	formatting = {
		format = function(entry, vim_item)
			-- debug 用，为了查看提示来自哪个源
			vim_item.kind = vim_item.kind .. "(" .. entry.source.name .. ")"

			return vim_item
		end,
	},
	sources = {
		-- 提供 copilot 补全( 基于 zbirenbaum/copilot-cmp)
		{ name = "copilot", group_index = 2 },
		-- 提供 nvim_lsp 补全( 基于 hrsh7th/cmp-nvim-lsp)
		{ name = "nvim_lsp", group_index = 2 },
		-- 基于hrsh7th/cmp-buffer
		{ name = "buffer", group_index = 2 },
		-- 提供 snippets 补全( 基于 saadparwaiz1/cmp_luasnip)
		{ name = "luasnip", group_index = 2 },
		-- 基于 hrsh7th/cmp-nvim-lsp-signature-help
		-- 提供在调用函数时的参数提示，按照函数的参数顺序显示
		{ name = "nvim_lsp_signature_help" },
	},
	experimental = {
		ghost_text = true,
	},
})

-- 针对 lua ,注入 nvim_lua , 方便提供vim 接口的代码提示
cmp.setup.filetype("lua", {
	sources = {
		-- 提供 copilot 补全( 基于 zbirenbaum/copilot-cmp)
		{ name = "copilot", group_index = 2 },
		-- 提供 nvim_lsp 补全( 基于 hrsh7th/cmp-nvim-lsp)
		{ name = "nvim_lsp", group_index = 2 },
		-- 基于hrsh7th/cmp-buffer
		{ name = "buffer", group_index = 2 },
		-- 提供 snippets 补全( 基于 saadparwaiz1/cmp_luasnip)
		{ name = "luasnip", group_index = 2 },
		{ name = "nvim_lua" },
	},
})
-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
	matching = { disallow_symbol_nonprefix_matching = false },
})
