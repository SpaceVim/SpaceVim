"=============================================================================
" string.vim --- SpaceVim string API
" init.vim --- Entry file for neovim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}

function! s:self.trim(str) abort
  let str = substitute(a:str, '\s*$', '', 'g')
  return substitute(str, '^\s*', '', 'g')
endfunction

function! s:self.fill(str, length) abort
  if strwidth(a:str) <= a:length
    return a:str . repeat(' ', a:length - strwidth(a:str))
  else
    let l = 0
    for i in range(strchars(a:str) - 1)
      if strwidth(strcharpart(a:str, 0, i)) > a:length
        break
      else
        let l = i
      endif
    endfor
    let str = strcharpart(a:str, 0, l)
    return str . repeat(' ', a:length - strwidth(str))
  endif
endfunction

function! s:self.fill_middle(str, length) abort
  if strwidth(a:str) <= a:length
    "return a:str . repeat(' ', a:length - strwidth(a:str))
    let n = a:length - strwidth(a:str)
    if n % 2 == 0
      return repeat(' ', (a:length - strwidth(a:str))/2) . a:str . repeat(' ', (a:length - strwidth(a:str))/2)
    else
      return repeat(' ', (a:length - strwidth(a:str))/2) . a:str . repeat(' ', (a:length + 1 - strwidth(a:str))/2)
    endif
  else
    let l = 0
    for i in range(strchars(a:str) - 1)
      if strwidth(strcharpart(a:str, 0, i)) > a:length
        break
      else
        let l = i
      endif
    endfor
    let str = strcharpart(a:str, 0, l)
    return str . repeat(' ', a:length - strwidth(str))
  endif
endfunction

function! s:self.trim_start(str) abort
  return substitute(a:str, '^\s*', '', 'g')
endfunction

function! s:self.trim_end(str) abort
  return substitute(a:str, '\s*$', '', 'g')
endfunction

function! s:self.string2chars(str) abort
  let chars = []
  for i in range(len(a:str))
    call add(chars, a:str[i : i])
  endfor
  return chars
endfunction

function! s:self.strAllIndex(str, need, use_expr) abort
  if a:use_expr
    let rst = []
    let idx = matchstrpos(a:str, a:need)
    while idx[1] != -1
      call add(rst, [idx[1], idx[2]])
      let idx = matchstrpos(a:str, a:need, idx[2])
    endwhile
    return rst
  else
    let rst = []
    let idx = match(a:str, "\\<" . a:need . "\\>")
    while idx != -1
      call add(rst, [idx, idx+len(a:need)])
      let idx = match(a:str, "\\<" . a:need . "\\>", idx + 1 + len(a:need))
    endwhile
    return rst
  endif
endfunction

function! s:self.strQ2B(str) abort
  let chars = self.string2chars(a:str)
  let bchars = []
  for char in chars
    let nr = char2nr(char)
    if nr == 12288
      call add(bchars, nr2char(32))
    elseif nr == 8216 &&  nr == 8217
      call add(bchars, nr2char(39))
    elseif nr >= 65281 && nr <= 65374
      call add(bchars, nr2char(nr - 65248))
    else
      call add(bchars, char)
    endif
  endfor
  return join(bchars, '')
endfunction

function! s:self.strB2Q(str) abort
  let chars = self.string2chars(a:str)
  let bchars = []
  for char in chars
    let nr = char2nr(char)
    if nr == 32
      call add(bchars, nr2char(12288))
    elseif nr >= 32 && nr <= 126
      call add(bchars, nr2char(nr + 65248))
    else
      call add(bchars, char)
    endif
  endfor
  return join(bchars, '')
  
endfunction

function! SpaceVim#api#data#string#get() abort
  return deepcopy(s:self)
endfunction

" vim:set et sw=2:
