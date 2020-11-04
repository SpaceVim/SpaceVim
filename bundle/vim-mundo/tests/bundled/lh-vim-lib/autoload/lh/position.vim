"=============================================================================
" $Id: position.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		autoload/lh/position.vim                               {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	05th Sep 2007
" Last Update:	$Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $ (05th Sep 2007)
"------------------------------------------------------------------------
" Description:	«description»
" 
"------------------------------------------------------------------------
" Installation:
" 	Drop it into {rtp}/autoload/lh/
" 	Vim 7+ required.
" History:	«history»
" 	v1.0.0:
" 		Creation
" TODO:		
" }}}1
"=============================================================================


"=============================================================================
let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Functions {{{1
" # Debug {{{2
function! lh#position#verbose(level)
  let s:verbose = a:level
endfunction

function! s:Verbose(expr)
  if exists('s:verbose') && s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#position#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" # Public {{{2
" Function: lh#position#is_before {{{3
" @param[in] positions as those returned from |getpos()|
" @return whether lhs_pos is before rhs_pos
function! lh#position#is_before(lhs_pos, rhs_pos)
  if a:lhs_pos[0] != a:rhs_pos[0]
    throw "Positions from incompatible buffers can't be ordered"
  endif
  "1 test lines
  "2 test cols
  let before 
	\ = (a:lhs_pos[1] == a:rhs_pos[1])
	\ ? (a:lhs_pos[2] < a:rhs_pos[2])
	\ : (a:lhs_pos[1] < a:rhs_pos[1])
  return before
endfunction
function! lh#position#IsBefore(lhs_pos, rhs_pos)
  return lh#position#is_before(a:lhs_pos, a:rhs_pos)
endfunction


" Function: lh#position#char_at_mark {{{3
" @return the character at a given mark (|mark|)
function! lh#position#char_at_mark(mark)
  let c = getline(a:mark)[col(a:mark)-1]
  return c
endfunction
function! lh#position#CharAtMark(mark)
return lh#position#char_at_mark(a:mark)
endfunction

" Function: lh#position#char_at_pos {{{3
" @return the character at a given position (|getpos()|)
function! lh#position#char_at_pos(pos)
  let c = getline(a:pos[1])[col(a:pos[2])-1]
  return c
endfunction
function! lh#position#CharAtPos(pos)
  return  lh#position#char_at_pos(a:pos)
endfunction



" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
