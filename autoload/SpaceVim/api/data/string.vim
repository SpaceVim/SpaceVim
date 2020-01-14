"=============================================================================
" string.vim --- SpaceVim string API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
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
"
" trim(str)
"
"   remove space at the begin and end of a string, same as |trim()|
"
" fill(str, length[, char])
"
"   fill string to length with {char}, if {char} is omnit, a space is used.

let s:self = {}

function! s:self.trim(str) abort
  let str = substitute(a:str, '\s*$', '', 'g')
  return substitute(str, '^\s*', '', 'g')
endfunction

function! s:self.fill(str, length, ...) abort
  if strwidth(a:str) <= a:length
    let l:string = a:str
  else
    let l:rightmost = 0
    while strwidth(strcharpart(a:str, 0, l:rightmost)) < a:length
      let l:rightmost += 1
    endwhile
    let l:string = strcharpart(a:str, 0, l:rightmost)
  endif
  let char = get(a:000, 0, ' ')
  if type(char) !=# 1 || len(char) > 1
    let char = ' '
  endif
  let l:spaces = repeat(char, a:length - strwidth(l:string))
  return l:string . l:spaces
endfunction

function! s:self.toggle_case(str) abort
  let chars = []
  for char in self.string2chars(a:str)
    if char2nr(char) >= 97 && char2nr(char) <= 122
      call add(chars, nr2char(char2nr(char) - 32))
    elseif char2nr(char) >= 65 && char2nr(char) <= 90
      call add(chars, nr2char(char2nr(char) + 32))
    else
      call add(chars, char)
    endif
  endfor
  return join(chars, '')
endfunction

function! s:self.fill_left(str, length, ...) abort
  if strwidth(a:str) <= a:length
    let l:string = a:str
  else
    let l:string = strcharpart(a:str, strwidth(a:str) - a:length, a:length)
  endif
  let char = get(a:000, 0, ' ')
  if type(char) !=# 1 || len(char) > 1
    let char = ' '
  endif
  let l:spaces = repeat(char, a:length - strwidth(l:string))
  return l:spaces . l:string
endfunction

function! s:self.fill_middle(str, length, ...) abort
  if strwidth(a:str) <= a:length
    let l:string = a:str
  else
    let l:string = strcharpart(a:str, (a:length/2 < 1 ? 1 : a:length/2), a:length)
  endif
  let l:numofspaces = a:length - strwidth(l:string)
  let char = get(a:000, 0, ' ')
  if type(char) !=# 1 || len(char) > 1
    let char = ' '
  endif
  let l:halfspaces = repeat(char, l:numofspaces/2)
  let l:rst = l:halfspaces . l:string . l:halfspaces
  if l:numofspaces % 2
    let l:rst .= char
  endif
  return l:rst
endfunction

function! s:self.trim_start(str) abort
  return substitute(a:str, '^\s*', '', 'g')
endfunction

function! s:self.trim_end(str) abort
  return substitute(a:str, '\s*$', '', 'g')
endfunction


" note: this function only works when encoding is utf-8
" ref: https://github.com/SpaceVim/SpaceVim/pull/2515
function! s:self.string2chars(str) abort
  let save_enc = &encoding
  let &encoding = 'utf-8'
  let chars = []
  for i in range(strchars(a:str))
    call add(chars, strcharpart(a:str,  i , 1))
  endfor
  let &encoding = save_enc
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
  let save_enc = &encoding
  let &encoding = 'utf-8'
  let chars = self.string2chars(a:str)
  let bchars = []
  for char in chars
    let nr = char2nr(char)
    if nr == 12288
      call add(bchars, nr2char(32))
    elseif nr == 8216 ||  nr == 8217
      call add(bchars, nr2char(39))
    elseif nr >= 65281 && nr <= 65374
      call add(bchars, nr2char(nr - 65248))
    else
      call add(bchars, char)
    endif
  endfor
  let &encoding = save_enc
  return join(bchars, '')
endfunction

function! s:self.strB2Q(str) abort
  let save_enc = &encoding
  let &encoding = 'utf-8'
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
  let &encoding = save_enc
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
