"=============================================================================
" FILE: autoload/incsearch/autocmd.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

noremap  <silent><expr> <Plug>(_incsearch-nohlsearch) incsearch#autocmd#auto_nohlsearch(0)
noremap! <silent><expr> <Plug>(_incsearch-nohlsearch) incsearch#autocmd#auto_nohlsearch(0)
nnoremap <silent>       <Plug>(_incsearch-nohlsearch) :<C-u>nohlsearch<CR>
xnoremap <silent>       <Plug>(_incsearch-nohlsearch) :<C-u>nohlsearch<CR>gv

" Make sure move cursor by search related action __after__ calling this
" function because the first move event just set nested autocmd which
" does :nohlsearch
" @expr
function! incsearch#autocmd#auto_nohlsearch(nest) abort
  " NOTE: see this value inside this function in order to toggle auto
  " :nohlsearch feature easily with g:incsearch#autocmd#auto_nohlsearch option
  if !g:incsearch#auto_nohlsearch | return '' | endif
  return s:auto_nohlsearch(a:nest)
endfunction

function! incsearch#autocmd#is_set() abort
  return exists('#incsearch-auto-nohlsearch#CursorMoved')
endfunction

function! s:auto_nohlsearch(nest) abort
  " NOTE: :h autocmd-searchpat
  "   You cannot implement this feature without feedkeys() because of
  "   :h autocmd-searchpat
  augroup incsearch-auto-nohlsearch
    autocmd!
    autocmd InsertEnter * :call <SID>attach_on_insert_leave() | autocmd! incsearch-auto-nohlsearch
    execute join([
    \   'autocmd CursorMoved *'
    \ , repeat('autocmd incsearch-auto-nohlsearch CursorMoved * ', a:nest)
    \ , 'call feedkeys("\<Plug>(_incsearch-nohlsearch)", "m")'
    \ , '| autocmd! incsearch-auto-nohlsearch'
    \ ], ' ')
  augroup END
  return ''
endfunction

function! s:attach_on_insert_leave() abort
  augroup incsearch-auto-nohlsearch-on-insert-leave
    autocmd!
    autocmd InsertLeave * :call incsearch#autocmd#auto_nohlsearch(1)
    \ | autocmd! incsearch-auto-nohlsearch-on-insert-leave
  augroup END
  return ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
