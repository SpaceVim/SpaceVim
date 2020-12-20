"=============================================================================
" $Id: test-askmenu.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		test-buffer-menu.vim                                      {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	18th Apr 2007
" Last Update:	$Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $
"------------------------------------------------------------------------
" Description:	
" 	Test units for buffermenu.vim
" 
"------------------------------------------------------------------------
" Installation:	Requires:
" 	(*) Vim 7.0+
" 	(*) vim_units.vim v0.2/1.0?
" 	    Vimscript # «???»
" 	(*) lh-vim-lib (lh#ask#menu)
"
" User Manual:
" 	Source this file.
"
" History:	
" (*) 17th Apr 2007: First version 
" TODO:		«missing features»
" }}}1
"=============================================================================



"=============================================================================
let s:cpo_save=&cpo
"------------------------------------------------------------------------
" Functions {{{1

function! TestAskMenu()
  imenu          42.40.10 &LH-Tests.&Menu.&ask.i       iask
  inoremenu      42.40.10 &LH-Tests.&Menu.&ask.inore   inoreask
  nmenu          42.40.10 &LH-Tests.&Menu.&ask.n       nask
  nnoremenu      42.40.10 &LH-Tests.&Menu.&ask.nnore   nnoreask
  nmenu <script> 42.40.10 &LH-Tests.&Menu.&ask.nscript nscriptask
  nnoremenu <script> 42.40.10 &LH-Tests.&Menu.&ask.nnnscript nnscriptask

  vmenu          42.40.10 &LH-Tests.&Menu.&ask.v     vask
  vnoremenu      42.40.10 &LH-Tests.&Menu.&ask.vnore vnoreask

  call s:CheckInMode('i', 'i')

endfunction

function! s:CheckInMode(mode, name)
  let g:menu = lh#askvim#menu('LH-Tests.Menu.ask.'.a:name, a:mode)
  let g:name = a:name
  " VUAssert 55 Equals g:menu.name     g:name     "Name mismatch"
  " VUAssert 56 Equals g:menu.priority '42.40.10' "Priority mismatch"
  " VUAssert 57 Fail "parce qu'il le faut bien"
  echomsg "name= ".g:menu.name
  echomsg "prio= ".g:menu.priority
endfunction

" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
