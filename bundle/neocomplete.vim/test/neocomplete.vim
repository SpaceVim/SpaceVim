
let s:suite = themis#suite('parser')
let s:assert = themis#helper('assert')

function! s:suite.escape() abort
  call s:assert.equals(
        \ neocomplete#filters#fuzzy_escape('abc'), 'a.*b.*c.*')
  call s:assert.equals(
        \ neocomplete#filters#fuzzy_escape('%a%b%c'), '%%a.*%%b.*%%c.*')
  call s:assert.equals(
        \ neocomplete#filters#fuzzy_escape('%[ab]c'), '%%%[a.*b.*%]c.*')
  call s:assert.equals(
        \ neocomplete#filters#fuzzy_escape('.abc'), '%.a.*b.*c.*')
endfunction

function! s:suite.sort() abort
  let candidates = []
  for i in range(1, 1000)
    call add(candidates, { 'word' : i, 'rank' : i })
  endfor
  function! CompareRank(i1, i2) abort
    let diff = (get(a:i2, 'rank', 0) - get(a:i1, 'rank', 0))
    return (diff != 0) ? diff : (len(a:i1.word) < len(a:i2.word)) ? 1 : -1
  endfunction"

  " Benchmark.
  let start = reltime()
  call sort(copy(candidates), 'CompareRank')
  echomsg reltimestr(reltime(start))
  let start = reltime()
  call neocomplete#filters#sorter_rank#define().filter(
        \   {'candidates' : copy(candidates), 'input' : '' })
  echomsg reltimestr(reltime(start))

  call s:assert.equals(sort(copy(candidates), 'CompareRank'),
        \ neocomplete#filters#sorter_rank#define().filter(
        \   {'candidates' : copy(candidates), 'input' : '' }))
endfunction

function! s:suite.fuzzy() abort
  call s:assert.equals(neocomplete#filters#matcher_fuzzy#define().filter(
        \ {'complete_str' : 'ae', 'candidates' : ['~/~']}), [])
endfunction

function! s:suite.overlap() abort
  call s:assert.equals(neocomplete#filters#converter_remove_overlap#
        \length('foo bar', 'bar baz'), 3)
  call s:assert.equals(neocomplete#filters#converter_remove_overlap#
        \length('foobar', 'barbaz'), 3)
  call s:assert.equals(neocomplete#filters#converter_remove_overlap#
        \length('foob', 'baz'), 1)
  call s:assert.equals(neocomplete#filters#converter_remove_overlap#
        \length('foobar', 'foobar'), 6)
  call s:assert.equals(neocomplete#filters#converter_remove_overlap#
        \length('тест', 'ст'), len('ст'))
endfunction

" vim:foldmethod=marker:fen:
