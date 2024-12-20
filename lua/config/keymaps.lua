-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set
local del = vim.keymap.del

local function create_file_in_directory()
  local dir = vim.g.obsidian_quick_note_path
  if not dir then
    print("Please set g:obsidian_quick_note_path in your options-local.lua")
    return
  end
  local date = os.date("%Y%m%d-%H%M")
  local filename = dir .. date .. ".md"
  vim.cmd("edit " .. filename)
end

map("n", "<leader>F", ":lua require('fzf-lua').live_grep()<CR>")
map("n", "<leader>oo", create_file_in_directory,{desc = "Create a new file in the quick note directory"})
