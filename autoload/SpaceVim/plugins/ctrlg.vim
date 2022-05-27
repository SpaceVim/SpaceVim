"=============================================================================
" ctrlg.vim --- display info via Ctrl-g
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
if exists('s:loaded')
  finish
endif
let s:loaded = 1

let s:save_cpo = &cpo
set cpo&vim

let s:win  = has("win32") || has("win64") || has("win16")
let s:lang = exists("$LANG") ? tolower($LANG[:1]) : 'en'

function! SpaceVim#plugins#ctrlg#display() abort
  
  let pwd = getcwd()

  if isdirectory('.git')
    let project_name = printf('[%s]', fnamemodify(pwd, ':t'))
  else
    let project_name = ''
  endif

  let file = fnamemodify(expand('%'), '.')

  if !empty(project_name)
    echohl Constant   | echo project_name
    echohl WarningMsg | echon "  >>  "
  endif
  echohl Special    | echon pwd
  echohl WarningMsg | echon "  >>  "
  echohl Directory  | echon file
endfun

let &cpo = s:save_cpo
unlet s:save_cpo
