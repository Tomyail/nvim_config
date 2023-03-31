local ok = pcall(require, "nvim-navic")
vim.o.winbar = ok and ("%{%v:lua.require'nvim-navic'.get_location()%}") or ""
