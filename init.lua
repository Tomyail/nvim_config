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
require("user.indentline")
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

if vim.fn.has("nvim-0.8") == 1 then
	require("user.winbar")
end
