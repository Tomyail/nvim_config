-- set completeopt=menuone,noinsert,noselect
-- inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
-- inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

local snip_status_ok, cmp_buffer = pcall(require, "cmp_buffer")
if not snip_status_ok then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

-- 目的是检查光标是否在行的开始位置或者位于一个空白字符之后
local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end
local icons = require("user.icons")

local kind_icons = icons.kind

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })
-- local lspkind = require'lspkind'

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	enabled = function()
		-- disable completion in comments
		local context = require("cmp.config.context")
		-- keep command mode completion enabled when cursor is in a comment
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return not context.in_treesitter_capture("comment")
				and not context.in_syntax_group("Comment")
				and vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
		end
		-- or cmp_dap.is_dap_buffer()
	end,
	sorting = {
		priority_weight = 1.0,
		comparators = {
			function(...)
				return cmp_buffer:compare_locality(...)
			end,
			cmp.config.compare.locality,
			cmp.config.compare.recently_used,
			cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
			cmp.config.compare.offset,
			cmp.config.compare.order,
			-- The rest of your comparators...
		},
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		-- Change choice nodes for luasnip
		["<C-p>"] = cmp.mapping(function(fallback)
			if luasnip.choice_active() then
				luasnip.change_choice(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-n>"] = cmp.mapping(function(fallback)
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-X>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<ESC>"] = cmp.mapping.abort(),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({
			-- behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		--[[ ["<Tab>"] = cmp.mapping(function(fallback) ]]
		--[[ 	if cmp.visible() then ]]
		--[[ 		cmp.select_next_item() ]]
		--[[ 	elseif luasnip.expandable() then ]]
		--[[ 		luasnip.expand() ]]
		--[[ 	elseif luasnip.expand_or_jumpable() then ]]
		--[[ 		luasnip.expand_or_jump() ]]
		--[[ 	elseif check_backspace() then ]]
		--[[ 		fallback() ]]
		--[[ 	else ]]
		--[[ 		fallback() ]]
		--[[ 	end ]]
		--[[ end, { "i", "s" }), ]]
		--[[ ["<S-Tab>"] = cmp.mapping(function(fallback) ]]
		--[[ 	if cmp.visible() then ]]
		--[[ 		cmp.select_prev_item() ]]
		--[[ 	elseif luasnip.jumpable(-1) then ]]
		--[[ 		luasnip.jump(-1) ]]
		--[[ 	else ]]
		--[[ 		fallback() ]]
		--[[ 	end ]]
		--[[ end, { "i", "s" }), ]]
	}),
	formatting = {
		--[[ fields = { "kind", "abbr", "menu" }, ]]
		format = function(entry, vim_item)
			--[[ print(entry.source.name) ]]
			--[[ print(vim.inspect(entry)) ]]
			-- Kind icons
			--[[ vim_item.kind = string.format("%s", kind_icons[vim_item.kind]) ]]
			vim_item.kind = vim_item.kind .. "(" .. entry.source.name .. ")"

			--[[ if entry.source.name == "cmp_tabnine" then ]]
			--[[   -- if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then ]]
			--[[   -- menu = entry.completion_item.data.detail .. " " .. menu ]]
			--[[   -- end ]]
			--[[   vim_item.kind = icons.misc.Robot ]]
			--[[ end ]]
			--[[ if entry.source.name == "copilot" then ]]
			--[[   vim_item.kind = icons.git.Octoface ]]
			--[[   vim_item.kind_hl_group = "CmpItemKindCopilot" ]]
			--[[ end ]]
			--[[ -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind ]]
			--[[ -- NOTE: order matters ]]
			--[[ vim_item.menu = ({ ]]
			--[[   -- nvim_lsp = "[LSP]", ]]
			--[[   -- nvim_lua = "[Nvim]", ]]
			--[[   -- luasnip = "[Snippet]", ]]
			--[[   -- buffer = "[Buffer]", ]]
			--[[   -- path = "[Path]", ]]
			--[[   -- emoji = "[Emoji]", ]]
			--[[]]
			--[[   nvim_lsp = "nvim_lsp", ]]
			--[[   nvim_lua = "nvim_lua", ]]
			--[[   luasnip = "luasnip", ]]
			--[[   buffer = "buff", ]]
			--[[   path = "path", ]]
			--[[   emoji = "emoji", ]]
			--[[   dap = "dap", ]]
			--[[ })[entry.source.name] ]]
			return vim_item
		end,
	},
	sources = {
		{ name = "cmp_tabnine", priority = 8 },
		{ name = "nvim_lsp", priority = 8 },
		{ name = "buffer", priority = 8 },
		--[[ { name = "cmdline" }, ]]
		{ name = "nvim_lsp_signature_help", priority = 7 },
		{ name = "luasnip", priority = 7 },
		{ name = "spell", keyword_length = 3, priority = 5, keyword_pattern = [[\w\+]] },
		{ name = "dictionary", keyword_length = 3, priority = 5, keyword_pattern = [[\w\+]] }, -- from uga-rosa/cmp-dictionary plug
		{ name = "path" },
		--[[ { name = "copilot" }, ]]
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		-- documentation = "native",
		documentation = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
		},
		completion = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
		},
	},
	experimental = {
		ghost_text = false,
		-- native_menu = false,
	},
})
