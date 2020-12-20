"=============================================================================
" $Id: UT.vim 193 2010-05-17 23:10:03Z luc.hermitte $
" File:		plugin/UT.vim                                        {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
let s:k_version = 003
" Version:	0.0.3
" Created:	11th Feb 2009
" Last Update:	$Date: 2010-05-17 19:10:03 -0400 (Mon, 17 May 2010) $
"------------------------------------------------------------------------
" Description:	Yet Another Unit Testing Framework for Vim 
" 
"------------------------------------------------------------------------
" Installation:	
" 	Drop the file into {rtp}/plugin/lh/
" History:	
" 	Strongly inspired by Tom Link's tAssert
" TODO:		«missing features»
" }}}1
"=============================================================================

" Avoid global reinclusion {{{1
if &cp || (exists("g:loaded_UT") && !exists('g:force_reload_UT'))
  finish
endif
let g:loaded_UT = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" Commands and Mappings {{{1

" Real commands (used to call UT files)
"command! UTRun {filenames}
command! -bang -nargs=+ -complete=file UTRun :call lh#UT#run("<bang>",<f-args>)

" Fake commands (used in UT files)
"command UTSuite {expression} [#{comments}]
command! -nargs=* UTSuite :echoerr "Use :UTRun and not :source on this script"<bar>finish
"command Assert {expression} [#{comments}]


" Commands and Mappings }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
" VIM: let g:UTfiles='tests/lh/UT*.vim'
