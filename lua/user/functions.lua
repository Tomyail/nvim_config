local M = {}

vim.cmd([[
  function Test()
    %SnipRun
    call feedkeys("\<esc>`.")
  endfunction
  function TestI()
    let b:caret = winsaveview()
    %SnipRun
    call winrestview(b:caret)
  endfunction
]])

function M.sniprun_enable()
	vim.cmd([[
    %SnipRun
    augroup _sniprun
     autocmd!
     autocmd TextChanged * call Test()
     autocmd TextChangedI * call TestI()
    augroup end
  ]])
	vim.notify("Enabled SnipRun")
end

function M.disable_sniprun()
	M.remove_augroup("_sniprun")
	vim.cmd([[
    SnipClose
    SnipTerminate
    ]])
	vim.notify("Disabled SnipRun")
end

function M.toggle_sniprun()
	if vim.fn.exists("#_sniprun#TextChanged") == 0 then
		M.sniprun_enable()
	else
		M.disable_sniprun()
	end
end

function M.remove_augroup(name)
	if vim.fn.exists("#" .. name) == 1 then
		vim.cmd("au! " .. name)
	end
end

vim.cmd([[ command! SnipRunToggle execute 'lua require("user.functions").toggle_sniprun()' ]])

-- get length of current word
function M.get_word_length()
	local word = vim.fn.expand("<cword>")
	return #word
end

function M.toggle_option(option)
	local value = not vim.api.nvim_get_option_value(option, {})
	vim.opt[option] = value
	vim.notify(option .. " set to " .. tostring(value))
end

function M.toggle_tabline()
	local value = vim.api.nvim_get_option_value("showtabline", {})

	if value == 2 then
		value = 0
	else
		value = 2
	end

	vim.opt.showtabline = value

	vim.notify("showtabline" .. " set to " .. tostring(value))
end

local diagnostics_active = true
function M.toggle_diagnostics()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end

function M.isempty(s)
	return s == nil or s == ""
end

function M.get_buf_option(opt)
	local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
	if not status_ok then
		return nil
	else
		return buf_option
	end
end

function M.smart_quit()
	local bufnr = vim.api.nvim_get_current_buf()
	local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
	if modified then
		vim.ui.input({
			prompt = "You have unsaved changes. Quit anyway? (y/n) ",
		}, function(input)
			if input == "y" then
				vim.cmd("q!")
			end
		end)
	else
		vim.cmd("q!")
	end
end

function M.find_text_under_cursor_dir()
	local treeApi = require("nvim-tree.api")
	local current = treeApi.tree.get_node_under_cursor()
	if current == nil then
		vim.notify("no node selected")
		return
	end
	local type = current.fs_stat.type
	-- print(vim.inspect(current))
	local dir
	if type == "file" then
		dir = current.parent.absolute_path
	elseif type == "directory" then
		dir = current.absolute_path
	else
		vim.notify("unknown type" .. type)
	end
	print(dir)
	local builtin = require("telescope.builtin")
	local themes = require("telescope.themes")
	--	builtin.live_grep({ cwd = dir })
	builtin.live_grep(themes.get_ivy({ cwd = dir }))

	--vim.api.nvim_command("Telescope live_grep theme=ivy cwd=" .. dir)
	-- require("telescope.builtin").live_grep({
	-- 		cwd = dir,
	-- 	})
end

function M.find_file_under_cursor_dir()
	local treeApi = require("nvim-tree.api")
	local current = treeApi.tree.get_node_under_cursor()
	if current == nil then
		vim.notify("no node selected")
		return
	end
	local type = current.fs_stat.type
	-- print(vim.inspect(current))
	local dir
	if type == "file" then
		dir = current.parent.absolute_path
	elseif type == "directory" then
		dir = current.absolute_path
	else
		vim.notify("unknown type" .. type)
	end
	print(dir)
	local builtin = require("telescope.builtin")
	local themes = require("telescope.themes")
	--	builtin.live_grep({ cwd = dir })
	builtin.find_files(themes.get_dropdown({ cwd = dir, previewer = false }))

	--vim.api.nvim_command("Telescope live_grep theme=ivy cwd=" .. dir)
	-- require("telescope.builtin").live_grep({
	-- 		cwd = dir,
	-- 	})
