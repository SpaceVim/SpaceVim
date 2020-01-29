"=============================================================================
" SpaceVim.vim --- SpaceVim theme
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" the theme colors should be 
" [
"    \ [ a_guifg, a_guibg, a_ctermfg, a_ctermbg],
"    \ [ b_guifg, b_guibg, b_ctermfg, b_ctermbg],
"    \ [ c_guifg, c_guibg, c_ctermfg, c_ctermbg],
"    \ [ z_guibg, z_ctermbg],
"    \ [ i_guifg, i_guibg, i_ctermfg, i_ctermbg],
"    \ [ v_guifg, v_guibg, v_ctermfg, v_ctermbg],
"    \ [ r_guifg, r_guibg, r_ctermfg, r_ctermbg],
" \ ]

function! SpaceVim#mapping#guide#theme#SpaceVim#palette() abort
    return [
                \ ['#282828' , '#FFA500' , 250, 97],
                \ ['#d75fd7' , '#4e4e4e' , 170 , 239],
                \ ['#c6c6c6' , '#3a3a3a' , 251 , 237],
                \ ['#1c1c1c', 16],
                \ ['#282828', '#00BFFF', 114, 152],
                \ ['#2c323c', '#ff8787', 114, 210],
                \ ['#2c323c', '#d75f5f', 114, 167],
                \ ['#282828', '#689d6a', 235, 72],
                \ ['#282828', '#8f3f71', 235, 132],
                \ ]
endfunction
