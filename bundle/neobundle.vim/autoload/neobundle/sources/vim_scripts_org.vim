"=============================================================================
" FILE: vim_scripts_org.vim
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

let s:Cache = unite#util#get_vital_cache()

let s:repository_cache = []

function! neobundle#sources#vim_scripts_org#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'vim-scripts.org',
      \ 'short_name' : 'vim.org',
      \ }

function! s:source.gather_candidates(args, context) abort "{{{
  let repository =
        \ 'https://raw.githubusercontent.com/vim-scraper/'
        \ .'vim-scraper.github.com/master/api/scripts_recent.json'

  call unite#print_message(
        \ '[neobundle/search:vim-scripts.org] repository: ' . repository)

  let plugins = s:get_repository_plugins(a:context, repository)

  try
    return map(copy(plugins), "{
        \ 'word' : v:val.name . ' ' . v:val.description,
        \ 'source__name' : v:val.name,
        \ 'source__path' : v:val.name,
        \ 'source__script_type' : s:convert2script_type(v:val.raw_type),
        \ 'source__description' : v:val.description,
        \ 'source__options' : [],
        \ 'action__uri' : v:val.uri,
        \ }")
  catch
    call unite#print_error(
          \ '[neobundle/search:vim-scripts.org] '
          \ .'Error occurred in loading cache.')
    call unite#print_error(
          \ '[neobundle/search:vim-scripts.org] '
          \ .'Please re-make cache by <Plug>(unite_redraw) mapping.')
    call neobundle#installer#error(v:exception . ' ' . v:throwpoint)

    return []
  endtry
endfunction"}}}

" Misc.
function! s:get_repository_plugins(context, path) abort "{{{
  let cache_dir = neobundle#get_neobundle_dir() . '/.neobundle'

  if a:context.is_redraw || !s:Cache.filereadable(cache_dir, a:path)
    " Reload cache.
    let cache_path = s:Cache.getfilename(cache_dir, a:path)

    call unite#print_message(
          \ '[neobundle/search:vim-scripts.org] '
          \ .'Reloading cache from ' . a:path)
    redraw

    if s:Cache.filereadable(cache_dir, a:path)
      call delete(cache_path)
    endif

    let temp = unite#util#substitute_path_separator(tempname())

    let cmd = neobundle#util#wget(a:path, temp)
    if cmd =~# '^E:'
      call unite#print_error(
            \ '[neobundle/search:vim-scripts.org] '.
            \ 'curl or wget command is not available!')
      return []
    endif

    let result = unite#util#system(cmd)

    if unite#util#get_last_status()
      call unite#print_message(
            \ '[neobundle/search:vim-scripts.org] ' . cmd)
      call unite#print_message(
            \ '[neobundle/search:vim-scripts.org] ' . result)
      call unite#print_error(
            \ '[neobundle/search:vim-scripts.org] Error occurred!')
      return []
    elseif !filereadable(temp)
      call unite#print_error('[neobundle/search:vim-scripts.org] '.
            \ 'Temporary file was not created!')
      return []
    else
      call unite#print_message('[neobundle/search:vim-scripts.org] Done!')
    endif

    sandbox let data = eval(get(readfile(temp), 0, '[]'))

    " Convert cache data.
    call s:Cache.writefile(cache_dir, a:path,
          \ [string(s:convert_vim_scripts_data(data))])

    call delete(temp)
  endif

  if empty(s:repository_cache)
    sandbox let s:repository_cache =
          \ eval(get(s:Cache.readfile(cache_dir, a:path), 0, '[]'))
  endif

  return s:repository_cache
endfunction"}}}

function! s:convert_vim_scripts_data(data) abort "{{{
  return map(copy(a:data), "{
        \ 'name' : v:val.n,
        \ 'raw_type' : v:val.t,
        \ 'repository' : v:val.rv,
        \ 'description' : printf('%-5s %s', v:val.rv, v:val.s),
        \ 'uri' : 'https://github.com/vim-scripts/' . v:val.n,
        \ }")
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
