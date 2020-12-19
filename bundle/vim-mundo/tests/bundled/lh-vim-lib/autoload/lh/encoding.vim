"=============================================================================
" $Id: encoding.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		autoload/lh/encoding.vim                               {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	21st Feb 2008
" Last Update:	$Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $
"------------------------------------------------------------------------
" Description:	
" 	Defines functions that help managing various encodings
" 
"------------------------------------------------------------------------
" Installation:	
" 	Drop it into {rtp}/autoload/lh/
" 	Vim 7+ required.
" History:	
" 	v2.0.7:
" 	(*) lh#encoding#Iconv() copied from map-tools
" TODO:		«missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------

" Function: lh#encoding#iconv(expr, from, to)  " {{{3
" Unlike |iconv()|, this wrapper returns {expr} when we know no convertion can
" be acheived.
function! lh#encoding#iconv(expr, from, to)
  " call Dfunc("s:ICONV(".a:expr.','.a:from.','.a:to.')')
  if has('multi_byte') && 
	\ ( has('iconv') || has('iconv/dyn') ||
	\ ((a:from=~'latin1\|utf-8') && (a:to=~'latin1\|utf-8')))
    " call confirm('encoding: '.&enc."\nto:".a:to, "&Ok", 1)
    " call Dret("s:ICONV convert=".iconv(a:expr, a:from, a:to))
    return iconv(a:expr,a:from,a:to)
  else
    " Cannot convert
    " call Dret("s:ICONV  no convert=".a:expr)
    return a:expr
  endif
endfunction

"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
