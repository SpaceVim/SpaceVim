"=============================================================================
" $Id: env.vim 244 2010-09-19 22:38:24Z luc.hermitte $
" File:         autoload/lh/env.vim                               {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      2.2.1
" Created:      19th Jul 2010
" Last Update:  $Date: 2010-09-19 18:38:24 -0400 (Sun, 19 Sep 2010) $
"------------------------------------------------------------------------
" Description:
"       Functions related to environment (variables)
" 
"------------------------------------------------------------------------
" Installation:
"       Drop this file into {rtp}/autoload/lh
"       Requires Vim7+
" History:      
" 	v2.2.1 First Version
" TODO:         «missing features»
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
let s:k_version = 221
function! lh#env#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = 0
function! lh#env#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#env#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1
function! lh#env#expand_all(string)
  let res = ''
  let tail = a:string
  while !empty(tail)
    let [ all, head, var, tail; dummy ] = matchlist(tail, '\(.\{-}\)\%(${\(.\{-}\)}\)\=\(.*\)')
    if empty(var)
      let res .= tail
      break
    else
      let res .= head
      let val = eval('$'.var)
      let res .= val
    endif
  endwhile
  return res
endfunction
"------------------------------------------------------------------------
" ## Internal functions {{{1

"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
