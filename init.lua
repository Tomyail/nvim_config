-- require("user.keymaps")
-- require("user.plugins")
-- require("user.autocommands")
-- require("user.options")
-- require("user.functions")
-- require("user.cmp")
-- require("user.lsp")
-- require("user.telescope")
-- require("user.treesitter")
-- require("user.autopairs")
-- require("user.nvim-tree")
-- require("user.bufferline")
-- require("user.lualine")
-- require("user.whichkey")
-- require("user.symbol-outline")
-- require("user.snippet")
-- require("user.leap")
-- require("user.mini")
--
--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({

    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {
  defaults = {
    lazy = false, -- should plugins be lazy-loaded?
  },
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
}
require("lazy").setup(opts)
