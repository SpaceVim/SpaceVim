let s:suite = themis#suite('count')
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
function! s:get_pos_char()
  return getline('.')[col('.')-1]
endfunction

function! s:reset_buffer()
  normal! ggdG
  call s:add_lines(['1pattern_a', '2pattern_b', '3pattern_c', '4pattern_d', '5pattern_e'])
  normal! Gddgg0zt
endfunction

function! s:suite.before_each()
  call s:reset_buffer()
endfunction

function! s:suite.forward_normal()
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "2/\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '3')
  exec "normal" "2/\\dpattern_[a-z]/e\<CR>"
  call s:assert.equals(s:get_pos_char(), 'd')
endfunction

function! s:suite.forward_visual()
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "v2/\\dpattern\<CR>\<Esc>"
  call s:assert.equals(s:get_pos_char(), '3')
  exec "normal" "v2/\\dpattern_[a-z]/e\<CR>\<Esc>"
  call s:assert.equals(s:get_pos_char(), 'd')
endfunction

function! s:suite.forward_operator_pending()
  call s:reset_buffer() " XXX: ???
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "2d/\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '3')
  call s:assert.equals(getline('.'), '3pattern_c')
  exec "normal" "2d/\\dpattern_/e\<CR>"
  call s:assert.equals(getline('.'), 'd')
endfunction

function! s:suite.forward_operator_pending_multiply()
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "2d2/\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '5')
  call s:assert.equals(getline('.'), '5pattern_e')
endfunction

function! s:suite.backward_normal()
  call s:assert.equals(s:get_pos_char(), '1')
  normal! G$
  call s:assert.equals(s:get_pos_char(), 'e')
  call s:assert.equals(line('.'), 5)
  call s:assert.equals(getline('.'), '5pattern_e')
  exec "normal" "2?\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '4')
endfunction

function! s:suite.backward_visual()
  call s:assert.equals(s:get_pos_char(), '1')
  normal! G$
  call s:assert.equals(s:get_pos_char(), 'e')
  exec "normal" "v2?\\dpattern\<CR>\<Esc>"
  call s:assert.equals(s:get_pos_char(), '4')
endfunction

function! s:suite.backward_operator_pending()
  normal! G$
  call s:assert.equals(s:get_pos_char(), 'e')
  exec "normal" "d2?\\dpattern_[a-z]\<CR>"
  call s:assert.equals(getline('.'), 'e')
  exec "normal" "d2?\\dpattern_[a-z]?e\<CR>"
  call s:assert.equals(s:get_pos_char(), '_')
  call s:assert.equals(getline('.'), '2pattern_')
endfunction

function! s:suite.backward_operator_pending_multiply()
  normal! G$
  exec "normal" "2d2?\\dpattern_[a-z]?e\<CR>"
  call s:assert.equals(s:get_pos_char(), '_')
  call s:assert.equals(getline('.'), '1pattern_')
endfunction
