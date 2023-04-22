""
" @section git-clean, clean
" @parentsection commands
" This commands is to run `git clean`.
" >
"   :Git clean -f
" <

let s:JOB = SpaceVim#api#import('job')
let s:NOTI = SpaceVim#api#import('notify')

function! git#clean#run(argvs) abort

  let cmd = ['git', 'clean'] + a:argvs
  call git#logger#debug('git-clean cmd:' . string(cmd))
  call s:JOB.start(cmd,
        \ {
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_exit'),
          \ }
          \ )

endfunction
function! s:on_stdout(id, data, event) abort
  
endfunction

function! s:on_stderr(id, data, event) abort
  
endfunction

function! s:on_exit(id, data, event) abort
  call git#logger#debug('git-clean exit data:' . string(a:data))
  if a:data ==# 0
    call s:NOTI.notify('stage files done!')
  else
    call s:NOTI.notify('stage files failed!')
  endif
endfunction

function! s:options() abort
    return join([
                \ '-f',
                \ '-n',
                \ ], "\n")
endfunction

function! git#clean#complete(ArgLead, CmdLine, CursorPos) abort
  if a:ArgLead =~# '^-'
    return s:options()
  endif
  return ''
endfunction


