"=============================================================================
" FILE: cmd.vim
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

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

if !vimproc#util#is_windows()
  function! vimproc#cmd#system(expr) abort
    return vimproc#system(a:expr)
  endfunction
  let &cpo = s:save_cpo
  finish
endif

" Based from : http://d.hatena.ne.jp/osyo-manga/20130611/1370950114

let s:cmd = {}

augroup vimproc
  autocmd VimLeave * call s:cmd.close()
augroup END


function! s:cmd.open() abort "{{{
  let cmd = 'cmd.exe'
  let self.vimproc = vimproc#popen3(cmd)
  let self.cwd = getcwd()

  " Wait until getting first prompt.
  let output = ''
  while output !~ '.\+>$'
    let output .= self.vimproc.stdout.read()
  endwhile
endfunction"}}}

function! s:cmd.close() abort "{{{
  call self.vimproc.waitpid()
endfunction"}}}

function! s:cmd.system(cmd) abort "{{{
  " Execute cmd.
  if self.cwd !=# getcwd()
    " Execute cd.
    let input = '(cd /D "' . getcwd() . '" & ' . a:cmd . ')'
    let self.cwd = getcwd()
  else
    let input = a:cmd
  endif

  call self.vimproc.stdin.write(input . "\n")

  " Wait until getting prompt.
  let output = ''
  while 1
    let output .= self.vimproc.stdout.read()
    let lastnl = strridx(output, "\n")
    if lastnl >= 0 &&
          \ output[lastnl + 1:] =~ '^\%([A-Z]:\\\|\\\\.\+\\.\+\\\).*>$'
      break
    endif
  endwhile
  let result = split(output, '\r\n\|\n')[1:-2]

  return join(result, "\n")
endfunction"}}}

call s:cmd.open()

function! vimproc#cmd#system(expr) abort
  let cmd = type(a:expr) == type('') ? a:expr :
        \ join(map(a:expr,
        \   'match(v:val, "\\s") >= 0 ? "\"".v:val."\"" : v:val'))
  return s:cmd.system(cmd)
endfunction

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
" vim:foldmethod=marker:fen:sw=2:sts=2
