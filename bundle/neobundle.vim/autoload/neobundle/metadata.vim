"=============================================================================
" FILE: metadata.vim
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

let s:metadata = {}
let s:repository =
      \ 'https://gist.githubusercontent.com/Shougo/'
      \ . '028d6ae320cc8f354f88/raw/'
      \ . '3b62ad42d39a4d3d4f236a45e00eb6b03ca23352/vim-pi.json'

function! neobundle#metadata#get(...) abort "{{{
  if empty(s:metadata)
    call s:load()
  endif
  return (a:0 == 0) ? copy(s:metadata) : get(s:metadata, a:1, {})
endfunction"}}}

function! neobundle#metadata#update() abort "{{{
  " Reload cache.
  let cache_path = neobundle#get_neobundle_dir() . '/.neobundle/metadata.json'

  if filereadable(cache_path)
    call delete(cache_path)
  endif

  let cmd = neobundle#util#wget(s:repository, cache_path)
  if cmd =~# '^E:'
    call neobundle#util#print_error(
          \ 'curl or wget command is not available!')
    return
  endif

  let result = neobundle#util#system(cmd)

  if neobundle#util#get_last_status()
    call neobundle#util#print_error('Error occurred!')
    call neobundle#util#print_error(cmd)
    call neobundle#util#print_error(result)
  elseif !filereadable(cache_path)
    call neobundle#util#print_error('Temporary file was not created!')
  endif
endfunction"}}}

function! s:load() abort "{{{
  " Reload cache.
  let cache_path = neobundle#get_neobundle_dir() . '/.neobundle/metadata.json'

  if !filereadable(cache_path)
    call neobundle#metadata#update()
  endif

  sandbox let s:metadata = eval(get(readfile(cache_path), 0, '{}'))

  return s:metadata
endfunction"}}}


let &cpo = s:save_cpo
unlet s:save_cpo

