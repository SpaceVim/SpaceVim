let s:JOB = SpaceVim#api#import('job')
let s:NOTI = SpaceVim#api#import('notify')

function! git#pull#run(args)
    let cmd = ['git', 'pull'] + a:args
    call git#logger#debug('git-pull cmd:' . string(cmd))
    let s:conflict_files = []
    call s:JOB.start(cmd,
                \ {
                \ 'on_stderr' : function('s:on_stderr'),
                \ 'on_stdout' : function('s:on_stdout'),
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )

endfunction

function! s:on_exit(id, data, event) abort
    call git#logger#debug('git-pull exit data:' . string(a:data))
    if a:data ==# 0
        call s:NOTI.notify('pulled done!')
    else
        call s:list_conflict_files()
        call s:NOTI.notify('pulled failed!')
    endif
endfunction

function! s:on_stdout(id, data, event) abort
    for data in a:data
        call git#logger#debug('git-pull stdout:' . data)
        if data =~# '^CONFLICT'
            " CONFLICT (content): Merge conflict in test.txt
            let file = data[38:]
            call add(s:conflict_files, file)
        endif
    endfor
endfunction

function! s:on_stderr(id, data, event) abort
    for data in a:data
        call git#logger#debug('git-pull stderr:' . data)
    endfor
    " stderr should not be added to commit buffer
    " let s:lines += a:data
endfunction

function! s:list_conflict_files() abort
    if !empty(s:conflict_files)
        let rst = []
        for file in s:conflict_files
            call add(rst, {
                        \ 'filename' : fnamemodify(file, ':p'),
                        \ })
        endfor
        call setqflist([], 'r', {'title': ' ' . len(rst) . ' conflict files',
                    \ 'items' : rst
                    \ })
        botright copen
    endif
endfunction

function! s:args_with_two() abort
    return join([
                \ '--all',
                \ ], "\n")
endfunction

function! s:args_with_one() abort
    return join([
                \ '-a',
                \ '-f',
                \ ], "\n")

endfunction

function! git#pull#complete(ArgLead, CmdLine, CursorPos)
    if a:ArgLead =~# '^--'
        return s:args_with_two()
    elseif a:ArgLead =~# '^-'
        return s:args_with_one()
    endif

    return ''

endfunction
