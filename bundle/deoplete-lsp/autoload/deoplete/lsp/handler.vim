"=============================================================================
" FILE: handler.vim
" License: MIT license
"=============================================================================

function! deoplete#lsp#handler#_init() abort
  augroup deoplete#lsp
    autocmd!
    autocmd InsertEnter * lua require'hover'.insert_enter_handler()
    autocmd InsertLeave * lua require'hover'.insert_leave_handler()
  augroup END
endfunction
