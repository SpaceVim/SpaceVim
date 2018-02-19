"=============================================================================
" string.vim --- SpaceVim string API
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:file = {}

function! s:trim(str) abort
  let str = substitute(a:str, '\s*$', '', 'g')
  return substitute(str, '^\s*', '', 'g')
endfunction

let s:file['trim'] = function('s:trim')

function! s:fill(str, length) abort
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

let s:file['fill'] = function('s:fill')

function! s:fill_middle(str, length) abort
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

let s:file['fill_middle'] = function('s:fill_middle')

function! s:trim_start(str) abort
  return substitute(a:str, '^\s*', '', 'g')
endfunction

let s:file['trim_start'] = function('s:trim_start')

function! s:trim_end(str) abort
  return substitute(a:str, '\s*$', '', 'g')
endfunction

let s:file['trim_end'] = function('s:trim_end')

function! s:string2chars(str) abort
  let chars = []
  for i in range(len(a:str))
    call add(chars, a:str[i : i])
  endfor
  return chars
endfunction
let s:file['string2chars'] = function('s:string2chars')

function! s:strAllIndex(str, need, use_expr) abort
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
let s:file['strAllIndex'] = function('s:strAllIndex')

function! SpaceVim#api#data#string#get() abort
  return deepcopy(s:file)
endfunction

" vim:set et sw=2:
