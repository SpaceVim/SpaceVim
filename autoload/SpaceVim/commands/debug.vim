let s:debug_message = []
function! SpaceVim#commands#debug#completion_debug(ArgLead, CmdLine, CursorPos) abort
    call add(s:debug_message, 'arglead:['.a:ArgLead .'] cmdline:[' .a:CmdLine .'] cursorpos:[' .a:CursorPos .']')
endfunction

function! SpaceVim#commands#debug#get_message() abort
    return join(s:debug_message, "\n")
endfunction

function! SpaceVim#commands#debug#clean_message() abort
   let s:debug_message = []
   return s:debug_message
endfunction
