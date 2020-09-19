"=============================================================================
" FILE: metadata.vim
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

let s:repository_cache = []

function! neobundle#sources#metadata#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'metadata',
      \ 'short_name' : 'meta',
      \ }

function! s:source.gather_candidates(args, context) abort "{{{
  let plugins = s:get_repository_plugins(a:context)

  try
    return map(copy(plugins), "{
        \ 'word' : v:val.name . ' ' . v:val.description,
        \ 'source__name' : v:val.name,
        \ 'source__path' : v:val.repository,
        \ 'source__script_type' : s:convert2script_type(v:val.raw_type),
        \ 'source__description' : v:val.description,
        \ 'source__options' : [],
        \ 'action__uri' : v:val.uri,
        \ }")
  catch
    call unite#print_error(
          \ '[neobundle/search:metadata] '
          \ .'Error occurred in loading cache.')
    call unite#print_error(
          \ '[neobundle/search:metadata] '
          \ .'Please re-make cache by <Plug>(unite_redraw) mapping.')
    call neobundle#installer#error(v:exception . ' ' . v:throwpoint)

    return []
  endtry
endfunction"}}}

" Misc.
function! s:get_repository_plugins(context) abort "{{{
  if a:context.is_redraw
    " Reload cache.
    call unite#print_message(
          \ '[neobundle/search:metadata] '
          \ .'Reloading cache from metadata repository')
    redraw

    call neobundle#metadata#update()
  endif

  return s:convert_metadata(neobundle#metadata#get())
endfunction"}}}

function! s:convert_metadata(data) abort "{{{
  return values(map(copy(a:data), "{
        \ 'name' : v:key,
        \ 'raw_type' : get(v:val, 'script-type', ''),
        \ 'repository' : substitute(v:val.url, '^git://', 'https://', ''),
        \ 'description' : '',
        \ 'uri' : get(v:val, 'homepage', ''),
        \ }"))
endfunction"}}}

function! s:convert2script_type(type) abort "{{{
  if a:type ==# 'utility'
    return 'plugin'
  elseif a:type ==# 'color scheme'
    return 'colors'
  else
    return a:type
  endif
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
