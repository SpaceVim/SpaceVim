"=============================================================================
" FILE: matcher_fuzzy.vim
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

function! neocomplete#filters#matcher_fuzzy#define() abort "{{{
  return s:matcher
endfunction"}}}

let s:matcher = {
      \ 'name' : 'matcher_fuzzy',
      \ 'description' : 'fuzzy matcher',
      \}

function! s:matcher.filter(context) abort "{{{
  if len(a:context.complete_str) > 10
    " Mix fuzzy mode.
    let len = len(a:context.complete_str)
    let fuzzy_len = len - len/(1 + len/10)
    let pattern =
          \ neocomplete#filters#escape(
          \     a:context.complete_str[: fuzzy_len-1])  .
          \ neocomplete#filters#fuzzy_escape(
          \     a:context.complete_str[fuzzy_len :])
  else
    let pattern = neocomplete#filters#fuzzy_escape(
          \ a:context.complete_str)
  endif

  " The first letter must be matched.
  let pattern = '^' . pattern

  lua << EOF
do
  local pattern = vim.eval('pattern')
  local input = vim.eval('a:context.complete_str')
  local candidates = vim.eval('a:context.candidates')
  if vim.eval('&ignorecase') ~= 0 then
    pattern = string.lower(pattern)
    input = string.lower(input)
    for i = #candidates-1, 0, -1 do
      local word = vim.type(candidates[i]) == 'dict' and
        string.lower(candidates[i].word) or string.lower(candidates[i])
      if string.find(word, pattern, 1) == nil then
        candidates[i] = nil
      end
    end
  else
    for i = #candidates-1, 0, -1 do
      local word = vim.type(candidates[i]) == 'dict' and
        candidates[i].word or candidates[i]
      if string.find(word, pattern, 1) == nil then
        candidates[i] = nil
      end
    end
  end
end
EOF

  return a:context.candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
