" set verbose=1
let s:suite = themis#suite('raw')
let s:assert = themis#helper('assert')

let s:type = dein#types#raw#define()
let s:path = tempname()
let s:base = s:path . '/repos/'

function! s:suite.protocol() abort
  " Protocol errors
  call s:assert.equals(s:type.init(
        \ 'http://raw.githubusercontent.com/Shougo/'
        \ . 'shougo-s-github/master/vim/colors/candy.vim', {}),
        \ {})
endfunction

function! s:suite.init() abort
  call dein#begin(s:path)
  call s:assert.equals(s:type.init(
        \ 'https://raw.githubusercontent.com/Shougo/'
        \ . 'shougo-s-github/master/vim/colors/candy.vim',
        \ {'script_type': 'colors'}),
        \ { 'type': 'raw', 'name': 'candy.vim',
        \   'path': s:base . 'raw.githubusercontent.com/Shougo/'
        \ . 'shougo-s-github/master/vim/colors' })
  call dein#end()
endfunction
