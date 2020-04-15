"=============================================================================
" default-plus.vim --- SpaceVim colorscheme
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Heachen Bear < 960720535@qq.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" default-plus.vim is based on default.vim ,it provide a better looks if you
" like to use vim in transparent terminal

hi clear Normal
set bg&

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "default"
hi Pmenu guifg=#c0c0c0 guibg=#404080
hi PmenuSel guifg=#c0c0c0 guibg=#2050d0
hi PmenuSbar guifg=blue guibg=darkgray
hi PmenuThumb guifg=#c0c0c0
hi LineNr	guifg=#d7daff
hi CursorLineNr guifg=#d7ffff
hi MoreMsg	guifg=springgreen
hi Question	guifg=springgreen
 
" vim: sw=2
