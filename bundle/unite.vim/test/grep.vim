let s:suite = themis#suite('parser')
let s:assert = themis#helper('assert')

function! s:suite.source() abort
  call s:assert.equals(unite#sources#grep#parse(
        \ 'foo:1:bar'), ['foo', '1', '0', 'bar'])
  call s:assert.equals(unite#sources#grep#parse(
        \ 'C:/foo:1:bar'), ['C:/foo', '1', '0', 'bar'])
  call s:assert.equals(unite#sources#grep#parse(
        \ 'C:/foo:1:0:bar'), ['C:/foo', '1', '0', 'bar'])
endfunction

" vim:foldmethod=marker:fen:
