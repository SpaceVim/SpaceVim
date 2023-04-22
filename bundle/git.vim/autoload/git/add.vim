""
" @section git-add, add
" @parentsection commands
" This commands is to add file contents to the index. For example, add current
" file to the index.
" >
"   :Git add %
" <

let s:JOB = SpaceVim#api#import('job')
let s:NOTI = SpaceVim#api#import('notify')

function! s:replace_argvs(argvs) abort
  let argvs = []
  for argv in a:argvs
    if argv ==# '%'
      call insert(argvs, expand('%'))
    else
      call insert(argvs, argv)
    endif
  endfor
  return argvs
endfunction

function! git#add#run(argvs) abort
  let cmd = ['git', 'add'] + s:replace_argvs(a:argvs)
  call git#logger#debug('git-add cmd:' . string(cmd))
  call s:JOB.start(cmd,
        \ {
          \ 'on_exit' : function('s:on_exit'),
          \ }
          \ )

endfunction

function! s:on_exit(id, data, event) abort
  call git#logger#debug('git-add exit data:' . string(a:data))
  if a:data ==# 0
    if exists(':GitGutter')
      GitGutter
    endif
    call s:NOTI.notify('stage files done!')
  else
    call s:NOTI.notify('stage files failed!')
  endif
endfunction

function! git#add#complete(ArgLead, CmdLine, CursorPos) abort

  return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

endfunction
