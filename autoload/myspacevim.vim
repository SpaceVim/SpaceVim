function! myspacevim#before() abort
    let g:neomake_enabled_c_makers = ['clang']
    nnoremap jk <Esc>
endfunction

function! myspacevim#after() abort
    iunmap jk
endfunction
