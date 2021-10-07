"=============================================================================
" FILE: lsp.vim
" License: MIT license
"=============================================================================

function! deoplete#lsp#enable() abort
  if has('vim_starting')
    augroup deoplete#lsp
      autocmd!
      autocmd VimEnter * call deoplete#lsp#enable()
    augroup END

    return 1
  endif

  if deoplete#lsp#init#_is_handler_enabled()
    return 1
  endif

  return deoplete#lsp#init#_enable_handler()
endfunction
