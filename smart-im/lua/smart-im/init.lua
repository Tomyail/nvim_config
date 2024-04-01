local M = {}
local utf8 = require("utf8")

local logger = require("smart-im.logger")
logger.set_using_notify(true)

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

function M.find_in_array(table, fn)
	for _, v in ipairs(table) do
		if fn(v) then
			return v
		end
	end
end
function M.change_input_by_os(lang)
	local methods = lang.methods
	local lang_name = lang.name
	local os_name = M.os_name()
	local target = M.find_in_array(methods, function(method)
		return method.os == os_name
	end)
	if target then
		if vim.fn.executable(target.cmd) == 1 then
			local command = string.format("%s %s", target.cmd, target.input)
			local status, exit_type, _ = os.execute(command)
			if status == 0 then
				local msg =
					string.format("run command %s for lang: %s on os: %s successfully", command, lang_name, os_name)
				logger.debug(msg)
			else
				local msg = string.format("run command %s for lang: %s on os: %s failed", command, lang_name, os_name)
				logger.warn(msg)
			end
		else
			local msg = string.format(
				"Command %s not found in lang: %s for os : %s. please ensure command exist",
				target.cmd,
				lang_name,
				os_name
			)
			logger.warn(msg)
		end
	else
		local msg = string.format(
			"No matched input method find in lang: %s for os: %s. please check your config",
			lang_name,
			os_name
		)
		logger.warn(msg)
	end
end

function M.get_range(str, col)
	-- lua's array index starts from 1!!
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

	local normal_col = col
	for _, range in ipairs(ranges) do
		if normal_col >= range.start_idx and normal_col <= range.end_idx then
			return range
		end
	end
end

function M.os_name()
	return string.lower(vim.loop.os_uname().sysname)
end

function M.setup(config)
	-- TODO allow config to override defaultConfig
	local defaultConfig = {
		logLevel = "OFF",
		default = {
			name = "default",
			methods = {
				{
					os = "darwin",
					cmd = "im-select",
					input = "com.apple.keylayout.ABC",
				},
			},
		},
		lang = {
			cjk = {
				name = "cjk",
				-- https://www.lddgo.net/en/string/cjk-unicode
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
					-- cjk symbols and punctuation
					{ 0x3000, 0x303F },
				},
				methods = {
					{
						os = "darwin",
						cmd = "im-select",
						input = "im.rime.inputmethod.Squirrel.Hans",
					},
				},
			},
		},
	}

	logger.set_log_level(defaultConfig.logLevel)
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			M.change_input_by_os(defaultConfig.default)
		end,
	})

	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function()
			local current_line_content = vim.api.nvim_get_current_line()
			local _line_idx, col_idx = unpack(vim.api.nvim_win_get_cursor(0))
			local range = M.get_range(current_line_content, col_idx)
			if range then
				local codepoint = utf8.codepoint(range.char)
				local msg = string.format("col_idx: %s, char: %s,  codepoint: %x", col_idx, range.char, codepoint)
				logger.debug(msg)
				local lang = M.get_matched_lang(defaultConfig.lang, codepoint)

				if lang then
					M.change_input_by_os(lang)
				else
					M.change_input_by_os(defaultConfig.default)
				end
			end
		end,
	})
end

return M
