"=============================================================================
" $Id: lhvl.vim 245 2010-09-19 22:40:10Z luc.hermitte $
" File:		plugin/lhvl.vim                                   {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	27th Apr 2010
" Last Update:	$Date: 2010-09-19 18:40:10 -0400 (Sun, 19 Sep 2010) $
"------------------------------------------------------------------------
" Description:	
"       Non-function resources from lh-vim-lib
" 
"------------------------------------------------------------------------
" Installation:	
"       Drop the file into {rtp}/plugin
" History:	
"       v2.2.1  first version
" TODO:		«missing features»
" }}}1
"=============================================================================

" Avoid global reinclusion {{{1
let s:k_version = 221
if &cp || (exists("g:loaded_lhvl")
      \ && (g:loaded_lhvl >= s:k_version)
      \ && !exists('g:force_reload_lhvl'))
  finish
endif
let g:loaded_lhvl = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" Commands and Mappings {{{1
" Moved from lh-cpp
command! PopSearch :call histdel('search', -1)| let @/=histget('search',-1)

" Commands and Mappings }}}1
"------------------------------------------------------------------------
" Functions {{{1
" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
