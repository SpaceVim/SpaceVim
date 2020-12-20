"=============================================================================
" $Id: UT.vim 193 2010-05-17 23:10:03Z luc.hermitte $
" File:		tests/lh/UT.vim                                      {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://hermitte.free.fr/vim/>
" Version:	0.0.1
" Created:	11th Feb 2009
" Last Update:	$Date: 2010-05-17 19:10:03 -0400 (Mon, 17 May 2010) $
"------------------------------------------------------------------------
" Description:	UnitTests for the UT plugin. 
" - Tests global assertions
" - Tests assertions definied in tests (functions s:Test)
" 
"------------------------------------------------------------------------
" Installation:	«install details»
" History:	«history»
" TODO:		«missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
UTSuite [lh#UT] Testing global and local assertions

Assert 1 == 1
Assert 1 != 42
Assert 1 < 20
Assert 1 > 20

let st = "string"
Assert st =~ 'str'
Assert st !~ 'str'
Assert st == 'str'
Assert st != 'str'
Assert st == 0
" Assert 0 + [0]

function! s:One()
  return 1
endfunction
Assert s:One() == 1

"------------------------------------------------------------------------
function! s:TestOK()
  Comment "TestOK"
  Assert! 1 == 1
  Assert 1 == 1
  Assert repeat('1', 5) == '11111'
  Assert! repeat('1', 5) == '11111'
endfunction

"------------------------------------------------------------------------
function! s:TestCriticalNOK()
  Comment "TestCriticalNOK"
  Assert! 1 == 0
  Assert repeat('1', 5) == '1111'
endfunction

"------------------------------------------------------------------------
function! s:TestNOK()
  Comment "TestNOK"
  Assert 0 == 1
  Assert repeat('1', 5) == '1111'
endfunction

function! s:Foo()
endfunction
"------------------------------------------------------------------------
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
