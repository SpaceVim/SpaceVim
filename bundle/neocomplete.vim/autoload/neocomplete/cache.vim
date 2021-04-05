"=============================================================================
" FILE: cache.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditionneocomplete#cache#
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

let s:Cache = neocomplete#util#get_vital().import('System.Cache.Deprecated')

" Cache loader.
function! neocomplete#cache#load_from_cache(cache_dir, filename, ...) abort "{{{
  let is_string = get(a:000, 0, 0)

  try
    " Note: For neocomplete.
    let list = []

    if is_string
      lua << EOF
do
  local ret = vim.eval('list')
  local list = {}
  for line in io.lines(vim.eval(
      'neocomplete#cache#encode_name(a:cache_dir, a:filename)')) do
    list = (loadstring) and loadstring('return ' .. line)()
                        or  load('return ' .. line)()
  end

  for i = 1, #list do
    ret:add(list[i])
  end
end
EOF
    else
      let list = eval(get(neocomplete#cache#readfile(
            \ a:cache_dir, a:filename), 0, '[]'))
    endif

    if !empty(list) && is_string && type(list[0]) != type('')
      " Type check.
      throw 'Type error'
    endif

    return list
  catch
    " echomsg string(v:errmsg)
    " echomsg string(v:exception)

    " Delete old cache file.
    let cache_name =
          \ neocomplete#cache#encode_name(a:cache_dir, a:filename)
    if filereadable(cache_name)
      call delete(cache_name)
    endif

    return []
  endtry
endfunction"}}}

" New cache loader.
function! neocomplete#cache#check_cache(cache_dir, key, async_cache_dictionary, keyword_cache, is_string) abort "{{{
  if !has_key(a:async_cache_dictionary, a:key)
    return
  endif

  let cache_list = a:async_cache_dictionary[a:key]

  if !has_key(a:keyword_cache, a:key)
    let a:keyword_cache[a:key] = []
  endif
  for cache in filter(copy(cache_list), 'filereadable(v:val.cachename)')
    let a:keyword_cache[a:key] += neocomplete#cache#load_from_cache(
              \ a:cache_dir, cache.filename, a:is_string)
  endfor

  call filter(cache_list, '!filereadable(v:val.cachename)')

  if empty(cache_list)
    " Delete from dictionary.
    call remove(a:async_cache_dictionary, a:key)
    return
  endif
endfunction"}}}

" For buffer source cache loader.
function! neocomplete#cache#get_cache_list(cache_dir, async_cache_list) abort "{{{
  let cache_list = a:async_cache_list

  let loaded_keywords = []
  let loaded = 0
  for cache in filter(copy(cache_list), 'filereadable(v:val.cachename)')
    let loaded = 1
    let loaded_keywords = neocomplete#cache#load_from_cache(
              \ a:cache_dir, cache.filename, 1)
  endfor

  call filter(cache_list, '!filereadable(v:val.cachename)')

  return [loaded, loaded_keywords]
endfunction"}}}

function! neocomplete#cache#save_cache(cache_dir, filename, keyword_list) abort "{{{
  if neocomplete#util#is_sudo()
    return
  endif

  " Output cache.
  let string = substitute(substitute(substitute(
        \ string(a:keyword_list), '^[', '{', ''),
        \  ']$', '}', ''), '\\', '\\\\', 'g')
  call neocomplete#cache#writefile(
        \ a:cache_dir, a:filename, [string])
endfunction"}}}

" Cache helper.
function! neocomplete#cache#getfilename(cache_dir, filename) abort "{{{
  let cache_dir = neocomplete#get_data_directory() . '/' . a:cache_dir
  return s:Cache.getfilename(cache_dir, a:filename)
endfunction"}}}
function! neocomplete#cache#filereadable(cache_dir, filename) abort "{{{
  let cache_dir = neocomplete#get_data_directory() . '/' . a:cache_dir
  return s:Cache.filereadable(cache_dir, a:filename)
endfunction"}}}
function! neocomplete#cache#readfile(cache_dir, filename) abort "{{{
  let cache_dir = neocomplete#get_data_directory() . '/' . a:cache_dir
  return s:Cache.readfile(cache_dir, a:filename)
endfunction"}}}
function! neocomplete#cache#writefile(cache_dir, filename, list) abort "{{{
  if neocomplete#util#is_sudo()
    return
  endif

  let cache_dir = neocomplete#get_data_directory() . '/' . a:cache_dir
  return s:Cache.writefile(cache_dir, a:filename, a:list)
endfunction"}}}
function! neocomplete#cache#encode_name(cache_dir, filename) abort
  " Check cache directory.
  let cache_dir = neocomplete#get_data_directory() . '/' . a:cache_dir
  return s:Cache.getfilename(cache_dir, a:filename)
endfunction
function! neocomplete#cache#check_old_cache(cache_dir, filename) abort "{{{
  let cache_dir = neocomplete#get_data_directory() . '/' . a:cache_dir
  return  s:Cache.check_old_cache(cache_dir, a:filename)
endfunction"}}}
function! neocomplete#cache#make_directory(directory) abort "{{{
  let directory =
        \ neocomplete#get_data_directory() .'/'.a:directory
  if !isdirectory(directory)
    if neocomplete#util#is_sudo()
      call neocomplete#print_error(printf(
            \ 'Cannot create Directory "%s" in sudo session.', directory))
    else
      call mkdir(directory, 'p')
    endif
  endif
endfunction"}}}

let s:sdir = neocomplete#util#substitute_path_separator(
      \ fnamemodify(expand('<sfile>'), ':p:h'))

function! neocomplete#cache#async_load_from_file(cache_dir, filename, pattern, mark) abort "{{{
  if !neocomplete#cache#check_old_cache(a:cache_dir, a:filename)
        \ || neocomplete#util#is_sudo()
    return neocomplete#cache#encode_name(a:cache_dir, a:filename)
  endif

  let pattern_file_name =
        \ neocomplete#cache#encode_name('keyword_patterns', a:filename)
  let cache_name =
        \ neocomplete#cache#encode_name(a:cache_dir, a:filename)

  " Create pattern file.
  call neocomplete#cache#writefile(
        \ 'keyword_patterns', a:filename, [a:pattern])

  " args: funcname, outputname, filename pattern mark
  "       minlen maxlen encoding
  let fileencoding =
        \ &fileencoding == '' ? &encoding : &fileencoding
  let argv = [
        \  'load_from_file', cache_name, a:filename, pattern_file_name, a:mark,
        \  g:neocomplete#min_keyword_length, fileencoding
        \ ]
  return s:async_load(argv, a:cache_dir, a:filename)
endfunction"}}}
function! neocomplete#cache#async_load_from_tags(cache_dir, filename, filetype, pattern, mark) abort "{{{
  if !neocomplete#cache#check_old_cache(a:cache_dir, a:filename)
        \ || neocomplete#util#is_sudo()
    return neocomplete#cache#encode_name(a:cache_dir, a:filename)
  endif

  let cache_name =
        \ neocomplete#cache#encode_name(a:cache_dir, a:filename)
  let pattern_file_name =
        \ neocomplete#cache#encode_name('tags_patterns', a:filename)

  let tags_file_name = '$dummy$'

  let filter_pattern =
        \ get(g:neocomplete#tags_filter_patterns, a:filetype, '')
  call neocomplete#cache#writefile('tags_patterns', a:filename,
        \ [a:pattern, tags_file_name, filter_pattern, a:filetype])

  " args: funcname, outputname, filename
  "       pattern mark minlen encoding
  let fileencoding = &fileencoding == '' ? &encoding : &fileencoding
  let argv = [
        \  'load_from_tags', cache_name, a:filename, pattern_file_name, a:mark,
        \  g:neocomplete#min_keyword_length, fileencoding
        \ ]
  return s:async_load(argv, a:cache_dir, a:filename)
endfunction"}}}
function! s:async_load(argv, cache_dir, filename) abort "{{{
  let vim_path = s:search_vim_path()

  if vim_path == '' || !executable(vim_path)
    call neocomplete#async_cache#main(a:argv)
  else
    let args = [vim_path, '-u', 'NONE', '-i', 'NONE', '-n',
          \       '-N', '-S', s:sdir.'/async_cache.vim']
          \ + a:argv
    call vimproc#system_bg(args)
    " call vimproc#system(args)
    " call system(join(args))
  endif

  return neocomplete#cache#encode_name(a:cache_dir, a:filename)
endfunction"}}}
function! s:search_vim_path() abort "{{{
  if exists('s:vim_path')
    return s:vim_path
  endif

  if !neocomplete#has_vimproc()
    return ''
  endif

  let paths = vimproc#get_command_name(v:progname, $PATH, -1)
  if empty(paths)
    if has('gui_macvim')
      " MacVim check.
      if !executable('/Applications/MacVim.app/Contents/MacOS/Vim')
        call neocomplete#print_error(
              \ 'You installed MacVim in not default directory!'.
              \ ' You must add MacVim installed path in $PATH.')
        let g:neocomplete#use_vimproc = 0
        return ''
      endif

      let s:vim_path = '/Applications/MacVim.app/Contents/MacOS/Vim'
    else
      call neocomplete#print_error(
            \ printf('Vim path : "%s" is not found.'.
            \        ' You must add "%s" installed path in $PATH.',
            \        v:progname, v:progname))
      let g:neocomplete#use_vimproc = 0
      return ''
    endif
  else
    let base_path = neocomplete#util#substitute_path_separator(
          \ fnamemodify(paths[0], ':p:h'))

    let s:vim_path = base_path . '/vim'

    if !executable(s:vim_path) && neocomplete#util#is_mac()
      " Note: Search "Vim" instead of vim.
      let s:vim_path = base_path. '/Vim'
    endif
  endif

  return s:vim_path
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
