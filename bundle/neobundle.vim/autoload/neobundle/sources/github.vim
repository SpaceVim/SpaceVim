"=============================================================================
" FILE: github.vim
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

function! neobundle#sources#github#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'github',
      \ 'short_name' : 'github',
      \ }

" sorter
let s:filter = {
\   "name" : "sorter_stars",
\}

function! s:filter.filter(candidates, context) abort
    return unite#util#sort_by(a:candidates, 'v:val.source__stars')
endfunction

call unite#define_filter(s:filter)
unlet s:filter

function! s:source.gather_candidates(args, context) abort "{{{
  let plugins = s:get_github_searches(a:context.source__input)


  return map(copy(plugins), "{
        \ 'word' : v:val.full_name. ' ' . v:val.description,
        \ 'source__name' : (v:val.fork ? '| ' : '') .
        \          v:val.full_name,
        \ 'source__path' : v:val.full_name,
        \ 'source__description' : v:val.description,
        \ 'source__stars' : v:val.stargazers_count,
        \ 'source__options' : [],
        \ 'action__uri' : v:val.html_url,
        \ }")
endfunction"}}}

" Misc.
" @vimlint(EVL102, 1, l:true)
" @vimlint(EVL102, 1, l:false)
" @vimlint(EVL102, 1, l:null)
function! s:get_github_searches(string) abort "{{{
  let uri = 'https://api.github.com/search/repositories?q='
        \ . a:string . '+language:VimL'.'\&sort=stars'.'\&order=desc'
  let temp = neobundle#util#substitute_path_separator(tempname())

  let cmd = neobundle#util#wget(uri, temp)

  call unite#print_message(
        \ '[neobundle/search:github] Searching plugins from github...')
  redraw

  let result = unite#util#system(cmd)

  if cmd =~# '^E:'
    call unite#print_error(
          \ '[neobundle/search:github] '.
          \ 'wget or curl command is not available!')
    return []
  elseif unite#util#get_last_status()
    call unite#print_message('[neobundle/search:github] ' . cmd)
    call unite#print_error('[neobundle/search:github] Error occurred!')
    call unite#print_error(result)
    return []
  elseif !filereadable(temp)
    call unite#print_error('[neobundle/search:github] '.
          \ 'Temporary file was not created!')
    return []
  else
    call unite#print_message('[neobundle/search:github] Done!')
  endif

  let [true, false, null] = [1,0,"''"]
  sandbox let data = eval(join(readfile(temp)))
  call filter(data.items,
        \ "stridx(v:val.full_name, a:string) >= 0")

  call delete(temp)

  return data.items
endfunction"}}}
" @vimlint(EVL102, 0, l:true)
" @vimlint(EVL102, 0, l:false)
" @vimlint(EVL102, 0, l:null)

call unite#custom_source('neobundle/search', 'sorters', 'sorters_stars')

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
