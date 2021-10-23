"=============================================================================
" $Id: let.vim 239 2010-06-01 00:48:43Z luc.hermitte $
" File:         plugin/let.vim                                    {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      2.2.1
" Created:      31st May 2010
" Last Update:  $Date: 2010-05-31 20:48:43 -0400 (Mon, 31 May 2010) $
"------------------------------------------------------------------------
" Description:
"       Defines a command :LetIfUndef that sets a variable if undefined
" 
"------------------------------------------------------------------------
" Installation:
"       Drop this file into {rtp}/plugin
"       Requires Vim7+
" History:      
" 	v2.2.1: first version of this command into lh-vim-lib
" TODO: 
" }}}1
"=============================================================================

" Avoid global reinclusion {{{1
let s:k_version = 221
if &cp || (exists("g:loaded_let")
      \ && (g:loaded_let >= s:k_version)
      \ && !exists('g:force_reload_let'))
  finish
endif
let g:loaded_let = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" Commands and Mappings {{{1
command! -nargs=+ LetIfUndef call s:LetIfUndef(<f-args>)
" Commands and Mappings }}}1
"------------------------------------------------------------------------
" Functions {{{1
" Note: most functions are best placed into
" autoload/«your-initials»/«let».vim
" Keep here only the functions are are required when the plugin is loaded,
" like functions that help building a vim-menu for this plugin.
function! s:LetIfUndef(var, value)
  if !exists(a:var)
    let {a:var} = eval(a:value)
  endif
endfunction

" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
