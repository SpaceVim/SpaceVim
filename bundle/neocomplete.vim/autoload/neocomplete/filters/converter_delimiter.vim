"=============================================================================
" FILE: converter_delimiter.vim
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

function! neocomplete#filters#converter_delimiter#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_delimiter',
      \ 'description' : 'delimiter converter',
      \}

" @vimlint(EVL102, 1, l:delim_cnt)
function! s:converter.filter(context) abort "{{{
  if g:neocomplete#max_keyword_width < 0
    return a:context.candidates
  endif

  " Delimiter check.
  for delimiter in get(g:neocomplete#delimiter_patterns,
        \ a:context.filetype, [])
    " Count match.
    let delim_cnt = 0
    let delimiter_vim = neocomplete#util#escape_pattern(delimiter)
    let matchend = matchend(a:context.complete_str, delimiter_vim)
    while matchend >= 0
      let matchend = matchend(a:context.complete_str,
            \ delimiter_vim, matchend)
      let delim_cnt += 1
    endwhile

    lua << EOF
    do
      local candidates = vim.eval('a:context.candidates')
      local pattern = vim.eval('neocomplete#filters#escape(delimiter)')..'.'
      for i = 0, #candidates-1 do
        if string.find(candidates[i].word, pattern, 1) ~= nil and (
            not candidates[i].abbr or
            string.gsub(candidates[i].word, '%([^)]*%)?', '()')
              == string.gsub(candidates[i].abbr, '%([^)]*%)?', '()')) then
          vim.command('call s:process_delimiter(a:context, '..
            'a:context.candidates['.. i ..
            '], delimiter_vim, delim_cnt)')
        end
      end
    end
EOF
  endfor

  return a:context.candidates
endfunction"}}}
" @vimlint(EVL102, 0, l:delim_cnt)

function! s:process_delimiter(context, candidate, delimiter, delim_cnt) abort
  let candidate = a:candidate

  let split_list = split(candidate.word, a:delimiter.'\ze.', 1)
  let delimiter_sub = substitute(
        \ a:delimiter, '\\\(.\)', '\1', 'g')
  let candidate.abbr = join(
        \ split(get(candidate, 'abbr', candidate.word),
        \             a:delimiter.'\ze.', 1)[ : a:delim_cnt],
        \ delimiter_sub)
  let candidate.word = join(split_list[ : a:delim_cnt], delimiter_sub)

  if g:neocomplete#max_keyword_width >= 0
        \ && len(candidate.abbr) > g:neocomplete#max_keyword_width
    let candidate.abbr = substitute(candidate.abbr,
          \ '\(\h\)\w*'.a:delimiter, '\1'.delimiter_sub, 'g')
  endif
  if a:delim_cnt+1 < len(split_list)
    let candidate.abbr .= delimiter_sub . '~'
    let candidate.dup = 0

    if g:neocomplete#enable_auto_delimiter
      let candidate.word .= delimiter_sub
    endif
  endif

  " Clear previous result.
  let a:context.prev_candidates = []
  let a:context.prev_complete_pos = -1
  let a:context.prev_line = ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
