"=============================================================================
" list.vim --- SpaceVim list API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
function! SpaceVim#api#data#list#get() abort
    return map({'pop' : '',
                \ 'push' : '',
                \ 'shift' : '',
                \ 'unshift' : '',
                \ 'uniq' : '',
                \ 'uniq_by' : '',
                \ 'uniq_by_func' : '',
                \ 'clear' : '',
                \ 'char_range' : '',
                \ 'has' : '',
                \ 'has_index' : '',
                \ 'listpart' : '',
                \ 'replace' : '',
                \ },
                \ "function('s:' . v:key)"
                \ )
endfunction

""
" @section data#list, api-data-list
" @parentsection api
" provides some functions to manipulate a list.
"
" pop({list})
" 
"   Removes the last element from {list} and returns the element,
" as if the {list} is a stack.
"
" push({list})
"
"   Appends {val} to the end of {list} and returns the list itself,
" as if the {list} is a stack.
"
" listpart({list}, {start}[, {len}])
" 
"   The result is a List, which is part of {list}, starting from
" index {start}, with the length {len}
"
" replace(list, begin, end, re_list)
"
"   replace {list} from {begin} to {end} with {re_list}
"
" shift({list})
"
"   remove first item in a {list}, and return the item
"
" unshift({list})
"
"  insert an item to the begin of the {list} 

function! s:pop(list) abort
    return remove(a:list, -1)
endfunction

function! s:listpart(list, start, ...) abort
  let idx = range(a:start, a:start + get(a:000, 0, 0))
  let rst = []
  for i in idx
    call add(rst, get(a:list, i))
  endfor
  return rst
endfunction

function! s:push(list, val) abort
  call add(a:list, a:val)
  return a:list
endfunction

function! s:shift(list) abort
    return remove(a:list, 0)
endfunction

function! s:unshift(list, val) abort
    return insert(a:list, a:val)
endfunction

function! s:uniq(list) abort
    return s:uniq_by(a:list, 'v:val')
endfunction

function! s:uniq_by_func(list, func) abort
    let list = map(copy(a:list), '[v:val, call(a:func, [v:val])]')
    let i = 0
    let seen = {}
    while i < len(list)
        let key = string(list[i][1])
        if has_key(seen, key)
            call remove(list, i)
        else
            let seen[key] = 1
            let i += 1
        endif
    endwhile
    return map(list, 'v:val[0]')
endfunction

function! s:uniq_by(list, f) abort
    let list = map(copy(a:list), printf('[v:val, %s]', a:f))
    let i = 0
    let seen = {}
    while i < len(list)
        let key = string(list[i][1])
        if has_key(seen, key)
            call remove(list, i)
        else
            let seen[key] = 1
            let i += 1
        endif
    endwhile
    return map(list, 'v:val[0]')
endfunction

function! s:clear(list) abort
  if !empty(a:list)
    unlet! a:list[0 : len(a:list) - 1]
  endif
  return a:list
endfunction

function! s:char_range(from, to) abort
  return map(
  \   range(char2nr(a:from), char2nr(a:to)),
  \   'nr2char(v:val)'
  \)
endfunction

function! s:has(list, val) abort
    return index(a:list, a:val) != -1
endfunction

function! s:has_index(list, index) abort
    return 0 <= a:index && a:index < len(a:list)
endfunction

function! s:replace(list, begin, end, re_list) abort
  if a:begin <= a:end && a:begin >= 0 && a:end < len(a:list)
    return a:list[:a:begin - 1] + a:re_list + a:list[a:end + 1:]
  else
    return a:list
  endif
endf

" vim:set et sw=2 cc=80:
