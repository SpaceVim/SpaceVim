let s:suite = themis#suite('socket')
let s:assert = themis#helper('assert')

function! s:suite.socket() abort
  call s:assert.true(vimproc#host_exists(
        \ 'www.yahoo.com'))
  call s:assert.true(vimproc#host_exists(
        \ 'https://www.yahoo.com'))
  call s:assert.true(vimproc#host_exists(
        \ 'https://www.yahoo.com/hoge/piyo'))

  let sock = vimproc#socket_open('www.yahoo.com', 80)
  call sock.write("GET / HTTP/1.0\r\n\r\n", 100)
  let res = ''
  let out = sock.read(-1, 100)
  while !sock.eof && out != ''
    let out = sock.read(-1, 100)
    let res .= out
  endwhile

  call s:assert.true(sock.is_valid)

  call sock.close()

  call s:assert.false(sock.is_valid)

  echo res
endfunction

" vim:foldmethod=marker:fen:
