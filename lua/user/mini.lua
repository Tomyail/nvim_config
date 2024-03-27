local status_ok, bufremove = pcall(require, "mini.bufremove")
if status_ok then
	bufremove.setup()
end

--[[ local status_ok, animate = pcall(require, "mini.animate") ]]
--[[ if status_ok then ]]
--[[ 	animate.setup() ]]
--[[ end ]]
local status_ok, indentscope = pcall(require, "mini.indentscope")
if status_ok then
	indentscope.setup()
end

local status_ok, bracketed = pcall(require, "mini.bracketed")
if status_ok then
	bracketed.setup()
end

local status_ok, surround = pcall(require, "mini.surround")
if status_ok then
	surround.setup(
		-- No need to copy this inside `setup()`. Will be used automatically.
		{
			-- Add custom surroundings to be used on top of builtin ones. For more
			-- information with examples, see `:h MiniSurround.config`.
			custom_surroundings = nil,
			-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
			highlight_duration = 500,
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = " a", -- Add surrounding in Normal and Visual modes
				delete = " d", -- Delete surrounding
				find = " f", -- Find surrounding (to the right)
				find_left = " F", -- Find surrounding (to the left)
				highlight = " h", -- Highlight surrounding
				replace = " r", -- Replace surrounding
				update_n_lines = " n", -- Update `n_lines`
				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
			-- Number of lines within which surrounding is searched
			n_lines = 20,
			-- Whether to respect selection type:
			-- - Place surroundings on separate lines in linewise mode.
			-- - Place surroundings on each line in blockwise mode.
			respect_selection_type = false,
			-- How to search for surrounding (first inside current line, then inside
			-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
			-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
			-- see `:h MiniSurround.config`.
			search_method = "cover",
		}
	)
end

local status_ok, ai = pcall(require, "mini.ai")
if status_ok then
	ai.setup({
		-- No need to copy this inside `setup()`. Will be used automatically.
		{
			-- Table with textobject id as fields, textobject specification as values.
			-- Also use this to disable builtin textobjects. See |MiniAi.config|.
			custom_textobjects = nil,
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Main textobject prefixes
				around = "a",
				inside = "i",
				-- Next/last variants
				around_next = "an",
				inside_next = "in",
				around_last = "al",
				inside_last = "il",
				-- Move cursor to corresponding edge of `a` textobject
				goto_left = "g[",
				goto_right = "g]",
			},
			-- Number of lines within which textobject is searched
			n_lines = 50,
			-- How to search for object (first inside current line, then inside
			-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
			-- 'cover_or_nearest', 'next', 'previous', 'nearest'.
			search_method = "cover_or_next",
		},
	})
end

local status_ok, starter = pcall(require, "mini.starter")
if status_ok then
	starter.setup()
end

local status_ok, sessions = pcall(require, "mini.sessions")
if status_ok then
	sessions.setup()
end
-- local status_ok, comment = pcall(require, "mini.comment")
-- if status_ok then
-- 	comment.setup()
-- end
