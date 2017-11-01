
let s:BASH_COMPLETE = SpaceVim#api#import('bash#complete')

if !exists('g:bashcomplete_debug')
  let g:bashcomplete_debug = 0
endif

" complete input

function! SpaceVim#plugins#bashcomplete#complete(ArgLead, CmdLine, CursorPos)
  return s:BASH_COMPLETE.complete_input(a:ArgLead, a:CmdLine, a:CursorPos)
endfunction


" bash omni
"

let s:pos = 0

let s:str = ''

function! SpaceVim#plugins#bashcomplete#omnicomplete(findstart, base) abort
  if a:findstart
    let str = getline('.')[:col('.') - 2]
    let s:str = substitute(str, '[^ ]*$', '' , 'g')
    let s:pos = len(s:str)
    if g:bashcomplete_debug
      echom 'pos is ' . s:pos
    endif
    return s:pos
  else
    if g:bashcomplete_debug
      echom 'a:base is : "' . a:base . '" '  . 'cmdline is "' . s:str . a:base . '"'
    endif
    return s:BASH_COMPLETE.complete(a:base, s:str . a:base, col('.'))
  endif
  

endfunction
