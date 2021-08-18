"=============================================================================
" FILE: omni.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Global options definition. "{{{
let g:neocomplete#sources#omni#functions =
      \ get(g:, 'neocomplete#sources#omni#functions', {})
let g:neocomplete#sources#omni#input_patterns =
      \ get(g:, 'neocomplete#sources#omni#input_patterns', {})
"}}}

let s:source = {
      \ 'name' : 'omni',
      \ 'kind' : 'manual',
      \ 'mark' : '[O]',
      \ 'rank' : 50,
      \ 'min_pattern_length' : 0,
      \ 'hooks' : {},
      \}

let s:List = neocomplete#util#get_vital().import('Data.List')

function! s:source.hooks.on_init(context) abort "{{{
  " Initialize omni completion pattern. "{{{
  call neocomplete#util#set_default_dictionary(
        \'g:neocomplete#sources#omni#input_patterns',
        \'html,xhtml,xml,markdown,mkd',
        \'<\|\s[[:alnum:]-]*')
  call neocomplete#util#set_default_dictionary(
        \'g:neocomplete#sources#omni#input_patterns',
        \'css,scss,sass',
        \'\w\{' . g:neocomplete#min_keyword_length . '\}\|\w\+[):;]\s*\w*\|[@!]')
  call neocomplete#util#set_default_dictionary(
        \'g:neocomplete#sources#omni#input_patterns',
        \'javascript',
        \'[^. \t]\.\%(\h\w*\)\?')
  call neocomplete#util#set_default_dictionary(
        \'g:neocomplete#sources#omni#input_patterns',
        \'actionscript',
        \'[^. \t][.:]\h\w*')
  "call neocomplete#util#set_default_dictionary(
        "\'g:neocomplete#sources#omni#input_patterns',
        "\'php',
        "\'[^. \t]->\h\w*\|\h\w*::\w*')
  call neocomplete#util#set_default_dictionary(
        \'g:neocomplete#sources#omni#input_patterns',
        \'java',
        \'\%(\h\w*\|)\)\.\w*')
  "call neocomplete#util#set_default_dictionary(
        "\'g:neocomplete#sources#omni#input_patterns',
        "\'perl',
        "\'\h\w*->\h\w*\|\h\w*::\w*')
  "call neocomplete#util#set_default_dictionary(
        "\'g:neocomplete#sources#omni#input_patterns',
        "\'c',
        "\'[^.[:digit:] *\t]\%(\.\|->\)\w*'
  "call neocomplete#util#set_default_dictionary(
        "\'g:neocomplete#sources#omni#input_patterns',
        "\'cpp',
        "\'[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*')
  call neocomplete#util#set_default_dictionary(
        \'g:neocomplete#sources#omni#input_patterns',
        \'objc',
        \'[^.[:digit:] *\t]\%(\.\|->\)\w*')
  call neocomplete#util#set_default_dictionary(
        \'g:neocomplete#sources#omni#input_patterns',
        \'objj',
        \'[\[ \.]\w\+$\|:\w*$')
  call neocomplete#util#set_default_dictionary(
        \'g:neocomplete#sources#omni#input_patterns',
        \'go',
        \'[^.[:digit:] *\t]\.\w*')
  call neocomplete#util#set_default_dictionary(
        \'g:neocomplete#sources#omni#input_patterns',
        \'clojure',
        \'\%(([^)]\+\)\|\*[[:alnum:]_-]\+')
  call neocomplete#util#set_default_dictionary(
        \'g:neocomplete#sources#omni#input_patterns',
        \'rust',
        \'[^.[:digit:] *\t]\%(\.\|\::\)\%(\h\w*\)\?')

  " External language interface check.
  if has('ruby')
    " call neocomplete#util#set_default_dictionary(
          "\'g:neocomplete#sources#omni#input_patterns', 'ruby',
          "\'[^. *\t]\.\h\w*\|\h\w*::\w*')
  endif
  if has('python') || has('python3')
    call neocomplete#util#set_default_dictionary(
          \'g:neocomplete#sources#omni#input_patterns',
          \'python', '[^. \t]\.\w*')
  endif
  "}}}
endfunction"}}}

function! s:source.get_complete_position(context) abort "{{{
  let a:context.source__complete_results =
        \ s:set_complete_results_pos(
        \   s:get_omni_funcs(a:context.filetype), a:context.input)

  return s:get_complete_pos(a:context.source__complete_results)
endfunction"}}}

