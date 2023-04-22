""
" @section git-mv, mv
" @parentsection commands
" This commands is to run `git mv` command asynchronously.
" It is to move file to the index. For example, rename current file.
" >
"   :Git mv % new_file.txt
" <

let s:JOB = SpaceVim#api#import('job')

function! git#mv#run(args) abort

  let args = a:args
  if index(a:args, '%') !=# -1
    let index = index(a:args, '%')
    let args[index] = expand('%')
  endif
  let cmd = ['git', 'mv'] + args
  call git#logger#debug('git-mv cmd:' . string(cmd))
  call s:JOB.start(cmd,
        \ {
          \ 'on_exit' : function('s:on_exit'),
          \ }
          \ )

endfunction

function! s:on_exit(id, data, event) abort
  call git#logger#debug('git-mv exit data:' . string(a:data))
  if a:data ==# 0
    if exists(':GitGutter')
      GitGutter
    endif
    echo 'done!'
  else
    echo 'failed!'
  endif
endfunction

function! s:options() abort
  return join([
        \ '-v',
        \ '-n',
        \ '-f',
        \ '-k',
        \ ], "\n")
endfunction

function! s:long_options() abort
  return join([
        \ '--verbose',
        \ '--dry-run',
        \ '--force',
        \ ], "\n")
endfunction

function! git#mv#complete(ArgLead, CmdLine, CursorPos) abort
  if a:ArgLead =~# '^--'
    return s:long_options()
  elseif a:ArgLead =~# '^-'
    return s:options()
  endif

  return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

endfunction

