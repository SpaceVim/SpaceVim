""
" @dict VlimeConnection.CreateREPL
" @usage [coding_system] [callback]
" @public
"
" Create the REPL thread, and optionally register a [callback] function to
" handle the result.
"
" [coding_system] is implementation-dependent. Omit this argument or pass
" v:null to let the server choose it for you.
"
" This method needs the SWANK-REPL contrib module. See
" @function(VlimeConnection.SwankRequire).
function! vlime#contrib#repl#CreateREPL(...) dict
    function! s:CreateREPL_CB(conn, Callback, chan, msg) abort
        call vlime#CheckReturnStatus(a:msg, 'vlime#contrib#repl#CreateREPL')
        " The package for the REPL defaults to ['COMMON-LISP-USER', 'CL-USER'],
        " so SetCurrentPackage(...) is not necessary.
        "call a:conn.SetCurrentPackage(a:msg[1][1])
        call vlime#TryToCall(a:Callback, [a:conn, a:msg[1][1]])
    endfunction

    let cmd = [vlime#SYM('SWANK-REPL', 'CREATE-REPL'), v:null]
    let coding_system = get(a:000, 0, v:null)
    if coding_system != v:null
        let cmd += [vlime#KW('CODING-SYSTEM'), coding_system]
    endif
    let Callback = get(a:000, 1, v:null)
    call self.Send(self.EmacsRex(cmd),
                \ function('s:CreateREPL_CB', [self, Callback]))
endfunction

""
" @dict VlimeConnection.ListenerEval
" @usage {expr} [callback]
" @public
"
" Evaluate {expr} in the current package and thread, and optionally register a
" [callback] function to handle the result.
" {expr} should be a plain string containing the lisp expression to be
" evaluated.
"
" This method needs the SWANK-REPL contrib module. See
" @function(VlimeConnection.SwankRequire).
function! vlime#contrib#repl#ListenerEval(expr, ...) dict
    function! s:ListenerEvalCB(conn, Callback, chan, msg) abort
        let stat = s:CheckAndReportReturnStatus(a:conn, a:msg,
                    \ 'vlime#contrib#repl#ListenerEval')
        if stat
            call vlime#TryToCall(a:Callback, [a:conn, a:msg[1][1]])
        endif
    endfunction

    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [vlime#SYM('SWANK-REPL', 'LISTENER-EVAL'), a:expr]),
                \ function('s:ListenerEvalCB', [self, Callback]))
endfunction

function! vlime#contrib#repl#Init(conn)
    let a:conn['CreateREPL'] = function('vlime#contrib#repl#CreateREPL')
    let a:conn['ListenerEval'] = function('vlime#contrib#repl#ListenerEval')
    call a:conn.CreateREPL(v:null)
endfunction

function! s:CheckAndReportReturnStatus(conn, return_msg, caller)
    let status = a:return_msg[1][0]
    if status['name'] == 'OK'
        return v:true
    elseif status['name'] == 'ABORT'
        call a:conn.ui.OnWriteString(a:conn, a:return_msg[1][1] . "\n",
                    \ {'name': 'ABORT-REASON', 'package': 'KEYWORD'})
        return v:false
    else
        call a:conn.ui.OnWriteString(a:conn, string(a:return_msg[1]),
                    \ {'name': 'UNKNOWN-ERROR', 'package': 'KEYWORD'})
        return v:false
    endif
endfunction
