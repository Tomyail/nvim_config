local M = {}

local utf8 = require("utf8")

-- switch to chinese input method if current char is chinese, otherwise switch to english input method
function M.check_and_switch_input_method()
	local bufnr = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()
	local row, col = unpack(vim.api.nvim_win_get_cursor(winnr))
	local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]

	local function is_chinese(char)
		local utf8_value = vim.fn.char2nr(char)
		-- print("char: " .. char .. "utf8_value: " .. utf8_value)
		return utf8_value >= 0x4E00 and utf8_value <= 0x9FFF
	end

	local prev_offset = 1
	local next_offset = 1
	local line_to_cursor = line:sub(1, col)
	local char_col = vim.fn.strchars(line_to_cursor)
	local current_char = vim.fn.matchstr(line, ".", char_col)
	-- print("current_char: " .. current_char .. "char_col: " .. char_col)
	local prev_char = char_col > prev_offset and vim.fn.matchstr(line, ".", char_col - prev_offset) or ""
	local next_char = char_col < vim.fn.strchars(line) and vim.fn.matchstr(line, ".", char_col + 1) or ""
	--[[ local current_char = vim.fn.matchstr(line, ".", col) ]]
	--[[ print("current_char: " .. current_char .. "col: " .. col) ]]
	--[[ local prev_char = col > prev_offset - 1 and vim.fn.matchstr(line, ".", col - prev_offset) or "" ]]
	--[[ local next_char = col < #line - next_offset + 1 and vim.fn.matchstr(line, ".", col + next_offset) or "" ]]
	if is_chinese(current_char) or is_chinese(prev_char) or is_chinese(next_char) then
		M.switch_to_chinese()
	else
		M.switch_to_english()
	end
end

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

function M.setup(config)
	-- print("smart-im setup")
	local defaultConfig = {
		logLevel = "info",
		lang = {
			chinese = {
				range = {
					{ 19968, 40959 },
					{ 13312, 19903 },
					{ 131072, 173791 },
					{ 63744, 64255 },
					{ 12288, 12351 },
				},
				{
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

	local function get_character_at_cursor()
		local cur_pos = vim.api.nvim_win_get_cursor(0)
		local line = vim.api.nvim_get_current_line()
		-- +1 for same index
		local char_pos = cur_pos[2] + 1
		for p, t in utf8.codes(line) do
			if p == char_pos then
				return (utf8.codepoint(t))
			end
		end
		return nil
	end


	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			M.switch_to_english()
		end,
	})

	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function()
			local function get_utf8_char(str, col)
				-- lua's array index starts from 1!!jk
				local pre_p = 1
				local pre_c = ""
				local ranges = {}

				for p, c in utf8.codes(str) do
					local range = { start_idx = pre_p, end_idx = p, char = pre_c }
					table.insert(ranges, range)
					pre_p = p
					pre_c = c
				end

				
				-- https://www.lddgo.net/en/string/cjk-unicode
				local chinese_ranges = {
					{ 0x4E00, 0x9FFF },
					{ 0x3400, 0x4DBF },
					{ 0x20000, 0x2A6DF },
					{ 0x2A700, 0x2B73F },
					{ 0x2B740, 0x2B81F },
					{ 0x2B820, 0x2CEAF },
					{ 0x2CEB0, 0x2EBEF },
					{ 0x30000, 0x3134A },
					{ 0x31350, 0x323AF}
				}

				local is_code_point_in_ranges = function(code_point, ranges)
					for _, range in ipairs(ranges) do
						if code_point >= range[1] and code_point <= range[2] then
							return true
						end
					end
					return false
				end

				-- targe char is the char at col > start_index and col <= end_index

				for _, range in ipairs(ranges) do
					if col >= range.start_idx and col < range.end_idx then
						vim.notify(
							"range: "
								.. vim.inspect(range)
								.. " col:"
								.. col
								.. " codepoint:"
								.. "0x"..string.format("%x",utf8.codepoint(range.char))
								.. "is_chinese:".. tostring(is_code_point_in_ranges(utf8.codepoint(range.char), chinese_ranges))
						)

						if(is_code_point_in_ranges(utf8.codepoint(range.char), chinese_ranges)) then
							M.switch_to_chinese()
						else
							M.switch_to_english()
						end


					end
				end
				return ""
			end
			local function get_cursor_column()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				print("line: " .. line)
				print("col: " .. col)
				return col
			end

			local function get_chars_of_current_line()
				get_cursor_column()
				local current_line = vim.api.nvim_get_current_line()
				-- local chars = {}
				-- local i = 1

				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				local result = get_utf8_char(current_line, col)
				-- local len = utf8.len(current_line)
				-- print("len: " .. len)
				-- local codes = utf8.codes(current_line)
				-- print("codes: " .. vim.inspect(codes))

				-- for p, c in utf8.codes(current_line) do
				-- 	print("p: " .. p)
				-- 	print("c: " .. c)
				-- end
				-- while i <= len do
				-- 	print("i".. i)
				-- 	local codepoint = utf8.codepoint(current_line, i)
				-- 	local offset = utf8.offset(current_line, i)

				-- 	print("codepoint: " .. codepoint)
				-- 	print("offset: " .. offset)
				-- 	local offsetChat = utf8.char(offset)
				-- 	print("offsetChat: " .. offsetChat)
				-- 	local codepointChat = utf8.char(codepoint)
				-- 	print("codepointChat: " .. codepointChat)
				--   local c, bytes = utf8.char(codepoint)

				--   if bytes then
				-- 	table.insert(chars, c)
				-- 	i = i + bytes
				--   else
				-- 	i = i + 1
				--   end
				-- end
				return chars
			end

			get_chars_of_current_line()
			-- print(vim.inspect(get_chars_of_current_line()))
			-- M.check_and_switch_input_method()
		end,
	})
end

return M
