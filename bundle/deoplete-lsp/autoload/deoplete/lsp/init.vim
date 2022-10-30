"=============================================================================
" FILE: init.vim
" License: MIT license
"=============================================================================

if !exists('g:deoplete#lsp#handler_enabled')
  let g:deoplete#lsp#handler_enabled = v:false
endif

if !exists('s:is_handler_enabled')
  let s:is_handler_enabled = v:false
endif

function! deoplete#lsp#init#_is_handler_enabled() abort
  return s:is_handler_enabled
endfunction

function! deoplete#lsp#init#_enable_handler() abort
  if !g:deoplete#lsp#handler_enabled
    return
  endif

  call deoplete#lsp#handler#_init()
  let s:is_handler_enabled = v:true
endfunction
