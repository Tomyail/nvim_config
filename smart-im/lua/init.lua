local M = {}

local utf8 = require("utf8")

-- 辅助函数：去除字符串首尾的空白字符
local function trim(s)
	return s:match("^%s*(.-)%s*$")
end
-- switch to english input method
function M.switch_to_english()
	local os_name = trim(vim.fn.system("uname")):lower()
	if os_name:match("darwin") then -- macOS
		if vim.fn.executable("im-select") == 1 then
			os.execute("im-select com.apple.keylayout.ABC")
		end
	elseif os_name:match("linux") then -- Linux (Ubuntu)
		if vim.fn.executable("ibus") == 1 then
			os.execute("ibus engine xkb:us::eng")
		end
	end
end

-- switch to chinese input method
function M.switch_to_chinese()
	local os_name = trim(vim.fn.system("uname")):lower()
	if os_name:match("darwin") then -- macOS
		if vim.fn.executable("im-select") == 1 then
			-- os.execute("im-select com.apple.inputmethod.SCIM.ITABC")
			os.execute("im-select im.rime.inputmethod.Squirrel.Hans")
		end
	elseif os_name:match("linux") then -- Linux (Ubuntu)
		if vim.fn.executable("ibus") == 1 then
			os.execute("ibus engine rime")
		end
	end
end

function M.get_matched_lang(lang_config, codepoint)
	local is_code_point_in_ranges = function(code_point, ranges)
		for _, range in ipairs(ranges) do
			if code_point >= range[1] and code_point <= range[2] then
				return true
			end
		end
		return false
	end
	for _, lang in pairs(lang_config) do
		if is_code_point_in_ranges(codepoint, lang.ranges) then
			return lang
		end
	end
end

function M.get_range(str, col)
	-- lua's array index starts from 1!!jk
	local pre_p = 0
	local pre_c = ""
	local ranges = {}

	for p, c in utf8.codes(str) do
		local range = { start_idx = pre_p, end_idx = p, char = pre_c }
		table.insert(ranges, range)
		pre_p = p
		pre_c = c
	end
	table.insert(ranges, { start_idx = pre_p, end_idx = string.len(str), char = pre_c })
	table.remove(ranges, 1)

	-- https://www.lddgo.net/en/string/cjk-unicodejk
	local chinese_ranges = {}

	local normal_col = col
	-- print("table" .. vim.inspect(ranges))
	-- vim.notify("str" .. str .. "normal_col" .. normal_col)
	for _, range in ipairs(ranges) do
		if normal_col >= range.start_idx and normal_col <= range.end_idx then
			return range
			-- vim.notify(
			-- 	"range: "
			-- 		.. vim.inspect(range)
			-- 		.. " normal_col:"
			-- 		.. normal_col
			-- 		.. " codepoint:"
			-- 		.. "0x"
			-- 		.. string.format("%x", utf8.codepoint(range.char))
			-- 		.. "is_chinese:"
			-- 		.. tostring(is_code_point_in_ranges(utf8.codepoint(range.char), chinese_ranges))
			-- )

			-- if is_code_point_in_ranges(utf8.codepoint(range.char), chinese_ranges) then
			-- 	M.switch_to_chinese()
			-- else
			-- 	M.switch_to_english()
			-- end
		end
	end
end

function M.os_name()
	return string.lower(vim.loop.os_uname().sysname)
end

function M.setup(config)
	local defaultConfig = {
		logLevel = "info",
		default = {
			methods = {
				{
					os = "darwin",
					cmd = "im-select",
					input = "com.apple.keylayout.ABC",
				},
			},
		},
		lang = {
			chinese = {
				ranges = {
					{ 0x4E00, 0x9FFF },
					{ 0x3400, 0x4DBF },
					{ 0x20000, 0x2A6DF },
					{ 0x2A700, 0x2B73F },
					{ 0x2B740, 0x2B81F },
					{ 0x2B820, 0x2CEAF },
					{ 0x2CEB0, 0x2EBEF },
					{ 0x30000, 0x3134A },
					{ 0x31350, 0x323AF },
				},
				methods = {
					{
						os = "darwin",
						cmd = "im-select",
						onMatch = "im.rime.inputmethod.Squirrel.Hans",
						onLeave = "com.apple.keylayout.ABC",
					},
					{
						os = "linux",
						cmd = "ibus",
						onMatch = "engine rime",
						onLeave = "engine xkb:us::eng",
					},
				},
			},
		},
	}

	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			M.switch_to_english()
		end,
	})

	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function()
			local current_line_content = vim.api.nvim_get_current_line()
			local line_idx, col_idx = unpack(vim.api.nvim_win_get_cursor(0))
			local range = M.get_range(current_line_content, col_idx)
			if range then
				local codepoint = utf8.codepoint(range.char)
				local lang = M.get_matched_lang(defaultConfig.lang, codepoint)
				vim.notify("lang" .. vim.inspect(lang))
			end
		end,
	})
end

return M
