"=============================================================================
" spinners.vim --- spinners API for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8
let s:self = {}
let s:self._data = {
      \ 'dot1' : {
      \             'frames' : ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'],
      \             'strwidth' : 1,
      \             'timeout' : 80
      \          }
      \ }

let s:self._id = 0

function! s:self.Onframe(...) abort
  
endfunction

" return timer id and strwidth
function! s:self.apply(name, var) abort
  
endfunction

function! s:self.get_info(name) abort
  return get(self._data, a:name, {})
endfunction

function! SpaceVim#api#unicode#spinners#get() abort
  return deepcopy(s:self)
endfunction
