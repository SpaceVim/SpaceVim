"=============================================================================
" $Id: list.vim 236 2010-06-01 00:43:34Z luc.hermitte $
" File:         autoload/lh/list.vim                                      {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"               <URL:http://code.google.com/p/lh-vim/>
" Version:      2.2.1
" Created:      17th Apr 2007
" Last Update:  $Date: 2010-05-31 20:43:34 -0400 (Mon, 31 May 2010) $ (17th Apr 2007)
"------------------------------------------------------------------------
" Description:  
"       Defines functions related to |Lists|
" 
"------------------------------------------------------------------------
" Installation: 
"       Drop it into {rtp}/autoload/lh/
"       Vim 7+ required.
" History:      
"       v2.2.1:
"       (*) use :unlet in :for loop to support heterogeneous lists
"       (*) binary search algorithms (upper_bound, lower_bound, equal_range)
"       v2.2.0:
"       (*) new functions: lh#list#accumulate, lh#list#transform,
"           lh#list#transform_if, lh#list#find_if, lh#list#copy_if,
"           lh#list#subset, lh#list#intersect
"       (*) the functions are compatible with lh#function functors
"       v2.1.1: 
"       (*) unique_sort
"       v2.0.7:
"       (*) Bug fix: lh#list#Match()
"       v2.0.6:
"       (*) lh#list#Find_if() supports search predicate, and start index
"       (*) lh#list#Match() supports start index
"       v2.0.0:
" TODO:         «missing features»
" }}}1
"=============================================================================


"=============================================================================
let s:cpo_save=&cpo
set cpo&vim

"------------------------------------------------------------------------
" ## Functions {{{1
" # Debug {{{2
function! lh#list#verbose(level)
  let s:verbose = a:level
endfunction

function! s:Verbose(expr)
  if exists('s:verbose') && s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#list#debug(expr)
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" # Public {{{2
" Function: lh#list#Transform(input, output, action) {{{3
" deprecated version
function! lh#list#Transform(input, output, action)
  let new = map(copy(a:input), a:action)
  let res = extend(a:output,new)
  return res

  for element in a:input
    let action = substitute(a:action, 'v:val','element', 'g')
    let res = eval(action)
    call add(a:output, res)
    unlet element " for heterogeneous lists
  endfor
  return a:output
endfunction

function! lh#list#transform(input, output, action)
  for element in a:input
    let res = lh#function#execute(a:action, element)
    call add(a:output, res)
    unlet element " for heterogeneous lists
  endfor
  return a:output
endfunction

function! lh#list#transform_if(input, output, action, predicate)
  for element in a:input
    if lh#function#execute(a:predicate, element)
      let res = lh#function#execute(a:action, element)
      call add(a:output, res)
    endif
    unlet element " for heterogeneous lists
  endfor
  return a:output
endfunction

function! lh#list#copy_if(input, output, predicate)
  for element in a:input
    if lh#function#execute(a:predicate, element)
      call add(a:output, element)
    endif
    unlet element " for heterogeneous lists
  endfor
  return a:output
endfunction

function! lh#list#accumulate(input, transformation, accumulator)
  let transformed = lh#list#transform(a:input, [], a:transformation)
  let res = lh#function#execute(a:accumulator, transformed)
  return res
endfunction

" Function: lh#list#match(list, to_be_matched [, idx]) {{{3
function! lh#list#match(list, to_be_matched, ...)
  let idx = (a:0>0) ? a:1 : 0
  while idx < len(a:list)
    if match(a:list[idx], a:to_be_matched) != -1
      return idx
    endif
    let idx += 1
  endwhile
  return -1
endfunction
function! lh#list#Match(list, to_be_matched, ...)
  let idx = (a:0>0) ? a:1 : 0
  return lh#list#match(a:list, a:to_be_matched, idx)
endfunction

" Function: lh#list#Find_if(list, predicate [, predicate-arguments] [, start-pos]) {{{3
function! lh#list#Find_if(list, predicate, ...)
  " Parameters
  let idx = 0
  let args = []
  if a:0 == 2
    let idx = a:2
    let args = a:1
  elseif a:0 == 1
    if type(a:1) == type([])
      let args = a:1
    elseif type(a:1) == type(42)
      let idx = a:1
    else
      throw "lh#list#Find_if: unexpected argument type"
    endif
  elseif a:0 != 0
      throw "lh#list#Find_if: unexpected number of arguments: lh#list#Find_if(list, predicate [, predicate-arguments] [, start-pos])"
  endif

  " The search loop
  while idx != len(a:list)
    let predicate = substitute(a:predicate, 'v:val', 'a:list['.idx.']', 'g')
    let predicate = substitute(predicate, 'v:\(\d\+\)_', 'args[\1-1]', 'g')
    let res = eval(predicate)
    if res | return idx | endif
    let idx += 1
  endwhile
  return -1
endfunction

