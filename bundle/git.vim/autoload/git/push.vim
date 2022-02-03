"=============================================================================
" push.vim --- push command for git.vim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================

let s:JOB = SpaceVim#api#import('job')
let s:NOTI = SpaceVim#api#import('notify')

function! git#push#run(...) abort

    let cmd = ['git', 'push']
    if len(a:1) > 0
        let cmd += a:1
    endif
    call s:JOB.start(cmd,
                \ {
                \ 'on_stdout' : function('s:on_stdout'),
                \ 'on_stderr' : function('s:on_stderr'),
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )

endfunction

function! s:on_exit(...) abort
    let data = get(a:000, 2)
    if data != 0
        echo 'failed!'
    else
        echo 'done!'
    endif
endfunction


function! s:on_stdout(id, data, event) abort
    for line in filter(a:data, '!empty(v:val)')
        call s:NOTI.notify(line, 'Normal')
    endfor
endfunction

function! s:on_stderr(id, data, event) abort
    for line in filter(a:data, '!empty(v:val)')
        call s:NOTI.notify(line, 'WarningMsg')
    endfor
endfunction

function! s:options() abort
    return [
                \ '-u',
                \ ]
endfunction

function! git#push#complete(ArgLead, CmdLine, CursorPos) abort
    let str = a:CmdLine[:a:CursorPos-1]
    if str =~# '^Git\s\+push\s\+-$'
        return join(s:options(), "\n")
    elseif str =~# '^Git\s\+push\s\+[^ ]*$' || str =~# '^Git\s\+push\s\+-u\s\+[^ ]*$'
        return join(s:remotes(), "\n")
    else
        let remote = matchstr(str, '\(Git\s\+push\s\+\)\@<=[^ ]*')
        return s:remote_branch(remote)
    endif
endfunction

function! s:remotes() abort
    return map(systemlist('git remote'), 'trim(v:val)')
endfunction

function! s:remote_branch(remote) abort
    let branchs = systemlist('git branch -a')
    if v:shell_error
        return ''
    else
        let branchs = join(map(filter(branchs, 'v:val =~ "\s*remotes/" . a:remote . "/[^ ]*$"'), 'trim(v:val)[len(a:remote) + 9:]'), "\n")
        return branchs
    endif
endfunction
