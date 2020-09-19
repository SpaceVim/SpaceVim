" Vim library for short description
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" 		Israel Chauca F. <israelchauca@gmail.com>
" Version:	0.1
" Description:	Long description.
" Last Change:	2013-02-03
" License:	Vim License (see :help license)
" Location:	autoload/vrs.vim
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
" uncomment after plugin development
" Remove the conditions you do not need, they are there just as an example.
"if exists("g:loaded_lib_vrs")
"      \ || v:version < 700
"      \ || v:version == 703 && !has('patch338')
"      \ || &compatible
"  let &cpo = s:save_cpo
"  finish
"endif
"let g:loaded_lib_vrs = 1

" Private Functions: {{{1

" Library Interface: {{{1

let s:vrs_patterns = {}
let s:erex = ExtendedRegexObject('vrs#get')
let g:vrs_collection = []
let g:vrs_collection_stack = []

function! vrs#set(name, flavour, pattern)
  if !has_key(s:vrs_patterns, a:name)
    let s:vrs_patterns[a:name] = {}
  endif
  if has_key(s:vrs_patterns[a:name], a:flavour)
    echohl ErrorMsg
    echom 'VRS: A pattern of that flavour ('.a:flavour.') already exists under "'.a:name.'".'
    echohl None
    return 0
  endif
  " let s:vrs_patterns[a:name][a:flavour] = (a:flavour == 'vim' ? s:erex.parse(a:pattern) : s:erex.parse_multiline_regex(a:pattern))
  let s:vrs_patterns[a:name][a:flavour] = (a:flavour == 'vim' ? s:erex.parse(a:pattern) : a:pattern)
  return 1
endfunction

function! vrs#get(name, ...)
  let flavor = a:0 ? a:1 : 'vim'
  " Allow using a list of names as well.
  return type(a:name) == type("")
        \ ? get(get(s:vrs_patterns, a:name, {}), flavor, '')
        \ : map(a:name, 's:vrs_patterns[v:val].' . flavor)
endfunction

function! vrs#match(string, pattern, ...)
  let args = extend([a:string, vrs#get(a:pattern)], a:000)
  return call('match', args)
endfunction

function! vrs#matchend(string, pattern, ...)
  let args = extend([a:string, vrs#get(a:pattern)], a:000)
  return call('matchend', args)
endfunction

function! vrs#matches(string, pattern, ...)
  return call('vrs#match', extend([a:string, a:pattern], a:000)) != -1
endfunction

function! vrs#exactly(string, pattern, ...)
  return (call('vrs#match', extend([a:string, a:pattern], a:000)) == 0) && (call('vrs#matchend', extend([a:string, a:pattern], a:000)) == (len(a:string)))
endfunction

" XXX Should these two return the filtered dict or just a list of keys?
function! vrs#from_partial(partial)
  return keys(filter(copy(s:vrs_patterns), 'stridx(v:key, a:partial) > -1'))
endfunction

function! vrs#from_sample(sample)
  return keys(filter(copy(s:vrs_patterns), 'a:sample =~# v:val.vim'))
endfunction

" operate on each match within a string
" TODO: allow this to work over a range
"       perhaps make the default callback be a new collection
" example:  :call vrs#each(getline(1, '$'), 'ip4', 'vrs#collect')
function! vrs#each(source, pattern, callback)
  let pattern = vrs#get(a:pattern)
  let remaining = match(a:source, pattern)
  while remaining != -1
    call call(a:callback, [matchlist(a:source, vrs#get(a:pattern), remaining)])
    let remaining = match(a:source, pattern, 1 + remaining)
  endwhile
endfunction

" callback for adding to the current collection
function! vrs#collect(item)
  call add(g:vrs_collection, a:item)
endfunction

" reset the current collection
function! vrs#delete_collection()
  let g:vrs_collection = []
endfunction

" extract a common submatch from the collection (defaults to 0 - the whole match)
function! vrs#slice_collection(...)
  let submatch = a:0 ? a:1 : 0
  return map(copy(g:vrs_collection), 'v:val[' . submatch . ']')
endfunction

" dump the collection submatch (default 0) at cursor point
function! vrs#append_collection(...)
  call append('.', call('vrs#slice_collection', a:000))
endfunction

" save this collection on the stack
function! vrs#push_collection()
  call add(g:vrs_collection_stack, g:vrs_collection)
endfunction

" save this collection and clear it ready for new collection
function! vrs#new_collection()
  call vrs#push_collection()
  call vrs#delete_collection()
endfunction

" restore a saved collection
function! vrs#pop_collection()
  if len(g:vrs_collection_stack) > 0
    let g:vrs_collection = remove(g:vrs_collection_stack, 0)
  else
    let g:vrs_collection = []
  endif
endfunction

" TODO: Add commands for the collection functions to make them simpler to use

" load VRS patterns

let erex = ExtendedRegexObject('vrs#get')
for pfile in split(glob(expand('<sfile>:p:h:h') . '/patterns/*.vrs'), "\n")
  " skip syntax test file
  if fnamemodify(pfile, ':t') == 'test.vrs'
    continue
  endif
  " echo fnamemodify(pfile, ':t')
  let [name, flavour, pattern] = ['', '', '']
  for line in readfile(pfile)
    " skip blank and comment only lines
    if line =~ '^\s*\(#\|$\)'
      continue
    endif
    " name lines must be flush to first column (no leading spaces)
    if line =~ '^\S'
      " strip trailing comments
      let line = substitute(line, '\s*#.*', '', '')
      if !empty(name)
        " finalise & add prior multiline pattern
        " echo 'call vrs#set(' . name . ' ' . flavour . ' ' . erex.parse(pattern) . ')'
        call vrs#set(name, flavour, pattern)
        let [name, flavour, pattern] = ['', '', '']
      endif
      if line =~ '\s\+\S\+\s\+\S'
        let [all, name, flavour, pattern ;rest] = matchlist(line, '^\(\S\+\)\s\+\(\S\+\)\s\+\(.*\)')
        " echo 'call vrs#set(' . name . ' ' . flavour . ' ' . erex.parse(pattern) . ')'
        call vrs#set(name, flavour, pattern)
        let [name, flavour, pattern] = ['', '', '']
      else
        let [all, name, flavour ;rest] = matchlist(line, '^\s*\(\S\+\)\s\+\(\S\+\)')
        let pattern = ''
      endif
    else
      " collect multiline pattern - each line must be preceded by spaces
      let pattern .= line
    endif
  endfor
  if !empty(name)
    " echo 'call vrs#set(' . name . ' ' . flavour . ' ' . erex.parse(pattern) . ')'
    call vrs#set(name, flavour, pattern)
  endif
endfor
" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