" Function: lh#list#find_if(list, predicate [, predicate-arguments] [, start-pos]) {{{3
function! lh#list#find_if(list, predicate, ...)
  " Parameters
  let idx = 0
  let args = []
  if a:0 == 1
    let idx = a:1
  elseif a:0 != 0
      throw "lh#list#find_if: unexpected number of arguments: lh#list#find_if(list, predicate [, start-pos])"
  endif

  " The search loop
  while idx != len(a:list)
    " let predicate = substitute(a:predicate, 'v:val', 'a:list['.idx.']', 'g')
    let res = lh#function#execute(a:predicate, a:list[idx])
    if res | return idx | endif
    let idx += 1
  endwhile
  return -1
endfunction

" Function: lh#list#lower_bound(sorted_list, value  [, first[, last]]) {{{3
function! lh#list#lower_bound(list, val, ...)
  let first = 0
  let last = len(a:list)
  if a:0 >= 1     | let first = a:1
  elseif a:0 >= 2 | let last = a:2
  elseif a:0 > 2
      throw "lh#list#equal_range: unexpected number of arguments: lh#list#equal_range(sorted_list, value  [, first[, last]])"
  endif

  let len = last - first

  while len > 0
    let half = len / 2
    let middle = first + half
    if a:list[middle] < a:val
      let first = middle + 1
      let len -= half + 1
    else
      let len = half
    endif
  endwhile
  return first
endfunction

" Function: lh#list#upper_bound(sorted_list, value  [, first[, last]]) {{{3
function! lh#list#upper_bound(list, val, ...)
  let first = 0
  let last = len(a:list)
  if a:0 >= 1     | let first = a:1
  elseif a:0 >= 2 | let last = a:2
  elseif a:0 > 2
      throw "lh#list#equal_range: unexpected number of arguments: lh#list#equal_range(sorted_list, value  [, first[, last]])"
  endif

  let len = last - first

  while len > 0
    let half = len / 2
    let middle = first + half
    if a:val < a:list[middle]
      let len = half
    else
      let first = middle + 1
      let len -= half + 1
    endif
  endwhile
  return first
endfunction

" Function: lh#list#equal_range(sorted_list, value  [, first[, last]]) {{{3
" @return [f, l], where
"   f : First position where {value} could be inserted
"   l : Last position where {value} could be inserted
function! lh#list#equal_range(list, val, ...)
  let first = 0
  let last = len(a:list)

  " Parameters
  if a:0 >= 1     | let first = a:1
  elseif a:0 >= 2 | let last  = a:2
  elseif a:0 > 2
      throw "lh#list#equal_range: unexpected number of arguments: lh#list#equal_range(sorted_list, value  [, first[, last]])"
  endif

  " The search loop ( == STLPort's equal_range)

  let len = last - first
  while len > 0
    let half = len / 2
    let middle = first + half
    if a:list[middle] < a:val
      let first = middle + 1
      let len -= half + 1
    elseif a:val < a:list[middle]
      let len = half
    else
      let left = lh#list#lower_bound(a:list, a:val, first, middle)
      let right = lh#list#upper_bound(a:list, a:val, middle+1, first+len)
      return [left, right]
    endif

    " let predicate = substitute(a:predicate, 'v:val', 'a:list['.idx.']', 'g')
    " let res = lh#function#execute(a:predicate, a:list[idx])
  endwhile
  return [first, first]
endfunction

" Function: lh#list#unique_sort(list [, func]) {{{3
" See also http://vim.wikia.com/wiki/Unique_sorting
"
" Works like sort(), optionally taking in a comparator (just like the
" original), except that duplicate entries will be removed.
" todo: support another argument that act as an equality predicate
function! lh#list#unique_sort(list, ...)
  let dictionary = {}
  for i in a:list
    let dictionary[string(i)] = i
  endfor
  let result = []
  " echo join(values(dictionary),"\n")
  if ( exists( 'a:1' ) )
    let result = sort( values( dictionary ), a:1 )
  else
    let result = sort( values( dictionary ) )
  endif
  return result
endfunction

function! lh#list#unique_sort2(list, ...)
  let list = copy(a:list)
  if ( exists( 'a:1' ) )
    call sort(list, a:1 )
  else
    call sort(list)
  endif
  if len(list) <= 1 | return list | endif
  let result = [ list[0] ]
  let last = list[0]
  let i = 1
  while i < len(list)
    if last != list[i]
      let last = list[i]
      call add(result, last)
    endif
    let i += 1
  endwhile
  return result
endfunction

" Function: lh#list#subset(list, indices) {{{3
function! lh#list#subset(list, indices)
  let result=[]
  for e in a:indices
    call add(result, a:list[e])
  endfor
  return result
endfunction

" Function: lh#list#intersect(list1, list2) {{{3
function! lh#list#intersect(list1, list2)
  let result = copy(a:list1)
  call filter(result, 'index(a:list2, v:val) >= 0')
  return result

  for e in a:list1
    if index(a:list2, e) > 0
      call result(result, e)
    endif
  endfor
endfunction

" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
