"=============================================================================
" highlight.vim --- highlight mode for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================


function! SpaceVim#plugins#highlight#start() abort
  let state = SpaceVim#api#import('transient_state') 
  let stack = []
  let s:current_match = ''
  call state.set_title('Highlight Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ {
        \ 'key' : 'n',
        \ 'desc' : 'Next match',
        \ 'func' : 'call call(' . string(function('s:next_item')) . ', [])',
        \ 'cmd' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'r',
        \ 'desc' : 'change range',
        \ 'func' : '',
        \ 'cmd' : 'call call(' . string(function('s:change_range')) . ', [])',
        \ 'exit' : 0,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : ['N', 'p'],
        \ 'desc' : 'Previous match',
        \ 'cmd' : 'call call(' . string(function('s:previous_item')) . ', [])',
        \ 'func' : '',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'b',
        \ 'desc' : 'search buffers',
        \ 'cmd' : '',
        \ 'func' : '',
        \ 'exit_cmd' : 'call call(' . string(function('s:search_buffers')) . ', [])',
        \ 'exit' : 1,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction
" n : next item
" N/p: Previous item
" r: change range
" R: reset
" e: iedit
" d/D: next previous definition
" b: search buffers
" /: search proj
" f: search files
" s: swoop
"
function! s:next_item() abort
  normal! n
endfunction

let s:current_range = 'display'
function! s:change_range() abort
  if s:current_range == 'display'
    let s:current_range = 'buffer'
  elseif s:current_range == 'buffer'
    let s:current_range = 'display'
  endif
endfunction

function! s:previous_item() abort
  normal! N 
endfunction

function! s:toggle_item() abort

endfunction

function! s:search_buffers() abort
  call SpaceVim#plugins#flygrep#open({'input' : s:current_match, 'files':'@buffers'}) 
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif
