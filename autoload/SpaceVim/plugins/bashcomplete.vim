
let s:BASH_COMPLETE = SpaceVim#api#import('bash#complete')

" complete input

function! SpaceVim#plugins#bashcomplete#complete(ArgLead, CmdLine, CursorPos)
  return s:BASH_COMPLETE.complete_input(a:ArgLead, a:CmdLine, a:CursorPos)
endfunction


" bash omni


function! SpaceVim#plugins#bashcomplete#omnicomplete(findstart, base)

  if a:findstart
    let str = getline('.')[:col('.') - 2]
    let pos = len(substitute(str, '[^ ]*$', '' , 'g'))
    return pos
  else
    let str = getline('.')[:col('.') - 1] . a:base
    return s:BASH_COMPLETE.complete(a:base, str, col('.'))
  endif
  

endfunction

function! SpaceVim#plugins#bashcomplete#test()

  call input('shell:', '', 'customlist,SpaceVim#plugins#bashcomplete#complete')

endfunction