end

function M.get_running_mode()
	local allowed_mode = { "basic", "enhanced", "deluxe" }
	local running_mode = os.getenv("NVIM_RUNNING_MODE")
	local function has_value(tab, val)
		for index, value in ipairs(tab) do
			if value == val then
				return true
			end
		end
		return false
	end

	if not has_value(allowed_mode, running_mode) then
		running_mode = "basic"
	end

	return running_mode
end

function M.start_leap_forward_to()
	local status_ok, leap = pcall(require, "leap")

	if not status_ok then
		return
	end
	leap.leap({ opts = { labels = {} } })
end

function M.delete_buff()
	local status_ok, bufremove = pcall(require, "mini.bufremove")

	if not status_ok then
		return
	end
	bufremove.delete()
end

-- get file path of current line for quickfix list, then open a normal window with direction for it
function M.open_qf_file_in_direction(direction)
	local current_line = vim.api.nvim_get_current_line()
	local file_path = current_line:match("[^|]+")
	if file_path then
		local open_windows = vim.api.nvim_list_wins()
		local first_normal_win_id = nil
		for _, win_id in ipairs(open_windows) do
			local bufnr = vim.api.nvim_win_get_buf(win_id)
			local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
			if buftype == "" then -- 检查窗口是否为普通窗口（不是 quickfix 或其他类型）
				first_normal_win_id = win_id
				break
			end
		end

		if first_normal_win_id then
			vim.api.nvim_set_current_win(first_normal_win_id)
			if direction == "vertical" then
				vim.cmd("vertical split " .. file_path)
			else
				vim.cmd("split " .. file_path)
			end
		else
			if direction == "vertical" then
				vim.cmd("vertical split " .. file_path)
			else
				vim.cmd("split " .. file_path)
			end
		end
	end
end

-- find files using telescope, set hidden and no_ignore options according to nvim-tree config
function M.find_files()
	--[[ https://github.com/nvim-tree/nvim-tree.lua/blob/45400cd7e02027937cd5e49845545e606ecf5a1f/lua/nvim-tree/actions/tree-modifiers/toggles.lua#L29 ]]
	local filters = require("nvim-tree.explorer.filters")
	local hidden = not filters.config.filter_dotfiles
	local git_ignored = not filters.config.filter_git_ignored

	require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
		previewer = false,
		hidden = hidden,
		no_ignore = git_ignored,
		no_ignore_parent = git_ignored,
	}))
end

-- switch to chinese input method if current char is chinese, otherwise switch to english input method
function M.check_and_switch_input_method()
	local bufnr = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()
	local row, col = unpack(vim.api.nvim_win_get_cursor(winnr))
	local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]

	local function is_chinese(char)
		local utf8_value = vim.fn.char2nr(char)
		return utf8_value >= 0x4E00 and utf8_value <= 0x9FFF
	end

	local prev_offset = 1
	local next_offset = 1
	local line_to_cursor = line:sub(1, col)
	local char_col = vim.fn.strchars(line_to_cursor)
	local current_char = vim.fn.matchstr(line, ".", char_col)
	print("current_char: " .. current_char .. "char_col: " .. char_col)
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
		os.execute("im-select com.apple.keylayout.ABC")
	elseif os_name:match("linux") then -- Linux (Ubuntu)
		os.execute("ibus engine xkb:us::eng")
	end
end

-- switch to chinese input method
function M.switch_to_chinese()
  local os_name = trim(vim.fn.system("uname")):lower()
  if os_name:match("darwin") then -- macOS
    os.execute("im-select com.apple.inputmethod.SCIM.ITABC")
  elseif os_name:match("linux") then -- Linux (Ubuntu)
    os.execute("ibus engine rime")
  end
end

return M
