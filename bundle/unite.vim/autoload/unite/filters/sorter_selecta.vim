"=============================================================================
" FILE: sorter_selecta.vim
" AUTHOR:  David Lee
" CONTRIBUTOR:  Jean Cavallo
" DESCRIPTION: Scoring code by Gary Bernhardt
"     https://github.com/garybernhardt/selecta
" License: MIT license
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
" 
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_selecta#define() abort
  if has('python') || has('python3')
    return s:sorter
  else
    return {}
  endif
endfunction

let s:root = expand('<sfile>:p:h')
let s:sorter = {
      \ 'name' : 'sorter_selecta',
      \ 'description' : 'sort by selecta algorithm',
      \}

if exists(':Python2or3') != 2
  if has('python3') && get(g:, 'pymode_python', '') !=# 'python'
    command! -nargs=1 Python2or3 python3 <args>
  else
    command! -nargs=1 Python2or3 python <args>
  endif
endif

function! s:sorter.filter(candidates, context) abort
  if a:context.input == '' || !has('float') || empty(a:candidates)
    return a:candidates
  endif

  return unite#filters#sorter_selecta#_sort(
        \ a:candidates, a:context.input)
endfunction

function! unite#filters#sorter_selecta#_sort(candidates, input) abort
  " Initialize.
  let is_path = has_key(a:candidates[0], 'action__path')
  for candidate in a:candidates
    let candidate.filter__rank = 0
    let candidate.filter__word = is_path ?
          \ fnamemodify(candidate.word, ':t') : candidate.word
  endfor


  let inputs = map(split(a:input, '\\\@<! '), "
        \ tolower(substitute(substitute(v:val, '\\\\ ', ' ', 'g'),
        \ '\\*', '', 'g'))")

  let candidates = s:sort_python(a:candidates, inputs)

  return candidates
endfunction

" @vimlint(EVL102, 1, l:input)
" @vimlint(EVL102, 1, l:candidate)
function! s:sort_python(candidates, inputs) abort
  for input in a:inputs
    if input != ''
      for candidate in a:candidates
        Python2or3 score()
      endfor
    endif
  endfor

  return unite#util#sort_by(a:candidates, 'v:val.filter__rank')
endfunction"}}}
" @vimlint(EVL102, 0, l:input)
" @vimlint(EVL102, 0, l:candidate)

" @vimlint(EVL102, 1, l:root)
function! s:def_python() abort
  if !(has('python') || has('python3'))
    return
  endif
  let root = s:root
  Python2or3 import sys
  Python2or3 import vim
  Python2or3 sys.path.insert(0, vim.eval('root'))
  Python2or3 from sorter_selecta import score
endfunction
" @vimlint(EVL102, 0, l:root)

call s:def_python()

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
