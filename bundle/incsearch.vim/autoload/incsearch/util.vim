"=============================================================================
" FILE: autoload/incsearch/util.vim
" AUTHOR: haya14busa
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
scriptencoding utf-8
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

let s:TRUE = !0
let s:FALSE = 0

" Public Utilities:
function! incsearch#util#deepextend(...) abort
  return call(function('s:deepextend'), a:000)
endfunction

" Utilities:

function! incsearch#util#import() abort
  let prefix = '<SNR>' . s:SID() . '_'
  let module = {}
  for func in s:functions
    let module[func] = function(prefix . func)
  endfor
  return copy(module)
endfunction

function! s:SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction

let s:functions = [
\     'is_visual'
\   , 'get_max_col'
\   , 'is_pos_less_equal'
\   , 'is_pos_more_equal'
\   , 'sort_num'
\   , 'sort_pos'
\   , 'count_pattern'
\   , 'silent_feedkeys'
\   , 'deepextend'
\   , 'dictfunction'
\   , 'regexp_join'
\ ]


function! s:is_visual(mode) abort
  return a:mode =~# "[vV\<C-v>]"
endfunction

" Return max column number of given line expression
" expr: similar to line(), col()
function! s:get_max_col(expr) abort
  return strlen(getline(a:expr)) + 1
endfunction

" return (x <= y)
function! s:is_pos_less_equal(x, y) abort
  return (a:x[0] == a:y[0]) ? a:x[1] <= a:y[1] : a:x[0] < a:y[0]
endfunction

" return (x > y)
function! s:is_pos_more_equal(x, y) abort
  return ! s:is_pos_less_equal(a:x, a:y)
endfunction

" x < y -> -1
" x = y -> 0
" x > y -> 1
function! s:compare_pos(x, y) abort
  return max([-1, min([1,(a:x[0] == a:y[0]) ? a:x[1] - a:y[1] : a:x[0] - a:y[0]])])
endfunction

function! s:sort_num(xs) abort
  " 7.4.341
  " http://ftp.vim.org/vim/patches/7.4/7.4.341
  if v:version > 704 || v:version == 704 && has('patch341')
    return sort(a:xs, 'n')
  else
    return sort(a:xs, 's:_sort_num_func')
  endif
endfunction

function! s:_sort_num_func(x, y) abort
  return a:x - a:y
endfunction

function! s:sort_pos(pos_list) abort
  " pos_list: [ [x1, y1], [x2, y2] ]
  return sort(a:pos_list, 's:compare_pos')
endfunction

" Return the number of matched patterns in the current buffer or the specified
" region with `from` and `to` positions
" parameter: pattern, from, to
function! s:count_pattern(pattern, ...) abort
  let w = winsaveview()
  let [from, to] = [
  \   get(a:, 1, [1, 1]),
  \   get(a:, 2, [line('$'), s:get_max_col('$')])
  \ ]
  let ignore_at_cursor_pos = get(a:, 3, 0)
  " direction flag
  let d_flag = s:compare_pos(from, to) > 0 ? 'b' : ''
  call cursor(from)
  let cnt = 0
  let base_flag = d_flag . 'W'
  try
    " first: accept a match at the cursor position
    let pos = searchpos(a:pattern, (ignore_at_cursor_pos ? '' : 'c' ) . base_flag)
    while (pos != [0, 0] && s:compare_pos(pos, to) isnot# (d_flag is# 'b' ? -1 : 1))
      let cnt += 1
      let pos = searchpos(a:pattern, base_flag)
    endwhile
  finally
    call winrestview(w)
  endtry
  return cnt
endfunction

" NOTE: support vmap?
" It doesn't handle feedkeys() on incsert or command-line mode
function! s:silent_feedkeys(expr, name, ...) abort
  " Ref:
  " https://github.com/osyo-manga/vim-over/blob/d51b028c29661d4a5f5b79438ad6d69266753711/autoload/over.vim#L6
  let mode = get(a:, 1, 'm')
  let name = 'incsearch-' . a:name
  let map = printf('<Plug>(%s)', name)
  if mode ==# 'n'
    let command = 'nnoremap'
  else
    let command = 'nmap'
  endif
  execute command '<silent>' map printf('%s:nunmap %s<CR>', a:expr, map)
  if mode(1) !=# 'ce'
    " FIXME: mode(1) !=# 'ce' exists only for the test
    "        :h feedkeys() doesn't work while runnning a test script
    "        https://github.com/kana/vim-vspec/issues/27
    call feedkeys(printf("\<Plug>(%s)", name))
  endif
endfunction

" deepextend (nest: 1)
function! s:deepextend(expr1, expr2) abort
  let expr2 = copy(a:expr2)
  for [k, V] in items(a:expr1)
    if (type(V) is type({}) || type(V) is type([])) && has_key(expr2, k)
      let a:expr1[k] = extend(a:expr1[k], expr2[k])
      unlet expr2[k]
    endif
    unlet V
  endfor
  return extend(a:expr1, expr2)
endfunction

let s:funcmanage = {}
function! s:funcmanage() abort
  return s:funcmanage
endfunction

function! s:dictfunction(dictfunc, dict) abort
  if has('patch-7.4.1842')
    let funcname = '_' . get(a:dictfunc, 'name')
  else
    let funcname = '_' . matchstr(string(a:dictfunc), '\d\+')
  endif
  let s:funcmanage[funcname] = {
  \   'func': a:dictfunc,
  \   'dict': a:dict
  \ }
  let prefix = '<SNR>' . s:SID() . '_'
  let fm = printf("%sfuncmanage()['%s']", prefix, funcname)
  execute join([
  \   printf('function! s:%s(...) abort', funcname),
  \   printf("  return call(%s['func'], a:000, %s['dict'])", fm, fm),
  \          'endfunction'
  \ ], "\n")
  return function(printf('%s%s', prefix, funcname))
endfunction


"--- regexp

let s:escaped_backslash = '\m\%(^\|[^\\]\)\%(\\\\\)*\zs'

function! s:regexp_join(ps) abort
  let rs = map(filter(copy(a:ps), 's:_is_valid_regexp(v:val)'), 's:escape_unbalanced_left_r(v:val)')
  return printf('\m\%%(%s\m\)', join(rs, '\m\|'))
endfunction

function! s:_is_valid_regexp(pattern) abort
  try
    if '' =~# a:pattern
    endif
    return s:TRUE
  catch
    return s:FALSE
  endtry
endfunction

" \m,\v:  [ -> \[
" \M,\V:  \[ -> [
function! s:escape_unbalanced_left_r(pattern) abort
  let rs = []
  let cs = split(a:pattern, '\zs')
  " escape backslash (\, \\\, \\\\\, ...)
  let escape_bs = s:FALSE
  let flag = &magic ? 'm' : 'M'
  let i = 0
  while i < len(cs)
    let c = cs[i]
    " characters to add to rs
    let addcs = [c]
    if escape_bs && s:_is_flag(c)
      let flag = c
    elseif c is# '[' && s:_may_replace_left_r_cond(escape_bs, flag)
      let idx = s:_find_right_r(cs, i)
      if idx is# -1
        if s:_is_flag(flag, 'MV')
          " Remove `\` before unbalanced `[`
          let rs = rs[:-2]
        else
          " Escape unbalanced `[`
          let addcs = ['\' . c]
        endif
      else
        let addcs = cs[(i):(i+idx)]
        let i += idx
      endif
    endif
    let escape_bs = (escape_bs || c isnot# '\') ? s:FALSE : s:TRUE
    let rs += addcs
    let i += 1
  endwhile
  return join(rs, '')
endfunction

" @ return boolean
function! s:_is_flag(flag, ...) abort
  let chars = get(a:, 1, 'mMvV')
  return a:flag =~# printf('\m[%s]', chars)
endfunction

" @ return boolean
function! s:_may_replace_left_r_cond(escape_bs, flag) abort
  return (a:escape_bs && s:_is_flag(a:flag, 'MV')) || (!a:escape_bs && s:_is_flag(a:flag, 'mv'))
endfunction

" @return index
function! s:_find_right_r(cs, i) abort
  return match(join(a:cs[(a:i+1):], ''), s:escaped_backslash . ']')
endfunction

"--- end of regexp


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" __END__  {{{
" vim: expandtab softtabstop=2 shiftwidth=2
" vim: foldmethod=marker
" }}}
