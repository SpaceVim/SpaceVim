if get(g:, 'spacevim_lint_on_save', 0)
    augroup Neomake_wsd
        au!
        autocmd! BufWritePost * Neomake
    augroup END
endif
