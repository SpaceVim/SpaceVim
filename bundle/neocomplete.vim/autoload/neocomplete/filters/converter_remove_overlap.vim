"=============================================================================
" FILE: converter_overlap.vim
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

function! neocomplete#filters#converter_remove_overlap#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_remove_overlap',
      \ 'description' : 'remove overlapped characters',
      \}

function! s:converter.filter(context) abort "{{{
  let next = matchstr(getline('.')[
        \ len(neocomplete#helper#get_cur_text()) :], '^\S\+')
  if next == ''
    return a:context.candidates
  endif

  let candidates = []
  for candidate in a:context.candidates
    let overlapped_len = neocomplete#filters#
          \converter_remove_overlap#length(candidate.word, next)

    if overlapped_len > 0
      if !has_key(candidate, 'abbr')
        let candidate.abbr = candidate.word
      endif

      let candidate.word = candidate.word[: -overlapped_len-1]
      call add(candidates, candidate)
    elseif !neocomplete#is_auto_complete()
      call add(candidates, candidate)
    endif
  endfor

  if empty(candidates)
    return a:context.candidates
  endif

  let candidates = filter(candidates,
        \ 'v:val.word !=# a:context.complete_str')

  return candidates
endfunction"}}}

function! neocomplete#filters#converter_remove_overlap#length(left, right) abort "{{{
  if a:left == '' || a:right == ''
    return 0
  endif

  let ret = 0

  lua << EOF
do
  local ret = vim.eval('ret')
  local left = vim.eval('a:left')
  local right = vim.eval('a:right')
  local left_len = string.len(left)
  local right_len = string.len(right)

  if left_len > right_len then
    left = string.sub(left, left_len-right_len, left_len)
  elseif left_len < right_len then
    right = string.sub(right, 0, left_len)
  end

  if left == right then
    ret = math.min(left_len, right_len)
  else
    local length = 1
    left_len = string.len(left)
    while 1 do
      local pattern = string.sub(left, left_len-length+1, left_len)
      local pos = string.find(right, pattern, 1, 1)
      if pos == nil then
        break
      end
      length = length + pos - 1
      if string.sub(left, left_len-length+1, left_len) ==
        string.sub(right, 1, length) then
        ret = length
        length = length + 1
      end
    end
  end
  vim.command('let ret = ' .. ret)
end
EOF

  return ret
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
