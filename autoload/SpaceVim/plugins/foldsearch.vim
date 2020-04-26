"=============================================================================
" foldsearch.vim --- async foldsearch plugin
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:JOB = SpaceVim#api#import('job')
let s:matched_lines = []

function! SpaceVim#plugins#foldsearch#word(word)
  let argv = ['rg', '--line-number', a:word]
  call s:foldsearch(argv)
endfunction

function! SpaceVim#plugins#foldsearch#expr(expr)
  let argv = ['rg', '--line-number', a:expr]
  call s:foldsearch(argv)
endfunction

function! s:foldsearch(argv) abort
  let s:matched_lines = []
  let jobid = s:JOB.start(a:argv, {
        \ 'on_stdout' : function('s:std_out'),
        \ 'on_exit' : function('s:exit'),
        \ })

  call s:JOB.send(jobid, call('getline', [1, '$']))
  call s:JOB.chanclose(jobid, 'stdin')
endfunction

function! s:std_out(id, data, event) abort
  for line in filter(a:data, '!empty(v:val)')
    call add(s:matched_lines, str2nr(matchstr(line, '^\d\+')))
  endfor
endfunction

function! s:exit(id, data, event) abort
  echom string(s:matched_lines)
  let preview = 0
  for nr in s:matched_lines
    if nr - preview >= 3 " first matched line is 3
      exe (preview + 1) . ',' . (nr - 1) . ':fold'
    endif
    let preview = nr
  endfor
  if line('$') - preview >=3
      exe (preview + 1) . ',' . line('$') . ':fold'
  endif
endfunction
