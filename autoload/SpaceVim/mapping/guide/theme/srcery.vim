"=============================================================================
" srcery.vim --- srcery theme for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Color Palette {{{

let s:black          = [ '#1c1b19',   0 ]
let s:red            = [ '#ef2f27',   1 ]
let s:green          = [ '#519f50',   2 ]
let s:yellow         = [ '#fbb829',   3 ]
let s:blue           = [ '#2c78bf',   4 ]
let s:magenta        = [ '#e02c6d',   5 ]
let s:cyan           = [ '#0aaeb3',   6 ]
let s:white          = [ '#918175',   7 ]
let s:bright_black   = [ '#2d2c29',   8 ]
let s:bright_red     = [ '#f75341',   9 ]
let s:bright_green   = [ '#98bc37',  10 ]
let s:bright_yellow  = [ '#fed06e',  11 ]
let s:bright_blue    = [ '#68a8e4',  12 ]
let s:bright_magenta = [ '#ff5c8f',  13 ]
let s:bright_cyan    = [ '#53fde9',  14 ]
let s:bright_white   = [ '#fce8c3',  15 ]

" xterm Colors
let s:orange         = [ '#d75f00', 166 ]
let s:bright_orange  = [ '#ff8700', 208 ]
let s:hard_black     = [ '#121212', 233 ]
let s:xgray1         = [ '#262626', 235 ]
let s:xgray2         = [ '#303030', 236 ]
let s:xgray3         = [ '#3a3a3a', 237 ]
let s:xgray4         = [ '#444444', 238 ]
let s:xgray5         = [ '#4e4e4e', 239 ]

" }}}

" the theme colors should be
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
" group_a: window id
" group_b/group_c: stausline sections
" group_z: empty area
" group_i: window id in insert mode
" group_v: window id in visual mode
" group_r: window id in select mode
" group_ii: window id in iedit-insert mode
" group_in: windows id in iedit-normal mode
function! SpaceVim#mapping#guide#theme#srcery#palette() abort
    return [
                \ ['#282828', '#fce8c3', 246, 15],
                \ ['#a89984', '#2d2c29', 239, 8],
                \ ['#a89984', '#3c3836', 237, 246],
                \ ['#665c54', 241],
                \ ['#282828', '#83a598', 235, 109],
                \ ['#282828', '#0aaeb3', 235, 6],
                \ ['#282828', '#8ec07c', 235, 108],
                \ ['#282828', '#689d6a', 235, 72],
                \ ['#282828', '#8f3f71', 235, 132],
                \ ]
endfunction
