"=============================================================================
" $Id: be.vim 193 2010-05-17 23:10:03Z luc.hermitte $
" File:		autoload/should/be.vim                            {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://hermitte.free.fr/vim/>
" Version:	0.0.3
" Created:	23rd Feb 2009
" Last Update:	$Date: 2010-05-17 19:10:03 -0400 (Mon, 17 May 2010) $
"------------------------------------------------------------------------
" Description:	
" 	UT & tAssert API
" 
"------------------------------------------------------------------------
" Installation:	
" 	Drop this file into {rtp}/autoload/should
" History:	
" 	
" TODO:		«missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------

" ## Functions {{{1
" # Debug {{{2
function! should#be#verbose(level)
  let s:verbose = a:level
endfunction

function! s:Verbose(expr)
  if exists('s:verbose') && s:verbose
    echomsg a:expr
  endif
endfunction

function! should#be#debug(expr)
  return eval(a:expr)
endfunction


" # Convinience functions for tAssert/UT {{{2
function! should#be#list(var)
  return type(a:var) == type([])
endfunction
function! should#be#number(var)
  return type(a:var) == type(42)
endfunction
function! should#be#string(var)
  return type(a:var) == type('')
endfunction
function! should#be#dict(var)
  return type(a:var) == type({})
endfunction
function! should#be#float(var)
  return type(a:var) == type(0.1)
endfunction
function! should#be#funcref(var)
  return type(a:var) == type(function('exists'))
endfunction



"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
