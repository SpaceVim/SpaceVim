"=============================================================================
" messletters.vim --- SpaceVim messletters API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8
let s:chars = {}
" type :
" 0: 1 ➛ ➊
" 1: 1 ➛ ➀
" 2: 1 ➛ ⓵
function! s:bubble_num(num, type) abort
  let list = []
  call add(list,['➊', '➋', '➌', '➍', '➎', '➏', '➐', '➑', '➒', '➓'])
  call add(list,['➀', '➁', '➂', '➃', '➄', '➅', '➆', '➇', '➈', '➉'])
  call add(list,['⓵', '⓶', '⓷', '⓸', '⓹', '⓺', '⓻', '⓼', '⓽', '⓾'])
  let n = ''
  try
    let n = list[a:type][a:num-1]
  catch
  endtry
  return  n
endfunction

let s:chars['bubble_num'] = function('s:bubble_num')

" type :
" 0: 1 ➛ ➊
" 1: 1 ➛ ➀
" 2: 1 ➛ ⓵
function! s:circled_num(num, type) abort
  " http://www.unicode.org/charts/beta/nameslist/n_2460.html
  if a:type == 0
    if a:num == 0
      return nr2char(9471)
    elseif index(range(1,10), a:num) != -1
      return nr2char(10102 + a:num - 1)
    elseif index(range(11, 20), a:num)
      return nr2char(9451 + a:num - 11)
    else
      return ''
    endif
  elseif a:type == 1
    if index(range(20), a:num) != -1
      if a:num == 0
        return nr2char(9450)
      else
        return nr2char(9311 + a:num)
      endif
    else
      return ''
    endif
  elseif a:type == 2
    if index(range(1, 10), a:num) != -1
      return nr2char(9461 + a:num - 1)
    else
      return ''
    endif
  elseif a:type == 3
    return a:num
  endif
endfunction

let s:chars['circled_num'] = function('s:circled_num')


function! s:index_num(num) abort
  let nums = [8304, 185, 178, 179, 8308, 8309, 8310, 8311, 8312, 8313]
  if index(range(10) , a:num) != -1
    return nr2char(nums[a:num])
  endif
  return ''
endfunction

let s:chars['index_num'] = function('s:index_num')


function! s:parenthesized_num(num) abort
  " http://www.unicode.org/charts/beta/nameslist/n_2460.html
  if index(range(1, 20), a:num) != -1
    return nr2char(9331 + a:num)
  else
    return ''
  endif
endfunction

let s:chars['parenthesized_num'] = function('s:parenthesized_num')

function! s:num_period(num) abort
  " http://www.unicode.org/charts/beta/nameslist/n_2460.html
  if index(range(1, 20), a:num) != -1
    return nr2char(9351 + a:num)
  else
    return ''
  endif
endfunction

let s:chars['num_period'] = function('s:num_period')

function! s:parenthesized_letter(letter) abort
  " http://www.unicode.org/charts/beta/nameslist/n_2460.html
  if index(range(1, 26), char2nr(a:letter) - 96) != -1
    return nr2char(9371 + char2nr(a:letter) - 96)
  else
    return ''
  endif
endfunction

let s:chars['parenthesized_letter'] = function('s:parenthesized_letter')

function! s:circled_letter(letter) abort
  " http://www.unicode.org/charts/beta/nameslist/n_2460.html
  if index(range(1, 26), char2nr(a:letter) - 64) != -1
    return nr2char(9397 + char2nr(a:letter) - 64)
  elseif index(range(1, 26), char2nr(a:letter) - 96) != -1
    return nr2char(9423 + char2nr(a:letter) - 96)
  else
    return ''
  endif
endfunction

let s:chars['circled_letter'] = function('s:circled_letter')

function! SpaceVim#api#messletters#get() abort
  return deepcopy(s:chars)
endfunction

" vim:set et sw=2:
