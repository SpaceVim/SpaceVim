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
  " Return to normal mode
  exec "normal! \<Esc>"
endfunction

function! s:suite.after()
  :1,$ delete
  let @/ = ''
endfunction

function! s:suite.cancel_forward_does_not_move_cursor()
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "/\\dpattern_./e\<C-c>"
  call s:assert.not_equals(s:get_pos_char(), 'a')
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "/\\dpattern_./e\<Esc>"
  call s:assert.not_equals(s:get_pos_char(), 'a')
  call s:assert.equals(s:get_pos_char(), '1')
endfunction

function! s:suite.cancel_backward_does_not_move_cursor()
  :$
  normal! $
  call s:assert.equals(s:get_pos_char(), 'e')
  exec "normal" "?\\dpattern_d?e\<C-c>"
  call s:assert.not_equals(s:get_pos_char(), 'd')
  call s:assert.equals(s:get_pos_char(), 'e')
endfunction

function! s:suite.cancel_stay_does_not_move_cursor()
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "g/\\dpattern_./e\<Tab>\<C-c>"
  call s:assert.not_equals(s:get_pos_char(), 'a')
  call s:assert.equals(s:get_pos_char(), '1')
endfunction

function! s:suite.cancel_forward_operator_pending()
  exec "normal" "d/\\dpattern_./e\<C-c>"
  call s:assert.equals(getline('.'), s:lines[0])
endfunction

function! s:suite.cancel_backward_operator_pending()
  :$
  normal! $
  exec "normal" "d?\\dpattern_d?e\<C-c>"
  call s:assert.equals(getline('.'), s:lines[-1])
endfunction

function! s:suite.cancel_stay_operator_pending()
  exec "normal" "dg/\\dpattern_./e\<Tab>\<C-c>"
  call s:assert.equals(getline('.'), s:lines[0])
endfunction

function! s:suite.cancel_forward_visual()
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "vl/\\dpattern_./e\<C-c>"
  call s:assert.not_equals(s:get_pos_char(), 'a')
  call s:assert.equals(s:get_pos_char(), 'p')
  call s:assert.equals(mode(1), 'v')
endfunction

function! s:suite.cancel_backward_visual()
  :$
  normal! $
  call s:assert.equals(s:get_pos_char(), 'e')
  exec "normal" "vh?\\dpattern_d?e\<C-c>"
  call s:assert.not_equals(s:get_pos_char(), 'd')
  call s:assert.equals(s:get_pos_char(), '_')
  call s:assert.equals(getline('.'), s:lines[-1])
endfunction

function! s:suite.cancel_stay_visual()
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "vl/\\dpattern_./e\<Tab>\<C-c>"
  call s:assert.not_equals(s:get_pos_char(), 'a')
  call s:assert.equals(s:get_pos_char(), 'p')
  call s:assert.equals(mode(1), 'v')
endfunction

function! s:suite.cancel_will_not_change_last_pattern()
  for key_seq in ['/', '?', 'g/']
    let p = 'vim: ' . key_seq
    let @/ = p
    exec "normal"  key_seq . "pattern\<Tab>\<C-c>"
    call s:assert.equals(@/, p)
  endfor
endfunction

function! s:suite.highlight_will_not_remain()
  for key_seq in ['/', '?', 'g/']
    exec "normal"  key_seq . "pattern\<Tab>\<C-c>"
    call s:assert.equals(getmatches(), [])
  endfor
endfunction

function! s:suite.default_highlight_will_not_remain()
  if !exists('v:hlsearch')
    call s:assert.skip("Skip because vim version are too low to test it")
  endif
  set hlsearch | nohlsearch
  let v:hlsearch = 0
  for key_seq in ['/', '?', 'g/']
    exec "normal"  key_seq . "pattern\<Tab>\<C-c>"
    call s:assert.equals(v:hlsearch, 0)
  endfor
  set hlsearch& | nohlsearch
endfunction

function! s:suite.preserve_vhlsearch_with_esc()
  if !exists('v:hlsearch')
    call s:assert.skip("Skip because vim version are too low to test it")
  endif
  set hlsearch
  for keyseq in ['/', '?', 'g/']
    let v:hlsearch = 1
    exec "normal" keyseq . "pattern\<Esc>"
    call s:assert.equals(v:hlsearch, 1)
  endfor
  set hlsearch& | nohlsearch
endfunction

