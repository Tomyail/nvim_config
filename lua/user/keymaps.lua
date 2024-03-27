local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key

vim.g.mapleader = ","

vim.g.maplocalleader = ","

-- Normal --
-- Better window navigation
--[[ keymap("n", "<C-h>", "<C-w>h", opts) ]]
--[[ keymap("n", "<C-j>", "<C-w>j", opts) ]]
--[[ keymap("n", "<C-k>", "<C-w>k", opts) ]]
--[[ keymap("n", "<C-l>", "<C-w>l", opts) ]]
-- Disable default key mappings
vim.g.tmux_navigator_no_mappings = 1
-- Custom key mappings
vim.api.nvim_set_keymap("n", "<C-h>", ":TmuxNavigateLeft<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":TmuxNavigateDown<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":TmuxNavigateUp<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":TmuxNavigateRight<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<C-space>", ":TmuxNavigatePrevious<cr>", { silent = true, noremap = true })

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

--[[ keymap('v',"<leader><leader>",'"zy:Telescope live_grep default_text=<C-r>z<CR>', opts) ]]
-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- tmux
-- disable default map
vim.g.tmux_navigator_no_mappings = 1

--[[ keymap('n', '<leader>u', "<cmd>source ~/.config/nvim/lua/user/snippet.lua<cr>", {}) ]]
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
--[[ 默认情况下，在 Neovim 中，当提取文本时，光标会移动到被提取文本的开头。有了这个特性，yank 将与以前的功能完全相同，唯一的区别是执行 yank 后光标位置不会改变。 ]]
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
