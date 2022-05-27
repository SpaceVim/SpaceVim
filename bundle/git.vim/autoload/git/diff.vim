let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')

function! git#diff#run(...)
    if len(a:1) == 1 && a:1[0] ==# '%'
        let cmd = ['git', 'diff', expand('%')] 
    else
        let cmd = ['git', 'diff'] + a:1
    endif
    let s:lines = []
    call git#logger#info('git-diff cmd:' . string(cmd))
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
        call git#logger#info('git-diff stdout:' . data)
    endfor
    let s:lines += a:data
endfunction
function! s:on_stderr(id, data, event) abort
    for data in a:data
        call git#logger#info('git-diff stderr:' . data)
    endfor
    let s:lines += a:data
endfunction
function! s:on_exit(id, data, event) abort
    call git#logger#info('git-diff exit data:' . string(a:data))
    let s:bufnr = s:openDiffBuffer()
    call setbufvar(s:bufnr, 'modifiable', 1)
    call s:BUFFER.buf_set_lines(s:bufnr, 0 , -1, 0, s:lines)
    call setbufvar(s:bufnr, 'modifiable', 1)
endfunction


function! s:openDiffBuffer() abort
    exe printf('%s git://diff', get(g:, 'git_diff_position', '10split'))
    normal! "_dd
    setl nobuflisted
    setl nomodifiable
    setl nonumber norelativenumber
    setl buftype=nofile
    setl bufhidden=wipe
    setf git-diff
    setl syntax=diff
    nnoremap <buffer><silent> q :call <SID>close_diff_window()<CR>
    return bufnr('%')
endfunction

function! git#diff#complete(ArgLead, CmdLine, CursorPos)

    return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

endfunction

function! s:close_diff_window() abort
    if winnr('$') > 1
        close
    else
        bd!
    endif
endfunction
