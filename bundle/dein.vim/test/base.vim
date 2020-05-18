" set verbose=1

let s:suite = themis#suite('base')
let s:assert = themis#helper('assert')

let s:path = tempname()

function! s:suite.before_each() abort
  call dein#_init()
endfunction

function! s:suite.block_normal() abort
  call s:assert.equals(dein#begin(s:path), 0)
  call s:assert.equals(dein#end(), 0)

  call s:assert.equals(dein#begin(s:path), 0)
  call s:assert.equals(dein#end(), 0)
endfunction

function! s:suite.begin_invalid() abort
  call s:assert.equals(dein#begin(s:path), 0)
  call s:assert.equals(dein#begin(s:path), 1)

  call dein#_init()
  call s:assert.equals(dein#end(), 1)

  call s:assert.equals(dein#end(), 1)

  call s:assert.equals(dein#begin(getcwd() . '/plugin'), 1)
endfunction

function! s:suite.end_invalid() abort
  call s:assert.equals(dein#end(), 1)
endfunction

function! s:suite.add_normal() abort
  call s:assert.equals(dein#begin(s:path), 0)

  call dein#add('foo', {})
  call s:assert.equals(g:dein#_plugins.foo.name, 'foo')
  call dein#add('bar')
  call s:assert.equals(g:dein#_plugins.bar.name, 'bar')

  call s:assert.equals(dein#end(), 0)
endfunction

function! s:suite.add_overwrite() abort
  call s:assert.equals(dein#begin(s:path), 0)

  call dein#add('foo', {})
  call s:assert.equals(g:dein#_plugins.foo.sourced, 0)

  call dein#add('foo', { 'sourced': 1 })
  call s:assert.equals(g:dein#_plugins.foo.sourced, 1)

  call s:assert.equals(dein#end(), 0)
endfunction

function! s:suite.get() abort
  let plugins = { 'foo': {'name': 'bar'} }

  call dein#begin(s:path)
  call dein#add('foo', { 'name': 'bar' })
  call s:assert.equals(dein#get('bar').name, 'bar')
  call dein#add('foo')
  call s:assert.equals(dein#get('foo').name, 'foo')
  call dein#end()
endfunction

function! s:suite.expand() abort
  call s:assert.equals(dein#util#_expand('~'),
        \ dein#util#_substitute_path(fnamemodify('~', ':p')))
  call s:assert.equals(dein#util#_expand('$HOME'),
        \ dein#util#_substitute_path($HOME))
endfunction
