"=============================================================================
" FILE: echodoc.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

if exists('g:loaded_echodoc') || !exists('v:completed_item')
  finish
endif

" Global options definition.
let g:echodoc#enable_at_startup = get(g:, 'echodoc#enable_at_startup',
      \ get(g:, 'echodoc_enable_at_startup', 0))
if g:echodoc#enable_at_startup
  " Enable startup.
  augroup echodoc
    autocmd!
    autocmd InsertEnter * call echodoc#enable()
  augroup END
endif

" echodoc floating window highlight group
highlight default link EchoDocFloat Pmenu

" echodoc popup window highlight group
highlight default link EchoDocPopup Pmenu

let g:loaded_echodoc = 1
