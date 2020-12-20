"=============================================================================
" $Id: function.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		tests/lh/function.vim                                   {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	03rd Nov 2008
" Last Update:	$Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $
"------------------------------------------------------------------------
" Description:	
" 	Tests for autoload/lh/function.vim
" 
"------------------------------------------------------------------------
" Installation:	«install details»
" History:	«history»
" TODO:		«missing features»
" }}}1
"=============================================================================

UTSuite [lh-vim-lib] Testing lh#function plugin

runtime autoload/lh/function.vim

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
function! Test(...)
  let nb = len(a:000)
  " echo "test(".nb.':' .join(a:000, ' -- ')')'
  let i =0
  while i!= len(a:000)
    echo "Test: type(".i.")=".type(a:000[i]).' --> '. string(a:000[i])
    let i += 1
  endwhile
endfunction

function! Print(...)
  let res = lh#list#accumulate([1,2,'foo'], 'string', 'join(v:1_, " ## ")')
  return res
endfunction

function! Id(...)
  return copy(a:000)
endfunction

function! s:TestId()
  let r = Id(1, 'string', [0], [[1]], {'ffo':42}, function('exists'), 1.2)
  Assert! len(r) == 7
  Assert! should#be#number (r[0])
  Assert! should#be#string (r[1])
  Assert! should#be#list   (r[2])
  Assert! should#be#list   (r[3])
  Assert! should#be#dict   (r[4])
  Assert! should#be#funcref(r[5])
  Assert! should#be#float  (r[6])
  Assert r[0] == 1
  Assert r[1] == 'string'
  Assert r[2] == [0]
  Assert r[3] == [[1]]
  Assert r[4].ffo == 42
  Assert r[5] == function('exists')
  Assert r[6] == 1.2
endfunction

function! s:Test_bind()
  " lh#function#bind + lh#function#execute
  let rev4 = lh#function#bind(function('Id'), 'v:4_', 42, 'v:3_', 'v:2_', 'v:1_')
  let r = lh#function#execute(rev4, 1,'two','three', [4,5])
  Assert! len(r) == 5
  Assert! should#be#list   (r[0])
  Assert! should#be#number (r[1])
  Assert! should#be#string (r[2])
  Assert! should#be#string (r[3])
  Assert! should#be#number (r[4])

  Assert r[0] == [4,5]
  Assert r[1] == 42
  Assert r[2] == 'three'
  Assert r[3] == 'two'
  Assert r[4] == 1
endfunction

function! s:Test_bind_compound_vars()
  " lh#function#bind + lh#function#execute
  let rev4 = lh#function#bind(function('Id'), 'v:4_', 'v:1_ . v:2_', 'v:3_', 'v:2_', 'v:1_')
  let r = lh#function#execute(rev4, 1,'two','three', [4,5])
  Assert! len(r) == 5
  Assert! should#be#list   (r[0])
  Assert! should#be#string (r[1])
  Assert! should#be#string (r[2])
  Assert! should#be#string (r[3])
  Assert! should#be#number (r[4])

  Assert r[0] == [4,5]
  Assert r[1] == '1two'
  Assert r[2] == 'three'
  Assert r[3] == 'two'
  Assert r[4] == 1
endfunction


function! s:Test_execute_func_string_name()
  " function name as string
  let r = lh#function#execute('Id', 1,'two',3)
  Assert! len(r) == 3
  Assert! should#be#number (r[0])
  Assert! should#be#string (r[1])
  Assert! should#be#number (r[2])
  Assert r[0] == 1
  Assert r[1] == 'two'
  Assert r[2] == 3
endfunction

function! s:Test_execute_string_expr()
  " exp as binded-string
  let r = lh#function#execute('Id(12,len(v:2_).v:2_, 42, v:3_, v:1_)', 1,'two',3)
  Assert! len(r) == 5
  Assert! should#be#number (r[0])
  Assert! should#be#string (r[1])
  Assert! should#be#number (r[2])
  Assert! should#be#number (r[3])
  Assert! should#be#number (r[4])
  Assert r[0] == 12
  Assert r[1] == len('two').'two'
  Assert r[2] == 42
  Assert r[3] == 3
  Assert r[4] == 1
endfunction

function! s:Test_execute_func()
  " calling a function() + bind
  let r = lh#function#execute(function('Id'), 1,'two','v:1_',['a',42])
  Assert! len(r) == 4
  Assert! should#be#number (r[0])
  Assert! should#be#string (r[1])
  Assert! should#be#string (r[2])
  Assert! should#be#list   (r[3])
  Assert r[0] == 1
  Assert r[1] == 'two'
  Assert r[2] == 'v:1_'
  Assert r[3] == ['a', 42]
endfunction
"------------------------------------------------------------------------
function! s:Test_bind_func_string_name_AND_execute()
  " function name as string
  let rev3 = lh#function#bind('Id', 'v:3_', 12, 'v:2_', 'v:1_')
  let r = lh#function#execute(rev3, 1,'two',3)

  Assert! len(r) == 4
  Assert! should#be#number (r[0])
  Assert! should#be#number (r[1])
  Assert! should#be#string (r[2])
  Assert! should#be#number (r[3])
  Assert r[0] == 3
  Assert r[1] == 12
  Assert r[2] == 'two'
  Assert r[3] == 1
endfunction

function! s:Test_bind_string_expr_AND_execute()
" expressions as string
  let rev3 = lh#function#bind('Id(12,len(v:2_).v:2_, 42, v:3_, v:1_)')
  let r = lh#function#execute(rev3, 1,'two',3)
  Assert! len(r) == 5
  Assert! should#be#number (r[0])
  Assert! should#be#string (r[1])
  Assert! should#be#number (r[2])
  Assert! should#be#number (r[3])
  Assert! should#be#number (r[4])
  Assert r[0] == 12
  Assert r[1] == len('two').'two'
  Assert r[2] == 42
  Assert r[3] == 3
  Assert r[4] == 1
endfunction

function! s:Test_double_bind_func_name()
  let f1 = lh#function#bind('Id', 1, 2, 'v:1_', 4, 'v:2_')
  " Comment "f1=".string(f1)
  let r = lh#function#execute(f1, 3, 5)
  Assert! len(r) == 5
  let i = 0
  while i != len(r)
    Assert! should#be#number (r[i])
    Assert r[i] == i+1
    let i += 1
  endwhile

  " f2
  let f2 = lh#function#bind(f1, 'v:1_', 5)
  " Comment "f2=f1(v:1_, 5)=".string(f2)
  let r = lh#function#execute(f2, 3)
  Assert! len(r) == 5
  let i = 0
  while i != len(r)
    Assert! should#be#number (r[i])
    " echo "?? ".(r[i])."==".(i+1)
    Assert r[i] == i+1
    let i += 1
  endwhile
endfunction

function! s:Test_double_bind_func()
  let f1 = lh#function#bind(function('Id'), 1, 2, 'v:1_', 4, 'v:2_')
  " Comment "f1=".string(f1)
  let r = lh#function#execute(f1, 3, 5)
  Assert! len(r) == 5
  let i = 0
  while i != len(r)
    Assert! should#be#number (r[i])
    Assert r[i] == i+1
    let i += 1
  endwhile

  " f2
  let f2 = lh#function#bind(f1, 'v:1_', 5)
  " Comment "f2=f1(v:1_, 5)=".string(f2)
  let r = lh#function#execute(f2, 3)
  Assert! len(r) == 5
  let i = 0
  while i != len(r)
    Assert! should#be#number (r[i])
    Assert r[i] == i+1
    let i += 1
  endwhile
endfunction

function! s:Test_double_bind_func_cplx()
  let s:bar = "bar"
  let f1 = lh#function#bind(function('Id'), 1, 2, 'v:1_', 4, 'v:2_', 'v:3_', 'v:4_', 'v:5_', 'v:6_', 'v:7_')
  " Comment "f1=".string(f1)
  let f2 = lh#function#bind(f1, 'v:1_', 5, 'foo', s:bar, 'len(s:bar.v:1_)+v:1_', [1,2], '[v:1_, v:2_]')
  " Comment "f2=f1(v:1_, 5)=".string(f2)

  let r = lh#function#execute(f2, 42, "foo")
  Assert! 0 && "not ready"
  Comment "2bcpl# ".string(r)
endfunction

function! s:Test_double_bind_expr()
  let f1 = lh#function#bind('Id(1, 2, v:1_, v:3_, v:2_)')
  Comment "2be# f1=".string(f1)
  let r = lh#function#execute(f1, 3, 5, 4)
  Comment "2be# ".string(r)
  Assert! len(r) == 5
  let i = 0
  while i != len(r)
    Assert! should#be#number (r[i])
    Assert r[i] == i+1
    let i += 1
  endwhile

  " f2
  let f2 = lh#function#bind(f1, 'v:1_', '"foo"', [])
  Comment "2be# f2=f1(v:1_, 5)=".string(f2)
  let r = lh#function#execute(f2, 3)
  Comment "2be# ".string(r)
  Assert! len(r) == 5
  let i = 0
  while i != len(r)-2
    Assert! should#be#number (r[i])
    Assert r[i] == i+1
    let i += 1
  endwhile

  Assert! should#be#list (r[-2])
  Assert r[-2] == []
  Assert! should#be#string (r[-1])
  Assert r[-1] == 'foo'
endfunction

"todo: write double-binded tests for all kind of binded parameters:
" 'len(g:bar)'
" 42
" []
" v:1_ + len(v:2_.v:3_)
" '"foo"'
" v:1_

"------------------------------------------------------------------------

let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
