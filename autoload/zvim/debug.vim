let s:debug_message = []
function! zvim#debug#completion_debug(ArgLead, CmdLine, CursorPos) abort
    call add(s:debug_message, "arglead:[".a:ArgLead ."] cmdline:[" .a:CmdLine ."] cursorpos:[" .a:CursorPos ."]")
endfunction

function! zvim#debug#get_message() abort
    return join(s:debug_message, "\n")
endfunction

function! zvim#debug#clean_message() abort
   let s:debug_message = []
   return s:debug_message
endfunction
