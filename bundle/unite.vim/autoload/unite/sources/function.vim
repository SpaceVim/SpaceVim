"=============================================================================
" FILE: function.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#function#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'function',
      \ 'description' : 'candidates from functions',
      \ 'default_action' : 'call',
      \ 'max_candidates' : 200,
      \ 'action_table' : {},
      \ 'matchers' : 'matcher_regexp',
      \ }

let s:cached_result = []
function! s:source.gather_candidates(args, context) abort "{{{
  if a:context.is_redraw || empty(s:cached_result)
    let s:cached_result = s:make_cache_functions()
  endif

  " Get command list.
  let cmd = unite#util#redir('function')

  let result = []
  for line in split(cmd, '\n')[1:]
    let line = line[9:]
    if line =~ '^<SNR>'
      continue
    endif
    let word = matchstr(line, '\h[[:alnum:]_:#.]*\ze()\?')
    if word == ''
      continue
    endif

    let dict = {
          \ 'word' : word  . '(',
          \ 'abbr' : line,
          \ 'action__description' : line,
          \ 'action__function' : word,
          \ 'action__text' : word . '(',
          \ }
    let dict.action__description = dict.abbr

    call add(result, dict)
  endfor

  return unite#util#sort_by(
        \ s:cached_result + result, 'tolower(v:val.word)')
endfunction"}}}

function! s:make_cache_functions() abort "{{{
  let helpfile = expand(findfile('doc/eval.txt', &runtimepath))
  if !filereadable(helpfile)
    return []
  endif

  let lines = readfile(helpfile)
  let functions = []
  let start = match(lines, '^abs')
  let end = match(lines, '^abs', start, 2)
  for i in range(end-1, start, -1)
    let func = matchstr(lines[i], '^\s*\zs\w\+(.\{-})')
    if func != ''
      let word = substitute(func, '(.\+)', '', '')
      call insert(functions, {
            \ 'word' : word . '(',
            \ 'abbr' : lines[i],
            \ 'action__description' : lines[i],
            \ 'action__function' : word,
            \ 'action__text' : word . '(',
            \ })
    endif
  endfor

  return functions
endfunction"}}}

" Actions "{{{
let s:source.action_table.preview = {
      \ 'description' : 'view the help documentation',
      \ 'is_quit' : 0,
      \ }
function! s:source.action_table.preview.func(candidate) abort "{{{
  let winnr = winnr()

  try
    execute 'help' a:candidate.action__function.'()'
    normal! zv
    normal! zt
    setlocal previewwindow
  catch /^Vim\%((\a\+)\)\?:E149/
    " Ignore
  endtry

  execute winnr.'wincmd w'
endfunction"}}}
let s:source.action_table.call = {
      \ 'description' : 'call the function and print result',
      \ }
function! s:source.action_table.call.func(candidate) abort "{{{
  if has_key(a:candidate, 'action__description')
    " Print description.

    " For function.
    let prototype_name = matchstr(
          \ a:candidate.action__description, '[^(]*')
    echohl Identifier | echon prototype_name | echohl None
    if prototype_name != a:candidate.action__description
      echon substitute(a:candidate.action__description[
            \ len(prototype_name) :], '^\s\+', ' ', '')
    endif
  endif

  let args = unite#util#input('call ' .
        \ a:candidate.action__function.'(', '', 'expression')
  if args != '' && args =~ ')$'
    redraw
    execute 'echo' a:candidate.action__function . '(' . args
  endif
endfunction"}}}
"}}}

let s:source.action_table.edit = {
      \ 'description' : 'edit the function from the source',
      \ }
function! s:source.action_table.edit.func(candidates) abort "{{{
  let func = unite#util#redir(
        \ 'verbose function '.a:candidates.action__function)
  let path = matchstr(split(func,'\n')[1], 'Last set from \zs.*$')
  execute 'edit' fnameescape(path)
  execute search('^[ \t]*fu\%(nction\)\?[ !]*'.
        \ a:candidates.action__function)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
