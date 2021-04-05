" Vim global plugin for short description
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" 		Israel Chauca F. <israelchauca@gmail.com>
" Version:	0.1
" Description:	Long description.
" Last Change:	2013-02-03
" License:	Vim License (see :help license)
" Location:	plugin/vrs.vim
" Website:	https://github.com/Raimondi/vrs
"
" See vrs.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help vrs

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" load guard
" uncomment after plugin development.
" XXX The conditions are only as examples of how to use them. Change them as
" needed. XXX
"if exists("g:loaded_vrs")
"      \ || v:version < 700
"      \ || v:version == 703 && !has('patch338')
"      \ || &compatible
"  let &cpo = s:save_cpo
"  finish
"endif
"let g:loaded_vrs = 1

" Options: {{{1

" Private Functions: {{{1

function! s:ex(key, ...) "{{{1
  let pattern = vrs#get(a:key)
  if empty(pattern)
    return ''
  endif
  let dest = a:0 ? a:1 : '@/'
  return 'let ' . dest . ' = ' . string(pattern)
endfunction

function! s:get_re(...)
  let re = vrs#get(input('Pattern name: ', '',
        \             'customlist,'.s:SID().'get_names'))
  if empty(re)
    return ''
  endif
  if !a:0 || a:1 == 0
    return re
  elseif a:1 == 1
    return string(re)
  else
    return '"' . escape(re, '"\') . '"'
  endif
endfunction

function! s:get_names(a, c, p)
  return vrs#from_partial(a:a)
endfunction

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')
endfun

" Public Interface: {{{1

function! ExtendedRegexObject(...)
  return call('extended_regex#ExtendedRegex', a:000)
endfunction

" Commands: {{{1
" first arg is the name of the pattern, second is the destination of the
" pattern found (defaults to @/.
" TODO add completion support.
command! -nargs=+ VRS exec s:ex(<f-args>)

" Maps: {{{1

inoremap <Plug>VRSPlain  <C-R>=<SID>get_re(0)<CR>
inoremap <Plug>VRSSingle <C-R>=<SID>get_re(1)<CR>
inoremap <Plug>VRSDouble <C-R>=<SID>get_re(2)<CR>
cnoremap <Plug>VRSPlain  <C-R>=<SID>get_re(0)<CR>
cnoremap <Plug>VRSSingle <C-R>=<SID>get_re(1)<CR>
cnoremap <Plug>VRSDouble <C-R>=<SID>get_re(2)<CR>
nnoremap <Plug>VRSPlain  "=<SID>get_re(0)<CR>p
nnoremap <Plug>VRSSingle "=<SID>get_re(1)<CR>p
nnoremap <Plug>VRSDouble "=<SID>get_re(2)<CR>p
nnoremap <Plug>VRS/      /<C-R>=<SID>get_re()<CR>
nnoremap <Plug>VRS?      ?<C-R>=<SID>get_re()<CR>


if !hasmapto('<Plug>VRSPlain', 'i')
  imap <unique> <C-B>rep  <Plug>VRSPlain
endif
if !hasmapto('<Plug>VRSSingle', 'i')
  imap <unique> <C-B>re'  <Plug>VRSSingle
endif
if !hasmapto('<Plug>VRSDouble', 'i')
  imap <unique> <C-B>re"  <Plug>VRSDouble
endif
if !hasmapto('<Plug>VRSPlain', 'c')
  cmap <unique> <C-G>rep  <Plug>VRSPlain
endif
if !hasmapto('<Plug>VRSSingle', 'c')
  cmap <unique> <C-G>re'  <Plug>VRSSingle
endif
if !hasmapto('<Plug>VRSDouble', 'c')
  cmap <unique> <C-G>re"  <Plug>VRSDouble
endif
if !hasmapto('<Plug>VRSPlain', 'n')
  nmap <unique> <Leader>rep  <Plug>VRSPlain
endif
if !hasmapto('<Plug>VRSSingle', 'n')
  nmap <unique> <Leader>re'  <Plug>VRSSingle
endif
if !hasmapto('<Plug>VRSDouble', 'n')
  nmap <unique> <Leader>re"  <Plug>VRSDouble
endif
if !hasmapto('<Plug>VRS/', 'n')
  nmap <unique> <Leader>re/  <Plug>VRS/
endif
if !hasmapto('<Plug>VRS?', 'n')
  nmap <unique> <Leader>re?  <Plug>VRS?
endif

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
