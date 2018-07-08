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

function! s:self.get(name) abort
  return get(self._data, a:name, {})
endfunction

function! SpaceVim#api#unicode#spinners#get() abort
  return deepcopy(s:self)
endfunction
