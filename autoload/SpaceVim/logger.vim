let s:logger_level = 0
let s:levels = ['Info', 'Warn', 'Error']
let s:logger_file = expand('~/.SpaceVim/.SpaceVim.log')
""
" @public
" Set debug level of SpaceVim, by default it is 0.
"
"     0 : log all the message.
"
"     1 : log warning and error message
"
"     2 : log error message only
function! SpaceVim#logger#setLevel(level) abort
    let s:logger_level = a:level
endfunction

function! s:wite(msg) abort
    call writefile([a:msg], s:logger_file, 'a')
endfunction

function! SpaceVim#logger#info(msg) abort
    call s:wite(s:warpMsg(a:msg, 1))
endfunction

function! SpaceVim#logger#viewLog(...) abort
    let l = a:0 > 0 ? a:1 : 0
    let logs = readfile(s:logger_file, '')
    for log in logs
        if log =~# '\[ SpaceVim \] \[\d\d\:\d\d\:\d\d\] \[' . s:levels[l] .'\]'
            echo log
        endif
    endfor
endfunction

""
" @public
" Set log output file of SpaceVim. by default it is
" `~/.SpaceVim/.SpaceVim.log`
function! SpaceVim#logger#setOutput(file) abort
    let s:logger_file = a:file
endfunction

function! s:warpMsg(msg,l) abort
    let time = strftime('%H:%M:%S')
    let log = '[ SpaceVim ] [' . time . '] [' . s:levels[a:l - 1] . '] ' . a:msg
    return log
endfunction

function! SpaceVim#logger#echoWarn(msg) abort
    echohl WarningMsg
    echom s:warpMsg(a:msg, 1)
    echohl None
endfunction
