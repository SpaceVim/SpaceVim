let s:suite = themis#suite('parser')
let s:assert = themis#helper('assert')

let g:kind = {
      \ 'name' : 'hoge',
      \ 'default_action' : 'open',
      \ 'action_table': {},
      \ }
let g:kind.action_table.open = {
      \ 'is_selectable' : 1,
      \ }
function! g:kind.action_table.open.func(candidate) abort
  echo 'hoge'
endfunction

let g:source = {
      \ 'name' : 'hoge',
      \ 'is_volatile' : 1,
      \ 'variables' : {'foo' : 'foo'}
      \}
function! g:source.gather_candidates(args, context) abort "{{{
  " Add dummy candidate.
  let g:candidates = [ a:context.input ]

  call map(g:candidates, '{
        \ "word" : v:val,
        \ "source" : "hoge",
        \ "kind" : "hoge",
        \}')

  return g:candidates
endfunction"}}}

function! s:suite.source() abort
  call s:assert.equals(unite#define_kind(g:kind), 0)

  call s:assert.equals(unite#define_source(g:source), 0)
  call s:assert.true(!empty(unite#get_all_sources(g:source.name)))

  call s:assert.equals(unite#undef_kind(g:kind.name), 0)

  call s:assert.equals(unite#undef_source(g:source.name), 0)
  call s:assert.true(empty(unite#get_all_sources(g:source.name)))
  call s:assert.equals(unite#define_source(g:source), 0)
endfunction

" vim:foldmethod=marker:fen:
