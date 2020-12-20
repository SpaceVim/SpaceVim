"=============================================================================
" $Id: list.vim 238 2010-06-01 00:47:16Z luc.hermitte $
" File:		tests/lh/list.vim                                      {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	19th Nov 2008
" Last Update:	$Date: 2010-05-31 20:47:16 -0400 (Mon, 31 May 2010) $
"------------------------------------------------------------------------
" Description:	
" 	Tests for autoload/lh/list.vim
" 
"------------------------------------------------------------------------
" Installation:	«install details»
" History:	«history»
" TODO:		«missing features»
" }}}1
"=============================================================================

UTSuite [lh-vim-lib] Testing lh#list functions

runtime autoload/lh/function.vim
runtime autoload/lh/list.vim
let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" Find_if
function! s:Test_Find_If_string_predicate()
    :let b = { 'min': 12, 'max': 42 }
    :let l = [ 1, 5, 48, 25, 5, 28, 6]
    :let i = lh#list#Find_if(l, 'v:val>v:1_.min  && v:val<v:1_.max && v:val%v:2_==0', [b, 2] )
    " echo i . '/' . len(l)
    Assert i == 5
    Assert l[i] == 28
    " :echo l[i]
endfunction

function! s:Test_Find_If_functor_predicate()
    :let l = [ 1, 5, 48, 25, 5, 28, 6]
    :let i = lh#list#find_if(l, 'v:1_>12  && v:1_<42 && v:1_%2==0')
    " echo i . '/' . len(l)
    Assert i == 5
    Assert l[i] == 28
    " :echo l[i]
endfunction

function! s:Test_find_if_double_bind()
    :let b = { 'min': 12, 'max': 42 }
    :let l = [ 1, 5, 48, 25, 5, 28, 6]
    :let f = lh#function#bind( 'v:3_>v:1_.min  && v:3_<v:1_.max && v:3_%v:2_==0') 
    :let p = lh#function#bind(f, b,2,'v:1_') 
    :let i = lh#list#find_if(l, p)
    :echo l[i]
endfunction
" double bind is not yet operational
UTIgnore Test_find_if_double_bind

"------------------------------------------------------------------------
" Unique Sorting
function! CmpNumbers(lhs, rhs)
  if     a:lhs < a:rhs  | return -1
  elseif a:lhs == a:rhs | return 0
  else              | return +1
  endif
endfunction

function! s:Test_sort()
    :let l = [ 1, 5, 48, 25, 5, 28, 6]
    :let expected = [ 1, 5, 6, 25, 28, 48]
    :let s = lh#list#unique_sort(l, "CmpNumbers") 
    " Comment string(s)
    Assert s == expected
endfunction

function! s:Test_sort2()
    :let l = [ 1, 5, 48, 25, 5, 28, 6]
    :let expected = [ 1, 5, 6, 25, 28, 48]
    :let s = lh#list#unique_sort2(l, "CmpNumbers") 
    " Comment string(s)
    Assert s == expected
endfunction

"------------------------------------------------------------------------
" Searchs
function! s:TestBinarySearches()
  let v1 = [ -3, -2, -1, -1, 0, 0, 1, 2, 3, 4, 6 ]
  let i = lh#list#lower_bound(v1, 3)
  Assert v1[i] == 3
  let i = lh#list#upper_bound(v1, 3)
  Assert v1[i] == 4
  let r = lh#list#equal_range(v1, 3)
  Assert v1[r[0]:r[1]-1] == [3]

  let i = lh#list#lower_bound(v1, -1)
  Assert v1[i] == -1
  let i = lh#list#upper_bound(v1, -1)
  Assert v1[i] == 0
  let r = lh#list#equal_range(v1, -1)
  Assert v1[r[0]:r[1]-1] == [-1, -1]

  let i = lh#list#lower_bound(v1, 5)
  Assert v1[i] == 6
  let i = lh#list#upper_bound(v1, 5)
  Assert v1[i] == 6
  let r = lh#list#equal_range(v1, 5)
  Assert v1[r[0]:r[1]-1] == []

  Assert len(v1) == lh#list#lower_bound(v1, 10)
  Assert len(v1) == lh#list#upper_bound(v1, 10)
  Assert [len(v1), len(v1)] == lh#list#equal_range(v1, 10)
endfunction

"------------------------------------------------------------------------
" accumulate

function! s:Test_accumulate_len_strings()
  let strings = [ 'foo', 'bar', 'toto' ]
  let len = eval(lh#list#accumulate(strings, 'strlen', 'join(v:1_,  "+")'))
  Assert len == 3+3+4
endfunction

function! s:Test_accumulate_join()
  let ll = [ 1, 2, 'foo', ['bar'] ]
  let res = lh#list#accumulate(ll, 'string', 'join(v:1_,  " ## ")')
  Assert res == "1 ## 2 ## 'foo' ## ['bar']"
  " This test will fail because it seems :for each loop cannot iterate on
  " heterogeneous containers
endfunction

"------------------------------------------------------------------------
" Copy_if
function! s:Test_copy_if()
    :let l = [ 1, 25, 5, 48, 25, 5, 28, 6]
    :let expected = [ 25, 48, 25, 28, 6]
    :let s = lh#list#copy_if(l, [], "v:1_ > 5") 
    " Comment string(s)
    Assert s == expected
endfunction

"------------------------------------------------------------------------
" subset
function! s:Test_subset()
    :let l = [ 1, 25, 5, 48, 25, 5, 28, 6]
    :let indices = [ 0, 5, 7, 3 ]
    :let expected = [ 1, 5, 6, 48 ]
    :let s = lh#list#subset(l, indices) 
    " Comment string(s)
    Assert s == expected
endfunction

"------------------------------------------------------------------------
" intersect
function! s:Test_intersect()
    :let l1 = [ 1, 25, 7, 48, 26, 5, 28, 6]
    :let l2 = [ 3, 8, 7, 25, 6 ]
    :let expected = [ 25, 7, 6 ]
    :let s = lh#list#intersect(l1, l2) 
    " Comment string(s)
    Assert s == expected
endfunction

"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
