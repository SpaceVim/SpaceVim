"=============================================================================
" palenight.vim --- palenight theme
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" Color Palette {{{
let s:gui01   = '#44475a'
let s:gui02   = '#5f6a8e'
let s:gui03   = '#ffb86c'
let s:gui04   = '#bd93f9'
let s:gui05   = '#ff5555'
let s:gui06   = '#f1fa8c'
let s:gui07   = '#50fa7b'
let s:gui08   = '#bd93f9'
let s:cterm01 = '236'
let s:cterm02 = '61'
let s:cterm03 = '215'
let s:cterm04 = '141'
let s:cterm05 = '160'
let s:cterm06 = '228'
let s:cterm07 = '84'
let s:cterm08 = '141'

let s:guiWhite   = '#f8f8f2'
let s:guiBlack   = '#282a36'
let s:ctermWhite = '15'
let s:ctermBlack = '16'

let s:ctermChangedColor = '59'
let s:guiChangedColor   = '#5f5f5f'

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

function! SpaceVim#mapping#guide#theme#palenight#palette() abort
  let is_bright = SpaceVim#layers#colorscheme#get_variable()['bright_statusline']
  if is_bright
    return [
          \ [ s:guiBlack , s:gui08 , s:ctermBlack , s:cterm08 ],
          \ [ s:guiWhite , s:gui02 , s:ctermWhite , s:cterm02 ],
          \ [ s:guiWhite , s:gui02 , s:ctermWhite , s:cterm02 ],
          \ [ s:gui01    , s:cterm01 ],
          \ [ s:guiBlack , s:gui07 , s:ctermBlack , s:cterm07 ],
          \ [ s:guiBlack , s:gui06 , s:ctermBlack , s:cterm06 ],
          \ [ s:guiBlack , s:gui05 , s:ctermWhite , s:cterm05 ],
          \ ['#282828', '#689d6a', 235, 72],
          \ ['#282828', '#8f3f71', 235, 132],
          \ ]
  else
    return [
          \ [ s:guiBlack , s:gui08 , s:ctermBlack , s:cterm08 ],
          \ [ s:guiWhite , s:gui01 , s:ctermWhite , s:cterm01 ],
          \ [ s:guiWhite , s:gui01 , s:ctermWhite , s:cterm01 ],
          \ [ s:guiChangedColor, s:ctermChangedColor],
          \ [ s:guiBlack , s:gui07 , s:ctermBlack , s:cterm07 ],
          \ [ s:guiBlack , s:gui06 , s:ctermBlack , s:cterm06 ],
          \ [ s:guiBlack , s:gui05 , s:ctermWhite , s:cterm05 ],
          \ ['#282828', '#689d6a', 235, 72],
          \ ['#282828', '#8f3f71', 235, 132],
          \ ]
  endif
endfunction
