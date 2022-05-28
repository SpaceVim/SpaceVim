let s:suite = themis#suite('cipher')
let s:assert = themis#helper('assert')

function! s:suite.cipher_string()
  call s:assert.equals(calendar#cipher#cipher('', 0), '')
  call s:assert.equals(calendar#cipher#cipher('', 100), '')
  call s:assert.equals(calendar#cipher#cipher('ABCDEabcde012345!#%+,-/@[]', 0), 'ABCDEabcde012345!#%+,-/@[]')
  call s:assert.equals(calendar#cipher#cipher('ABCDEabcde012345!#%+,-/@[]', 100), 'FGHIJfghij56789:&(*0124E`b')
endfunction

function! s:suite.cipher_number()
  call s:assert.equals(calendar#cipher#cipher(0, 0), '0')
  call s:assert.equals(calendar#cipher#cipher(0, 100), '5')
  call s:assert.equals(calendar#cipher#cipher(16777216, 0), '16777216')
  call s:assert.equals(calendar#cipher#cipher(16777216, 100), '6;<<<76;')
endfunction

function! s:suite.cipher_array()
  call s:assert.equals(calendar#cipher#cipher([], 0), [])
  call s:assert.equals(calendar#cipher#cipher([0, 1, 2], 0), ['0', '1', '2'])
  call s:assert.equals(calendar#cipher#cipher([0, 1, 2], 100), ['5', '6', '7'])
  call s:assert.equals(calendar#cipher#cipher(['65536', '16777216', '4294967296'], 100), [';::8;', '6;<<<76;', '97>9>;<7>;'])
endfunction

function! s:suite.cipher_object()
  call s:assert.equals(calendar#cipher#cipher({}, 100), {})
  call s:assert.equals(calendar#cipher#cipher(
        \ { 'foo': [ '0', { 'bar': 16777216 }, [] ], 'bar': { 'baz': 'qux' }, 'quux': 'qux' }, 100),
        \ { 'foo': [ '5', { 'bar': '6;<<<76;' }, [] ], 'bar': { 'baz': 'vz}' }, 'quux': 'vz}' })
endfunction

function! s:suite.decipher_string()
  call s:assert.equals(calendar#cipher#decipher('', 0), '')
  call s:assert.equals(calendar#cipher#decipher('', 100), '')
  call s:assert.equals(calendar#cipher#decipher('ABCDEabcde012345!#%+,-/@[]', 0), 'ABCDEabcde012345!#%+,-/@[]')
  call s:assert.equals(calendar#cipher#decipher('FGHIJfghij56789:&(*0124E`b', 100), 'ABCDEabcde012345!#%+,-/@[]')
endfunction

function! s:suite.decipher_number()
  call s:assert.equals(calendar#cipher#decipher('0', 0), 0)
  call s:assert.equals(calendar#cipher#decipher('5', 100), 0)
  call s:assert.equals(calendar#cipher#decipher('16777216', 0), 16777216)
  call s:assert.equals(calendar#cipher#decipher('6;<<<76;', 100), 16777216)
endfunction

function! s:suite.decipher_array()
  call s:assert.equals(calendar#cipher#decipher([], 0), [])
  call s:assert.equals(calendar#cipher#decipher(['0', '1', '2'], 0), ['0', '1', '2'])
  call s:assert.equals(calendar#cipher#decipher(['5', '6', '7'], 100), ['0', '1', '2'])
  call s:assert.equals(calendar#cipher#decipher([';::8;', '6;<<<76;', '97>9>;<7>;'], 100), ['65536', '16777216', '4294967296'])
endfunction

function! s:suite.decipher_object()
  call s:assert.equals(calendar#cipher#decipher({}, 100), {})
  call s:assert.equals(calendar#cipher#decipher(
        \ { 'foo': [ '5', { 'bar': '6;<<<76;' }, [] ], 'bar': { 'baz': 'vz}' }, 'quux': 'vz}' }, 100),
        \ { 'foo': [ '0', { 'bar': '16777216' }, [] ], 'bar': { 'baz': 'qux' }, 'quux': 'qux' })
endfunction
