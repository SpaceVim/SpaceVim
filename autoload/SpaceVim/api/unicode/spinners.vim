"=============================================================================
" spinners.vim --- spinners API for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
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

function! s:self.Onframe(...) abort dict
  if self.index < len(self.spinners) - 1
    let self.index += 1
  else
    let self.index = 0
  endif
  let self.str = self.spinners[self.index]
  exe 'let ' . self.var . '=  self.str'
endfunction

" return timer id and strwidth
function! s:self.apply(name, var) abort dict
  let time = self._data[a:name].timeout
  let self.index = 0
  let self.var = a:var
  let self.spinners = self._data[a:name].frames
  exe 'let ' . self.var . '=  self.spinners[self.index]'
  let self.timer_id = timer_start(time, self.Onframe, {'repeat' : -1})
  return [self.timer_id, self._data[a:name].strwidth]
endfunction


function! s:self.get_str() abort
  return self.str
endfunction

function! s:self.get_info(name) abort
  return get(self._data, a:name, {})
endfunction

function! SpaceVim#api#unicode#spinners#get() abort
  return deepcopy(s:self)
endfunction
