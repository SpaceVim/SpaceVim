"=============================================================================
" FILE: helpers.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! neosnippet#helpers#get_cursor_snippet(snippets, cur_text) abort
  let cur_word = matchstr(a:cur_text, '\S\+$')
  if cur_word !=# '' && has_key(a:snippets, cur_word)
      return cur_word
  endif

  while cur_word !=# ''
    if has_key(a:snippets, cur_word) &&
          \ a:snippets[cur_word].options.word
      return cur_word
    endif

    let cur_word = substitute(cur_word, '^\%(\w\+\|\W\)', '', '')
  endwhile

  return cur_word
endfunction

function! neosnippet#helpers#get_snippets(...) abort
  let mode = get(a:000, 0, mode())

  call neosnippet#init#check()

  let neosnippet = neosnippet#variables#current_neosnippet()
  let snippets = copy(neosnippet.snippets)
  for filetype in s:get_sources_filetypes(neosnippet#helpers#get_filetype())
    call neosnippet#commands#_make_cache(filetype)
    call extend(snippets, neosnippet#variables#snippets()[filetype])
  endfor

  let cur_text = neosnippet#util#get_cur_text()

  if mode ==# 'i' || mode ==# 's'
    " Special filters.
    if !s:is_beginning_of_line(cur_text)
      call filter(snippets, '!v:val.options.head')
    endif
  endif

  call filter(snippets, "cur_text =~# get(v:val, 'regexp', '')")

  if exists('b:neosnippet_disable_snippet_triggers')
    call filter(snippets,
          \ 'index(b:neosnippet_disable_snippet_triggers, v:val.word) < 0')
  endif

  return snippets
endfunction
function! neosnippet#helpers#get_completion_snippets() abort
  return filter(neosnippet#helpers#get_snippets(),
        \ "!get(v:val.options, 'oneshot', 0)")
endfunction

function! neosnippet#helpers#get_snippets_directory(...) abort
  let filetype = get(a:000, 0, neosnippet#helpers#get_filetype())
  let snippets_dir = []
  if !get(g:neosnippet#disable_runtime_snippets, filetype,
        \ get(g:neosnippet#disable_runtime_snippets, '_', 0))
    let snippets_dir += neosnippet#variables#runtime_dir()
  endif
  let snippets_dir += copy(neosnippet#variables#snippets_dir())

  return snippets_dir
endfunction

function! neosnippet#helpers#get_filetype() abort
  " context_filetype.vim installation check.
  if !exists('s:exists_context_filetype')
    silent! call context_filetype#version()
    let s:exists_context_filetype = exists('*context_filetype#version')
  endif

  let context_filetype =
        \ s:exists_context_filetype ?
        \ context_filetype#get_filetype() : &filetype
  if context_filetype ==# ''
    let context_filetype = 'nothing'
  endif

  return context_filetype
endfunction

function! neosnippet#helpers#get_selected_text(type, ...) abort
  let sel_save = &selection
  let &selection = 'inclusive'
  let reg_save = @@
  let pos = getpos('.')

  try
    " Invoked from Visual mode, use '< and '> marks.
    if a:0
      silent exe 'normal! `<' . a:type . '`>y'
    elseif a:type ==# 'line'
      silent exe "normal! '[V']y"
    elseif a:type ==# 'block'
      silent exe 'normal! `[\<C-v>`]y'
    else
      silent exe 'normal! `[v`]y'
    endif

    return @@
  finally
    let &selection = sel_save
    let @@ = reg_save
    call setpos('.', pos)
  endtry
endfunction
function! neosnippet#helpers#delete_selected_text(type, ...) abort
  let sel_save = &selection
  let &selection = 'inclusive'
  let reg_save = @@
  let pos = getpos('.')

  try
    " Invoked from Visual mode, use '< and '> marks.
    if a:0
      silent exe 'normal! `<' . a:type . '`>d'
    elseif a:type ==# 'V'
      silent exe 'normal! `[V`]s'
    elseif a:type ==# "\<C-v>"
      silent exe 'normal! `[\<C-v>`]d'
    else
      silent exe 'normal! `[v`]d'
    endif
  finally
    let &selection = sel_save
    let @@ = reg_save
    call setpos('.', pos)
  endtry
endfunction
function! neosnippet#helpers#substitute_selected_text(type, text) abort
  let sel_save = &selection
  let &selection = 'inclusive'
  let reg_save = @@
  let pos = getpos('.')

  try
    " Invoked from Visual mode, use '< and '> marks.
    if a:0
      silent exe 'normal! `<' . a:type . '`>s' . a:text
    elseif a:type ==# 'V'
      silent exe "normal! '[V']hs" . a:text
    elseif a:type ==# "\<C-v>"
      silent exe "normal! `[\<C-v>`]s" . a:text
    else
      silent exe 'normal! `[v`]s' . a:text
    endif
  finally
    let &selection = sel_save
    let @@ = reg_save
    call setpos('.', pos)
  endtry
endfunction

function! neosnippet#helpers#vim2json(expr) abort
  return has('patch-7.4.1498') ? json_encode(a:expr) : string(a:expr)
endfunction
function! neosnippet#helpers#json2vim(expr) abort
  sandbox return has('patch-7.4.1498') ? json_decode(a:expr) : eval(a:expr)
endfunction

function! s:is_beginning_of_line(cur_text) abort
  let keyword_pattern = '\S\+'
  let cur_keyword_str = matchstr(a:cur_text, keyword_pattern.'$')
  let line_part = a:cur_text[: -1-len(cur_keyword_str)]
  let prev_word_end = matchend(line_part, keyword_pattern)

  return prev_word_end <= 0
endfunction

function! s:get_sources_filetypes(filetype) abort
  let filetypes =
        \ exists('*context_filetype#get_filetypes') ?
        \   context_filetype#get_filetypes(a:filetype) :
        \ split(((a:filetype ==# '') ? 'nothing' : a:filetype), '\.')
  return neosnippet#util#uniq(['_'] + filetypes + [a:filetype])
endfunction

function! s:get_list() abort
  if !exists('s:List')
    let s:List = vital#of('neosnippet').import('Data.List')
  endif
  return s:List
endfunction

function! neosnippet#helpers#get_snippets_files(filetype) abort
  let snippets_files = []
  for path in neosnippet#helpers#get_snippets_directory()
    for glob in s:get_list().flatten(
          \ map(split(get(g:neosnippet#scope_aliases,
          \   a:filetype, a:filetype), '\s*,\s*'), "
          \   [v:val.'.snip', v:val.'.snippets',
          \    v:val.'/**/*.snip', v:val.'/**/*.snippets']
          \ + (a:filetype !=# '_' &&
          \    !has_key(g:neosnippet#scope_aliases, a:filetype) ?
          \    [v:val . '_*.snip', v:val . '_*.snippets'] : [])"))
      let snippets_files += split(globpath(path, glob), '\n')
    endfor
  endfor
  return s:get_list().uniq(snippets_files)
endfunction
function! neosnippet#helpers#get_snippet_files(filetype) abort
  let path = join(neosnippet#helpers#get_snippets_directory(), ',')
  let snippet_files = []
  for glob in s:get_list().flatten(
        \ map(split(get(g:neosnippet#scope_aliases,
        \   a:filetype, a:filetype), '\s*,\s*'), "
        \   [v:val.'/*.snippet']"))
    let snippet_files += split(globpath(path, glob), '\n')
  endfor
  return s:get_list().uniq(snippet_files)
endfunction
