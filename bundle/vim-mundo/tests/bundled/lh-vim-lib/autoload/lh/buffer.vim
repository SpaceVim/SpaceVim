"=============================================================================
" $Id: buffer.vim 246 2010-09-19 22:40:58Z luc.hermitte $
" File:		autoload/lh/buffer.vim                               {{{1
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:	2.2.1
" Created:	23rd Jan 2007
" Last Update:	$Date: 2010-09-19 18:40:58 -0400 (Sun, 19 Sep 2010) $
"------------------------------------------------------------------------
" Description:	
" 	Defines functions that help finding windows and handling buffers.
" 
"------------------------------------------------------------------------
" Installation:	
" 	Drop it into {rtp}/autoload/lh/
" 	Vim 7+ required.
" History:	
"	v 1.0.0 First Version
" 	(*) Functions moved from searchInRuntimeTime  
" 	v 2.2.0
" 	(*) new function: lh#buffer#list()
" TODO:	
" }}}1
"=============================================================================


"=============================================================================
let s:cpo_save=&cpo
set cpo&vim

" ## Functions {{{1
"------------------------------------------------------------------------
" # Debug {{{2
function! lh#buffer#verbose(level)
  let s:verbose = a:level
endfunction

function! s:Verbose(expr)
  if exists('s:verbose') && s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#buffer#debug(expr)
  return eval(a:expr)
endfunction

"------------------------------------------------------------------------
" # Public {{{2

" Function: lh#buffer#find({filename}) {{{3
" If {filename} is opened in a window, jump to this window, otherwise return -1
" Moved from searchInRuntimeTime.vim
function! lh#buffer#find(filename)
  let b = bufwinnr(a:filename)
  if b == -1 | return b | endif
  exe b.'wincmd w'
  return b
endfunction
function! lh#buffer#Find(filename)
  return lh#buffer#find(a:filename)
endfunction

" Function: lh#buffer#jump({filename},{cmd}) {{{3
function! lh#buffer#jump(filename, cmd)
  if lh#buffer#find(a:filename) != -1 | return | endif
  exe a:cmd . ' ' . a:filename
endfunction
function! lh#buffer#Jump(filename, cmd)
  return lh#buffer#jump(a:filename, a:cmd)
endfunction

" Function: lh#buffer#scratch({bname},{where}) {{{3
function! lh#buffer#scratch(bname, where)
  try
    silent exe a:where.' sp '.a:bname
  catch /.*/
    throw "Can't open a buffer named '".a:bname."'!"
  endtry
  setlocal bt=nofile bh=wipe nobl noswf ro
endfunction
function! lh#buffer#Scratch(bname, where)
  return lh#buffer#scratch(a:bname, a:where)
endfunction

" Function: lh#buffer#list() {{{3
function! lh#buffer#list()
  let all = range(0, bufnr('$'))
  " let res = lh#list#transform_if(all, [], 'v:1_', 'buflisted')
  let res = lh#list#copy_if(all, [], 'buflisted')
  return res
endfunction
" Ex: echo lh#list#transform(lh#buffer#list(), [], "bufname")
"=============================================================================
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
