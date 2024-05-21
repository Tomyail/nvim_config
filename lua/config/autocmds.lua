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
vim.api.nvim_command('autocmd BufRead,BufNewFile *.omnijs set filetype=javascript')

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "omnijs" },
--   callback = function()
--     vim.opt_local.filetype = "javascript"
--   end,
-- })
