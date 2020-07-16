let s:suite = themis#suite('cancel')
let s:assert = themis#helper('assert')

" Helper:
function! s:add_line(str)
  put! =a:str
endfunction
function! s:add_lines(lines)
  for line in reverse(deepcopy(a:lines))
    put! =line
  endfor
endfunction
function! s:get_pos_char()
  return getline('.')[col('.')-1]
endfunction

function! s:reset_buffer()
  :1,$ delete
  let s:lines = ['1pattern_a', '2pattern_b', '3pattern_c', '4pattern_d', '5pattern_e']
  call s:add_lines(s:lines)
  normal! Gddgg0zt
endfunction

function! s:suite.before()
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  call s:reset_buffer()
endfunction

function! s:suite.before_each()
  :1
  normal! zt
endfunction

function! s:suite.after()
  :1,$ delete
  let g:incsearch#smart_backward_word = 1
endfunction

function! s:suite.module_management()
  call s:assert.equals(s:get_pos_char(), '1')
  :1
  let g:incsearch#smart_backward_word = 0
  exec "normal" "/\\dpattern_.\\v\<C-w>\<Bs>/e\<CR>"
  call s:assert.equals(s:get_pos_char(), 'a')
  :1
  let g:incsearch#smart_backward_word = 1
  exec "normal" "/\\dpattern_./e\\v\<C-w>\<CR>"
  call s:assert.equals(s:get_pos_char(), 'a')
endfunction

