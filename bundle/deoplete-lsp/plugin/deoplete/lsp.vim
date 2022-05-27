"=============================================================================
" FILE: lsp.vim
" License: MIT license
"=============================================================================

if exists('g:loaded_deoplete_lsp')
  finish
endif

let g:loaded_deoplete_lsp = 1

" Global options definition.
if get(g:, 'deoplete#enable_at_startup', 0)
  call deoplete#lsp#enable()
endif

let g:completion_docked_hover = get(
      \ g:, 'completion_docked_hover', 0)
let g:completion_docked_maximum_size = get(
      \ g:, 'completion_docked_maximum_size', 10)
let g:completion_docked_minimum_size = get(
      \ g:, 'completion_docked_minimum_size', 3)
