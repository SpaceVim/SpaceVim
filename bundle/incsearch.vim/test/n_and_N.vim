let s:suite = themis#suite('n_and_N')
let s:assert = themis#helper('assert')

" see: v:searchforward
let s:DIRECTION = { 'backward': 0, 'forward': 1}

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
  call s:add_lines(copy(s:line_texts))
  normal! Gddgg0zt
endfunction

function! s:suite.before()
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  " Explicitly map default `n` and `N`
  " unmap workaround
  noremap n  n
  noremap N  N
  unmap n
  unmap N
  let s:line_texts = ['1pattern 2pattern 3pattern 4pattern']
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
  let g:incsearch#consistent_n_direction = 0
endfunction

function! s:suite.after_forward()
  let v:searchforward = s:DIRECTION.backward
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "/\\dpattern\<CR>"
  call s:assert.equals(v:searchforward, s:DIRECTION.forward)
  call s:assert.equals(s:get_pos_char(), '2')
  normal! n
  call s:assert.equals(s:get_pos_char(), '3')
  normal! 2N
  call s:assert.equals(s:get_pos_char(), '1')
endfunction

function! s:suite.after_backward()
  " NOTE: Use feedkeys() to manipulate v:searchforward but it seems to work
  " fine with this test, so it's possible that :h function-search-undo
  " doesn't work with Ex-mode?
  normal! $
  let v:searchforward = s:DIRECTION.forward
  call s:assert.equals(s:get_pos_char(), 'n')
  exec "normal" "?\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '4')
  call s:assert.equals(v:searchforward, s:DIRECTION.backward)
  normal! n
  call s:assert.equals(s:get_pos_char(), '3')
  normal! n
  call s:assert.equals(s:get_pos_char(), '2')
  normal! 2N
  call s:assert.equals(s:get_pos_char(), '4')
endfunction

function! s:suite.after_stay()
  let v:searchforward = s:DIRECTION.backward
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "g/\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '1')
  call s:assert.equals(v:searchforward, s:DIRECTION.forward)
  normal! n
  call s:assert.equals(s:get_pos_char(), '2')
  normal! N
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "g/\\dpattern\<Tab>\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  normal! n
  call s:assert.equals(s:get_pos_char(), '3')
endfunction

function! s:suite.consistent_n_and_N_direction()
  let g:incsearch#consistent_n_direction = 1
  normal! $
  let v:searchforward = s:DIRECTION.forward
  call s:assert.equals(s:get_pos_char(), 'n')
  exec "normal" "?\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '4')
  call s:assert.equals(v:searchforward, s:DIRECTION.forward)
  normal! N
  call s:assert.equals(s:get_pos_char(), '3')
  normal! n
  call s:assert.equals(s:get_pos_char(), '4')

  :1,$ delete
  call s:add_line('1pattern1 2pattern2 3pattern3 4pattern4')
  normal! gg$
  let v:searchforward = s:DIRECTION.forward
  call s:assert.equals(s:get_pos_char(), '4')
  exec "normal" "?\\dpattern\\d?e\<CR>"
  call s:assert.equals(s:get_pos_char(), '3')
  call s:assert.equals(v:searchforward, s:DIRECTION.forward)
  normal! N
  call s:assert.equals(s:get_pos_char(), '2')
  normal! n
  call s:assert.equals(s:get_pos_char(), '3')
  let g:incsearch#consistent_n_direction = 0
endfunction


