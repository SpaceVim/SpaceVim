let s:suite = themis#suite('toml')
let s:assert = themis#helper('assert')

function! s:suite.get_in_paren() abort
  call s:assert.equals(neosnippet#parser#_get_in_paren(
        \ '(', ')',
        \ '(foobar)'),
        \ 'foobar')
  call s:assert.equals(neosnippet#parser#_get_in_paren(
        \ '(', ')',
        \ '(foobar, baz)'),
        \ 'foobar, baz')
  call s:assert.equals(neosnippet#parser#_get_in_paren(
        \ '(', ')',
        \ '(foobar, (baz))'),
        \ 'foobar, (baz)')
  call s:assert.equals(neosnippet#parser#_get_in_paren(
        \ '(', ')',
        \ 'foobar('),
        \ '')
  call s:assert.equals(neosnippet#parser#_get_in_paren(
        \ '(', ')',
        \ 'foobar()'),
        \ '')
  call s:assert.equals(neosnippet#parser#_get_in_paren(
        \ '(', ')',
        \ 'foobar(fname)'),
        \ 'fname')
  call s:assert.equals(neosnippet#parser#_get_in_paren(
        \ '(', ')',
        \ 'wait()    wait(long, int)'),
        \ 'long, int')
  call s:assert.equals(neosnippet#parser#_get_in_paren(
        \ '(', ')',
        \ 'wait()    (long, int)'),
        \ '')
endfunction

function! s:suite.get_completed_snippet() abort
  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'foo(', 'abbr' : 'foo()',
        \ 'menu' : '', 'info' : ''
        \ }, 'foo(', ''), ')${1}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'foo(', 'abbr' : 'foo()',
        \ 'menu' : '', 'info' : ''
        \ }, 'foo)', ''), '')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'foo(', 'abbr' : '',
        \ 'menu' : '', 'info' : ''
        \ }, 'foo(', ''), '${1})${2}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'foo(', 'abbr' : 'foo(hoge)',
        \ 'menu' : '', 'info' : ''
        \ }, 'foo(', ''), '${1:#:hoge})${2}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'foo', 'abbr' : 'foo(hoge)',
        \ 'menu' : '', 'info' : ''
        \ }, 'foo', ''), '(${1:#:hoge})${2}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'foo(', 'abbr' : 'foo(hoge, piyo)',
        \ 'menu' : '', 'info' : ''
        \ }, 'foo(', ''), '${1:#:hoge}${2:#:, piyo})${3}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'foo(', 'abbr' : 'foo(hoge, piyo(foobar))',
        \ 'menu' : '', 'info' : ''
        \ }, 'foo(', ''), '${1:#:hoge}${2:#:, piyo()})${3}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'foo(', 'abbr' : 'foo(hoge[, abc])',
        \ 'menu' : '', 'info' : ''
        \ }, 'foo(', ''), '${1:#:hoge[, abc]})${2}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'foo(', 'abbr' : 'foo(...)',
        \ 'menu' : '', 'info' : ''
        \ }, 'foo(', ''), '${1:#:...})${2}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'foo(', 'abbr' : 'foo(hoge, ...)',
        \ 'menu' : '', 'info' : ''
        \ }, 'foo(', ''), '${1:#:hoge}${2:#:, ...})${3}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'Dictionary', 'abbr' : 'Dictionary<Key, Value>(foo)',
        \ 'menu' : '', 'info' : ''
        \ }, 'Dictionary', ''), '<${1:#:Key}${2:#:, Value}>(${3:#:foo})${4}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'Dictionary(',
        \ 'abbr' : 'Dictionary<Key, Value> Dictionary(foo)',
        \ 'menu' : '', 'info' : ''
        \ }, 'Dictionary(', ''), '${1:#:foo})${2}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'Dictionary(', 'abbr' : '',
        \ 'menu' : '', 'info' : ''
        \ }, 'Dictionary(', '('), '')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'Dictionary(', 'abbr' : 'Dictionary(foo)',
        \ 'menu' : '', 'info' : ''
        \ }, 'Dictionary(', '('), '')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'Dictionary(', 'abbr' : 'Dictionary(foo)',
        \ 'menu' : '', 'info' : ''
        \ }, 'Dictionary(', ')'), '${1:#:foo})${2}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'Dictionary', 'abbr' : 'Dictionary(foo)',
        \ 'menu' : '', 'info' : ''
        \ }, 'Dictionary', ''), '(${1:#:foo})${2}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'forEach', 'abbr' : 'forEach(BiConsumer<Object, Object>)',
        \ 'menu' : '', 'info' : ''
        \ }, 'forEach', ''), '(${1:#:BiConsumer<>})${2}')

  call s:assert.equals(neosnippet#parser#_get_completed_snippet({
        \ 'word' : 'something', 'abbr' : 'something(else)',
        \ 'menu' : '', 'info' : 'func()',
        \ }, 'something', ''), '(${1:#:else})${2}')
endfunction

