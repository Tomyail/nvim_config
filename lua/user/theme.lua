-- vim.cmd[[colorscheme gruvbox]]

vim.cmd([[
try
  colorscheme tokyonight
		" colorscheme nord
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme habamax
  set background=dark
endtry
]])
vim.cmd([[highlight Normal guibg=none]])

local status_ok, colorizer = pcall(require, "nvim-highlight-colors")
if not status_ok then
	return
end

colorizer.setup({
	render = "foreground",
	enable_named_colors = true,
	enable_tailwind = true,
})
