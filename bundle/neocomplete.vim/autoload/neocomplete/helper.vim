"=============================================================================
" FILE: helper.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
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

function! neocomplete#helper#get_cur_text(...) abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let is_skip_char = get(a:000, 0, 0)
  let mode = mode()
  if neocomplete.event ==# 'InsertEnter'
    let mode = 'i'
  endif

  let cur_text =
        \ (mode ==# 'i' ?
        \   (col('.')-1) : col('.')) >= len(getline('.')) ?
        \      getline('.') :
        \      matchstr(getline('.'),
        \         '^.*\%' . (mode ==# 'i' && !is_skip_char ?
        \                    col('.') : col('.') - 1)
        \         . 'c' . (mode ==# 'i' ? '' : '.'))

  if cur_text =~ '^.\{-}\ze\S\+$'
    let complete_str = matchstr(cur_text, '\S\+$')
    let cur_text = matchstr(cur_text, '^.\{-}\ze\S\+$')
  else
    let complete_str = ''
  endif

  if neocomplete.event ==# 'InsertCharPre'
    let complete_str .= v:char
  endif

  let neocomplete.cur_text = cur_text . complete_str

  " Save cur_text.
  return neocomplete.cur_text
endfunction"}}}

function! neocomplete#helper#get_force_omni_complete_pos(cur_text) abort "{{{
  let filetype = neocomplete#get_context_filetype()
  let omnifunc = &l:omnifunc

  if neocomplete#helper#check_invalid_omnifunc(omnifunc)
    return -1
  endif

  let pattern = ''

  if has_key(g:neocomplete#force_omni_input_patterns, omnifunc)
    let pattern = g:neocomplete#force_omni_input_patterns[omnifunc]
  elseif filetype != '' &&
        \ get(g:neocomplete#force_omni_input_patterns, filetype, '') != ''
    let pattern = g:neocomplete#force_omni_input_patterns[filetype]
  endif

  if pattern == ''
    return -1
  endif

  return match(a:cur_text, '\%(' . pattern . '\m\)$')
endfunction"}}}

function! neocomplete#helper#is_enabled_source(source, filetype) abort "{{{
  let source = type(a:source) == type('') ?
        \ get(neocomplete#variables#get_sources(), a:source, {})
        \ : a:source

  return !empty(source) && (empty(source.filetypes) ||
        \     neocomplete#helper#check_filetype(source.filetypes))
        \  && (!get(source.disabled_filetypes, '_', 0) &&
        \      !neocomplete#helper#check_filetype(source.disabled_filetypes))
endfunction"}}}

function! neocomplete#helper#get_source_filetypes(filetype) abort "{{{
  return neocomplete#context_filetype#filetypes()
endfunction"}}}

function! neocomplete#helper#complete_check() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  if g:neocomplete#enable_debug
    echomsg split(reltimestr(reltime(neocomplete.start_time)))[0]
  endif
  let ret =
        \ neocomplete#is_auto_complete()
        \     && g:neocomplete#skip_auto_completion_time != ''
        \     && split(reltimestr(reltime(neocomplete.start_time)))[0] >
        \          g:neocomplete#skip_auto_completion_time
  if ret
    let neocomplete = neocomplete#get_current_neocomplete()
    let neocomplete.skipped = 1

    call neocomplete#print_debug('Skipped.')
  endif

  return ret
endfunction"}}}

function! neocomplete#helper#get_syn_name(is_trans) abort "{{{
  return len(getline('.')) < 200 ?
        \ synIDattr(synIDtrans(synID(line('.'), mode() ==# 'i' ?
        \          col('.')-1 : col('.'), a:is_trans)), 'name') : ''
endfunction"}}}

function! neocomplete#helper#match_word(cur_text, ...) abort "{{{
  let pattern = a:0 >= 1 ? a:1 : neocomplete#get_keyword_pattern_end()

  " Check wildcard.
  let complete_pos = match(a:cur_text, pattern)

  let complete_str = (complete_pos >=0) ?
        \ a:cur_text[complete_pos :] : ''

  return [complete_pos, complete_str]
endfunction"}}}

function! neocomplete#helper#filetype_complete(arglead, cmdline, cursorpos) abort "{{{
  " Dup check.
  let ret = {}
  for item in map(
        \ split(globpath(&runtimepath, 'syntax/*.vim'), '\n') +
        \ split(globpath(&runtimepath, 'indent/*.vim'), '\n') +
        \ split(globpath(&runtimepath, 'ftplugin/*.vim'), '\n')
        \ , 'fnamemodify(v:val, ":t:r")')
    if !has_key(ret, item) && item =~ '^'.a:arglead
      let ret[item] = 1
    endif
  endfor

  return sort(keys(ret))
endfunction"}}}

function! neocomplete#helper#unite_patterns(pattern_var, filetype) abort "{{{
  let keyword_patterns = []

  lua << EOF
do
  local patterns = vim.eval('keyword_patterns')
  local filetypes = vim.eval("split(a:filetype, '\\.')")
  local pattern_var = vim.eval('a:pattern_var')

  local dup_check = {}
  for i = 0, #filetypes-1 do
    local ft = filetypes[i]

    -- Composite filetype.
    if pattern_var[ft] ~= nil and dup_check[ft] == nil then
      dup_check[ft] = 1
      patterns:add(pattern_var[ft])
    end
  end

  if #patterns == 0 then
    local default = pattern_var['_']
    if default == nil then
      default = pattern_var['default']
    end
    if default ~= nil and default ~= '' then
      patterns:add(default)
    end
  end
end
EOF

  return join(keyword_patterns, '\m\|')
endfunction"}}}

function! neocomplete#helper#check_filetype(dictionary) abort "{{{
  return !empty(filter(neocomplete#context_filetype#filetypes(),
        \ 'get(a:dictionary, v:val, 0)'))
endfunction"}}}

function! neocomplete#helper#get_sources_list(...) abort "{{{
  let filetype = neocomplete#get_context_filetype()

  let source_names = exists('b:neocomplete_sources') ?
        \ b:neocomplete_sources :
        \ get(a:000, 0,
        \   get(g:neocomplete#sources, filetype,
        \     get(g:neocomplete#sources, '_', ['_'])))
  call neocomplete#init#_sources(source_names)

  let all_sources = neocomplete#available_sources()
  let sources = {}
  for source_name in source_names
    if source_name ==# '_'
      " All sources.
      let sources = all_sources
      break
    endif

    if !has_key(all_sources, source_name)
      call neocomplete#print_warning(printf(
            \ 'Invalid source name "%s" is given.', source_name))
      continue
    endif

    let sources[source_name] = all_sources[source_name]
  endfor

  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.sources = filter(sources, "
        \   empty(v:val.filetypes) ||
        \   neocomplete#helper#check_filetype(v:val.filetypes)")
  let neocomplete.sources_filetype = neocomplete.context_filetype

  return neocomplete.sources
endfunction"}}}

function! neocomplete#helper#clear_result() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()

  let neocomplete.complete_str = ''
  let neocomplete.candidates = []
  let neocomplete.complete_sources = []
  let neocomplete.complete_pos = -1

  " Restore completeopt.
  if neocomplete.completeopt !=# &completeopt
    " Restore completeopt.
    let &completeopt = neocomplete.completeopt
  endif
endfunction"}}}

function! neocomplete#helper#call_hook(sources, hook_name, context) abort "{{{
  for source in neocomplete#util#convert2list(a:sources)
    try
      if has_key(source.hooks, a:hook_name)
        call call(source.hooks[a:hook_name],
              \ [extend(source.neocomplete__context, a:context)],
              \ source.hooks)
      endif
    catch
      call neocomplete#print_error(v:throwpoint)
      call neocomplete#print_error(v:exception)
      call neocomplete#print_error(
            \ 'Error occurred in calling hook "' . a:hook_name . '"!')
      call neocomplete#print_error(
            \ 'Source name is ' . source.name)
    endtry
  endfor
endfunction"}}}

function! neocomplete#helper#call_filters(filters, source, context) abort "{{{
  let context = extend(a:source.neocomplete__context, a:context)
  for filter in a:filters
    try
      let context.candidates = call(filter.filter, [context], filter)
    catch
      call neocomplete#print_error(v:throwpoint)
      call neocomplete#print_error(v:exception)
      call neocomplete#print_error(
            \ 'Error occurred in calling filter '
            \   . filter.name . '!')
      call neocomplete#print_error(
            \ 'Source name is ' . a:source.name)
    endtry
  endfor

  return context.candidates
endfunction"}}}

function! neocomplete#helper#sort_human(candidates) abort "{{{
  " Use lua interface.
  lua << EOF
do
  local candidates = vim.eval('a:candidates')
  local t = {}
  for i = 1, #candidates do
    t[i] = candidates[i-1]
  end
  table.sort(t, function(a, b) return a.word < b.word end)
  for i = 0, #candidates-1 do
    candidates[i] = t[i+1]
  end
end
EOF
  return a:candidates
endfunction"}}}

function! neocomplete#helper#check_invalid_omnifunc(omnifunc) abort "{{{
  return a:omnifunc == '' || (a:omnifunc !~ '#' && !exists('*' . a:omnifunc))
endfunction"}}}

function! neocomplete#helper#indent_current_line() abort "{{{
  let pos = getpos('.')
  let len = len(getline('.'))
  let equalprg = &l:equalprg
  try
    setlocal equalprg=
    silent normal! ==
  finally
    let &l:equalprg = equalprg
    let pos[2] += len(getline('.')) - len
    call setpos('.', pos)
  endtry
endfunction"}}}

function! neocomplete#helper#complete_configure() abort "{{{
  set completeopt-=menu
  set completeopt-=longest
  set completeopt+=menuone

  " Set options.
  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.completeopt = &completeopt

  if neocomplete#util#is_complete_select()
        \ && &completeopt !~# 'noinsert\|noselect'
    if g:neocomplete#enable_auto_select
      set completeopt-=noselect
      set completeopt+=noinsert
    else
      set completeopt-=noinsert
      set completeopt+=noselect
    endif
  endif
endfunction"}}}

function! neocomplete#helper#clean(directory) abort "{{{
  let directory = neocomplete#get_data_directory() .'/'.a:directory
  for file in split(glob(directory . '/*'), '\n')
    let orig = substitute(substitute(fnamemodify(file, ':t'),
        \             '=-', ':', 'g'), '=+', '/', 'g')
    if !filereadable(orig)
      call delete(file)
    endif
  endfor
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
