"=============================================================================
" foldsearch.vim --- async foldsearch plugin
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:JOB = SpaceVim#api#import('job')
let s:matched_lines = []
let s:foldsearch_highlight_id = -1


function! SpaceVim#plugins#foldsearch#end()
  normal! zE
  try
    call matchdelete(s:foldsearch_highlight_id)
  catch
  endtry
endfunction

function! SpaceVim#plugins#foldsearch#word(word)
  let argv = ['rg', '--line-number', '--fixed-strings', a:word]
  try
    call matchdelete(s:foldsearch_highlight_id)
  catch
  endtry
  let s:foldsearch_highlight_id = matchadd('Search', '\<' . a:word . '\>', 10)
  call s:foldsearch(argv)
endfunction

function! SpaceVim#plugins#foldsearch#expr(expr)
  let argv = ['rg', '--line-number', a:expr]
  try
    call matchdelete(s:foldsearch_highlight_id)
  catch
  endtry
  let s:foldsearch_highlight_id = matchadd('Search', a:expr, 10)
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
  let preview = 0
  for nr in s:matched_lines
    if nr - preview >= 3 " first matched line is 3
      exe (preview + 1) . ',' . (nr - 1) . ':fold'
    endif
    let preview = nr
  endfor
  if line('$') - preview >=2
      exe (preview + 1) . ',' . line('$') . ':fold'
  endif
endfunction
