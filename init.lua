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
require("user.whichkey")
require("user.symbol-outline")
require("user.snippet")
require("user.leap")
require("user.yanky")
require("user.chat-gpt")
require("user.mini")

local nvim_version = vim.fn.eval("split(v:version, '\\.')[0]")
local nvim_major_version = tonumber(nvim_version)

-- 当 vim.g.loaded_matchparen 设置为 true 时，matchparen 插件不会被加载，因此括号匹配的高亮显示会被关闭。这是因为在加载插件的过程中，Neovim 会检查每个插件的 loaded_ 前缀的全局变量（如果存在的话），如果该变量设置为 true，那么对应的插件就不会被加载。
vim.g.loaded_matchparen = true

--[[ if nvim_major_version > 0.8 then ]]
--[[     require("user.winbar") ]]
--[[ end ]]

