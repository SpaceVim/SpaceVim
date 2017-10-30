let s:completer = fnamemodify(g:Config_Main_Home, ':p:h:h') . '/autoload/SpaceVim/bin/get_complete'
function! SpaceVim#plugins#bashcomplete#complete(ArgLead, CmdLine, CursorPos)
  let result = systemlist([s:completer, a:CmdLine])
  if a:ArgLead == ''
    let result = map(result, 'a:CmdLine . v:val')
  else
    let leader = substitute(a:CmdLine, '[^ ]*$', '', 'g')
    let result = map(result, 'leader . v:val')
  endif
  return result
endfunction

function! SpaceVim#plugins#bashcomplete#test()

  call input('shell:', '', 'customlist,SpaceVim#plugins#bashcomplete#complete')

endfunction
