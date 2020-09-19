"=============================================================================
" FILE: util.vim
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

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

let s:is_windows = has('win32')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!isdirectory('/proc') && executable('sw_vers')))

" iconv() wrapper for safety.
function! vimproc#util#has_iconv() abort "{{{
  " On Windows, some encodings can be converted by iconv() even if
  " libiconv.dll is not available.
  return (has('iconv') || (s:is_windows && exists('*iconv')))
endfunction"}}}
function! vimproc#util#iconv(expr, from, to) abort "{{{
  if !vimproc#util#has_iconv()
        \ || a:expr == '' || a:from == ''
        \ || a:to == '' || a:from ==# a:to
    return a:expr
  endif

  let result = iconv(a:expr, a:from, a:to)
  return result != '' ? result : a:expr
endfunction"}}}
function! vimproc#util#systemencoding() abort "{{{
  return s:is_windows ? 'utf-8' : 'char'
endfunction"}}}
function! vimproc#util#termencoding() abort "{{{
  return 'char'
endfunction"}}}
function! vimproc#util#stdinencoding() abort "{{{
  return exists('g:stdinencoding') && type(g:stdinencoding) == type("") ?
        \ g:stdinencoding : vimproc#util#termencoding()
endfunction"}}}
function! vimproc#util#stdoutencoding() abort "{{{
  return exists('g:stdoutencoding') && type(g:stdoutencoding) == type("") ?
        \ g:stdoutencoding : vimproc#util#termencoding()
endfunction"}}}
function! vimproc#util#stderrencoding() abort "{{{
  return exists('g:stderrencoding') && type(g:stderrencoding) == type("") ?
        \ g:stderrencoding : vimproc#util#termencoding()
endfunction"}}}
function! vimproc#util#expand(path) abort "{{{
  return vimproc#util#substitute_path_separator(
        \ (a:path =~ '^\~') ? fnamemodify(a:path, ':p') :
        \ (a:path =~ '^\$\h\w*') ? substitute(a:path,
        \               '^\$\h\w*', '\=eval(submatch(0))', '') :
        \ a:path)
endfunction"}}}
function! vimproc#util#is_windows() abort "{{{
  return s:is_windows
endfunction"}}}
function! vimproc#util#is_mac() abort "{{{
  return s:is_mac
endfunction"}}}
function! vimproc#util#is_cygwin() abort "{{{
  return s:is_cygwin
endfunction"}}}
function! vimproc#util#has_lua() abort "{{{
  " Note: Disabled if_lua feature if less than 7.3.885.
  " Because if_lua has double free problem.
  return has('lua') && (v:version > 703 || v:version == 703 && has('patch885'))
endfunction"}}}
function! vimproc#util#substitute_path_separator(path) abort "{{{
  return s:is_windows ? substitute(a:path, '\\', '/', 'g') : a:path
endfunction"}}}
function! vimproc#util#cd(path) abort  "{{{
  execute (haslocaldir() ? 'lcd' : 'cd') fnameescape(a:path)
endfunction"}}}

function! vimproc#util#uniq(list, ...) abort "{{{
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
function! vimproc#util#set_default(var, val, ...) abort  "{{{
  if !exists(a:var) || type({a:var}) != type(a:val)
    let alternate_var = get(a:000, 0, '')

    let {a:var} = exists(alternate_var) ?
          \ {alternate_var} : a:val
  endif
endfunction"}}}
function! vimproc#util#try_update_windows_dll(version) abort  "{{{
  let old_path = g:vimproc#dll_path . '.old'
  if filereadable(old_path)
    if delete(old_path) == -1
      return 0
    endif
  endif
  if filereadable(g:vimproc#dll_path)
    if delete(g:vimproc#dll_path) == -1
      if rename(g:vimproc#dll_path, old_path)
        return 0
      endif
    endif
  endif
  return vimproc#util#try_download_windows_dll(a:version)
endfunction"}}}
function! vimproc#util#try_download_windows_dll(version) abort  "{{{
  let fname = printf('vimproc_win%s.dll', has('win64') ? '64' : '32')
  let url = printf('https://github.com/Shougo/vimproc.vim/releases/download/ver.%s/%s', a:version, fname)

  if executable('curl')
    let cmd = printf('curl --insecure --silent --location --output %s %s',
          \ s:win_escape(g:vimproc#dll_path),
          \ s:win_escape(url))
    call system(cmd)
    return filereadable(g:vimproc#dll_path)

  elseif executable('powershell')
    let pscmd = printf("(New-Object Net.WebClient).DownloadFile('%s', '%s')",
          \ url, g:vimproc#dll_path)
    let cmd = printf('powershell -Command %s', s:win_escape(pscmd))
    call system(cmd)
    return filereadable(g:vimproc#dll_path)
  endif
  return 0
endfunction"}}}
function! s:win_escape(str) abort  "{{{
  return '"' . substitute(a:str, '"', '""', 'g') . '"'
endfunction"}}}


" Global options definition. "{{{
call vimproc#util#set_default(
      \ 'g:stdinencoding', 'char')
call vimproc#util#set_default(
      \ 'g:stdoutencoding', 'char')
call vimproc#util#set_default(
      \ 'g:stderrencoding', 'char')
"}}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
" vim: foldmethod=marker
