let s:suite = themis#suite('fopen')
let s:assert = themis#helper('assert')
call themis#helper('command').with(s:)

let s:filename = 'test.txt'
let s:contents = ['foo', 'bar']

function! s:suite.before_each() abort
  call writefile(s:contents, s:filename, 'b')
endfunction

function! s:suite.after_each() abort
  if filereadable(s:filename)
    call delete(s:filename)
  endif
endfunction

function! s:suite.read() abort
  let file = vimproc#fopen(s:filename)
  let res = file.read()

  call s:assert.true(file.is_valid)

  call file.close()

  call s:assert.false(file.is_valid)

  call s:assert.equals(
        \ readfile(s:filename),
        \ split(res, '\r\n\|\r\|\n'))
endfunction

function! s:suite.read_lines() abort
  let file = vimproc#fopen(s:filename, 'r')
  let res = file.read_lines()

  call s:assert.true(file.is_valid)

  call file.close()

  call s:assert.false(file.is_valid)

  call s:assert.equals(
        \ readfile(s:filename, 'b'), res)
endfunction

function! s:suite.read_line() abort
  let file = vimproc#fopen(s:filename, 'r', 0)
  let res = []
  while !file.eof
    let res += [file.read_line()]
  endwhile

  call s:assert.true(file.is_valid)

  call file.close()

  call s:assert.false(file.is_valid)

  call s:assert.equals(readfile(s:filename), res)
endfunction

function! s:suite.write() abort
  let file = vimproc#fopen(s:filename, 'w')
  let res = "hello\nvimproc\n.vim"

  call s:assert.true(file.is_valid)

  call file.write(res)
  call file.close()

  call s:assert.false(file.is_valid)

  call s:assert.equals(
        \ readfile(s:filename),
        \ split(res, '\r\n\|\r\|\n'))
endfunction

function! s:suite.append() abort
  let file = vimproc#fopen(s:filename, 'a')
  let res = "\nhello\nvimproc\n.vim"

  call s:assert.true(file.is_valid)

  call file.write(res)
  call file.close()

  call s:assert.false(file.is_valid)

  call s:assert.equals(
        \ readfile(s:filename),
        \ s:contents + split(res, '\r\n\|\r\|\n'))
endfunction

function! s:suite.read_write() abort
  let file = vimproc#fopen(s:filename, 'r+')
  let res = file.read()

  call s:assert.equals(
        \ readfile(s:filename),
        \ split(res, '\r\n\|\r\|\n'))

  call s:assert.true(file.is_valid)

  let res = "\nhello\nvimproc\n.vim"
  call file.write(res)
  call file.close()

  call s:assert.false(file.is_valid)

  call s:assert.equals(
        \ readfile(s:filename),
        \ s:contents + split(res, '\r\n\|\r\|\n'))
endfunction

function! s:suite.with_oflag() abort
  let file = vimproc#fopen(s:filename, 'O_RDONLY')
  let res = file.read()

  call s:assert.true(file.is_valid)

  call file.close()

  call s:assert.false(file.is_valid)

  call s:assert.equals(
        \ readfile(s:filename),
        \ split(res, '\r\n\|\r\|\n'))

  let file = vimproc#fopen(s:filename, 'O_WRONLY|O_TRUNC')
  let res = "hello\nvimproc\n.vim"
  call file.write(res)

  call s:assert.true(file.is_valid)

  call file.close()

  call s:assert.false(file.is_valid)

  call s:assert.equals(
        \ readfile(s:filename),
        \ split(res, '\r\n\|\r\|\n'))

  let file = vimproc#fopen(s:filename, 'O_RDWR|O_APPEND')
  let res2 = "\nworld\n!"
  call file.write(res2)

  call s:assert.true(file.is_valid)

  call file.close()

  call s:assert.false(file.is_valid)

  call s:assert.equals(
        \ readfile(s:filename),
        \ split(res . res2, '\r\n\|\r\|\n'))
endfunction

function! s:suite.invalid_fmode() abort
  let file = vimproc#fopen(s:filename, 'r')

  Throws /write() error/ file.write('foo')

  call file.close()

  call s:assert.equals(readfile(s:filename), s:contents)

  let file = vimproc#fopen(s:filename, 'w')

  Throws /read() error/ file.read()

  call file.close()

  call s:assert.true(empty(readfile(s:filename)))
endfunction

" vim:foldmethod=marker:fen:
