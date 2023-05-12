local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = false,
            z = false, -- bindings for folds, spelling and others prefixed with z
            g = false, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gcc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    ["a"] = { "<cmd>Alpha<cr>", "Alpha" },
    b = {
      name ="Buffers",
      o = {"<cmd>lua require('user.functions').onlyBufferThis()<cr>", "Only"}
    },
    -- ["b"] = {
    --   "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    --   "Buffers",
    -- },
    ["/"] = { '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', "Comment" },
    ["w"] = { "<cmd>w!<CR>", "Save" },
    ["q"] = { '<cmd>lua require("user.functions").delete_buff()<cr>', "Quit" },
    -- ["q"] = { '<cmd>lua require("user.functions").smart_quit()<CR>', "Quit" },
    ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
    ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
    ["f"] = {
        "<cmd>lua require('user.functions').find_files()<cr>",
        "Find files",
    },
    ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
    e = {
        name = "Explorer",
        ["e"] = { "<cmd>NvimTreeToggle<cr>", "Open" },
        ["f"] = { "<cmd>NvimTreeFindFile<cr>", "Find" },
        ["o"] = { "<cmd>NvimTreeCollapseKeepBuffers<cr>", "Collapses" },
    },
    d = {
        name = "Debug",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
        o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
        O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
        r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
        l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
        u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
        x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
    },
    p = {
        name = "Packer",
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        S = { "<cmd>PackerStatus<cr>", "Status" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
    },
    o = {
        name = "Options",
        w = { '<cmd>lua require("user.functions").toggle_option("wrap")<cr>', "Wrap" },
        r = { '<cmd>lua require("user.functions").toggle_option("relativenumber")<cr>', "Relative" },
        l = { '<cmd>lua require("user.functions").toggle_option("cursorline")<cr>', "Cursorline" },
        s = { '<cmd>lua require("user.functions").toggle_option("spell")<cr>', "Spell" },
        t = { '<cmd>lua require("user.functions").toggle_tabline()<cr>', "Tabline" },
    },
    r = {
        name = "Replace",
        r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
        w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
        f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
    },
    g = {
        name = "Git",
        g = { "<cmd>LazyGit<CR>", "Lazygit" },
        j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
        k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
        l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
        p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
        r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
        R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
        s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
        u = {
            "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
            "Undo Stage Hunk",
        },
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        d = {
            "<cmd>Gitsigns diffthis HEAD<cr>",
            "Diff",
        },
    },
    D = {
        name = "find under directory",
        f = {
            "<cmd>lua require('user.functions').find_file_under_cursor_dir()<cr>",
            "find file",
        },
        F = {

            "<cmd>lua require('user.functions').find_text_under_cursor_dir()<cr>",
            "find text",
        },
    },
    l = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        d = {
            "<cmd>TroubleToggle<cr>",
            "Diagnostics",
        },
        w = {
            "<cmd>Telescope diagnostics<cr>",
            "Workspace Diagnostics",
        },
        f = { "<cmd>lua vim.lsp.buf.format({async=true})<cr>", "Format" },
        F = { "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
        j = {
            "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
            "Next Diagnostic",
        },
        k = {
            "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
            "Prev Diagnostic",
        },
        l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
        q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        S = {
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace Symbols",
        },
        o = { "<cmd>SymbolsOutline<cr>", "Outline" },
        R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
        t = { '<cmd>lua require("user.functions").toggle_diagnostics()<cr>', "Toggle Diagnostics" },
    },
    s = {
        name = "Search",
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        C = { "<cmd>Telescope commands<cr>", "Commands" },
    },
    t = {
        name = "Terminal",
        ["1"] = { ":1ToggleTerm<cr>", "1" },
        ["2"] = { ":2ToggleTerm<cr>", "2" },
        ["3"] = { ":3ToggleTerm<cr>", "3" },
        ["4"] = { ":4ToggleTerm<cr>", "4" },
        n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
        u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
        t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
        p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
        f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
        h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
        v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
    },
    T = {
        name = "Treesitter",
        h = { "<cmd>TSHighlightCapturesUnderCursor<cr>", "Highlight" },
        p = { "<cmd>TSPlaygroundToggle<cr>", "Playground" },
    },
    m = {
        name = "Mark",
        a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add mark" },
        m = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Toggle mark menu" },
    },
}
local vopts = {
    mode = "v", -- VISUAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}
local chatgpt = require("chatgpt")
local vmappings = {
    ["/"] = { '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', "Comment" },
    s = { "<esc><cmd>'<,'>SnipRun<cr>", "Run range" },
    G = { "<esc><cmd>ChatGPTEditWithInstructions<cr>", "Run range" },
    -- search selected text via Telescope live_grep
    -- https://www.reddit.com/r/neovim/comments/p8wtmn/comment/h9ty0s2/?utm_source=share&utm_medium=web2x&context=3
    ["<leader>"] = { '"zy:Telescope live_grep default_text=<C-r>z<CR>', "Global Search" },
    c = {
        name = "chatgpt",
        c = {
            function()
                chatgpt.edit_with_instructions()
            end,
            "Edit with instructions",
        },
    },
}

local m_opts = {
    mode = "n", -- NORMAL mode
    prefix = "m",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local m_mappings = {
    a = { "<cmd>BookmarkAnnotate<cr>", "Annotate" },
    c = { "<cmd>BookmarkClear<cr>", "Clear" },
    m = { "<cmd>BookmarkToggle<cr>", "Toggle" },
    h = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Harpoon" },
    j = { "<cmd>BookmarkNext<cr>", "Next" },
    k = { "<cmd>BookmarkPrev<cr>", "Prev" },
    s = { "<cmd>BookmarkShowAll<cr>", "Prev" },
    -- s = {
    --   "<cmd>lua require('telescope').extensions.vim_bookmarks.all({ hide_filename=false, prompt_title=\"bookmarks\", shorten_path=false })<cr>",
    --   "Show",
    -- },
    x = { "<cmd>BookmarkClearAll<cr>", "Clear All" },
    u = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Harpoon UI" },
}

-- local ctrl_opts = {
-- 	mode = "n", -- NORMAL mode
-- 	prefix = "ctrl",
-- 	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
-- 	silent = true, -- use `silent` when creating keymaps
-- 	noremap = true, -- use `noremap` when creating keymaps
-- 	nowait = true, -- use `nowait` when creating keymaps
-- }
--
-- local ctrl_mappings = {
-- 	a = { "<cmd>BookmarkAnnotate<cr>", "Annotate" },
-- 	c = { "<cmd>BookmarkClear<cr>", "Clear" },
-- 	m = { "<cmd>BookmarkToggle<cr>", "Toggle" },
-- 	h = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Harpoon" },
-- 	j = { "<cmd>BookmarkNext<cr>", "Next" },
-- 	k = { "<cmd>BookmarkPrev<cr>", "Prev" },
-- 	s = { "<cmd>BookmarkShowAll<cr>", "Prev" },
-- 	-- s = {
-- 	--   "<cmd>lua require('telescope').extensions.vim_bookmarks.all({ hide_filename=false, prompt_title=\"bookmarks\", shorten_path=false })<cr>",
-- 	--   "Show",
-- 	-- },
-- 	x = { "<cmd>BookmarkClearAll<cr>", "Clear All" },
-- 	u = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Harpoon UI" },
-- }
--
local bracket_mappings = {
    ["[b"] = "previous Buffer",
    ["[B"] = "first Buffer",
    ["]b"] = "next Buffer",
    ["]B"] = "last Buffer",
    ["[c"] = "previous Comment block",
    ["[C"] = "first Comment block",
    ["]c"] = "next Comment block",
    ["]C"] = "last Comment block",
    ["[x"] = "previous Conflict marker",
    ["[X"] = "first Conflict marker",
    ["]x"] = "next Conflict marker",
    ["]X"] = "last Conflict marker",
    ["[d"] = "previous Diagnostic",
    ["[D"] = "first Diagnostic",
    ["]d"] = "next Diagnostic",
    ["]D"] = "last Diagnostic",
    ["[f"] = "previous File on disk",
    ["[F"] = "first File on disk",
    ["]f"] = "next File on disk",
    ["]F"] = "last File on disk",
    ["[i"] = "previous Indent change",
    ["[I"] = "first Indent change",
    ["]i"] = "next Indent change",
    ["]I"] = "last Indent change",
    ["[j"] = "previous Jump from jumplist inside current buffer",
    ["[J"] = "first Jump from jumplist inside current buffer",
    ["]j"] = "next Jump from jumplist inside current buffer",
    ["]J"] = "last Jump from jumplist inside current buffer",
    ["[l"] = "previous Location from location list",
    ["[L"] = "first Location from location list",
    ["]l"] = "next Location from location list",
    ["]L"] = "last Location from location list",
    ["[o"] = "previous Old files",
    ["[O"] = "first Old files",
    ["]o"] = "next Old files",
    ["]O"] = "last Old files",
    ["[q"] = "previous Quickfix entry from quickfix list",
    ["[Q"] = "first Quickfix entry from quickfix list",
    ["]q"] = "next Quickfix entry from quickfix list",
    ["]Q"] = "last Quickfix entry from quickfix list",
    ["[t"] = "previous Tree-sitter node and parents",
    ["[T"] = "first Tree-sitter node and parents",
    ["]t"] = "next Tree-sitter node and parents",
    ["]T"] = "last Tree-sitter node and parents",
    ["[u"] = "previous Undo states from specially tracked linear history",
    ["[U"] = "first Undo states from specially tracked linear history",
    ["]u"] = "next Undo states from specially tracked linear history",
    ["]U"] = "last Undo states from specially tracked linear history",
    ["[w"] = "previous Window in current tab",
    ["[W"] = "first Window in current tab",
    ["]w"] = "next Window in current tab",
    ["]W"] = "last Window in current tab",
    ["[y"] = "previous Yank selection replacing latest put region",
    ["[Y"] = "first Yank selection replacing latest put region",
    ["]y"] = "next Yank selection replacing latest put region",
    ["]Y"] = "last Yank selection replacing latest put region",
}

local space_mapping = {
    [" a"] = "add surround",
    [" d"] = "delete surround",
    [" f"] = "find surround(right)",
    [" F"] = "find surround(left)",
    [" r"] = "replace surround(left)",
    [" n"] = "update n_line",
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
which_key.register(m_mappings, m_opts)
which_key.register(bracket_mappings, { mode = "n", prefix = "" })
which_key.register(space_mapping, { mode = "n", prefix = "" })
which_key.register(space_mapping, { mode = "v", prefix = "" })
-- which_key.register(ctrl_mappings,ctrl_opts)
