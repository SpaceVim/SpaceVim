"=============================================================================
" hybrid.vim --- hybrid colorschem palette
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" [
"    \ [ a_guifg,  a_guibg,  a_ctermfg,  a_ctermbg],
"    \ [ b_guifg,  b_guibg,  b_ctermfg,  b_ctermbg],
"    \ [ c_guifg,  c_guibg,  c_ctermfg,  c_ctermbg],
"    \ [ z_guibg,  z_ctermbg],
"    \ [ i_guifg,  i_guibg,  i_ctermfg,  i_ctermbg],
"    \ [ v_guifg,  v_guibg,  v_ctermfg,  v_ctermbg],
"    \ [ r_guifg,  r_guibg,  r_ctermfg,  r_ctermbg],
"    \ [ ii_guifg, ii_guibg, ii_ctermfg, ii_ctermbg],
"    \ [ in_guifg, in_guibg, in_ctermfg, in_ctermbg],
" \ ]

function! SpaceVim#mapping#guide#theme#hybrid#palette() abort
    return [
                \ ['#d7ffaf', '#5F875F', 193, 65],
                \ ['#ffffff', '#373b41', 231, 22],
                \ ['#ffffff', '#282a2e', 231, 237],
                \ ['#4e4e4e', 239],
                \ ['#c5c8c6', '#81a2be', 193, 110],
                \ ['#c5c8c6', '#cc6666', 231, 167],
                \ ['#d7d7ff', '#5f5f87', 88, 0],
                \ ['#ffffff', '#689d6a', 231, 72],
                \ ['#ffffff', '#8f3f71', 231, 132],
                \ ]
endfunction
