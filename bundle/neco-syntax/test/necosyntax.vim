let s:suite = themis#suite('parser')
let s:assert = themis#helper('assert')

function! s:suite.syntax() abort
  call s:assert.equals(sort(necosyntax#_split_pattern(
        \ '\(d\|e\|f\)', '')),
        \ ['d', 'e', 'f'])
  call s:assert.equals(sort(necosyntax#_split_pattern(
        \ '\(a\|b\)-c', '')),
        \ ['a-c', 'b-c'])
  call s:assert.equals(sort(necosyntax#_split_pattern(
        \ 'c\(d\|e\|f\)', '')),
        \ ['cd', 'ce', 'cf'])
  call s:assert.equals(sort(necosyntax#_split_pattern(
        \ '\(a\|b\)c\(d\|e\|f\)', '')),
        \ ['acd', 'ace', 'acf', 'bcd', 'bce', 'bcf'])
  call s:assert.equals(sort(necosyntax#_split_pattern(
        \ '\\\%(dump\|end\|jobname\)', '')),
        \ ['\dump', '\end', '\jobname'])
endfunction
