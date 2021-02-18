"=============================================================================
" FILE: file.vim
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

let s:source = {
      \ 'name' : 'file',
      \ 'kind' : 'manual',
      \ 'mark' : '[F]',
      \ 'rank' : 10,
      \ 'sorters' : 'sorter_filename',
      \ 'converters' : ['converter_remove_overlap', 'converter_abbr'],
      \ 'is_volatile' : 1,
      \ 'input_pattern': '/',
      \}

function! s:source.get_complete_position(context) abort "{{{
  let filetype = a:context.filetype
  if filetype ==# 'vimshell' || filetype ==# 'unite' || filetype ==# 'int-ssh'
    return -1
  endif

  " Filename pattern.
  let pattern = neocomplete#get_keyword_pattern_end('filename', self.name)
  let [complete_pos, complete_str] =
        \ neocomplete#helper#match_word(a:context.input, pattern)

  if complete_str =~ '//' || complete_str == '/' ||
        \ (neocomplete#is_auto_complete() &&
        \     complete_str !~ '/' ||
        \     complete_str =~#
        \          '\\[^ ;*?[]"={}'']\|\.\.\+$\|/c\%[ygdrive/]$\|\${')
    " Not filename pattern.
    return -1
  endif

  if complete_str =~ '/'
    let complete_pos += strridx(complete_str, '/') + 1
  endif

  return complete_pos
endfunction"}}}

function! s:source.gather_candidates(context) abort "{{{
  let pattern = neocomplete#get_keyword_pattern_end('filename', self.name)
  let complete_str =
        \ neocomplete#helper#match_word(a:context.input, pattern)[1]
  if neocomplete#is_windows() && complete_str =~ '^[\\/]'
    return []
  endif

  let cwd = getcwd()
  try
    let buffer_dir = fnamemodify(bufname('%'), ':h')
    if isdirectory(buffer_dir)
      " cd to buffer directory.
      execute 'lcd' fnameescape(buffer_dir)
    endif

    let files = s:get_glob_files(complete_str, '')
  finally
    execute 'lcd' fnameescape(cwd)
  endtry

  return files
endfunction"}}}

let s:cached_files = {}

function! s:get_glob_files(complete_str, path) abort "{{{
  let path = ',,' . substitute(a:path, '\.\%(,\|$\)\|,,', '', 'g')

  let complete_str = neocomplete#util#substitute_path_separator(
        \ substitute(a:complete_str, '\\\(.\)', '\1', 'g'))
  let complete_str = substitute(complete_str, '[^/.]\+$', '', '')

  " Note: Support ${env}
  let complete_str = substitute(complete_str, '\${\(\w\+\)}', '$\1', 'g')

  let glob = (complete_str !~ '\*$')?
        \ complete_str . '*' : complete_str

  let ftype = getftype(glob)
  if ftype != '' && ftype !=# 'dir'
    " Note: If glob() device files, Vim may freeze!
    return []
  endif

  if a:path == ''
    let files = neocomplete#util#glob(glob)
  else
    try
      let globs = globpath(path, glob)
    catch
      return []
    endtry
    let files = split(substitute(globs, '\\', '/', 'g'), '\n')
  endif

  call filter(files, 'v:val !~ "/\\.\\.\\?$"')

  let files = map(
        \ files, "{
        \    'word' : fnamemodify(v:val, ':t'),
        \    'action__is_directory' : isdirectory(v:val),
        \    'kind' : (isdirectory(v:val) ? 'dir' : 'file'),
        \ }")

  let candidates = []
  for dict in files
    let abbr = dict.word
    if dict.action__is_directory && dict.word !~ '/$'
      let abbr .= '/'
      if g:neocomplete#enable_auto_delimiter
        let dict.word .= '/'
      endif
    endif
    let dict.abbr = abbr

    " Escape word.
    let dict.word = escape(dict.word, ' ;*?[]"={}''')

    call add(candidates, dict)
  endfor

  return candidates
endfunction"}}}

function! neocomplete#sources#file#define() abort "{{{
  return s:source
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
