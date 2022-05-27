"=============================================================================
" branch.vim --- branch action of git.vim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

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
let s:branch_info = {}
" {
"   branch_name : 'xxx',
"   last_update_done : 111111, ms
" }
let s:job_pwds = {}

function! s:update_branch_name(pwd, ...) abort
  let force = get(a:000, 0, 0)
  let cmd = 'git rev-parse --abbrev-ref HEAD'
  if force || get(get(s:branch_info, a:pwd, {}), 'last_update_done', 0) >= localtime() - 1
    let jobid =  s:JOB.start(cmd,
          \ {
            \ 'on_stdout' : function('s:on_stdout_show_branch'),
            \ 'on_exit' : function('s:on_exit_show_branch'),
            \ 'cwd' : a:pwd,
            \ }
            \ )
    if jobid > 0
      call extend(s:job_pwds, {'jobid' . jobid : a:pwd})
    endif
  endif
endfunction
function! s:on_stdout_show_branch(id, data, event) abort
  let b = s:STR.trim(join(a:data, ''))
  if !empty(b)
    let pwd = get(s:job_pwds, 'jobid' . a:id, '')
    if !empty(pwd)
      let s:branch_info[pwd] = {
            \ 'name' : b,
            \ }
    endif
  endif
endfunction

function! s:on_exit_show_branch(id, data, event) abort
  let pwd = get(s:job_pwds, 'jobid' . a:id, '')
  if !has_key(s:branch_info, pwd) && !empty(pwd)
    let s:branch_info[pwd] = {}
  endif
  if !empty(pwd)
    call extend(s:branch_info[pwd], {
          \ 'last_update_done' : localtime(),
          \ })
  endif
endfunction

function! git#branch#current(...) abort
  let pwd = getcwd()
  let branch = get(s:branch_info, pwd, {})
  if empty(branch)
    call s:update_branch_name(pwd)
  endif
  let branch_name = get(branch, 'name', '')
  let prefix = get(a:000, 0 , '')
  if !empty(branch_name)
    return ' ' . prefix . ' ' . branch_name . ' '
  else
    return ''
  endif
endfunction

function! git#branch#detect() abort
  call s:update_branch_name(getcwd(), 1)
endfunction
