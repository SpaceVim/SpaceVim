let s:suite = themis#suite('default_behaviors')
let s:assert = themis#helper('assert')

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Helper:
function! s:add_line(str)
  put! =a:str
endfunction
function! s:add_lines(lines)
  for line in reverse(a:lines)
    put! =line
  endfor
endfunction

function! s:assert.eq_with_default(command, default_command, pattern)
  let [x, y] = s:get_pos_with_default(a:command, a:default_command, a:pattern)
  call s:assert.equals(x,y)
endfunction

function! s:assert.not_eq_with_default(command, default_command, pattern)
  let [x, y] = s:get_pos_with_default(a:command, a:default_command, a:pattern)
  call s:assert.not_equals(x,y)
endfunction

function! s:get_pos_with_default(command, default_command, pattern)
  let w = winsaveview()
  silent! exec 'normal! ' . a:default_command . a:pattern . "\<CR>"
  " let x = getcurpos()
  let x = winsaveview()
  call winrestview(w)
  silent! exec 'normal ' . a:command . a:pattern . "\<CR>"
  " let y = getcurpos()
  let y = winsaveview()
  return [x, y]
endfunction

function! s:is_pos_less_equal(x, y) " x <= y
  return (a:x[0] == a:y[0]) ? a:x[1] <= a:y[1] : a:x[0] < a:y[0]
endfunction

function! s:get_pos_char()
  return getline('.')[col('.')-1]
endfunction

function! s:reset_buffer()
  :1,$ delete
  call s:add_lines(copy(s:line_texts))
  normal! Gddgg0zt
endfunction

function! s:suite.before()
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  let s:line_texts = [
  \     'pattern1 pattern2 pattern3'
  \   , 'pattern4 pattern5 pattern6'
  \ ]
  call s:reset_buffer()
endfunction

function! s:suite.before_each()
  :1
endfunction

function! s:suite.after()
  unmap /
  unmap ?
  unmap g/
  :1,$ delete
  set wrapscan&
endfunction


" Main:

function! s:suite.forward()
  set nowrapscan
  call s:assert.eq_with_default('/','/','pat')
  call s:assert.eq_with_default('/','/','pattern\d')
  normal! gg0
  call s:assert.eq_with_default('/','/','pattern1')
  call s:assert.eq_with_default('/','/','pattern2')
  call s:assert.eq_with_default('/','/','pattern3')
  set wrapscan
  normal! gg0
  call s:assert.eq_with_default('/','/','pattern2')
  call s:assert.eq_with_default('/','/','pattern1')

  " Handle empty input
  normal! gg0
  call s:assert.eq_with_default('/','/','pat')
  let x = getpos('.')
  call s:assert.eq_with_default('/','/','')
  let y = getpos('.')
  call s:assert.not_equals(x, y)
  call s:assert.true(s:is_pos_less_equal(x, y))
endfunction

function! s:suite.backward()
  set nowrapscan
  normal! G$
  call s:assert.eq_with_default('?','?','pattern3')
  call s:assert.eq_with_default('?','?','pattern2')
  call s:assert.eq_with_default('?','?','pattern1')
  normal! G$
  call s:assert.not_eq_with_default('?','/','pattern3')
  call s:assert.not_eq_with_default('?','/','pattern2')
  call s:assert.not_eq_with_default('?','/','pattern1')
  set wrapscan
  normal! gg0
  call s:assert.eq_with_default('?','?','pattern5')
  call s:assert.eq_with_default('?','/','pattern5')

  " Handle empty input
  normal! G$
  call s:assert.eq_with_default('?','?','pat')
  let x = getpos('.')[1:2]
  call s:assert.eq_with_default('?','?','')
  let y = getpos('.')[1:2]
  call s:assert.not_equals(x, y)
  call s:assert.true(s:is_pos_less_equal(y, x))
endfunction

function! s:suite.stay()
  set nowrapscan
  normal! gg0
  " let c = getcurpos()
  let c = winsaveview()
  call s:assert.not_eq_with_default('g/','/','pat')
  " call s:assert.equals(getcurpos(), c)
  call s:assert.equals(winsaveview(), c)
  set wrapscan
  call s:assert.not_eq_with_default('g/','/','pat')
  " call s:assert.equals(getcurpos(), c)
  call s:assert.equals(winsaveview(), c)

  " History
  exec "normal g/hoge\<CR>"
  call s:assert.equals('hoge', @/)
  call s:assert.equals('hoge', histget('/', -1))

  " Handle empty input
  normal! gg0
  call s:assert.not_eq_with_default('g/','/','pat')
  let x = getpos('.')
  call s:assert.not_eq_with_default('g/','/','')
  let y = getpos('.')
  call s:assert.equals(x, y)
  call s:assert.not_equals('', @/)
  call s:assert.not_equals('', histget('/', -1))
  call s:assert.equals('pat', @/)
  call s:assert.equals('pat', histget('/', -1))
endfunction

function! s:suite.offset()
  normal! gg0
  call s:assert.eq_with_default('/','/','pattern1/e')
  call s:assert.equals(s:get_pos_char(), '1')
  call s:assert.eq_with_default('?','?','pat?e5+1')
  call s:assert.equals(s:get_pos_char(), '6')
  exec "normal g/pattern\\d/e\<CR>"
  call s:assert.equals(@/, 'pattern\d')
  call s:assert.equals(histget('/', -1), 'pattern\d/e')
endfunction
