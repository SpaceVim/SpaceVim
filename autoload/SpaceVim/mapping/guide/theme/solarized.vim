"=============================================================================
" solarized.vim --- solarized theme for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" the theme colors should be 
" [
"    \ [ a_guifg, a_guibg, a_ctermbg, a_ctermfg],
"    \ [ b_guifg, b_guibg, b_ctermbg, b_ctermfg],
"    \ [ c_guifg, c_guibg, c_ctermbg, c_ctermfg],
"    \ [ z_guibg, z_ctermbg],
"    \ [ i_guibg, i_guifg, i_ctermbg, i_ctermfg],
"    \ [ v_guibg, v_guifg, v_ctermbg, v_ctermfg],
"    \ [ r_guibg, r_guifg, r_ctermbg, r_ctermfg],
" \ ]
" group_a: window id
" group_b/group_c: stausline sections
" group_z: empty area 
" group_i: window id in insert mode
" group_v: window id in visual mode
" group_r: window id in select mode

let s:gui_base03      = '#002b36'
let s:gui_base02      = '#073642'
let s:gui_base01      = '#586e75'
let s:gui_base00      = '#657b83'
let s:gui_base0       = '#839496'
let s:gui_base1       = '#93a1a1'
let s:gui_base2       = '#eee8d5'
let s:gui_base3       = '#fdf6e3'
let s:gui_yellow      = '#b58900'
let s:gui_orange      = '#cb4b16'
let s:gui_red         = '#dc322f'
let s:gui_magenta     = '#d33682'
let s:gui_violet      = '#6c71c4'
let s:gui_blue        = '#268bd2'
let s:gui_cyan        = '#2aa198'
"let s:gui_green       = "#859900" "original
let s:gui_green       = '#719e07' "experimental

let s:cterm_base03      = 8
let s:cterm_base02      = 0
let s:cterm_base01      = 10
let s:cterm_base00      = 11
let s:cterm_base0       = 12
let s:cterm_base1       = 14
let s:cterm_base2       = 7
let s:cterm_base3       = 15
let s:cterm_yellow      = 3
let s:cterm_orange      = 9
let s:cterm_red         = 1
let s:cterm_magenta     = 5
let s:cterm_violet      = 13
let s:cterm_blue        = 4
let s:cterm_cyan        = 6
let s:cterm_green       = 2

function! SpaceVim#mapping#guide#theme#solarized#palette() abort
  if &background ==# 'light'
    return [
          \ [s:gui_base03, s:gui_base01, s:cterm_base01, s:cterm_base03],
          \ [s:gui_base02, s:gui_base1,  s:cterm_base1,  s:cterm_base02],
          \ [s:gui_base02, s:gui_base0,  s:cterm_base0,  s:cterm_base02],
          \ [s:gui_base2,  s:cterm_base2],
          \ [s:gui_base03, s:gui_blue,   s:cterm_base03, s:cterm_blue],
          \ [s:gui_base03, s:gui_orange, s:cterm_base03, s:cterm_orange],
          \ [s:gui_base03, s:gui_cyan,   s:cterm_base03, s:cterm_cyan],
          \ ['#282828', '#689d6a', 235, 72],
          \ ['#282828', '#8f3f71', 235, 132],
          \ ]
  else
    return [
          \ [s:gui_base3,  s:gui_base1,  s:cterm_base1,  s:cterm_base3],
          \ [s:gui_base2,  s:gui_base01, s:cterm_base01, s:cterm_base2],
          \ [s:gui_base2,  s:gui_base00, s:cterm_base00, s:cterm_base2],
          \ [s:gui_base02, s:cterm_base02],
          \ [s:gui_base3,  s:gui_blue,   s:cterm_base3, s:cterm_blue],
          \ [s:gui_base3,  s:gui_orange, s:cterm_base3, s:cterm_orange],
          \ [s:gui_base3,  s:gui_cyan,   s:cterm_base3, s:cterm_cyan],
          \ ['#282828', '#689d6a', 235, 72],
          \ ['#282828', '#8f3f71', 235, 132],
          \ ]
  endif
endfunction
