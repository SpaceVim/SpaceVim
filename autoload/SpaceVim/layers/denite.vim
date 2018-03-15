"=============================================================================
" denite.vim --- SpaceVim denite layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#denite#plugins() abort
  return [
        \ ['Shougo/denite.nvim',{ 'merged' : 0, 'loadconf' : 1}],
        \ ['pocari/vim-denite-emoji', {'merged' : 0}],
        \ ]
endfunction

function! SpaceVim#layers#denite#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['j', 'i'], 'Denite outline', 'jump to a definition in buffer', 1)
  nnoremap <silent> <C-p> :Denite file_rec<cr>
  let g:_spacevim_mappings.f = {'name' : '+Fuzzy Finder'}
  call s:defind_fuzzy_finder()
endfunction

let s:file = expand('<sfile>:~')
let s:unite_lnum = expand('<slnum>') + 3
function! s:defind_fuzzy_finder() abort
  nnoremap <silent> <Leader>fr
        \ :<C-u>Denite -buffer-name=resume resume<CR>
  let lnum = expand('<slnum>') + s:unite_lnum - 4
  let g:_spacevim_mappings.f.r = ['Denite -buffer-name=resume resume',
        \ 'resume unite window',
        \ [
        \ '[Leader f r ] is to resume unite window',
        \ '',
        \ 'Definition: ' . s:file . ':' . lnum,
        \ ]
        \ ]
endfunction
" vim:set et sw=2 cc=80:
