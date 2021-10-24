function! chat#startServer(name) abort

endfunction

function! chat#openWin(...) abort
    if a:0 == 0
        call  chat#chatting#OpenMsgWin()   
    else
        if !empty(globpath(&rtp,'autoload/chat/' . a:1 .'.vim'))
            call call('chat#' . a:1 . '#OpenMsgWin', [])
        endif
    endif
endfunction
