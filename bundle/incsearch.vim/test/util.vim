let s:suite = themis#suite('util')
let s:assert = themis#helper('assert')

function! s:suite.after_each()
  set ignorecase& smartcase&
endfunction

function! s:suite.parse_pattern()
  call s:assert.equals(
  \   incsearch#parse_pattern('pattern/e', '/'),  ['pattern', 'e'])
  call s:assert.equals(
  \   incsearch#parse_pattern('{pattern\/pattern}/{offset}', '/'),
  \   ['{pattern\/pattern}', '{offset}'])
  call s:assert.equals(
  \   incsearch#parse_pattern('{pattern}/;/{newpattern} :h //;', '/'),
  \   ['{pattern}', ';/{newpattern} :h //;'])
  call s:assert.equals(
  \   incsearch#parse_pattern('pattern?e', '?'),  ['pattern', 'e'])
  call s:assert.equals(
  \   incsearch#parse_pattern('pattern?e', '/'),  ['pattern?e', ''])
  call s:assert.equals(
  \   incsearch#parse_pattern('{pattern\?pattern}?{offset}', '?'),
  \   ['{pattern\?pattern}', '{offset}'])
endfunction

function! s:suite.detect_case()
  set noignorecase nosmartcase
  call s:assert.equals(incsearch#detect_case('pattern'), '\C')
  call s:assert.equals(incsearch#detect_case('PatterN'), '\C')
  set ignorecase nosmartcase
  call s:assert.equals(incsearch#detect_case('pattern'), '\c')
  call s:assert.equals(incsearch#detect_case('PatterN'), '\c')
  set noignorecase smartcase
  call s:assert.equals(incsearch#detect_case('pattern'), '\C')
  call s:assert.equals(incsearch#detect_case('PatterN'), '\C')
  set ignorecase smartcase
  call s:assert.equals(incsearch#detect_case('pattern'), '\c')
  call s:assert.equals(incsearch#detect_case('PatterN'), '\C')
endfunction

function! s:suite.detect_case_ignore_uppercase_escaped_letters()
  set noignorecase nosmartcase
  call s:assert.equals(incsearch#detect_case('\Vpattern'), '\C')
  call s:assert.equals(incsearch#detect_case('\VPatterN'), '\C')
  set ignorecase nosmartcase
  call s:assert.equals(incsearch#detect_case('\Vpattern'), '\c')
  call s:assert.equals(incsearch#detect_case('\VPatterN'), '\c')
  set noignorecase smartcase
  call s:assert.equals(incsearch#detect_case('\Vpattern'), '\C')
  call s:assert.equals(incsearch#detect_case('\VPatterN'), '\C')
  set ignorecase smartcase
  call s:assert.equals(incsearch#detect_case('\Vpattern'), '\c')
  call s:assert.equals(incsearch#detect_case('\VPatterN'), '\C')
endfunction

function! s:suite.detect_case_explicit_flag()
  set noignorecase nosmartcase
  call s:assert.equals(incsearch#detect_case('\cpattern'), '\c')
  call s:assert.equals(incsearch#detect_case('\Cpattern'), '\C')
  call s:assert.equals(incsearch#detect_case('\CPatterN'), '\C')
  call s:assert.equals(incsearch#detect_case('\cPatterN'), '\c')
  set ignorecase nosmartcase
  call s:assert.equals(incsearch#detect_case('\cpattern'), '\c')
  call s:assert.equals(incsearch#detect_case('\Cpattern'), '\C')
  call s:assert.equals(incsearch#detect_case('\CPatterN'), '\C')
  call s:assert.equals(incsearch#detect_case('\cPatterN'), '\c')
  set noignorecase smartcase
  call s:assert.equals(incsearch#detect_case('\cpattern'), '\c')
  call s:assert.equals(incsearch#detect_case('\Cpattern'), '\C')
  call s:assert.equals(incsearch#detect_case('\CPatterN'), '\C')
  call s:assert.equals(incsearch#detect_case('\cPatterN'), '\c')
  set ignorecase smartcase
  call s:assert.equals(incsearch#detect_case('\cpattern'), '\c')
  call s:assert.equals(incsearch#detect_case('\Cpattern'), '\C')
  call s:assert.equals(incsearch#detect_case('\CPatterN'), '\C')
  call s:assert.equals(incsearch#detect_case('\cPatterN'), '\c')
endfunction

function! s:suite.detect_case_parcent()
  set ignorecase smartcase
  call s:assert.equals(incsearch#detect_case('\%Cpattern'), '\c')
  call s:assert.equals(incsearch#detect_case('\%Vpattern'), '\c')
  call s:assert.equals(incsearch#detect_case('\%Upattern'), '\c')
  call s:assert.equals(incsearch#detect_case('\%Apattern'), '\C')
  call s:assert.equals(incsearch#detect_case('\%V\%Vpattern'), '\c')
  call s:assert.equals(incsearch#detect_case('\V\Vpattern'), '\c')
endfunction
