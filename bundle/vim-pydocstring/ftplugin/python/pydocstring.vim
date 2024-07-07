" File:     pydocstring.vim
" Author:   Shinya Ohyanagi <sohyanagi@gmail.com>
" Version:  2.5.0
" WebPage:  http://github.com/heavenshell/vim-pydocstring/
" Description: Generate Python docstring to your Python script file.
" License: BSD, see LICENSE for more details.

let s:save_cpo = &cpo
set cpo&vim

" version check
if !has('nvim') && (!has('channel') || !has('job'))
  echoerr '+channel and +job are required for pydocstring.vim'
  finish
endif

command! -buffer -nargs=0 -range=0 Pydocstring call pydocstring#insert(<q-args>, <count>, <line1>, <line2>)
command! -buffer -nargs=0 PydocstringFormat call pydocstring#format()

nnoremap <silent> <buffer> <Plug>(pydocstring) :call pydocstring#insert()<CR>
if get(g:, 'pydocstring_enable_mapping', 1)
  if !hasmapto('<Plug>(pydocstring)', 'n')
    nmap <silent> <buffer> <C-l> <Plug>(pydocstring)
  endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo
