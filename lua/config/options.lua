-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ","

-- disable autoformat on save
vim.g.autoformat = false

local ok, _ = pcall(require, "config.options-local")
if not ok then
  vim.notify("No local options(/config/options-local.lua) file found", vim.log.levels.WARN)
end
