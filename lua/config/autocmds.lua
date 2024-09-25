-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- Set spelllang to en,cjk for markdown files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.spelllang = "en,cjk"
  end,
})

-- using javascript filetpye for omnijs
vim.api.nvim_command("autocmd BufRead,BufNewFile *.omnijs set filetype=javascript")

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "omnijs" },
--   callback = function()
--     vim.opt_local.filetype = "javascript"
--   end,
-- })
--
--

_G.CloseCurrentToggleTerm = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local toggleterm_index = string.match(bufname, "#toggleterm#(%d+)")
  local command = ":" .. toggleterm_index .. "ToggleTerm"
  vim.cmd(command)
end

-- 给toggleterm buf 增加一个normal 状态的 esc 监听，按下之后关掉 当前的toggleterm
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    if ft == "toggleterm" then
      local bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<Esc>",
        ":lua _G.CloseCurrentToggleTerm()<CR>",
        { noremap = true, silent = true }
      )
      return
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    local filetype = vim.bo.filetype
    local buftype = vim.bo.buftype
    -- print("Current filetype: " .. filetype)
    -- print("Current buftype: " .. buftype)
    -- only normal buffer's winbar is set
    if buftype == "" then
      vim.opt_local.winbar = "%=%m %f"
    else
      vim.opt_local.winbar = nil
    end
  end,
})

-- 在quickfix 窗口中按 w 键，可以使用窗口选择器打开 quickfix 项
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    local picker = require("window-picker")
    -- 定义使用窗口选择器打开 quickfix 项的函数
    local function open_with_window_picker()
      local qf_entry = vim.fn.getqflist()[vim.fn.line(".")]
      local picked_window_id = picker.pick_window()
      if not picked_window_id then
        return
      end
      vim.api.nvim_set_current_win(picked_window_id)
      vim.cmd("edit " .. vim.fn.bufname(qf_entry.bufnr))
      vim.api.nvim_win_set_cursor(0, { qf_entry.lnum, qf_entry.col - 1 })
    end
    vim.api.nvim_buf_set_keymap(0, "n", "w", "", { noremap = true, silent = true, callback = open_with_window_picker })
  end,
})