function! s:source.gather_candidates(context) abort "{{{
  return s:get_candidates(
        \ s:set_complete_results_words(
        \  a:context.source__complete_results),
        \  a:context.complete_pos, a:context.complete_str)
endfunction"}}}

function! neocomplete#sources#omni#define() abort "{{{
  return s:source
endfunction"}}}

function! s:get_omni_funcs(filetype) abort "{{{
  let funcs = []
  for ft in insert(split(a:filetype, '\.'), '_')
    let omnifuncs = neocomplete#util#convert2list(
          \ get(g:neocomplete#sources#omni#functions, ft, &l:omnifunc))

    for omnifunc in omnifuncs
      if neocomplete#helper#check_invalid_omnifunc(omnifunc)
        " omnifunc is irregal.
        continue
      endif

      if get(g:neocomplete#sources#omni#input_patterns, omnifunc, '') != ''
        let pattern = g:neocomplete#sources#omni#input_patterns[omnifunc]
      elseif get(g:neocomplete#sources#omni#input_patterns, ft, '') != ''
        let pattern = g:neocomplete#sources#omni#input_patterns[ft]
      else
        let pattern = ''
      endif

      if pattern == ''
        continue
      endif

      call add(funcs, [omnifunc, pattern])
    endfor
  endfor

  return s:List.uniq(funcs)
endfunction"}}}
function! s:get_omni_list(list) abort "{{{
  let omni_list = []

  " Convert string list.
  for val in deepcopy(a:list)
    let dict = (type(val) == type('') ?
          \ { 'word' : val } : val)
    call add(omni_list, dict)

    unlet val
  endfor

  return omni_list
endfunction"}}}

function! s:set_complete_results_pos(funcs, cur_text) abort "{{{
  " Try omnifunc completion. "{{{
  let complete_results = {}
  for [omnifunc, pattern] in a:funcs
    if neocomplete#is_auto_complete()
          \ && (pattern == ''
          \     || a:cur_text !~# '\%(' . pattern . '\m\)$')
      continue
    endif

    " Save pos.
    let pos = getpos('.')

    try
      let complete_pos = call(omnifunc, [1, ''])
    catch
      call neocomplete#print_error(
            \ 'Error occurred calling omnifunction: ' . omnifunc)
      call neocomplete#print_error(v:throwpoint)
      call neocomplete#print_error(v:exception)
      let complete_pos = -1
    finally
      if getpos('.') != pos
        call setpos('.', pos)
      endif
    endtry

    if complete_pos < 0
      continue
    endif

    let complete_str = a:cur_text[complete_pos :]

    let complete_results[omnifunc] = {
          \ 'candidates' : [],
          \ 'complete_pos' : complete_pos,
          \ 'complete_str' : complete_str,
          \ 'omnifunc' : omnifunc,
          \}
  endfor
  "}}}

  return complete_results
endfunction"}}}
function! s:set_complete_results_words(complete_results) abort "{{{
  " Try source completion.
  for [omnifunc, result] in items(a:complete_results)
    if neocomplete#complete_check()
      return a:complete_results
    endif

    let pos = getpos('.')

    try
      let ret = call(omnifunc, [0, result.complete_str])
      let list = type(ret) == type({}) ? ret.words :
            \ type(ret) == type([]) ? ret : []
    catch
      call neocomplete#print_error(
            \ 'Error occurred calling omnifunction: ' . omnifunc)
      call neocomplete#print_error(v:throwpoint)
      call neocomplete#print_error(v:exception)
      let list = []
    finally
      call setpos('.', pos)
    endtry

    let list = s:get_omni_list(list)

    let result.candidates = list
  endfor

  return a:complete_results
endfunction"}}}
function! s:get_complete_pos(complete_results) abort "{{{
  if empty(a:complete_results)
    return -1
  endif

  let complete_pos = col('.')
  for result in values(a:complete_results)
    if complete_pos > result.complete_pos
      let complete_pos = result.complete_pos
    endif
  endfor

  return complete_pos
endfunction"}}}
function! s:get_candidates(complete_results, complete_pos, complete_str) abort "{{{
  " Append prefix.
  let candidates = []
  for result in values(a:complete_results)
    if result.complete_pos > a:complete_pos
      let prefix = a:complete_str[: result.complete_pos
            \                            - a:complete_pos - 1]

      for keyword in result.candidates
        let keyword.word = prefix . keyword.word
      endfor
    endif

    let candidates += result.candidates
  endfor

  return candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
