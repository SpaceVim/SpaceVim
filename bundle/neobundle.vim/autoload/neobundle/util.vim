"=============================================================================
" FILE: util.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
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

let s:is_windows = has('win32')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!isdirectory('/proc') && executable('sw_vers')))

function! neobundle#util#substitute_path_separator(path) abort "{{{
  return (s:is_windows && a:path =~ '\\') ?
        \ tr(a:path, '\', '/') : a:path
endfunction"}}}
function! neobundle#util#expand(path) abort "{{{
  let path = (a:path =~ '^\~') ? fnamemodify(a:path, ':p') :
        \ (a:path =~ '^\$\h\w*') ? substitute(a:path,
        \               '^\$\h\w*', '\=eval(submatch(0))', '') :
        \ a:path
  return (s:is_windows && path =~ '\\') ?
        \ neobundle#util#substitute_path_separator(path) : path
endfunction"}}}
function! neobundle#util#join_paths(path1, path2) abort "{{{
  " Joins two paths together, handling the case where the second path
  " is an absolute path.
  if s:is_absolute(a:path2)
    return a:path2
  endif
  if a:path1 =~ (s:is_windows ? '[\\/]$' : '/$') ||
        \ a:path2 =~ (s:is_windows ? '^[\\/]' : '^/')
    " the appropriate separator already exists
    return a:path1 . a:path2
  else
    " note: I'm assuming here that '/' is always valid as a directory
    " separator on Windows. I know Windows has paths that start with \\?\ that
    " diasble behavior like that, but I don't know how Vim deals with that.
    return a:path1 . '/' . a:path2
  endif
endfunction "}}}
if s:is_windows
  function! s:is_absolute(path) abort "{{{
    return a:path =~ '^[\\/]\|^\a:'
  endfunction "}}}
else
  function! s:is_absolute(path) abort "{{{
    return a:path =~ "^/"
  endfunction "}}}
endif

function! neobundle#util#is_windows() abort "{{{
  return s:is_windows
endfunction"}}}
function! neobundle#util#is_mac() abort "{{{
  return s:is_mac
endfunction"}}}
function! neobundle#util#is_cygwin() abort "{{{
  return s:is_cygwin
endfunction"}}}

" Sudo check.
function! neobundle#util#is_sudo() abort "{{{
  return $SUDO_USER != '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)
endfunction"}}}

" Check vimproc. "{{{
function! neobundle#util#has_vimproc() abort "{{{
  if !exists('*vimproc#version')
    try
      call vimproc#version()
    catch
    endtry
  endif

  return exists('*vimproc#version')
endfunction"}}}
"}}}
" iconv() wrapper for safety.
function! s:iconv(expr, from, to) abort "{{{
  if a:from == '' || a:to == '' || a:from ==? a:to
    return a:expr
  endif
  let result = iconv(a:expr, a:from, a:to)
  return result != '' ? result : a:expr
endfunction"}}}
function! neobundle#util#system(str, ...) abort "{{{
  let command = a:str
  let input = a:0 >= 1 ? a:1 : ''
  let command = s:iconv(command, &encoding, 'char')
  let input = s:iconv(input, &encoding, 'char')

  if a:0 == 0
    let output = neobundle#util#has_vimproc() ?
          \ vimproc#system(command) : system(command, "\<C-d>")
  elseif a:0 == 1
    let output = neobundle#util#has_vimproc() ?
          \ vimproc#system(command, input) : system(command, input)
  else
    " ignores 3rd argument unless you have vimproc.
    let output = neobundle#util#has_vimproc() ?
          \ vimproc#system(command, input, a:2) : system(command, input)
  endif

  let output = s:iconv(output, 'char', &encoding)

  return substitute(output, '\n$', '', '')
endfunction"}}}
function! neobundle#util#get_last_status() abort "{{{
  return neobundle#util#has_vimproc() ?
        \ vimproc#get_last_status() : v:shell_error
endfunction"}}}

" Split a comma separated string to a list.
function! neobundle#util#split_rtp(runtimepath) abort "{{{
  if stridx(a:runtimepath, '\,') < 0
    return split(a:runtimepath, ',')
  endif

  let split = split(a:runtimepath, '\\\@<!\%(\\\\\)*\zs,')
  return map(split,'substitute(v:val, ''\\\([\\,]\)'', "\\1", "g")')
endfunction"}}}

function! neobundle#util#join_rtp(list, runtimepath, rtp) abort "{{{
  return (stridx(a:runtimepath, '\,') < 0 && stridx(a:rtp, ',') < 0) ?
        \ join(a:list, ',') : join(map(copy(a:list), 's:escape(v:val)'), ',')
endfunction"}}}

function! neobundle#util#split_envpath(path) abort "{{{
  let delimiter = neobundle#util#is_windows() ? ';' : ':'
  if stridx(a:path, '\' . delimiter) < 0
    return split(a:path, delimiter)
  endif

  let split = split(a:path, '\\\@<!\%(\\\\\)*\zs' . delimiter)
  return map(split,'substitute(v:val, ''\\\([\\'
        \ . delimiter . ']\)'', "\\1", "g")')
endfunction"}}}

function! neobundle#util#join_envpath(list, orig_path, add_path) abort "{{{
  let delimiter = neobundle#util#is_windows() ? ';' : ':'
  return (stridx(a:orig_path, '\' . delimiter) < 0
        \ && stridx(a:add_path, delimiter) < 0) ?
        \   join(a:list, delimiter) :
        \   join(map(copy(a:list), 's:escape(v:val)'), delimiter)
endfunction"}}}

" Removes duplicates from a list.
function! neobundle#util#uniq(list, ...) abort "{{{
  let list = a:0 ? map(copy(a:list), printf('[v:val, %s]', a:1)) : copy(a:list)
  let i = 0
  let seen = {}
  while i < len(list)
    let key = string(a:0 ? list[i][1] : list[i])
    if has_key(seen, key)
      call remove(list, i)
    else
      let seen[key] = 1
      let i += 1
    endif
  endwhile
  return a:0 ? map(list, 'v:val[0]') : list
endfunction"}}}

function! neobundle#util#set_default(var, val, ...) abort  "{{{
  if !exists(a:var) || type({a:var}) != type(a:val)
    let alternate_var = get(a:000, 0, '')

    let {a:var} = exists(alternate_var) ?
          \ {alternate_var} : a:val
  endif
endfunction"}}}
function! neobundle#util#set_dictionary_helper(variable, keys, pattern) abort "{{{
  for key in split(a:keys, '\s*,\s*')
    if !has_key(a:variable, key)
      let a:variable[key] = a:pattern
    endif
  endfor
endfunction"}}}

function! neobundle#util#get_filetypes() abort "{{{
  let filetype = exists('b:neocomplcache.context_filetype') ?
        \ b:neocomplcache.context_filetype : &filetype
  return split(filetype, '\.')
endfunction"}}}

function! neobundle#util#convert2list(expr) abort "{{{
  return type(a:expr) ==# type([]) ? a:expr :
        \ type(a:expr) ==# type('') ?
        \   (a:expr == '' ? [] : split(a:expr, '\r\?\n', 1))
        \ : [a:expr]
endfunction"}}}

function! neobundle#util#print_error(expr) abort "{{{
  return s:echo(a:expr, 'error')
endfunction"}}}

function! neobundle#util#redraw_echo(expr) abort "{{{
  return s:echo(a:expr, 'echo')
endfunction"}}}

function! neobundle#util#redraw_echomsg(expr) abort "{{{
  return s:echo(a:expr, 'echomsg')
endfunction"}}}

function! s:echo(expr, mode) abort "{{{
  let msg = map(neobundle#util#convert2list(a:expr),
        \ "'[neobundle] ' .  v:val")
  if empty(msg)
    return
  endif

  if has('vim_starting') || a:mode ==# 'error'
    call s:echo_mode(join(msg, "\n"), a:mode)
    return
  endif

  let more_save = &more
  let showcmd_save = &showcmd
  let ruler_save = &ruler
  try
    set nomore
    set noshowcmd
    set noruler

    let height = max([1, &cmdheight])
    echo ''
    for i in range(0, len(msg)-1, height)
      redraw

      call s:echo_mode(join(msg[i : i+height-1], "\n"), a:mode)
    endfor
  finally
    let &more = more_save
    let &showcmd = showcmd_save
    let &ruler = ruler_save
  endtry
endfunction"}}}
function! s:echo_mode(m, mode) abort "{{{
  for m in split(a:m, '\r\?\n', 1)
    if !has('vim_starting') && a:mode !=# 'error'
      let m = neobundle#util#truncate_skipping(
            \ m, &columns - 1, &columns/3, '...')
    endif

    if a:mode ==# 'error'
      echohl WarningMsg | echomsg m | echohl None
    elseif a:mode ==# 'echomsg'
      echomsg m
    else
      echo m
    endif
  endfor
endfunction"}}}

function! neobundle#util#name_conversion(path) abort "{{{
  return fnamemodify(split(a:path, ':')[-1], ':s?/$??:t:s?\c\.git\s*$??')
endfunction"}}}

function! neobundle#util#vim2json(expr) abort "{{{
  return has('patch-7.4.1498') ? json_encode(a:expr) : string(a:expr)
endfunction "}}}
function! neobundle#util#json2vim(expr) abort "{{{
  sandbox return has('patch-7.4.1498') ? json_decode(a:expr) : eval(a:expr)
endfunction "}}}

" Escape a path for runtimepath.
function! s:escape(path) abort"{{{
  return substitute(a:path, ',\|\\,\@=', '\\\0', 'g')
endfunction"}}}

function! neobundle#util#unify_path(path) abort "{{{
  return fnamemodify(resolve(a:path), ':p:gs?\\\+?/?')
endfunction"}}}

function! neobundle#util#cd(path) abort "{{{
  if isdirectory(a:path)
    execute (haslocaldir() ? 'lcd' : 'cd') fnameescape(a:path)
  endif
endfunction"}}}

function! neobundle#util#writefile(path, list) abort "{{{
  let path = neobundle#get_neobundle_dir() . '/.neobundle/' . a:path
  let dir = fnamemodify(path, ':h')
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif

  return writefile(a:list, path)
endfunction"}}}

function! neobundle#util#cleandir(path) abort "{{{
  let path = neobundle#get_neobundle_dir() . '/.neobundle/' . a:path

  for file in filter(split(globpath(path, '*', 1), '\n'),
        \ '!isdirectory(v:val)')
    call delete(file)
  endfor
endfunction"}}}

function! neobundle#util#rmdir(path) abort "{{{
  if has('patch-7.4.1120')
    call delete(a:path, 'rf')
  else
    let cmdline = '"' . a:path . '"'
    if neobundle#util#is_windows()
      " Note: In rm command, must use "\" instead of "/".
      let cmdline = substitute(cmdline, '/', '\\\\', 'g')
    endif

    " Use system instead of vimproc#system()
    let result = system(g:neobundle#rm_command . ' ' . cmdline)
    if v:shell_error
      call neobundle#installer#error(result)
    endif
  endif
endfunction"}}}

function! neobundle#util#copy_bundle_files(bundles, directory) abort "{{{
  " Delete old files.
  call neobundle#util#cleandir(a:directory)

  let files = {}
  for bundle in a:bundles
    for file in filter(split(globpath(
          \ bundle.rtp, a:directory.'/**', 1), '\n'),
          \ '!isdirectory(v:val)')
      let filename = fnamemodify(file, ':t')
      let files[filename] = readfile(file)
    endfor
  endfor

  for [filename, list] in items(files)
    if filename =~# '^tags\%(-.*\)\?$'
      call sort(list)
    endif
    call neobundle#util#writefile(a:directory . '/' . filename, list)
  endfor
endfunction"}}}
function! neobundle#util#merge_bundle_files(bundles, directory) abort "{{{
  " Delete old files.
  call neobundle#util#cleandir(a:directory)

  let files = []
  for bundle in a:bundles
    for file in filter(split(globpath(
          \ bundle.rtp, a:directory.'/**', 1), '\n'),
          \ '!isdirectory(v:val)')
      let files += readfile(file, ':t')
    endfor
  endfor

  call neobundle#util#writefile(
        \ a:directory.'/'.a:directory . '.vim', files)
endfunction"}}}

" Sorts a list using a set of keys generated by mapping the values in the list
" through the given expr.
" v:val is used in {expr}
function! neobundle#util#sort_by(list, expr) abort "{{{
  let pairs = map(a:list, printf('[v:val, %s]', a:expr))
  return map(s:sort(pairs,
  \      'a:a[1] ==# a:b[1] ? 0 : a:a[1] ># a:b[1] ? 1 : -1'), 'v:val[0]')
endfunction"}}}

" Executes a command and returns its output.
" This wraps Vim's `:redir`, and makes sure that the `verbose` settings have
" no influence.
function! neobundle#util#redir(cmd) abort "{{{
  let [save_verbose, save_verbosefile] = [&verbose, &verbosefile]
  set verbose=0 verbosefile=
  redir => res
    silent! execute a:cmd
  redir END
  let [&verbose, &verbosefile] = [save_verbose, save_verbosefile]
  return res
endfunction"}}}

" Sorts a list with expression to compare each two values.
" a:a and a:b can be used in {expr}.
function! s:sort(list, expr) abort "{{{
  if type(a:expr) == type(function('function'))
    return sort(a:list, a:expr)
  endif
  let s:expr = a:expr
  return sort(a:list, 's:_compare')
endfunction"}}}

function! s:_compare(a, b) abort
  return eval(s:expr)
endfunction

function! neobundle#util#print_bundles(bundles) abort "{{{
  echomsg string(map(copy(a:bundles), 'v:val.name'))
endfunction"}}}

function! neobundle#util#sort_human(filenames) abort "{{{
  return sort(a:filenames, 's:compare_filename')
endfunction"}}}

" Compare filename by human order. "{{{
function! s:compare_filename(i1, i2) abort
  let words_1 = s:get_words(a:i1)
  let words_2 = s:get_words(a:i2)
  let words_1_len = len(words_1)
  let words_2_len = len(words_2)

  for i in range(0, min([words_1_len, words_2_len])-1)
    if words_1[i] >? words_2[i]
      return 1
    elseif words_1[i] <? words_2[i]
      return -1
    endif
  endfor

  return words_1_len - words_2_len
endfunction"}}}

function! s:get_words(filename) abort "{{{
  let words = []
  for split in split(a:filename, '\d\+\zs\ze')
    let words += split(split, '\D\zs\ze\d\+')
  endfor

  return map(words, "v:val =~ '^\\d\\+$' ? str2nr(v:val) : v:val")
endfunction"}}}

function! neobundle#util#wget(uri, outpath) abort "{{{
  if executable('curl')
    return printf('curl --fail -s -o "%s" "%s"', a:outpath, a:uri)
  elseif executable('wget')
    return printf('wget -q -O "%s" "%s"', a:outpath, a:uri)
  else
    return 'E: curl or wget command is not available!'
  endif
endfunction"}}}

function! neobundle#util#truncate_skipping(str, max, footer_width, separator) abort "{{{
  let width = s:wcswidth(a:str)
  if width <= a:max
    let ret = a:str
  else
    let header_width = a:max - s:wcswidth(a:separator) - a:footer_width
    let ret = s:strwidthpart(a:str, header_width) . a:separator
          \ . s:strwidthpart_reverse(a:str, a:footer_width)
  endif

  return ret
endfunction"}}}
function! s:strwidthpart(str, width) abort "{{{
  if a:width <= 0
    return ''
  endif
  let ret = a:str
  let width = s:wcswidth(a:str)
  while width > a:width
    let char = matchstr(ret, '.$')
    let ret = ret[: -1 - len(char)]
    let width -= s:wcswidth(char)
  endwhile

  return ret
endfunction"}}}
function! s:strwidthpart_reverse(str, width) abort "{{{
  if a:width <= 0
    return ''
  endif
  let ret = a:str
  let width = s:wcswidth(a:str)
  while width > a:width
    let char = matchstr(ret, '^.')
    let ret = ret[len(char) :]
    let width -= s:wcswidth(char)
  endwhile

  return ret
endfunction"}}}
function! s:wcswidth(str) abort "{{{
  return v:version >= 704 ? strwidth(a:str) : strlen(a:str)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker

