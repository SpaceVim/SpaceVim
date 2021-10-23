"=============================================================================
" FILE: member.vim
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
let g:neocomplete#sources#member#prefix_patterns =
      \ get(g:, 'neocomplete#sources#member#prefix_patterns', {})
let g:neocomplete#sources#member#input_patterns =
      \ get(g:, 'neocomplete#sources#member#input_patterns', {})
"}}}

" Important variables.
if !exists('s:member_sources')
  let s:member_sources = {}
endif

let s:source = {
      \ 'name' : 'member',
      \ 'kind' : 'manual',
      \ 'mark' : '[M]',
      \ 'rank' : 5,
      \ 'min_pattern_length' : 0,
      \ 'hooks' : {},
      \ 'is_volatile' : 1,
      \}

function! s:source.hooks.on_init(context) abort "{{{
  augroup neocomplete "{{{
    " Make cache events
    autocmd CursorHold * call s:make_cache_current_buffer(
          \ line('.')-10, line('.')+10)
    autocmd InsertEnter,InsertLeave *
          \ call neocomplete#sources#member#make_cache_current_line()
    autocmd FileType *
          \ call neocomplete#sources#member#remake_cache(&l:filetype)
  augroup END"}}}

  " Initialize member prefix patterns. "{{{
  call neocomplete#util#set_default_dictionary(
        \ 'g:neocomplete#sources#member#prefix_patterns',
        \ '_', '\.')
  call neocomplete#util#set_default_dictionary(
        \ 'g:neocomplete#sources#member#prefix_patterns',
        \ 'c,objc', '\.\|->')
  call neocomplete#util#set_default_dictionary(
        \ 'g:neocomplete#sources#member#prefix_patterns',
        \ 'cpp,objcpp', '\.\|->\|::')
  call neocomplete#util#set_default_dictionary(
        \ 'g:neocomplete#sources#member#prefix_patterns',
        \ 'perl,php', '->')
  call neocomplete#util#set_default_dictionary(
        \ 'g:neocomplete#sources#member#prefix_patterns',
        \ 'ruby', '\.\|::')
  call neocomplete#util#set_default_dictionary(
        \ 'g:neocomplete#sources#member#prefix_patterns',
        \ 'lua', '\.\|:')
  "}}}

  " Initialize member patterns. "{{{
  call neocomplete#util#set_default_dictionary(
        \ 'g:neocomplete#sources#member#input_patterns',
        \ '_', '\h\w*\%(()\?\|\[\h\w*\]\)\?')
  "}}}

  " Initialize script variables. "{{{
  let s:member_sources = {}
  "}}}
endfunction
"}}}

function! s:source.get_complete_position(context) abort "{{{
  " Check member prefix pattern.
  let filetype = a:context.filetype
  let prefix = get(g:neocomplete#sources#member#prefix_patterns, filetype,
        \ get(g:neocomplete#sources#member#prefix_patterns, '_', ''))
  if prefix == ''
    return -1
  endif

  let member = s:get_member_pattern(filetype)
  let complete_pos = matchend(a:context.input,
        \ member . '\m\%(' . prefix . '\m\)\ze\w*$')
  return complete_pos
endfunction"}}}

function! s:source.gather_candidates(context) abort "{{{
  " Check member prefix pattern.
  let filetype = a:context.filetype
  let prefix = get(g:neocomplete#sources#member#prefix_patterns, filetype,
        \ get(g:neocomplete#sources#member#prefix_patterns, '_', ''))
  if prefix == ''
    return []
  endif

  call neocomplete#sources#member#remake_cache(filetype)

  let var_name = matchstr(a:context.input,
        \ s:get_member_pattern(filetype) . '\m\%(' .
        \ prefix . '\m\)\ze\w*$')
  if var_name == ''
    return []
  endif

  return s:get_member_list(a:context, a:context.input, var_name)
endfunction"}}}

function! neocomplete#sources#member#define() abort "{{{
  return s:source
endfunction"}}}

function! neocomplete#sources#member#make_cache_current_line() abort "{{{
  if !neocomplete#is_enabled()
    call neocomplete#initialize()
  endif

  " Make cache from current line.
  return s:make_cache_current_buffer(line('.')-1, line('.')+1)
endfunction"}}}
function! neocomplete#sources#member#make_cache_current_buffer() abort "{{{
  if !neocomplete#is_enabled()
    call neocomplete#initialize()
  endif

  " Make cache from current buffer.
  return s:make_cache_current_buffer(1, line('$'))
endfunction"}}}
function! s:make_cache_current_buffer(start, end) abort "{{{
  let filetype = neocomplete#get_context_filetype(1)

  if !has_key(s:member_sources, bufnr('%'))
    call s:initialize_source(bufnr('%'), filetype)
  endif

  call s:make_cache_lines(bufnr('%'), filetype, getline(a:start, a:end))
endfunction"}}}
function! s:make_cache_lines(srcname, filetype, lines) abort "{{{
  let filetype = a:filetype
  if !has_key(s:member_sources, a:srcname)
    call s:initialize_source(a:srcname, filetype)
  endif

  let prefix = get(g:neocomplete#sources#member#prefix_patterns, filetype,
        \ get(g:neocomplete#sources#member#prefix_patterns, '_', ''))
  if prefix == ''
    return
  endif
  let source = s:member_sources[a:srcname]
  let member_pattern = s:get_member_pattern(filetype)
  let prefix_pattern = member_pattern . '\m\%(' . prefix . '\m\)'
  let keyword_pattern =
        \ prefix_pattern . member_pattern

  " Cache member pattern.
  for line in a:lines
    let match = match(line, keyword_pattern)

    while match >= 0 "{{{
      let match_str = matchstr(line, '^'.keyword_pattern, match)

      " Next match.
      let match = matchend(line, prefix_pattern, match)

      let member_name = matchstr(match_str, member_pattern . '$')
      if member_name == ''
        continue
      endif
      let var_name = match_str[ : -len(member_name)-1]

      if !has_key(source.member_cache, var_name)
        let source.member_cache[var_name] = {}
      endif
      if !has_key(source.member_cache[var_name], member_name)
        let source.member_cache[var_name][member_name] = 1
      endif

      let match_str = matchstr(var_name, '^'.keyword_pattern)
    endwhile"}}}
  endfor
endfunction"}}}

function! s:get_member_list(context, cur_text, var_name) abort "{{{
  let keyword_list = []
  for source in filter(s:get_sources_list(a:context),
        \ 'has_key(v:val.member_cache, a:var_name)')
    let keyword_list +=
          \ keys(source.member_cache[a:var_name])
  endfor

  return keyword_list
endfunction"}}}

function! s:get_sources_list(context) abort "{{{
  let filetypes_dict = {}
  for filetype in a:context.filetypes
    let filetypes_dict[filetype] = 1
  endfor

  return values(filter(copy(s:member_sources),
        \ "has_key(filetypes_dict, v:val.filetype)
        \ || has_key(filetypes_dict, '_')
        \ || bufnr('%') == v:key
        \ || (bufname('%') ==# '[Command Line]' && bufwinnr('#') == v:key)"))
endfunction"}}}

function! s:initialize_source(srcname, filetype) abort "{{{
  let path = (a:srcname=~ '^\d\+$') ?
        \ fnamemodify(bufname(a:srcname), ':p') : a:srcname
  let filename = fnamemodify(path, ':t')
  if filename == ''
    let filename = '[No Name]'
    let path .= '/[No Name]'
  endif

  let ft = a:filetype
  if ft == ''
    let ft = 'nothing'
  endif

  let s:member_sources[a:srcname] = {
        \ 'member_cache' : {}, 'filetype' : ft,
        \ 'time' : getftime(path),
        \ 'keyword_pattern' : neocomplete#get_keyword_pattern(ft, s:source.name),
        \}
endfunction"}}}

function! s:get_member_pattern(filetype) abort "{{{
  return get(g:neocomplete#sources#member#input_patterns, a:filetype,
        \ get(g:neocomplete#sources#member#input_patterns, '_', ''))
endfunction"}}}

function! neocomplete#sources#member#remake_cache(filetype) abort "{{{
  if !neocomplete#is_enabled()
    call neocomplete#initialize()
  endif

  if get(g:neocomplete#sources#member#prefix_patterns, a:filetype, '') == ''
    return
  endif

  for dictionary in
        \ filter(map(neocomplete#sources#dictionary#get_dictionaries(a:filetype),
        \  "neocomplete#util#substitute_path_separator(
        \      fnamemodify(v:val, ':p'))"),
        \ "filereadable(v:val) && (!has_key(s:member_sources, v:val)
        \    || getftime(v:val) > s:member_sources[v:val].time)")
    call s:make_cache_lines(dictionary, a:filetype, readfile(dictionary))
  endfor
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
