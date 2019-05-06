"=============================================================================
" SpaceVim.vim --- SpaceVim colorscheme
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


if v:version > 580
  hi clear
  if exists('syntax_on')
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
let s:is_dark=(&background ==# 'dark')

function! s:hi(items) abort
  for [item, fg, bg, cterm, gui] in a:items
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

" color palette

let s:palette = {
      \ 'dark' : [
      \ ['Boolean'          , 178 , ''  , 'None'      , 'None']      ,
      \ ['Character'        , 75  , ''  , 'None'      , 'None']      ,
      \ ['ColorColumn'      , ''  , 236 , 'None'      , 'None']      ,
      \ ['Comment'          , 30  , ''  , 'None'      , 'italic']    ,
      \ ['Conditional'      , 68  , ''  , 'bold'      , 'bold']      ,
      \ ['Constant'         , 218 , ''  , 'None'      , 'None']      ,
      \ ['Cursor'           , 235 , 178 , 'bold'      , 'bold']      ,
      \ ['CursorColumn'     , ''  , 236 , 'None'      , 'None']      ,
      \ ['CursorLine'       , ''  , 236 , 'None'      , 'None']      ,
      \ ['CursorLineNr'     , 134 , 236 , 'None'      , 'None']      ,
      \ ['Debug'            , 225 , ''  , 'None'      , 'None']      ,
      \ ['Define'           , 177 , ''  , 'None'      , 'None']      ,
      \ ['Delimiter'        , 151 , ''  , 'None'      , 'None']      ,
      \ ['DiffAdd'          , ''  , 24  , 'None'      , 'None']      ,
      \ ['DiffChange'       , 181 , 239 , 'None'      , 'None']      ,
      \ ['DiffDelete'       , 162 , 53  , 'None'      , 'None']      ,
      \ ['DiffText'         , ''  , 102 , 'None'      , 'None']      ,
      \ ['Directory'        , 67  , ''  , 'bold'      , 'bold']      ,
      \ ['Error'            , 160 , 235 , 'bold'      , 'bold']      ,
      \ ['ErrorMsg'         , 196 , 235 , 'bold'      , 'bold']      ,
      \ ['Exception'        , 204 , ''  , 'bold'      , 'bold']      ,
      \ ['Float'            , 135 , ''  , 'None'      , 'None']      ,
      \ ['FoldColumn'       , 67  , 236 , 'None'      , 'None']      ,
      \ ['Folded'           , 133 , 236 , 'bold'      , 'bold']      ,
      \ ['Function'         , 169 , ''  , 'bold'      , 'bold']      ,
      \ ['Identifier'       , 167 , ''  , 'None'      , 'None']      ,
      \ ['Ignore'           , 244 , ''  , 'None'      , 'None']      ,
      \ ['IncSearch'        , 16  , 76  , 'bold'      , 'bold']      ,
      \ ['Keyword'          , 68  , ''  , 'bold'      , 'bold']      ,
      \ ['Label'            , 104 , ''  , 'None'      , 'None']      ,
      \ ['LineNr'           , 238 , 235 , 'None'      , 'None']      ,
      \ ['Macro'            , 140 , ''  , 'None'      , 'None']      ,
      \ ['MatchParen'       , 40  , 234 , 'bold       , underline'   , 'bold , underline'] ,
      \ ['ModeMsg'          , 229 , ''  , 'None'      , 'None']      ,
      \ ['NonText'          , 241 , ''  , 'None'      , 'None']      ,
      \ ['Normal'           , 249 , 235 , 'None'      , 'None']      ,
      \ ['Number'           , 176 , ''  , 'None'      , 'None']      ,
      \ ['Operator'         , 111 , ''  , 'None'      , 'None']      ,
      \ ['Pmenu'            , 141 , 236 , 'None'      , 'None']      ,
      \ ['PmenuSbar'        , 28  , 233 , 'None'      , 'None']      ,
      \ ['PmenuSel'         , 251 , 97  , 'None'      , 'None']      ,
      \ ['PmenuThumb'       , 160 , 97  , 'None'      , 'None']      ,
      \ ['PreCondit'        , 139 , ''  , 'None'      , 'None']      ,
      \ ['PreProc'          , 176 , ''  , 'None'      , 'None']      ,
      \ ['Question'         , 81  , ''  , 'None'      , 'None']      ,
      \ ['Repeat'           , 68  , ''  , 'bold'      , 'bold']      ,
      \ ['Search'           , 16  , 76  , 'bold'      , 'bold']      ,
      \ ['SignColumn'       , 118 , 235 , 'None'      , 'None']      ,
      \ ['Special'          , 169 , ''  , 'None'      , 'None']      ,
      \ ['SpecialChar'      , 171 , ''  , 'bold'      , 'bold']      ,
      \ ['SpecialComment'   , 24  , ''  , 'None'      , 'None']      ,
      \ ['SpecialKey'       , 59  , ''  , 'None'      , 'None']      ,
      \ ['SpellBad'         , 168 , ''  , 'underline' , 'undercurl'] ,
      \ ['SpellCap'         , 110 , ''  , 'underline' , 'undercurl'] ,
      \ ['SpellLocal'       , 253 , ''  , 'underline' , 'undercurl'] ,
      \ ['SpellRare'        , 218 , ''  , 'underline' , 'undercurl'] ,
      \ ['Statement'        , 68  , ''  , 'None'      , 'None']      ,
      \ ['StatusLine'       , 140 , 238 , 'None'      , 'None']      ,
      \ ['StatusLineNC'     , 242 , 237 , 'None'      , 'None']      ,
      \ ['StatusLineTerm'   , 140 , 238 , 'bold'      , 'bold']      ,
      \ ['StatusLineTermNC' , 244 , 237 , 'bold'      , 'bold']      ,
      \ ['StorageClass'     , 178 , ''  , 'bold'      , 'bold']      ,
      \ ['String'           , 36  , ''  , 'None'      , 'None']      ,
      \ ['Structure'        , 68  , ''  , 'bold'      , 'bold']      ,
      \ ['TabLine'          , 66  , 239 , 'None'      , 'None']      ,
      \ ['TabLineFill'      , 145 , 238 , 'None'      , 'None']      ,
      \ ['TabLineSel'       , 178 , 240 , 'None'      , 'None']      ,
      \ ['Tag'              , 161 , ''  , 'None'      , 'None']      ,
      \ ['Title'            , 176 , ''  , 'None'      , 'None']      ,
      \ ['Todo'             , 172 , 235 , 'bold'      , 'bold']      ,
      \ ['Type'             , 68  , ''  , 'None'      , 'None']      ,
      \ ['Typedef'          , 68  , ''  , 'None'      , 'None']      ,
      \ ['VertSplit'        , 234 , ''  , 'None'      , 'None']      ,
      \ ['Visual'           , ''  , 238 , 'None'      , 'None']      ,
      \ ['VisualNOS'        , ''  , 238 , 'None'      , 'None']      ,
      \ ['Warning'          , 136 , ''  , 'bold'      , 'bold']      ,
      \ ['WarningMsg'       , 136 , ''  , 'bold'      , 'bold']      ,
      \ ['WildMenu'         , 214 , 239 , 'None'      , 'None']      ,
      \ ['VertSplit'        , 235 , 238 , 'None'      , 'None']      ,
      \ ]                   ,
      \ 'light' : [
      \ ],
      \ }

call s:hi(s:palette[s:is_dark ? 'dark' : 'light'])


if s:is_dark
  set background=dark
endif
