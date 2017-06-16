" the theme colors should be 
" [
"    \ [ a_guifg, a_guibg, a_ctermfg, a_ctermbg],
"    \ [ b_guifg, b_guibg, b_ctermfg, b_ctermbg],
"    \ [ c_guifg, c_guibg, c_ctermfg, c_ctermbg],
"    \ [ z_guibg, z_ctermbg],
"    \ [ i_guifg, i_guibg, i_ctermfg, i_ctermbg],
"    \ [ v_guifg, v_guibg, v_ctermfg, v_ctermbg],
" \ ]


function! SpaceVim#mapping#guide#theme#gruvbox#palette() abort
    return [
                \ ['#282828', '#a89984', 246, 235],
                \ ['#a89984', '#504945', 239, 246],
                \ ['#a89984', '#3c3836', 237, 246],
                \ ['#665c54', 241]
                \ ]
endfunction
