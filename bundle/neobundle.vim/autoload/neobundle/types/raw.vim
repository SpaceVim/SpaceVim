"=============================================================================
" FILE: raw.vim
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
call neobundle#util#set_default(
      \ 'g:neobundle#types#raw#calc_hash_command',
      \ executable('sha1sum') ? 'sha1sum' :
      \ executable('md5sum') ? 'md5sum' : '')
"}}}

function! neobundle#types#raw#define() abort "{{{
  return s:type
endfunction"}}}

let s:type = {
      \ 'name' : 'raw',
      \ }

function! s:type.detect(path, opts) abort "{{{
  " No auto detect.
  let type = ''
  let name = ''

  if a:path =~# '^https:.*\.vim$'
    " HTTPS

    let name = neobundle#util#name_conversion(a:path)

    let type = 'raw'
  elseif a:path =~#
        \ '^https://www\.vim\.org/scripts/download_script.php?src_id=\d\+$'
    " For www.vim.org
    let name = 'vim-scripts-' . matchstr(a:path, '\d\+$')
    let type = 'raw'
  endif

  return type == '' ?  {} :
        \ { 'name': name, 'uri' : a:path, 'type' : type }
endfunction"}}}
function! s:type.get_sync_command(bundle) abort "{{{
  if a:bundle.script_type == ''
    return 'E: script_type is not found.'
  endif

  let path = a:bundle.path

  if !isdirectory(path)
    " Create script type directory.
    call mkdir(path, 'p')
  endif

  let filename = path . '/' . get(a:bundle,
        \ 'type__filename', fnamemodify(a:bundle.uri, ':t'))
  let a:bundle.type__filepath = filename

  let cmd = neobundle#util#wget(a:bundle.uri, filename)

  return cmd
endfunction"}}}
function! s:type.get_revision_number_command(bundle) abort "{{{
  if g:neobundle#types#raw#calc_hash_command == ''
    return ''
  endif

  if !filereadable(a:bundle.type__filepath)
    " Not Installed.
    return ''
  endif

  " Calc hash.
  return printf('%s %s',
        \ g:neobundle#types#raw#calc_hash_command,
        \ a:bundle.type__filepath)
endfunction"}}}
function! s:type.get_revision_lock_command(bundle) abort "{{{
  let new_rev = matchstr(a:bundle.new_rev, '^\S\+')
  if a:bundle.rev != '' && new_rev != '' &&
        \ new_rev !=# a:bundle.rev
    " Revision check.
    return printf('E: revision digest is not matched : "%s"(got) and "%s"(rev).',
          \ new_rev, a:bundle.rev)
  endif

  " Not supported.
  return ''
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
