let s:suite = themis#suite('parser')
let s:assert = themis#helper('assert')

function! s:suite.vimoption2python() abort
  call s:assert.equals(
        \ deoplete#util#vimoption2python('@,48-57,_,\'), '[\w@0-9_\\]')
  call s:assert.equals(
        \ deoplete#util#vimoption2python('@,-,48-57,_'), '[\w@0-9_-]')
  call s:assert.equals(
        \ deoplete#util#vimoption2python('@,,,48-57,_'), '[\w@,0-9_]')
  call s:assert.equals(
        \ deoplete#util#versioncmp('0.1.10', '0.1.8'), 2)
  call s:assert.equals(
        \ deoplete#util#versioncmp('0.1.10', '0.1.10'), 0)
  call s:assert.equals(
        \ deoplete#util#versioncmp('0.1.10', '0.1.0010'), 0)
  call s:assert.equals(
        \ deoplete#util#versioncmp('0.1.1', '0.1.8'), -7)
  call s:assert.equals(
        \ deoplete#util#versioncmp('0.1.1000', '0.1.10'), 990)
  call s:assert.equals(
        \ deoplete#util#versioncmp('0.1.0001', '0.1.10'), -9)
  call s:assert.equals(
        \ deoplete#util#versioncmp('2.0.1', '1.3.5'), 9696)
  call s:assert.equals(
        \ deoplete#util#versioncmp('3.2.1', '0.0.0'), 30201)
  call s:assert.equals(
        \ deoplete#util#vimoption2python('45,48-57,65-90,95,97-122'),
        \ '[\w0-9A-Z_a-z-]')
  call s:assert.equals(
        \ deoplete#util#vimoption2python('33,35-39,42-43,45-58,60-90,94,95,97-122,126'),
        \ '[\w!#-''*-+\--:<-Z^_a-z~]')
  call s:assert.equals(
        \ deoplete#util#vimoption2python('33-45'), '[\w!-\-]')
endfunction
