"=============================================================================
" runner.vim --- code runner for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

let s:runners = {}

function! s:open_win() abort
  
endfunction


function! s:async_run(runner) abort
  
endfunction


function! s:update_statusline() abort
  
endfunction


function! SpaceVim#plugins#runner#open()
  let runner = get(s:runners, &filetype, '')
  if !empty(runner)
    call s:open_win()
    call s:async_run(runner)
    call s:update_statusline()
  endif
endfunction
