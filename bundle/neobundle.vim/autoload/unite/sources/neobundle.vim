"=============================================================================
" FILE: neobundle.vim
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

function! unite#sources#neobundle#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'neobundle',
      \ 'description' : 'candidates from bundles',
      \ 'hooks' : {},
      \ }

function! s:source.hooks.on_init(args, context) abort "{{{
  let bundle_names = filter(copy(a:args), 'v:val != "!"')
  let a:context.source__bang =
        \ index(a:args, '!') >= 0
  let a:context.source__bundles = neobundle#util#sort_by(
        \  (empty(bundle_names) ?
        \   neobundle#config#get_neobundles() :
        \   neobundle#config#search(bundle_names)),
        \ 'tolower(v:val.orig_name)')
endfunction"}}}

" Filters "{{{
function! s:source.source__converter(candidates, context) abort "{{{
  for candidate in a:candidates
    if candidate.source__uri =~
          \ '^\%(https\?\|git\)://github.com/'
      let candidate.action__uri = candidate.source__uri
      let candidate.action__uri =
            \ substitute(candidate.action__uri, '^git://', 'https://', '')
      let candidate.action__uri =
            \ substitute(candidate.action__uri, '.git$', '', '')
    endif
  endfor

  return a:candidates
endfunction"}}}

let s:source.converters = s:source.source__converter
"}}}

function! s:source.gather_candidates(args, context) abort "{{{
  let _ = map(copy(a:context.source__bundles), "{
        \ 'word' : substitute(v:val.orig_name,
        \  '^\%(https\?\|git\)://\%(github.com/\)\?', '', ''),
        \ 'kind' : 'neobundle',
        \ 'action__path' : v:val.path,
        \ 'action__directory' : v:val.path,
        \ 'action__bundle' : v:val,
        \ 'action__bundle_name' : v:val.name,
        \ 'source__uri' : v:val.uri,
        \ 'source__description' : v:val.description,
        \ 'is_multiline' : 1,
        \ }
        \")

  let max = max(map(copy(_), 'len(v:val.word)'))

  call unite#print_source_message(
        \ '#: not sourced, X: not installed', self.name)

  for candidate in _
    let candidate.abbr =
          \ neobundle#is_sourced(candidate.action__bundle_name) ? ' ' :
          \ neobundle#is_installed(candidate.action__bundle_name) ? '#' : 'X'
    let candidate.abbr .= ' ' . unite#util#truncate(candidate.word, max)
    if candidate.source__description != ''
      let candidate.abbr .= ' : ' . candidate.source__description
    endif

    if a:context.source__bang
      let status = s:get_commit_status(candidate.action__bundle)
      if status != ''
        let candidate.abbr .= "\n   " . status
      endif
    endif

    let candidate.word .= candidate.source__description
  endfor

  return _
endfunction"}}}

function! s:get_commit_status(bundle) abort "{{{
  if !isdirectory(a:bundle.path)
    return 'Not installed'
  endif

  let type = neobundle#config#get_types(a:bundle.type)
  let cmd = has_key(type, 'get_revision_pretty_command') ?
        \ type.get_revision_pretty_command(a:bundle) :
        \ type.get_revision_number_command(a:bundle)
  if cmd == ''
    return ''
  endif

  let cwd = getcwd()
  try
    call neobundle#util#cd(a:bundle.path)
    let output = neobundle#util#system(cmd)
  finally
    call neobundle#util#cd(cwd)
  endtry

  if neobundle#util#get_last_status()
    return printf('Error(%d) occurred when executing "%s"',
          \ neobundle#util#get_last_status(), cmd)
  endif

  return output
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
