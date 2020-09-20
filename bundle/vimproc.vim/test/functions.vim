let s:suite = themis#suite('functions')
let s:assert = themis#helper('assert')

function! s:suite.functions() abort
  let errmsg_save = v:exception
  call s:assert.true(vimproc#kill(9999, 0))
  call s:assert.not_equals(errmsg_save, vimproc#get_last_errmsg())
endfunction

" vim:foldmethod=marker:fen:
