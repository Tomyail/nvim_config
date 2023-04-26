vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
    autocmd BufNewFile,BufRead *.omnijs set filetype=javascript
  augroup end
  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end
  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end
  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end
  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end
  augroup _quickfix
  autocmd!
    autocmd FileType qf nnoremap <buffer> <silent> <C-v> :lua require('user.functions').open_qf_file_in_direction("vertical")<CR>
    autocmd FileType qf nnoremap <buffer> <silent> <C-s> :lua require('user.functions').open_qf_file_in_direction("split")<CR>
  augroup end
]])

-- exit win if nvimtree is the only win
--[[ vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif" ]]
--[[ vim.api.nvim_create_autocmd("BufEnter", { ]]
--[[   nested = true, ]]
--[[   callback = function() ]]
--[[     if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then ]]
--[[       vim.cmd "quit" ]]
--[[     end ]]
--[[   end ]]
--[[ }) ]]
vim.cmd([[
  autocmd InsertLeave * lua require('user.functions').switch_to_english()
]])
vim.cmd([[
  autocmd InsertEnter * lua require('user.functions').check_and_switch_input_method()
]])

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		vim.cmd("hi link illuminatedWord LspReferenceText")
	end,
})
