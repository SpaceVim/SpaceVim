""
" @section git-mv, mv
" @parentsection commands
" This commands is to mv file contents to the index. For example, mv current
" file to the index.
" >
"   :Git mv %
" <

let s:JOB = SpaceVim#api#import('job')

function! git#mv#run(files) abort

    if len(a:files) == 1 && a:files[0] ==# '%'
        let cmd = ['git', 'mv', expand('%')] 
    else
        let cmd = ['git', 'mv'] + a:files
    endif
    call git#logger#info('git-mv cmd:' . string(cmd))
    call s:JOB.start(cmd,
                \ {
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )

endfunction

function! s:on_exit(id, data, event) abort
    call git#logger#info('git-mv exit data:' . string(a:data))
    if a:data ==# 0
        if exists(':GitGutter')
            GitGutter
        endif
        echo 'done!'
    else
        echo 'failed!'
    endif
endfunction

function! git#rm#complete(ArgLead, CmdLine, CursorPos) abort

    return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

endfunction

