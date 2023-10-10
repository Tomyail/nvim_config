-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

local utils = require("user.functions")


local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  --[[ vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open')) ]]
  --[[ vim.keymap.set('n', 'o', api.node.open.edit, opts('Open')) ]]
  --[[ vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open')) ]]
  --[[ vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD')) ]]
  --[[ vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD')) ]]
  --[[ vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split')) ]]
  --[[ vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split')) ]]
  --[[ vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab')) ]]
  --[[ vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling')) ]]
  --[[ vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling')) ]]
  --[[ vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory')) ]]
  --[[ vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory')) ]]
  --[[ vim.keymap.set('n', '<S-CR>', api.node.navigate.parent_close, opts('Close Directory')) ]]
  --[[ vim.keymap.set('n', '<Space><Space>', api.node.open.preview, opts('Open Preview')) ]]
  --[[ vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling')) ]]
  --[[ vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling')) ]]
  --[[ vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore')) ]]
  --[[ vim.keymap.set('n', '.', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles')) ]]
  --[[ vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh')) ]]
  --[[ vim.keymap.set('n', 'N', api.fs.create, opts('Create')) ]]
  --[[ vim.keymap.set('n', 'd', api.fs.remove, opts('Delete')) ]]
  --[[ vim.keymap.set('n', 'r', api.fs.rename, opts('Rename')) ]]
  --[[ vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename')) ]]
  --[[ vim.keymap.set('n', 'x', api.fs.cut, opts('Cut')) ]]
  --[[ vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy')) ]]
  --[[ vim.keymap.set('n', 'p', api.fs.paste, opts('Paste')) ]]
  --[[ vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name')) ]]
  --[[ vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path')) ]]
  --[[ vim.keymap.set('n', 'yy', api.fs.copy.absolute_path, opts('Copy Absolute Path')) ]]
  --[[ vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git')) ]]
  --[[ vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git')) ]]
  --[[ vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up')) ]]
  vim.keymap.set('n', 's', function()
    -- local node = api.tree.get_node_under_cursor()
    utils.start_leap_forward_to()
    -- your code goes here
  end, opts('leap'))

  vim.keymap.set('n', 'S', function()
    -- local node = api.tree.get_node_under_cursor()
    utils.start_leap_backword_to()
    -- your code goes here
  end, opts('leap back'))

  vim.keymap.set('n', 'O', api.node.run.system, opts('Run System'))
  vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))

end
--   nnoremap sf :NvimTreeFindFile<CR>


nvim_tree.setup({
  on_attach = on_attach,
	disable_netrw = true,
	hijack_netrw = true,
	open_on_tab = false,
	hijack_cursor = false,
	update_cwd = true,
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = false,
		update_cwd = true,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	filters = {
		dotfiles = true,
		custom = {},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 500,
	},
	view = {
		width = 30,
		--[[ height = 30, ]]
		side = "left",
		number = false,
		relativenumber = false,
	},
	renderer = {
		add_trailing = false,
		group_empty = false,
		highlight_git = false,
		highlight_opened_files = "none",
		root_folder_modifier = ":~",
		indent_markers = {
			enable = false,
			icons = {
				corner = "└ ",
				edge = "│ ",
				none = "  ",
			},
		},
		icons = {
			--[[ webdev_colors = true, ]]
			git_placement = "before",
			padding = " ",
			symlink_arrow = " ➛ ",
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_closed = "",
					arrow_open = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
		special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
		open_file = {
			quit_on_open = false,
			resize_window = true,
			window_picker = {
				enable = true,
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
	},
})
