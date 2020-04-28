"=============================================================================
" foldsearch.vim --- Fold search support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


if exists('s:filename')
  " @bug s:filename always return 'scheme'
  "
  " because this script will be loaded twice. This is the feature of vim,
  " when call an autoload func, vim will try to load the script again
  finish
endif

let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#foldsearch#config()

  let g:_spacevim_mappings_space.F = {'name' : '+Foldsearch'}
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['F', 'w'], 'call call('
        \ . string(s:_function('s:foldsearch_word')) . ', [])',
        \ ['foldsearch-word',
        \ [
        \ 'SPC F w is to foldsearch input word',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['F', 'W'], 'call call('
        \ . string(s:_function('s:foldsearch_cursor')) . ', [])',
        \ ['foldsearch-cword',
        \ [
        \ 'SPC F W is to foldsearch cursor word',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['F', 'p'], 'call call('
        \ . string(s:_function('s:foldsearch_expr')) . ', [])',
        \ ['foldsearch-regexp',
        \ [
        \ 'SPC F p is to foldsearch regexp',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  call SpaceVim#mapping#space#def('nnoremap', ['F', 'e'],
        \ 'call SpaceVim#plugins#foldsearch#end()',
        \ ['end foldsearch',
        \ [
        \ 'SPC F e is to end foldsearch',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ],
        \ 1)
endfunction

function! s:foldsearch_word() abort
  let word = input('foldsearch word >')
  if !empty(word)
    call SpaceVim#plugins#foldsearch#word(word)
  endif
endfunction

function! s:foldsearch_cursor() abort
  let word = expand('<cword>')
  if !empty(word)
    call SpaceVim#plugins#foldsearch#word(word)
  endif
endfunction

function! s:foldsearch_expr() abort
  let word = input('foldsearch expr >')
  if !empty(word)
    call SpaceVim#plugins#foldsearch#expr(word)
  endif
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
" vim:set et sw=2 cc=80:
