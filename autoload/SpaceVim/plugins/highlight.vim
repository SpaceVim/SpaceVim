"=============================================================================
" highlight.vim --- highlight mode for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================


function! SpaceVim#plugins#highlight#start()
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Highlight Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ ],
        \ 'right' : [
        \ ],
        \ }
        \ )
  call state.open()

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
