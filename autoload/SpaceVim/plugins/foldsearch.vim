"=============================================================================
" foldsearch.vim --- async foldsearch plugin
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:JOB = SpaceVim#api#import('job')
let s:SYS = SpaceVim#api#import('system')
let s:LOGGER =SpaceVim#logger#derive('fsearch')

let s:matched_lines = []
let s:foldsearch_highlight_id = -1

let [
      \ s:grep_default_exe,
      \ s:grep_default_opt,
      \ s:grep_default_ropt,
      \ s:grep_default_expr_opt,
      \ s:grep_default_fix_string_opt,
      \ s:grep_default_ignore_case,
      \ s:grep_default_smart_case
      \ ] = SpaceVim#mapping#search#default_tool()


function! SpaceVim#plugins#foldsearch#end() abort
  normal! zE
  try
    call matchdelete(s:foldsearch_highlight_id)
  catch
  endtry
endfunction

function! SpaceVim#plugins#foldsearch#word(word) abort
  let argv = [s:grep_default_exe] + 
        \ s:grep_default_opt +
        \ s:grep_default_fix_string_opt +
        \ [a:word]
  call s:LOGGER.info('cmd: ' . string(argv))
  try
    call matchdelete(s:foldsearch_highlight_id)
  catch
  endtry
  let s:foldsearch_highlight_id = matchadd('Search', '\<' . a:word . '\>', 10)
  call s:foldsearch(argv)
endfunction

function! SpaceVim#plugins#foldsearch#expr(expr) abort
  let argv = [s:grep_default_exe] + 
        \ s:grep_default_opt +
        \ s:grep_default_expr_opt +
        \ [a:expr]
  call s:LOGGER.info('cmd: ' . string(argv))
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
    call add(s:matched_lines, str2nr(matchstr(line, ':\d\+:')[1:-2]))
  endfor
endfunction

function! s:exit(id, data, event) abort
  call s:LOGGER.info('foldsearch job exit with: '. a:data)
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
