" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#openbrowser#new()
let s:OpenBrowser = s:V.import('OpenBrowser').new(
\ s:V.import('OpenBrowser.Config').new_user_var_source('openbrowser_')
\)
unlet s:V


function! openbrowser#load() abort
  " dummy function to load this file.
endfunction

function! openbrowser#open(...) abort
  return call(s:OpenBrowser.open, a:000, s:OpenBrowser)
endfunction

function! openbrowser#search(...) abort
  return call(s:OpenBrowser.search, a:000, s:OpenBrowser)
endfunction

function! openbrowser#smart_search(...) abort
  return call(s:OpenBrowser.smart_search, a:000, s:OpenBrowser)
endfunction

" :OpenBrowser
function! openbrowser#_cmd_open(...) abort
  return call(s:OpenBrowser.cmd_open, a:000, s:OpenBrowser)
endfunction

" :OpenBrowserSearch
function! openbrowser#_cmd_search(...) abort
  return call(s:OpenBrowser.cmd_search, a:000, s:OpenBrowser)
endfunction

" :OpenBrowserSmartSearch
function! openbrowser#_cmd_smart_search(...) abort
  return call(s:OpenBrowser.cmd_smart_search, a:000, s:OpenBrowser)
endfunction

" Completions for:
" * :OpenBrowserSearch
" * :OpenBrowserSmartSearch
function! openbrowser#_cmd_search_complete(...) abort
  return call(s:OpenBrowser.cmd_search_complete, a:000, s:OpenBrowser)
endfunction

" <Plug>(openbrowser-open)
function! openbrowser#_keymap_open(...) abort
  return call(s:OpenBrowser.keymap_open, a:000, s:OpenBrowser)
endfunction

" <Plug>(openbrowser-search)
function! openbrowser#_keymap_search(...) abort
  return call(s:OpenBrowser.keymap_search, a:000, s:OpenBrowser)
endfunction

" <Plug>(openbrowser-smart-search)
function! openbrowser#_keymap_smart_search(...) abort
  return call(s:OpenBrowser.keymap_smart_search, a:000, s:OpenBrowser)
endfunction


let &cpo = s:save_cpo
