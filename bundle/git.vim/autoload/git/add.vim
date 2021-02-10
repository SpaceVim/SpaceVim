""
" @section git-add, add
" @parentsection commands
" This commands is to add file contents to the index. For example, add current
" file to the index.
" >
"   :Git add %
" <

let s:JOB = SpaceVim#api#import('job')

function! git#add#run(files)

    if len(a:files) == 1 && a:files[0] ==# '%'
        let cmd = ['git', 'add', expand('%')] 
    else
        let cmd = ['git', 'add'] + a:files
    endif
    call git#logger#info('git-add cmd:' . string(cmd))
    call s:JOB.start(cmd,
                \ {
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )

endfunction

function! s:on_exit(id, data, event) abort
    call git#logger#info('git-add exit data:' . string(a:data))
    if a:data ==# 0
        if exists(':GitGutter')
            GitGutter
        endif
        echo 'done!'
    else
        echo 'failed!'
    endif
endfunction

function! git#add#complete(ArgLead, CmdLine, CursorPos)

    return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

endfunction
