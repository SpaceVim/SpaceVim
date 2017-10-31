
let s:BASH_COMPLETE = SpaceVim#api#import('bash#complete')

function! SpaceVim#plugins#bashcomplete#complete(ArgLead, CmdLine, CursorPos)
  return s:BASH_COMPLETE.complete_input(a:ArgLead, a:CmdLine, a:CursorPos)
endfunction

function! SpaceVim#plugins#bashcomplete#test()

  call input('shell:', '', 'customlist,SpaceVim#plugins#bashcomplete#complete')

endfunction
