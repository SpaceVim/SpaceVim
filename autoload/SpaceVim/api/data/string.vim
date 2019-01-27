"=============================================================================
" string.vim --- SpaceVim string API
" init.vim --- Entry file for neovim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section data#string, api-data-string
" @parentsection api
"
" @subsection Functions
"
" split(str [, sep [, keepempty[, max]]])
"
"   run vim command, and return the output of such command.

let s:self = {}

function! s:self.trim(str) abort
  let str = substitute(a:str, '\s*$', '', 'g')
  return substitute(str, '^\s*', '', 'g')
endfunction

function! s:self.fill(str, length) abort
  if strwidth(a:str) <= a:length
    let l:string = a:str
  else
    let l:rightmost = 0
    while strwidth(strcharpart(a:str, 0, l:rightmost)) < a:length
      let l:rightmost += 1
    endwhile
    let l:string = strcharpart(a:str, 0, l:rightmost)
  endif
  let l:spaces = repeat(' ', a:length - strwidth(l:string))
  return l:string . l:spaces
endfunction

function! s:self.fill_left(str, length) abort
  if strwidth(a:str) <= a:length
    let l:string = a:str
  else
    let l:rightmost = 0
    while strwidth(strcharpart(a:str, 0, l:rightmost)) < a:length
      let l:rightmost += 1
    endwhile
    let l:string = strcharpart(a:str, 0, l:rightmost)
  endif
  let l:spaces = repeat(' ', a:length - strwidth(l:string))
  return l:spaces . l:string
endfunction

function! s:self.fill_middle(str, length) abort
  if strwidth(a:str) <= a:length
    let l:string = a:str
  else
    let l:rightmost = 0
    while strwidth(strcharpart(a:str, 0, l:rightmost)) < a:length
      let l:rightmost += 1
    endwhile
    let l:string = strcharpart(a:str, 0, l:rightmost)
  endif
  let l:numofspaces = a:length - strwidth(l:string)
  let l:halfspaces = repeat(' ', l:numofspaces/2)
  let l:rst = l:halfspaces . a:str . l:halfspaces
  if l:numofspaces % 2
    let l:rst .= ' '
  endif
  return l:rst
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


function! s:self.split(str, ...) abort
  let sep = get(a:000, 0, '')
  let keepempty = get(a:000, 1, 0)
  let max = get(a:000, 2, -1)
  let rlist = split(a:str, sep, keepempty)
  if max >= 2
    let rst = []
    for item in rlist
      if len(rst) >= max - 1
        break
      endif
      call add(rst, item)
    endfor
    let last = join(rlist[max-1:], sep)
    call add(rst, last)
    return rst
  else
    return rlist
  endif
endfunction

function! SpaceVim#api#data#string#get() abort
  return deepcopy(s:self)
endfunction

" vim:set et sw=2:
