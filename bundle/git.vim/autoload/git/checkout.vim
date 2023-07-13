let s:JOB = SpaceVim#api#import('job')
let s:NOTI = SpaceVim#api#import('notify')

function! git#checkout#run(args)

    let cmd = ['git', 'checkout'] + a:args
    call git#logger#debug('git-checkout cmd:' . string(cmd))
    call s:JOB.start(cmd,
                \ {
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )

endfunction

function! s:on_exit(id, data, event) abort
    call git#logger#debug('git-checkout exit data:' . string(a:data))
    if a:data ==# 0
        silent! checktime
        call s:NOTI.notify('checkout done.')
        call git#branch#detect()
    else
        call s:NOTI.notify('checkout failed.', 'WarningMsg')
    endif
endfunction

function! s:options() abort
    return join([
                \ '-m',
                \ '-b',
                \ ], "\n")
endfunction

function! git#checkout#complete(ArgLead, CmdLine, CursorPos)
    if a:ArgLead =~# '^-'
        return s:options()
    endif
    let branchs = systemlist('git branch')
    if v:shell_error
        return ''
    else
        let branchs = join(map(filter(branchs, 'v:val !~ "^*"'), 'trim(v:val)'), "\n")
        return branchs
    endif

endfunction

