let s:suite = themis#suite('lexer')
let s:assert = themis#helper('assert')

function! s:suite.token() abort
  let lex = vimproc#lexer#init_lexer('1234 5678')
  call s:assert.true(lex.advance())
  call s:assert.equals(lex.token(), g:vimproc#lexer#token_type.int)
  call s:assert.true(lex.advance())
  call s:assert.equals(lex.token(), g:vimproc#lexer#token_type.int)
endfunction

function! s:suite.value() abort
  let lex = vimproc#lexer#init_lexer('1234 5678')
  call s:assert.true(lex.advance())
  call s:assert.equals(lex.value(), 1234)
  call s:assert.true(lex.advance())
  call s:assert.equals(lex.value(), 5678)
endfunction

" vim:foldmethod=marker:fen:
