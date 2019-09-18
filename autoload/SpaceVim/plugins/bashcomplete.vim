"=============================================================================
" bashcomplete.vim --- bash complete for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:BASH_COMPLETE = SpaceVim#api#import('bash#complete')

if !exists('g:bashcomplete_debug')
  let g:bashcomplete_debug = 0
endif

" complete input

function! SpaceVim#plugins#bashcomplete#complete(ArgLead, CmdLine, CursorPos) abort
  return s:BASH_COMPLETE.complete_input(a:ArgLead, a:CmdLine, a:CursorPos)
endfunction


" bash omni
"

let s:pos = 0

let s:str = ''

let s:base = ''

function! SpaceVim#plugins#bashcomplete#omnicomplete(findstart, base) abort
  if a:findstart
    let str = getline('.')[:col('.') - 2]
    let s:str = substitute(str, '[^ ]*$', '' , 'g')
    let s:pos = len(s:str)
    if g:bashcomplete_debug
      echom 'pos is ' . s:pos
    endif
    let s:base = str[s:pos :]
    return s:pos
  else
    if g:bashcomplete_debug
      echom 's:base is : "' . s:base . '" '  . 'cmdline is "' . s:str . s:base . '"'
    endif
    return s:BASH_COMPLETE.complete(a:base, s:str . s:base, col('.'))
  endif
  

endfunction
