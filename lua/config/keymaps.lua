-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set
local del = vim.keymap.del

-- del("n", "<leader>w")
-- del("n", "<leader>wd")
-- del("n", "<leader>w-")
-- del("n", "<leader>w|")
-- del("n", "<leader>ww")
-- 本来希望 <leader>w 保存的,但是默认注册<leader>w的二级菜单,导致一级的w绑定了window ,而且不能解绑,所以只能用ww了
map("n", "<leader>ww", "<cmd>w!<cr>", { desc = "Save" })
