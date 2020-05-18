" set verbose=1

let s:suite = themis#suite('install_base')
let s:assert = themis#helper('assert')

function! s:suite.rm() abort
  let temp = tempname()
  call writefile([], temp)

  call dein#install#_rm(temp)

  call s:assert.equals(filereadable(temp), 0)
endfunction

function! s:suite.copy_directories() abort
  let temp = tempname()
  let temp2 = tempname()
  let temp3 = tempname()

  call mkdir(temp)
  call mkdir(temp2)
  call mkdir(temp3)
  call writefile([], temp.'/foo')
  call writefile([], temp3.'/bar')
  call s:assert.true(filereadable(temp.'/foo'))
  call s:assert.true(filereadable(temp3.'/bar'))

  call dein#install#_copy_directories([temp, temp3], temp2)

  call s:assert.true(isdirectory(temp2))
  call s:assert.true(filereadable(temp2.'/foo'))
  call s:assert.true(filereadable(temp2.'/bar'))
endfunction

function! s:suite.args2string() abort
  call s:assert.equals(
        \ dein#install#_args2string_unix(['foo', 'bar']), "'foo' 'bar'")
  call s:assert.equals(
        \ dein#install#_args2string_windows([]), '')
  call s:assert.equals(
        \ dein#install#_args2string_windows(['foo']), 'foo')
  call s:assert.equals(
        \ dein#install#_args2string_windows(['foo', 'bar']), 'foo "bar"')
  call s:assert.equals(
        \ dein#install#_args2string_windows(['fo o', 'bar']), '"fo o" "bar"')
endfunction
