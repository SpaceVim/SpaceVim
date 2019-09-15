"=============================================================================
" dict.vim --- SpaceVim dict API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section data#dict, api-data-dict
" @parentsection api
" provides some functions to manipulate a dict.
"
" make({keys}, {values}[, {fill}])
" 
"   make a dictionary from two list, the {keys} and {values}.
"
" swap({dict})
"
"   swap the keys and values in a dictionary.
"
" make_index
"
"   make a dictionary from a list, use 





function! SpaceVim#api#data#dict#get() abort
  return map({
        \ 'make' : '',
        \ 'swap' : '',
        \ 'make_index' : '',
        \ 'pick' : '',
        \ 'omit' : '',
        \ 'clear' : '',
        \ 'max_by' : '',
        \ 'min_by' : '',
        \ 'foldl' : '',
        \ 'foldr' : '',
        \ 'entrys' : '',
        \ },
        \ "function('s:' . v:key)"
        \ )
endfunction

function! s:entrys(dict) abort
  let entrys = []
  for key in keys(a:dict)
    call add(entrys, {key : a:dict[key]})
  endfor
  return entrys
endfunction

function! s:make(keys, values, ...) abort
  let dict = {}
  let fill = a:0 ? a:1 : 0
  for i in range(len(a:keys))
    let key = type(a:keys[i]) == type('') ? a:keys[i] : string(a:keys[i])
    if key ==# ''
      throw "SpaceVim API: data#dict: Can't use an empty string for key."
    endif
    let dict[key] = get(a:values, i, fill)
  endfor
  return dict
endfunction

" Swaps keys and values
function! s:swap(dict) abort
  return s:make(values(a:dict), keys(a:dict))
endfunction

" Makes a index dict from a list
function! s:make_index(list, ...) abort
  let value = a:0 ? a:1 : 1
  return s:make(a:list, [], value)
endfunction

function! s:pick(dict, keys) abort
  let new_dict = {}
  for key in a:keys
    if has_key(a:dict, key)
      let new_dict[key] = a:dict[key]
    endif
  endfor
  return new_dict
endfunction

function! s:omit(dict, keys) abort
  let new_dict = copy(a:dict)
  for key in a:keys
    if has_key(a:dict, key)
      call remove(new_dict, key)
    endif
  endfor
  return new_dict
endfunction

function! s:clear(dict) abort
  for key in keys(a:dict)
    call remove(a:dict, key)
  endfor
  return a:dict
endfunction

function! s:_max_by(dict, expr) abort
  let dict = s:swap(map(copy(a:dict), a:expr))
  let key = dict[max(keys(dict))]
  return [key, a:dict[key]]
endfunction

function! s:max_by(dict, expr) abort
  if empty(a:dict)
    throw 'SpaceVim API: data#dict: Empty dictionary'
  endif
  return s:_max_by(a:dict, a:expr)
endfunction

function! s:min_by(dict, expr) abort
  if empty(a:dict)
    throw 'SpaceVim API: data#dict: Empty dictionary'
  endif
  return s:_max_by(a:dict, '-(' . a:expr . ')')
endfunction

function! s:_foldl(f, init, xs) abort
  let memo = a:init
  for [k, v] in a:xs
    let expr = substitute(a:f, 'v:key', string(k), 'g')
    let expr = substitute(expr, 'v:val', string(v), 'g')
    let expr = substitute(expr, 'v:memo', string(memo), 'g')
    unlet memo
    let memo = eval(expr)
  endfor
  return memo
endfunction

function! s:foldl(f, init, dict) abort
  return s:_foldl(a:f, a:init, items(a:dict))
endfunction

function! s:foldr(f, init, dict) abort
  return s:_foldl(a:f, a:init, reverse(items(a:dict)))
endfunction

" vim:set et sw=2 cc=80:
