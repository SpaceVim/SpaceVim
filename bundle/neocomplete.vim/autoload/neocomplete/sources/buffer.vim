"=============================================================================
" FILE: buffer.vim
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
let g:neocomplete#sources#buffer#cache_limit_size =
      \ get(g:, 'neocomplete#sources#buffer#cache_limit_size', 500000)
let g:neocomplete#sources#buffer#disabled_pattern =
      \ get(g:, 'neocomplete#sources#buffer#disabled_pattern', '')
let g:neocomplete#sources#buffer#max_keyword_width =
      \ get(g:, 'neocomplete#sources#buffer#max_keyword_width', 80)
"}}}

" Important variables.
if !exists('s:buffer_sources')
  let s:buffer_sources = {}
  let s:async_dictionary_list = {}
endif

let s:source = {
      \ 'name' : 'buffer',
      \ 'kind' : 'manual',
      \ 'mark' : '[B]',
      \ 'rank' : 5,
      \ 'min_pattern_length' :
      \     g:neocomplete#auto_completion_start_length,
      \ 'hooks' : {},
      \ 'is_volatile' : 1,
      \}

function! s:source.hooks.on_init(context) abort "{{{
  let s:buffer_sources = {}

  augroup neocomplete "{{{
    autocmd BufEnter,BufRead,BufWinEnter,BufWritePost *
          \ call s:check_source()
    autocmd InsertEnter,InsertLeave *
          \ call neocomplete#sources#buffer#make_cache_current_line()
    autocmd VimLeavePre * call s:clean()
  augroup END"}}}

  " Create cache directory.
  call neocomplete#cache#make_directory('buffer_cache')
  call neocomplete#cache#make_directory('buffer_temp')

  " Initialize script variables. "{{{
  let s:buffer_sources = {}
  let s:async_dictionary_list = {}
  "}}}

  call s:make_cache_buffer(bufnr('%'))
  call s:check_source()
endfunction
"}}}

function! s:source.hooks.on_final(context) abort "{{{
  silent! delcommand NeoCompleteBufferMakeCache

  let s:buffer_sources = {}
endfunction"}}}

function! s:source.hooks.on_post_filter(context) abort "{{{
  " Filters too long word.
  call filter(a:context.candidates,
        \ 'len(v:val.word) < g:neocomplete#sources#buffer#max_keyword_width')
endfunction"}}}

function! s:source.gather_candidates(context) abort "{{{
  call s:check_async_cache(a:context)

  let keyword_list = []
  for source in s:get_sources_list(a:context)
    let keyword_list += source.words
  endfor
  return keyword_list
endfunction"}}}

function! neocomplete#sources#buffer#define() abort "{{{
  return s:source
endfunction"}}}

function! neocomplete#sources#buffer#get_frequencies() abort "{{{
  return get(get(s:buffer_sources, bufnr('%'), {}), 'frequencies', {})
endfunction"}}}

function! neocomplete#sources#buffer#make_cache_current_line() abort "{{{
  if neocomplete#is_locked()
    return
  endif

  " let start = reltime()
  call s:make_cache_current_buffer(
        \ max([1, line('.') - winline()]),
        \ min([line('$'), line('.') + winheight(0) - winline()]))
  " echomsg reltimestr(reltime(start))
endfunction"}}}

function! s:should_create_cache(bufnr) " {{{
  let filepath = fnamemodify(bufname(a:bufnr), ':p')
  return getfsize(filepath) < g:neocomplete#sources#buffer#cache_limit_size
        \ && getbufvar(a:bufnr, '&modifiable')
        \ && !getwinvar(bufwinnr(a:bufnr), '&previewwindow')
        \ && (g:neocomplete#sources#buffer#disabled_pattern == ''
        \  || filepath !~# g:neocomplete#sources#buffer#disabled_pattern)
endfunction"}}}

function! s:get_sources_list(context) abort "{{{
  let filetypes_dict = {}
  for filetype in a:context.filetypes
    let filetypes_dict[filetype] = 1
  endfor

  return values(filter(copy(s:buffer_sources),
        \ "has_key(filetypes_dict, v:val.filetype)
        \ || has_key(filetypes_dict, '_')
        \ || bufnr('%') == v:key
        \ || (bufname('%') ==# '[Command Line]' && bufwinnr('#') == v:key)"))
endfunction"}}}

function! s:initialize_source(srcname) abort "{{{
  let path = fnamemodify(bufname(a:srcname), ':p')
  let filename = fnamemodify(path, ':t')
  if filename == ''
    let filename = '[No Name]'
    let path .= '/[No Name]'
  endif

  let ft = getbufvar(a:srcname, '&filetype')
  if ft == ''
    let ft = 'nothing'
  endif

  let keyword_pattern = neocomplete#get_keyword_pattern(ft, s:source.name)

  let s:buffer_sources[a:srcname] = {
        \ 'words' : [],
        \ 'frequencies' : {},
        \ 'name' : filename, 'filetype' : ft,
        \ 'keyword_pattern' : keyword_pattern,
        \ 'cached_time' : 0,
        \ 'path' : path,
        \ 'cache_name' : neocomplete#cache#encode_name('buffer_cache', path),
        \}
endfunction"}}}

function! s:make_cache_file(srcname) abort "{{{
  " Initialize source.
  if !has_key(s:buffer_sources, a:srcname)
    call s:initialize_source(a:srcname)
  endif

  let source = s:buffer_sources[a:srcname]

  if !filereadable(source.path)
        \ || getbufvar(a:srcname, '&modified')
        \ || getbufvar(a:srcname, '&buftype') =~ 'nofile\|acwrite'
    call s:make_cache_buffer(a:srcname)
    return
  endif

  call neocomplete#print_debug('make_cache_buffer: ' . source.path)

  let source.cache_name =
        \ neocomplete#cache#async_load_from_file(
        \     'buffer_cache', source.path,
        \     source.keyword_pattern, 'B')
  let source.cached_time = localtime()
  let source.filetype = getbufvar(a:srcname, '&filetype')
  let s:async_dictionary_list[source.path] = [{
        \ 'filename' : source.path,
        \ 'cachename' : source.cache_name,
        \ }]
endfunction"}}}

function! s:make_cache_buffer(srcname) abort "{{{
  if !s:should_create_cache(a:srcname)
    return
  endif

  call neocomplete#print_debug('make_cache_buffer: ' . a:srcname)

  if !s:exists_current_source()
    call s:initialize_source(a:srcname)

    if a:srcname ==# bufnr('%')
      " Force sync cache
      call s:make_cache_current_buffer(1, 1000)
      return
    endif
  endif

  let source = s:buffer_sources[a:srcname]
  let temp = neocomplete#cache#getfilename(
        \ 'buffer_temp', getpid() . '_' . a:srcname)
  let lines = getbufline(a:srcname, 1, '$')
  call writefile(lines, temp)

  " Create temporary file
  let source.cache_name =
        \ neocomplete#cache#async_load_from_file(
        \     'buffer_cache', temp,
        \     source.keyword_pattern, 'B')
  let source.cached_time = localtime()
  let source.filetype = getbufvar(a:srcname, '&filetype')
  if source.filetype == ''
    let source.filetype = 'nothing'
  endif
  let s:async_dictionary_list[source.path] = [{
        \ 'filename' : temp,
        \ 'cachename' : source.cache_name,
        \ }]
endfunction"}}}

function! s:check_changed_buffer(bufnr) abort "{{{
  let source = s:buffer_sources[a:bufnr]

  let ft = getbufvar(a:bufnr, '&filetype')
  if ft == ''
    let ft = 'nothing'
  endif

  let filename = fnamemodify(bufname(a:bufnr), ':t')
  if filename == ''
    let filename = '[No Name]'
  endif

  return source.name != filename || source.filetype != ft
endfunction"}}}

function! s:check_source() abort "{{{
  " Check new buffer.
  call map(filter(range(1, bufnr('$')), "
        \ (v:val != bufnr('%') || neocomplete#has_vimproc())
        \ && (!has_key(s:buffer_sources, v:val) && buflisted(v:val)
        \   || (has_key(s:buffer_sources, v:val) &&
        \     s:buffer_sources[v:val].cached_time
        \         < getftime(s:buffer_sources[v:val].path)))
        \ && (!neocomplete#is_locked(v:val) ||
        \    g:neocomplete#disable_auto_complete)
        \ && s:should_create_cache(v:val)
        \ "), 's:make_cache_file(v:val)')

  " Remove unlisted buffers.
  call filter(s:buffer_sources,
        \ "v:key == bufnr('%') || buflisted(str2nr(v:key))")
endfunction"}}}

function! s:exists_current_source() abort "{{{
  return has_key(s:buffer_sources, bufnr('%')) &&
        \ !s:check_changed_buffer(bufnr('%'))
endfunction"}}}

function! s:make_cache_current_buffer(start, end) abort "{{{
  let srcname = bufnr('%')

  " Make cache from current buffer.
  if !s:should_create_cache(srcname)
    return
  endif

  if !s:exists_current_source()
    call s:initialize_source(srcname)
  endif

  let source = s:buffer_sources[srcname]
  let keyword_pattern = source.keyword_pattern
  if keyword_pattern == ''
    return
  endif

  let words = []

  lua << EOF
do
  local words = vim.eval('words')
  local dup = {}
  local min_length = vim.eval('g:neocomplete#min_keyword_length')
  for linenr = vim.eval('a:start'), vim.eval('a:end') do
    local match = 0
    while 1 do
      local match_str = vim.eval('matchstr(getline('..linenr..
      '), keyword_pattern, ' .. match .. ')')
      if match_str == '' then
        break
      end
      if dup[match_str] == nil
        and string.len(match_str) >= min_length then
        dup[match_str] = 1
        words:add(match_str)
      end

      -- Next match.
      match = vim.eval('matchend(getline(' .. linenr ..
        '), keyword_pattern, ' .. match .. ')')
    end
  end
end
EOF

  let source.words = neocomplete#util#uniq(source.words + words)
endfunction"}}}

function! s:check_async_cache(context) abort "{{{
  for source in s:get_sources_list(a:context)
    if !has_key(s:async_dictionary_list, source.path)
      continue
    endif

    " Load from cache.
    let [loaded, file_cache] = neocomplete#cache#get_cache_list(
          \ 'buffer_cache', s:async_dictionary_list[source.path])
    if loaded
      let source.words = file_cache
    endif

    if empty(s:async_dictionary_list[source.path])
      call remove(s:async_dictionary_list, source.path)
    endif
  endfor
endfunction"}}}

function! s:clean() abort "{{{
  " Remove temporary files
  for file in glob(printf('%s/%d_*',
        \ neocomplete#get_data_directory() . '/buffer_temp',
        \ getpid()), 1, 1)
    call delete(file)

    let cachefile = neocomplete#get_data_directory() . '/buffer_cache/'
          \ . substitute(substitute(file, ':', '=-', 'g'), '[/\\]', '=+', 'g')
    if filereadable(cachefile)
      call delete(cachefile)
    endif
  endfor
endfunction"}}}

" Command functions. "{{{
function! neocomplete#sources#buffer#make_cache(name) abort "{{{
  if !neocomplete#is_enabled()
    call neocomplete#initialize()
  endif

  if a:name == ''
    let number = bufnr('%')
  else
    let number = bufnr(a:name)

    if number < 0
      let bufnr = bufnr('%')

      " No swap warning.
      let save_shm = &shortmess
      set shortmess+=A

      " Open new buffer.
      execute 'silent! edit' fnameescape(a:name)

      let &shortmess = save_shm

      if bufnr('%') != bufnr
        setlocal nobuflisted
        execute 'buffer' bufnr
      endif
    endif

    let number = bufnr(a:name)
  endif

  call s:make_cache_file(number)
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
