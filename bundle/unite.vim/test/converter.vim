let s:suite = themis#suite('parser')
let s:assert = themis#helper('assert')

function! s:suite.common_string() abort
  call s:assert.equals(unite#filters#common_string([]), '')
  call s:assert.equals(unite#filters#common_string(
        \ [ '/foo/bar' ]), '/foo/')
  call s:assert.equals(unite#filters#common_string(
        \ [ '/foo/bar', '/bar/bar' ]), '/')
  call s:assert.equals(unite#filters#common_string(
        \ [ '/foo/bar', '/foo/bar' ]), '/foo/')
  call s:assert.equals(unite#filters#common_string(
        \ [ '/bar', '/bar' ]), '/')
  call s:assert.equals(unite#filters#common_string(
        \ [ '/foo/baz/bar/', '/foo/bar/bar/' ]), '/foo/')
endfunction

function! s:suite.uniq() abort
  call s:assert.equals(unite#filters#uniq(
        \ [ '/foo/bar' ]), ['bar'])
  call s:assert.equals(unite#filters#uniq(
        \ [ '/foo/bar', '/bar/bar' ]), ['/foo/bar', '/bar/bar'])
  call s:assert.equals(unite#filters#uniq(
        \ [ '/foo/baz/bar', '/foo/bar/bar' ]),
        \ ['.../baz/bar', '.../bar/bar'])
  call s:assert.equals(unite#filters#uniq(
        \ [ '/Users/Pedro/OneDrive/queries.py',
        \   '/Users/Pedro/Desktop/queries.py' ]),
        \ ['.../OneDrive/queries.py', '.../Desktop/queries.py'])
  call s:assert.equals(unite#filters#uniq(
        \ [ '/foo/baz/bar/', '/foo/bar/bar/' ]),
        \ ['.../baz/bar/', '.../bar/bar/'])
  call s:assert.equals(unite#filters#uniq(
        \ [ '/foo/bar/bar', '/foo/bar/bar' ]),
        \ ['.../bar', '.../bar'])
endfunction

" vim:foldmethod=marker:fen:
