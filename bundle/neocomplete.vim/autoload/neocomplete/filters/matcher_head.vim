"=============================================================================
" FILE: matcher_head.vim
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

function! neocomplete#filters#matcher_head#define() abort "{{{
  return s:matcher
endfunction"}}}

let s:matcher = {
      \ 'name' : 'matcher_head',
      \ 'description' : 'head matcher',
      \}

function! s:matcher.filter(context) abort "{{{
  lua << EOF
do
  local pattern = vim.eval(
      "'^' . neocomplete#filters#escape(a:context.complete_str)")
  local input = vim.eval('a:context.complete_str')
  local candidates = vim.eval('a:context.candidates')
  if vim.eval('&ignorecase') ~= 0 then
    pattern = string.lower(pattern)
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
