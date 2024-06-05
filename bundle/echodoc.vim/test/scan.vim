scriptencoding utf8

let s:scan = themis#suite('Function scanning')

function! s:scan.basic() abort
  Setup
  call FeedScan('ixxx(', 'xxx(')
  call FeedScan('a)', '')
  call FeedScan('i', 'xxx(')
  call FeedScan('a<cr>', "xxx(\n")
  call FeedScan('a)', '')
  call FeedScan('a)', '')
  call FeedScan('a((', '')
  Teardown
endfunction


function! s:scan.single_char_func_name() abort
  Setup
  call FeedScan('ix()', '')
  call FeedScan('i', 'x(')
  Teardown
endfunction


function! s:scan.single_char_func_name_space() abort
  Setup
  call FeedScan('icall x()', '')
  call FeedScan('i', 'x(')
  Teardown
endfunction


function! s:scan.nested_func() abort
  Setup
  call FeedScan('ix(y(', 'y(')
  call FeedScan('a)', 'x(y()')
  call FeedScan('A,<cr>z', "x(y(),\nz")
  call FeedScan('A(', 'z(')
  Teardown
endfunction


function! s:scan.non_func_paren() abort
  Setup
  call FeedScan('ixxx((1, 2, 3),', 'xxx((1, 2, 3),')
  call FeedScan('2hCyyy(', 'yyy(')
  call FeedScan('A)', 'xxx((1, 2, yyy()')
  Teardown

  Setup
  call FeedScan('ixxx\((', '')
  Teardown

  Setup
  call FeedScan('ixxx ((', 'xxx ((')
  Teardown
endfunction


function! s:scan.skip_strings() abort
  Setup
  call FeedScan('ixxx("yyy(",', 'xxx("yyy(",')
  Teardown

  Setup
  call FeedScan('ixxx(`yyy(`,', 'xxx(`yyy(`,')
  Teardown

  " Ensure escaped delimiters are skipped.
  Setup
  call FeedScan('ixxx("yyy(\"",', 'xxx("yyy(\"",')
  Teardown

  Setup
  call FeedScan('ixxx(`yyy(\``,', 'xxx(`yyy(\``,')
  Teardown

  " Ensure string skipping isn't confused by other string delimiters.
  Setup
  call FeedScan('ixxx("yyy(''`",', 'xxx("yyy(''`",')
  Teardown

  Setup
  call FeedScan('ixxx(`yyy(''"`,', 'xxx(`yyy(''"`,')
  Teardown
endfunction


function! s:scan.multiline() abort
  Setup
  call FeedScan('ixxx(<cr>', "xxx(\n")
  call FeedScan('a<cr>', '')
  let b:echodoc_max_blank_lines = 2
  call FeedScan('a', "xxx(\n\n")
  Teardown

  Setup
  let b:echodoc_max_blank_lines = 0
  call FeedScan('ixxx(<cr>', "xxx(\n")
  call FeedScan('a<cr>', '')
  Teardown

  Setup
  let b:echodoc_max_blank_lines = 100
  let crs = repeat('<cr>aaa,', 4)
  let nls = substitute(crs, '<cr>', "\n", 'g')
  call FeedScan('ixxx('.crs, 'xxx('.nls)
  call FeedScan('a<cr>', '')
  Teardown
endfunction


function! s:scan.multibyte() abort
  Setup
  call FeedScan('i幸運のための河童頭の上におなら(',
        \ '幸運のための河童頭の上におなら(')
  call FeedScan('A(💨,(🐸 + 🐢), "✨🍀✨"',
        \ '幸運のための河童頭の上におなら((💨,(🐸 + 🐢), "✨🍀✨"')
  call FeedScan('A))', '')
  Teardown

  Setup
  call FeedScan('i悪い翻訳者(<cr>', "悪い翻訳者(\n")
  call FeedScan('a"כובע חגיגי",<cr>', "悪い翻訳者(\n\"כובע חגיגי\",\n")
  call FeedScan('a"شعر الصدر"', "悪い翻訳者(\n\"כובע חגיגי\",\n\"شعر الصدر\"")
  Teardown
endfunction
