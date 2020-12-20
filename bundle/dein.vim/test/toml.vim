let s:suite = themis#suite('toml')
let s:assert = themis#helper('assert')

function! s:suite.before_each() abort
  let g:temp = tempname()
endfunction

function! s:suite.after_each() abort
  call delete(g:temp)
endfunction

function! s:suite.normal() abort
  call writefile([
        \ '# This is a TOML document.',
        \ '',
        \ 'title = "TOML Example"',
        \ 'foo = {i = ''Plug''}',
        \ 'map = {i = "Plug", c = "Plug"}',
        \ '',
        \ '[owner]',
        \ 'name = "Tom Preston-Werner"',
        \ 'dob = 1979 # First class dates',
        \ ], g:temp)
  call s:assert.equals(dein#toml#parse_file(g:temp), {
        \ 'title': 'TOML Example',
        \ 'foo': {'i': 'Plug'},
        \ 'map': {'i': 'Plug', 'c': 'Plug'},
        \ 'owner': {'name': 'Tom Preston-Werner', 'dob': 1979}
        \ })
  call writefile([
        \ '[[foo]]',
        \ '[[foo]]',
        \ '[foo.ftplugin]',
        \ 'c = "let g:bar = 0"',
        \ ], g:temp)
  call s:assert.equals(dein#toml#parse_file(g:temp), {
        \ 'foo': [{}, {'ftplugin': {'c': 'let g:bar = 0'}}]
        \ })
endfunction
