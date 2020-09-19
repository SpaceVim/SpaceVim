"=============================================================================
" FILE: parser.vim
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

" Constants. {{{
let g:vimproc#lexer#token_type = {
      \ 'int' : 257,
      \ 'string' : 258,
      \ }
" }}}

function! vimproc#lexer#init_lexer(text) abort
  let lexer = deepcopy(s:lexer)
  let lexer.reader = vimproc#lexer#init_reader(a:text)

  return lexer
endfunction

let s:lexer = {}
function! s:lexer.advance() abort
  call self.skip_spaces()

  let c = self.reader.read()
  if c < 0
    return 0
  endif

  if c =~ '\d'
    call self.reader.unread()
    call self.lex_digit()
    let self.tok = g:vimproc#lexer#token_type.int
  else
    throw 'Exception: Not int.'
  endif

  return 1
endfunction

function! s:lexer.lex_digit() abort
  let self.val = 0
  while 1
    let c = self.reader.read()
    if c < 0
      break
    elseif c !~ '\d'
      call self.reader.unread()
      break
    endif

    let self.val = self.val * 10 + c
  endwhile
endfunction

function! s:lexer.skip_spaces() abort
  while 1
    let c = self.reader.read()
    if c < 0
      break
    elseif c !~ '\s'
      call self.reader.unread()
      break
    endif
  endwhile
endfunction

function! s:lexer.token() abort
  return self.tok
endfunction

function! s:lexer.value() abort
  return self.val
endfunction

function! vimproc#lexer#init_reader(text) abort
  let reader = deepcopy(s:reader)
  let reader.text = split(a:text, '\zs')
  let reader.pos = 0

  return reader
endfunction

let s:reader = {}

function! s:reader.read() abort
  if self.pos >= len(self.text)
    " Buffer over.
    return -1
  endif

  let c = self.text[self.pos]
  let self.pos += 1

  return c
endfunction

function! s:reader.unread() abort
  let self.pos -= 1
endfunction


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
" vim:foldmethod=marker:fen:sw=2:sts=2
