if get(g:, 'spacevim_lint_on_save', 0)
    augroup Neomake_on_save
        au!
        autocmd! BufWritePost * Neomake
    augroup END
endif
if empty(maparg('<leader>ck', '',0,1))
    nnoremap <silent> <Leader>ck :Neomake<CR>
endif

if get(g:, 'spacevim_lint_on_the_fly', 0)
    let g:neomake_tempfile_enabled = 1
    let g:neomake_open_list = 0
    augroup Neomake_on_the_fly
        au!
        autocmd! TextChangedI * Neomake
    augroup END
endif
