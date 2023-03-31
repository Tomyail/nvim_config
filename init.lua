require("user.keymaps")
require("user.plugins")
require("user.autocommands")
require("user.options")
require("user.functions")
require("user.notify")
require("user.theme")
require("user.cmp")
require("user.lsp")
require("user.telescope")
require("user.treesitter")
require("user.autopairs")
require("user.comment")
require("user.gitsigns")
require("user.nvim-tree")
require("user.bufferline")
require("user.lualine")
require("user.toggleterm")
require("user.project")
require("user.impatient")
require("user.alpha")
--[[ require "user.hop" ]]
require("user.whichkey")
require("user.neoscroll")
require("user.jabs")
require("user.bookmark")
require("user.trouble")
require("user.symbol-outline")
require("user.gps")
require("user.cybu")
require("user.snippet")
require("user.leap")
require("user.yanky")
require("user.chat-gpt")
--[[ require("user.surround") ]]
require("user.mini")

if vim.fn.has("nvim-0.8") == 1 then
	require("user.winbar")
end

-- 定义一个全局函数
_G.open_qf_file_in_direction = function(direction)
    local current_line = vim.api.nvim_get_current_line()
    local file_path = current_line:match("[^|]+")
    if file_path then
        local open_windows = vim.api.nvim_list_wins()
        local first_normal_win_id = nil
        for _, win_id in ipairs(open_windows) do
            local bufnr = vim.api.nvim_win_get_buf(win_id)
            local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
            if buftype == "" then  -- 检查窗口是否为普通窗口（不是 quickfix 或其他类型）
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



vim.cmd([[
    autocmd FileType qf luafile ~/.config/nvim/init.lua
    autocmd FileType qf nnoremap <buffer> <silent> <C-v> :lua open_qf_file_in_direction("vertical")<CR>
    autocmd FileType qf nnoremap <buffer> <silent> <C-s> :lua open_qf_file_in_direction("split")<CR>
]])
