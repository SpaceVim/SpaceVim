let s:JOB = SpaceVim#api#import('job')
let s:STR = SpaceVim#api#import('data#string')

function! git#branch#run(args) abort
  if len(a:args) == 0
    call git#branch#manager#open()
    return
  else
    let cmd = ['git', 'branch'] + a:args
  endif
  call git#logger#info('git-branch cmd:' . string(cmd))
  call s:JOB.start(cmd,
        \ {
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_stdout' : function('s:on_stdout'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )

endfunction

function! s:on_stdout(id, data, event) abort
  for line in filter(a:data, '!empty(v:val)')
    exe 'Echo ' . line
  endfor
endfunction

function! s:on_stderr(id, data, event) abort
  for line in filter(a:data, '!empty(v:val)')
    exe 'Echoerr ' . line
  endfor
endfunction
function! s:on_exit(id, data, event) abort
  call git#logger#info('git-branch exit data:' . string(a:data))
  if a:data ==# 0
    call git#branch#manager#update()
    echo 'done!'
  else
    echo 'failed!'
  endif
endfunction

function! git#branch#complete(ArgLead, CmdLine, CursorPos) abort

  return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

endfunction

let s:branch = ''
function! s:update_branch_name() abort
  let cmd = 'git rev-parse --abbrev-ref HEAD'
  call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : function('s:on_stdout_show_branch'),
        \ }
        \ )
endfunction
function! s:on_stdout_show_branch(id, data, event) abort
  let b = s:STR.trim(join(a:data, ''))
  if !empty(b)
    let s:branch = b
  endif
endfunction
function! git#branch#current() abort
  if empty(s:branch)
    call s:update_branch_name()
  endif
  return s:branch
endfunction

function! git#branch#detect() abort
  call s:update_branch_name()
endfunction
