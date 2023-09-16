"=============================================================================
" helpgrep.vim --- asynchronous helpgrep
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! s:generate() abort
    return filter(split(&rtp, ','), 'isdirectory(v:val)')
endfunction

function! s:help_files() abort
    return globpath(&rtp, 'doc/*.txt', 0, 1)
endfunction

function! SpaceVim#plugins#helpgrep#help(...) abort
  call SpaceVim#plugins#flygrep#open({
          \ 'input' : get(a:000, 0, ''),
          \ 'files' : s:help_files(),
          \ })
endfunction
