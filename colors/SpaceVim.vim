"=============================================================================
" SpaceVim.vim --- default color scheme for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif


if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  " prevent change statuslines
  finish
else
  let g:colors_name='SpaceVim'
endif

let s:HIAPI = SpaceVim#api#import('vim#highlight')
let s:COLOR = SpaceVim#api#import('color')

" color palette

let s:palette = {
      \ 'dark' : [
      \ ['Normal'     , 249 , 235 , 'None' , 'None'] ,
      \ ['Cursor'     , 235 , 178 , 'bold' , 'bold'] ,
      \ ['Pmenu'      , 141 , 234 , 'None' , 'None'] ,
      \ ['PmenuSel'   , 251 , 97  , 'None' , 'None'] ,
      \ ['PmenuSbar'  , 28  , 233 , 'None' , 'None'] ,
      \ ['PmenuThumb' , 160 , 97  , 'None' , 'None'] ,
      \ ['LineNr'     , 238 , 234 , 'None' , 'None'] ,
      \ ['CursorLine' , ''  , 234 , 'None' , 'None'],
      \ ['CursorLineNr' , 134 , 234 , 'None' , 'None'],
      \ ['CursorColumn' , ''  , 234 , 'None' , 'None'],
      \ ['ColorColumn' , ''  , 234 , 'None' , 'None'],
      \ ],
      \ 'light' : [
      \ ['Normal' , 249, 235, 'None', 'None'],
      \ ],
      \ }

function! s:hi() abort
  for [item, fg, bg, cterm, gui] in s:palette[&background]
    call s:HIAPI.hi(
          \ {
          \ 'name' : item,
          \ 'ctermbg' : bg,
          \ 'ctermfg' : fg,
          \ 'guifg' : s:COLOR.nr2str(fg),
          \ 'guibg' : s:COLOR.nr2str(bg),
          \ 'cterm' : cterm,
          \ 'gui' : gui,
          \ }
          \ )
  endfor
endfunction

call s:hi()
