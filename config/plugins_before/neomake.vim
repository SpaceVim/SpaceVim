if get(g:, 'spacevim_lint_on_save', 0)
    augroup Neomake_on_save
        au!
        autocmd! BufWritePost * call s:neomake()
    augroup END
endif

let g:_spacevim_toggle_syntax_flag = 1

function! s:neomake() abort
    if g:_spacevim_toggle_syntax_flag == 1
        Neomake
    endif
endfunction

if get(g:, 'spacevim_lint_on_the_fly', 0)
    let g:neomake_tempfile_enabled = 1
    let g:neomake_open_list = 0
    augroup Neomake_on_the_fly
        au!
        autocmd! TextChangedI * call s:neomake()
    augroup END
endif
