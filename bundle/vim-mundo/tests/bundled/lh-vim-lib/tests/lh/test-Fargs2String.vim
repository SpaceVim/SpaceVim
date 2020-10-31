"=============================================================================
" $Id: test-Fargs2String.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		tests/lh/test-Fargs2String.vim                           {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	16th Apr 2007
" Last Update:	$Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $
"------------------------------------------------------------------------
" Description:	Tests for lh-vim-lib . lh#command#Fargs2String
" 
"------------------------------------------------------------------------
" Installation:	
" 	Relies on the version «patched by myself|1?» of vim_units
" History:	«history»
" TODO:		«missing features»
" }}}1
"=============================================================================

function! s:TestEmpty()
  let empty = []
  let res = lh#command#Fargs2String(empty)
  call VUAssertEquals(len(empty), 0, 'Expected empty', 22)
  call VUAssertEquals(res, '', 'Expected empty result', 23)
endfunction

function! s:TestSimpleText1()
  let expected = 'text'
  let one = [ expected ]
  let res = lh#command#Fargs2String(one)
  call VUAssertEquals(len(one), 0, 'Expected empty', 27)
  call VUAssertEquals(res, expected, 'Expected a simple result', 28)
endfunction

function! s:TestSimpleTextN()
  let expected = 'text'
  let list = [ expected , 'stuff1', 'stuff2']
  let res = lh#command#Fargs2String(list)
  call VUAssertEquals(len(list), 2, 'Expected not empty', 38)
  call VUAssertEquals(res, expected, 'Expected a simple result', 39)
endfunction

function! s:TestComposedN()
  let expected = '"a several tokens string"'
  let list = [ '"a', 'several', 'tokens', 'string"', 'stuff1', 'stuff2']
  let res = lh#command#Fargs2String(list)
  call VUAssertEquals(len(list), 2, 'Expected not empty', 46)
  call VUAssertEquals(res, expected, 'Expected a composed string', 47)
  call VUAssertEquals(list, ['stuff1', 'stuff2'], 'Expected a list', 48)
  call VUAssertNotSame(list, ['stuff1', 'stuff2'], 'Expected different lists', 49)
endfunction

function! s:TestComposed1()
  let expected = '"string"'
  let list = [ '"string"', 'stuff1', 'stuff2']
  let res = lh#command#Fargs2String(list)
  call VUAssertEquals(len(list), 2, 'Expected not empty', 56)
  call VUAssertEquals(res, expected, 'Expected a string', 57)
  call VUAssertEquals(list, ['stuff1', 'stuff2'], 'Expected a list', 58)
  call VUAssertNotSame(list, ['stuff1', 'stuff2'], 'Expected different lists', 59)
endfunction

function! s:TestInvalidString()
  let expected = '"a string'
  let list = [ '"a', 'string']
  let res = lh#command#Fargs2String(list)
  call VUAssertEquals(len(list), 0, 'Expected empty', 66)
  call VUAssertEquals(res, expected, 'Expected an invalid string', 67)
endfunction

function! AllTests()
  call s:TestEmpty()
  call s:TestSimpleText1()
  call s:TestSimpleTextN()
  call s:TestComposed1()
  call s:TestComposedN()
endfunction

" call VURunnerRunTest('AllTests')
VURun % AllTests

"=============================================================================
" vim600: set fdm=marker:
