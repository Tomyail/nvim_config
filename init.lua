require("user.keymaps")
require("user.plugins")
require("user.gps")
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
require("user.cybu")
require("user.snippet")
require("user.leap")
require("user.yanky")
require("user.chat-gpt")
--[[ require("user.surround") ]]
require("user.copilot")
require("user.mini")

local nvim_version = vim.fn.eval("split(v:version, '\\.')[0]")
local nvim_major_version = tonumber(nvim_version)

--[[ if nvim_major_version > 0.8 then ]]
--[[     require("user.winbar") ]]
--[[ end ]]

