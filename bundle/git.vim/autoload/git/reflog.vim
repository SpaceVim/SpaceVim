let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')

function! git#reflog#run(args)
    let cmd = ['git', 'reflog'] + a:args
    let s:bufnr = s:openRefLogBuffer()
    let s:lines = []
    call git#logger#info('git-reflog cmd:' . string(cmd))
    call s:JOB.start(cmd,
                \ {
                \ 'on_stderr' : function('s:on_stderr'),
                \ 'on_stdout' : function('s:on_stdout'),
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )
endfunction

function! s:on_stdout(id, data, event) abort
    for data in a:data
        call git#logger#info('git-reflog stdout:' . data)
    endfor
    let s:lines += filter(a:data, '!empty(v:val)')
endfunction
function! s:on_stderr(id, data, event) abort
    for data in a:data
        call git#logger#info('git-reflog stderr:' . data)
    endfor
    let s:lines += a:data
endfunction
function! s:on_exit(id, data, event) abort
    call git#logger#info('git-reflog exit data:' . string(a:data))
    call s:BUFFER.buf_set_lines(s:bufnr, 0 , -1, 0, s:lines)
endfunction

function! s:openRefLogBuffer() abort
    let bp = bufnr('%')
    edit git://reflog
    normal! "_dd
    setl nobuflisted
    setl nomodifiable
    setl nonumber norelativenumber
    setl buftype=nofile
    setl bufhidden=wipe
    setf git-reflog
    exe 'nnoremap <buffer><silent> q :b' . bp . '<Cr>'
    return bufnr('%')
endfunction

function! s:subcommands() abort
    return ['show', 'expire', 'delete', 'exists']
endfunction

function! s:show_options() abort
    return []
endfunction

function! s:expire_options() abort
    return ['--all', '--single-worktree']
endfunction

function! git#reflog#complete(ArgLead, CmdLine, CursorPos)
    let str = a:CmdLine[:a:CursorPos-1]
    if str =~# '^Git\s\+reflog\s\+[^ ]*$'
        return join(s:subcommands(), "\n")
    elseif str =~# '^Git\s\+reflog\s\+show\s\+-'
        return join(s:show_options(), "\n")
    elseif str =~# '^Git\s\+reflog\s\+expire\s\+-'
        return join(s:expire_options(), "\n")
    else
        return ''
    endif
endfunction
