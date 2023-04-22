let s:JOB = SpaceVim#api#import('job')


function! git#reset#run(args)

    if len(a:args) == 1 && a:args[0] ==# '%'
        let cmd = ['git', 'reset', 'HEAD', expand('%')] 
    else
        let cmd = ['git', 'reset'] + a:args
    endif
    call git#logger#debug('git-reset cmd:' . string(cmd))
    call s:JOB.start(cmd,
                \ {
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )

endfunction

function! s:on_exit(id, data, event) abort
    call git#logger#debug('git-reset exit data:' . string(a:data))
    if a:data ==# 0
        if exists(':GitGutter')
            GitGutter
        endif
        echo 'done!'
    else
        echo 'failed!'
    endif
endfunction

function! git#reset#complete(ArgLead, CmdLine, CursorPos)

    return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

endfunction

