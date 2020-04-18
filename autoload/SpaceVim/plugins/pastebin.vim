"=============================================================================
" pastebin.vim --- Pastebin support for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:JOB = SpaceVim#api#import('job')
let s:job_id = -1

function! SpaceVim#plugins#pastebin#paste()
  let s:url = ''
  let context = ''
  " let ft = &filetype
  let cmd = 'curl -s -F "content=<-" http://dpaste.com/api/v2/'
  let s:job_id =  s:JOB.start(cmd,{
        \ 'on_stdout' : function('s:on_stdout'),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ })
  call s:JOB.send(s:job_id, split(context, "\n"))
  call s:JOB.chanclose(s:job_id, 'stdin')
endfunction
function! s:on_stdout(job_id, data, event) abort
  " echom 'stdout:' . string(a:data)
  for url in filter(a:data, '!empty(v:val)')
    let s:url = url
  endfor
endfunction

function! s:on_stderr(job_id, data, event) abort
  " echom 'stderr:' . string(a:data)
endfunction

function! s:on_exit(job_id, data, event) abort
  if a:data ==# 0 && !empty(s:url)
    let @+ = s:url
    echo 'Pastbin: ' . s:url
  endif
endfunction
