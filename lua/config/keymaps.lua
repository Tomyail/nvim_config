-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set
local del = vim.keymap.del

-- 因为在whichkkey 自定义 <leader>w是保存文件,所以需要删掉 所有的子命令,否则 leader w 冲突
-- del("n", "<leader>wd")
-- del("n", "<leader>w-")
-- del("n", "<leader>w|")
-- del("n", "<leader>ww")
-- map("n", "<leader>ww", "<cmd>w!<cr>", { desc = "Save" })
