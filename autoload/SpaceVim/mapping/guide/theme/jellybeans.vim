"=============================================================================
" jellybeans.vim --- jellybeans colorscheme palette
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
" Color palette
let s:gui00 = "#151515"
let s:gui01 = "#262626"
let s:gui02 = "#4f5b66"
let s:gui03 = "#65737e"
let s:gui04 = "#a7adba"
let s:gui05 = "#c0c5ce"
let s:gui06 = "#cdd3de"
let s:gui07 = "#d8dee9"
let s:gui08 = "#870000"
let s:gui09 = "#f99157"
let s:gui0A = "#fac863"
let s:gui0B = "#437019"
let s:gui0C = "#5fb3b3"
let s:gui0D = "#0d61ac"
let s:gui0E = "#c594c5"
let s:gui0F = "#ab7967"

let s:cterm00 = "233"
let s:cterm01 = "235"
let s:cterm02 = "59"
let s:cterm03 = "66"
let s:cterm04 = "145"
let s:cterm05 = "152"
let s:cterm06 = "188"
let s:cterm07 = "189"
let s:cterm08 = "88"
let s:cterm09 = "209"
let s:cterm0A = "221"
let s:cterm0B = "22"
let s:cterm0C = "73"
let s:cterm0D = "25"
let s:cterm0E = "176"
let s:cterm0F = "137"

let s:guiWhite = "#ffffff"
let s:guiGray = "#666666"
let s:ctermWhite = "231"
let s:ctermGray = "243"

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

function! SpaceVim#mapping#guide#theme#gruvbox#palette() abort
    return [
                \ ['#d8dee9', '#0d61ac', 189, 25],
                \ ['#ffffff', '#262626', 231, 233],
                \ ['#4f5b66', '#151515', 237, 246],
                \ ['#665c54', 241],
                \ ['#ffffff', '#437019', 231, 233],
                \ ['#282828', '#fe8019', 235, 208],
                \ ['#282828', '#8ec07c', 235, 108],
                \ ['#282828', '#689d6a', 235, 72],
                \ ['#282828', '#8f3f71', 235, 132],
                \ ]
endfunction
