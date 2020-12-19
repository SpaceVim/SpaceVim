let s:suite = themis#suite('popen')
let s:assert = themis#helper('assert')

function! s:suite.popen2() abort
  if !vimproc#util#is_windows() && !executable('ls')
    call s:assert.skip('ls command is not installed.')
    return
  endif

  if vimproc#util#is_windows()
    let cmd = ['cmd', '/c', 'DIR', '/B']
  else
    let cmd = ['ls']
  endif
  let sub = vimproc#popen2(cmd)
  let res = ''
  while !sub.stdout.eof
    let res .= sub.stdout.read()
  endwhile
  " Newline conversion.
  let res = substitute(res, '\r\n', '\n', 'g')

  call s:assert.true(sub.is_valid)

  let [cond, status] = sub.waitpid()

  call s:assert.equals(cond, 'exit')

  call s:assert.equals(status, 0)

  call s:assert.false(sub.is_valid)

  call s:assert.equals(res, system(join(cmd)))

  unlet cmd
  unlet sub

  if vimproc#util#is_windows()
    let cmd = ['cmd', '/c', 'DIR', '/B', '/A']
  else
    let cmd = ['ls', '-la']
  endif
  let sub = vimproc#popen2(cmd)
  let res = ''
  while !sub.stdout.eof
    let res .= sub.stdout.read()
  endwhile
  " Newline conversion.
  let res = substitute(res, '\r\n', '\n', 'g')

  call s:assert.true(sub.is_valid)

  let [cond, status] = sub.waitpid()

  call s:assert.equals(cond, 'exit')

  call s:assert.equals(status, 0)

  call s:assert.false(sub.is_valid)

  call s:assert.equals(res, system(join(cmd)))

  unlet cmd
  unlet sub
endfunction

function! s:suite.popen3() abort
  if vimproc#util#is_windows()
    let cmd = ['cmd', '/c', 'DIR', '/B']
  else
    let cmd = ['ls']
  endif
  let sub = vimproc#popen3(cmd)
  let res = ''
  while !sub.stdout.eof
    let res .= sub.stdout.read()
  endwhile
  " Newline conversion.
  let res = substitute(res, '\r\n', '\n', 'g')

  call s:assert.true(sub.is_valid)

  let [cond, status] = sub.waitpid()

  call s:assert.equals(cond, 'exit')

  call s:assert.equals(status, 0)

  call s:assert.false(sub.is_valid)

  call s:assert.equals(res, system(join(cmd)))

  unlet cmd
  unlet sub
endfunction

function! s:suite.redirection1() abort
  let output = vimproc#system('echo "foo" > test.txt | echo "bar"')
  call s:assert.equals(output, "bar\n")
  sleep 3
  call s:assert.equals(readfile('test.txt'), ['foo'])
  if filereadable('test.txt')
    call delete('test.txt')
  endif
endfunction

function! s:suite.redirection2() abort
  let sub = vimproc#ptyopen('echo "foo" > test.txt | echo "bar"')
  let res = ''
  while !sub.stdout.eof
    let res .= sub.stdout.read()
  endwhile
  " Newline conversion.
  let res = substitute(res, '\r\n', '\n', 'g')
  sleep 3
  call s:assert.equals(readfile('test.txt'), ['foo'])
  if filereadable('test.txt')
    call delete('test.txt')
  endif
endfunction

" vim:foldmethod=marker:fen:
