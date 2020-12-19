let s:suite = themis#suite('highlight')
let s:assert = themis#helper('assert')

" Helper:
function! s:add_line(str)
  put! =a:str
endfunction
function! s:add_lines(lines)
  for line in reverse(a:lines)
    put! =line
  endfor
endfunction
function! s:get_pos_char()
  return getline('.')[col('.')-1]
endfunction

function! s:reset_buffer()
  :1,$ delete
  call s:add_lines(s:line_texts)
  normal! Gddgg0zt
endfunction

function! s:suite.before()
  set wrapscan&
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  let s:line_texts = ['1pattern_a', '2pattern_b', '3pattern_c', '4pattern_d', '5pattern_e']
  call s:reset_buffer()
endfunction

function! s:suite.after()
  :1,$ delete
endfunction

function! s:suite.before_each()
  :1
  call s:assert.equals(s:get_pos_char(), '1')
  call clearmatches()
  call s:assert.equals(getmatches(), [])
endfunction

function! s:suite.hlsearch()
  if !exists('v:hlsearch')
    call s:assert.skip("Skip because vim version are too low to test it")
  endif
  set hlsearch
  " FIXME: <- why...???
  for keyseq in ['/', '?', 'g/']
    nohlsearch
    call s:assert.equals(v:hlsearch, 0)
    exec "normal" keyseq . "pattern\<CR>"
    call s:assert.equals(v:hlsearch, 1)
  endfor
  nohlsearch
  call s:assert.equals(v:hlsearch, 0)
  exec "normal!" "hl" | " dummy
  call s:assert.equals(v:hlsearch, 0)
  set hlsearch&
endfunction

function! s:suite.preserve_nohlsearch() abort
  for keyseq in ['/', '?', 'g/']
    set nohlsearch
    nohlsearch
    call s:assert.equals(&hlsearch, 0)
    exec "normal" keyseq . "pattern\<CR>"
    call s:assert.equals(&hlsearch, 0)
  endfor
  set hlsearch&
endfunction

function! s:suite.incremental_highlight()
  call incsearch#highlight#incremental_highlight('\vvimvimvim')
  call s:assert.equals(len(getmatches()), 3)
  let groups = map(getmatches(), 'v:val.group')
  let patterns = map(getmatches(), 'v:val.pattern')
  call s:assert.not_equals(index(groups, 'IncSearchMatch'), -1)
  call s:assert.not_equals(index(groups, 'IncSearchCursor'), -1)
  call s:assert.not_equals(index(groups, 'IncSearchOnCursor'), -1)
  call s:assert.not_equals(index(patterns, '\vvimvimvim'), -1)
endfunction

function! s:suite.incremental_separate_highlight()
  call incsearch#highlight#incremental_highlight('\vpattern_', 1, 1, [2,2])
  call s:assert.equals(len(getmatches()), 4)
  let groups = map(getmatches(), 'v:val.group')
  let patterns = map(getmatches(), 'v:val.pattern')
  call s:assert.not_equals(index(groups, 'IncSearchMatch'), -1)
  call s:assert.not_equals(index(groups, 'IncSearchCursor'), -1)
  call s:assert.not_equals(index(groups, 'IncSearchOnCursor'), -1)
  call s:assert.not_equals(index(groups, 'IncSearchMatchReverse'), -1)
  call s:assert.equals(index(patterns, '\vpattern_'), -1)
  call s:assert.not_equals(index(patterns, '\v(%>2l|%2l%>2c)\m\(\vpattern_\m\)'), -1)
  call s:assert.not_equals(index(patterns, '\v(%<2l|%2l%<2c)\m\(\vpattern_\m\)'), -1)
  " Make sure all patterns valid by calling with search() and see
  " it won't throw any errors
  for p in patterns
    normal! gg
    call search(p, 'n')
  endfor
endfunction

function! s:suite.forward_pattern()
  let U = incsearch#util#import()
  let L = vital#incsearch#new().import('Data.List')
  let from = [3,3]
  let pat = incsearch#highlight#forward_pattern('pattern', from)
  :1
  let pos = searchpos(pat, 'n')
  let pos2 = searchpos('pattern', 'n')
  call s:assert.true(U.is_pos_less_equal(from, pos))
  call s:assert.false(U.is_pos_less_equal(from, pos2))
  let poses = []
  for _ in range(10)
    let poses += [searchpos(pat)]
  endfor
  let poses = L.uniq(poses)
  for p in poses
    call s:assert.true(U.is_pos_less_equal(from, p))
  endfor
  call s:assert.equals(poses, [[4,2],[5,2]])
endfunction

function! s:suite.backward_pattern()
  let U = incsearch#util#import()
  let L = vital#incsearch#new().import('Data.List')
  let from = [3,3]
  let pat = incsearch#highlight#backward_pattern('pattern', from)
  :$
  let pos = searchpos(pat, 'bn')
  let pos2 = searchpos('pattern', 'bn')
  call s:assert.true(U.is_pos_less_equal(pos, from))
  call s:assert.false(U.is_pos_less_equal(pos2, from))
  let poses = []
  for _ in range(10)
    let poses += [searchpos(pat, 'b')]
  endfor
  let poses = L.uniq(poses)
  for p in poses
    call s:assert.true(U.is_pos_less_equal(pos, from))
  endfor
  call s:assert.equals(poses, [[3, 2], [2, 2], [1, 2]])
endfunction

function! s:suite.separate_highlight_with_searching()
  " XXX: it just test scripts works or not
  let g:incsearch#separate_highlight = 1
  for keyseq in ['/', '?', 'g/']
    exec "normal" keyseq . "pattern\<CR>"
  endfor
  let g:incsearch#separate_highlight = 0
  for keyseq in ['/', '?', 'g/']
    exec "normal" keyseq . "pattern\<CR>"
  endfor
endfunction
