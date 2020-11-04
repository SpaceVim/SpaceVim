"=============================================================================
" $Id: vim_UT.vim 193 2010-05-17 23:10:03Z luc.hermitte $
" File:		ftplugin/vim/vim_UT.vim                              {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
let s:k_version = 003
" Version:	0.0.3
" Created:	20th Feb 2009
" Last Update:	$Date: 2010-05-17 19:10:03 -0400 (Mon, 17 May 2010) $
"------------------------------------------------------------------------
" Description:	Yet Another Unit Testing Framework for Vim 
" - Defines <F7> as :UTRun {targets=g:UTfiles}
" 
"------------------------------------------------------------------------
" Installation:	«install details»
" History:	«history»
" TODO:		«missing features»
" }}}1
"=============================================================================

" Buffer-local Definitions {{{1
" Avoid local reinclusion {{{2
if &cp || (exists("b:loaded_ftplug_vim_UT") && !exists('g:force_reload_ftplug_vim_UT'))
  finish
endif
let b:loaded_ftplug_vim_UT = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid local reinclusion }}}2

"------------------------------------------------------------------------
" Local mappings {{{2

nnoremap <buffer> <silent> <Plug>UTMake :call <sid>UTMake()<cr>

let s:key = lh#option#get('UTMake_key', '<F7>')
exe 'imap <buffer> '.s:key.' <c-\><c-n><Plug>UTMake'
exe 'vmap <buffer> '.s:key.' <c-\><c-n><Plug>UTMake'
exe 'nmap <buffer> '.s:key.' <Plug>UTMake'

"=============================================================================
" Global Definitions {{{1
" Avoid global reinclusion {{{2
if &cp || (exists("g:loaded_ftplug_vim_UT") && !exists('g:force_reload_ftplug_vim_UT'))
  let &cpo=s:cpo_save
  finish
endif
let g:loaded_ftplug_vim_UT = s:k_version
" Avoid global reinclusion }}}2
"------------------------------------------------------------------------
" Functions {{{2

function! s:UTMake()
  let files = lh#option#get('UTfiles', '%')
  echo 'update|source '.expand('%').'|UTRun '.files
  update
  so%
  exe 'UTRun '.files
endfunction


" Functions }}}2
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
" VIM: let g:UTfiles='tests/lh/UT*.vim'
