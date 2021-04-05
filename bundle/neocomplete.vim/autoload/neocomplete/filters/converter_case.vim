"=============================================================================
" FILE: converter_case.vim
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

function! neocomplete#filters#converter_case#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_case',
      \ 'description' : 'case converter',
      \}

function! s:converter.filter(context) abort "{{{
  if !neocomplete#is_text_mode() && !neocomplete#within_comment()
    return a:context.candidates
  endif

  if a:context.complete_str =~ '^\l\{3}$'
    for candidate in s:get_convert_candidates(a:context.candidates)
      let candidate.word = tolower(candidate.word)
      if has_key(candidate, 'abbr')
        let candidate.abbr = tolower(candidate.abbr)
      endif
    endfor
  elseif a:context.complete_str =~ '^\u\{3}$'
    for candidate in s:get_convert_candidates(a:context.candidates)
      let candidate.word = toupper(candidate.word)
      if has_key(candidate, 'abbr')
        let candidate.abbr = toupper(candidate.abbr)
      endif
    endfor
  elseif a:context.complete_str =~ '^\u\l\+$'
    for candidate in s:get_convert_candidates(a:context.candidates)
      let candidate.word = toupper(candidate.word[0]).
            \ candidate.word[1:]
      if has_key(candidate, 'abbr')
        let candidate.abbr = toupper(candidate.abbr[0]).
              \ tolower(candidate.abbr[1:])
      endif
    endfor
  endif

  return a:context.candidates
endfunction"}}}

function! s:get_convert_candidates(candidates) abort
  return filter(copy(a:candidates),
        \ "get(v:val, 'neocomplete__convertable', 1)
        \  && v:val.word =~ '^[a-zA-Z0-9_''-]\\+$'")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
