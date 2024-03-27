local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

require("nvim-treesitter.configs").setup({})
-- nvim-ts-context-commentstring is set up automatically
local utils = require("user.functions")

local supported_lang = {
	-- list installled for n in *; do printf '%s,\n' "${n%.*}"; done
	basic = {
		"astro",
		"bash",
		"c",
		"cmake",
		"comment",
		"cpp",
		"css",
		"dockerfile",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"html",
		"javascript",
		"jq",
		"json",
		"json5",
		"jsonc",
		"jsonnet",
		"lua",
		"make",
		"markdown",
		"php",
		"ruby",
		"scss",
		"sql",
		"vim",
		"vue",
		"yaml",
		"heex",
		"eex",
		"elixir",
		"tsx",
		"typescript",
		"vue",
		"yaml",
		"scss",
		"markdown",
		"markdown_inline",
		"elixir",
	},
	enhanced = {
		"awk",
		"bash",
		"beancount",
		"c",
		"c_sharp",
		"clojure",
		"cmake",
		"comment",
		"commonlisp",
		"cooklang",
		"cpp",
		"css",
		"dart",
		"diff",
		"dockerfile",
		"dot",
		"eex",
		"elm",
		"embedded_template",
		"erlang",
		"fennel",
		"fish",
		"fusion",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"gleam",
		"go",
		"graphql",
		"haskell",
		"help",
		"html",
		"http",
		"java",
		"javascript",
		"jq",
		"jsdoc",
		"json",
		"json5",
		"jsonc",
		"jsonnet",
		"kotlin",
		"latex",
		"llvm",
		"lua",
		"make",
		"mermaid",
		"ninja",
		"nix",
		"ocaml",
		"ocaml_interface",
		"ocamllex",
		"perl",
		"php",
		"prisma",
		"proto",
		"pug",
		"python",
		"query",
		"racket",
		"regex",
		"rst",
		"ruby",
		"rust",
		"scala",
		"scheme",
		"sql",
		"svelte",
		"swift",
		"todotxt",
		"toml",
		"vim",
		"wgsl",
		"zig",
		"surface",
	},
	deluxe = "all",
}
configs.setup({
	ensure_installed = supported_lang[utils.get_running_mode()], -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true, disable = { "yaml" } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},

	--[[ "RRethy/nvim-treesitter-endwise", ]]
	endwise = {
		enable = true,
	},
	--[[ "windwp/nvim-ts-autotag", ]]
	autotag = {
		enable = true,
	},
	--[[ "windwp/nvim-autopairs", ]]
	--[[ autopairs = { ]]
	--[[ 	enable = true, ]]
	--[[ }, ]]
	-- nvim-treesitter-textsubjects
	--[[ textsubjects = { ]]
	--[[ 	enable = true, ]]
	--[[ 	keymaps = { ]]
	--[[ 		["."] = "textsubjects-smart", ]]
	--[[ 		[";"] = "textsubjects-container-outer", ]]
	--[[ 	}, ]]
	--[[ }, ]]
	-- JoosepAlviste/nvim-ts-context-commentstring
	--[[ textobjects = { ]]
	--[[ 	select = { ]]
	--[[ 		enable = true, ]]
	--[[]]
	--[[ 		-- Automatically jump forward to textobj, similar to targets.vim ]]
	--[[ 		lookahead = true, ]]
	--[[]]
	--[[ 		keymaps = { ]]
	--[[ 			-- You can use the capture groups defined in textobjects.scm ]]
	--[[ 			["af"] = "@function.outer", ]]
	--[[ 			["if"] = "@function.inner", ]]
	--[[ 			["ac"] = "@class.outer", ]]
	--[[ 			["ic"] = "@class.inner", ]]
	--[[ 			["icl"] = "@call.inner", ]]
	--[[ 			["acl"] = "@call.outer", ]]
	--[[ 			["ilp"] = "@loop.inner", ]]
	--[[ 			["ipm"] = "@parameter.inner", ]]
	--[[ 			["ib"] = "@block.inner", ]]
	--[[ 			["icn"] = "@conditional.inner", ]]
	--[[ 		}, ]]
	--[[ 	}, ]]
	--[[ }, ]]
})

-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
--  parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
