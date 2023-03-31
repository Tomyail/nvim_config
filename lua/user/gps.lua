local status_ok, navic = pcall(require, "nvim-navic")
if not status_ok then
	return
end

navic.setup({
	icons = {
		File = " ",
		Module = " ",
		Namespace = " ",
		Package = " ",
		Class = " ",
		Method = " ",
		Property = " ",
		Field = " ",
		Constructor = " ",
		Enum = " ",
		Interface = " ",
		Function = " ",
		Variable = " ",
		Constant = " ",
		String = " ",
		Number = " ",
		Boolean = " ",
		Array = " ",
		Object = " ",
		Key = " ",
		Null = " ",
		EnumMember = " ",
		Struct = " ",
		Event = " ",
		Operator = " ",
		TypeParameter = " ",
	},
	highlight = true,
	separator = " > ",
	depth_limit = 3,
	depth_limit_indicator = "..",
	safe_output = true,
})

local M = {}
M.attach = function(client, bufnr)
	local status_cmp_ok, navic = pcall(require, "nvim-navic")
	if status_cmp_ok then
		if client.server_capabilities.documentSymbolProvider then
			navic.attach(client, bufnr)
		end
	end
end

return M
