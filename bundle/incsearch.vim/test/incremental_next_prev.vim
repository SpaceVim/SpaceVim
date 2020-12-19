let s:suite = themis#suite('incremental_next_prev')
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
  normal! ggdG
  call s:add_lines(copy(s:line_texts))
  normal! Gddgg0zt
endfunction

function! s:suite.before()
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  let s:line_texts = [
  \     '0'
  \   , 'pattern1'
  \   , 'pattern2'
  \   , 'pattern3'
  \   , 'pattern4'
  \   , 'pattern5'
  \   , '6'
  \ ]
  call s:reset_buffer()
endfunction

function! s:suite.before_each()
  :1
  set wrapscan&
endfunction

function! s:suite.after()
  call s:reset_buffer()
endfunction

function! s:suite.inc_next_forward()
  exec "normal" "/pattern\\zs\\d\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[2])
  :1
  exec "normal" "/pattern\\zs\\d\<Tab>\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[3])
endfunction

function! s:suite.inc_next_backward()
  :$
  call s:assert.equals(s:get_pos_char(), 6)
  exec "normal" "?pattern\\zs\\d\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[4])
  :$
  exec "normal" "?pattern\\zs\\d\<Tab>\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[3])
endfunction

function! s:suite.inc_prev_forward()
  exec "normal" "/pattern\\zs\\d\<Tab>\<S-Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[1])
  :1
  exec "normal" "/pattern\\zs\\d\<Tab>\<Tab>\<S-Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[2])
endfunction

function! s:suite.inc_prev_backward()
  :$
  call s:assert.equals(s:get_pos_char(), 6)
  exec "normal" "?pattern\\zs\\d\<Tab>\<S-Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[5])
  :$
  exec "normal" "?pattern\\zs\\d\<Tab>\<Tab>\<S-Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[4])
endfunction

function! s:suite.inc_next_stay()
  exec "normal" "g/pattern\\zs\\d\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[1])
  :1
  exec "normal" "g/pattern\\zs\\d\<Tab>\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[2])
endfunction

function! s:suite.inc_prev_stay()
  exec "normal" "g/pattern\\zs\\d\<Tab>\<Tab>\<S-Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[1])
endfunction

" h: last-pattern
" NOTE: incsearch.vim works interactibely
function! s:suite.inc_last_pattern()
  " let @/ = "pattern\\zs\\d"
  call histadd('/', "pattern\\zs\\d")
  exec "normal" "/\<Tab>\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[2])
  call s:assert.equals(@/, "pattern\\zs\\d")
endfunction


function! s:suite.inc_last_pattern_offset()
  " let @/ = "pattern\\d"
  call histadd('/', "pattern\\d")
  exec "normal" "//e\<Tab>\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[2])
  call s:assert.equals(s:get_pos_char(), 2)
  call s:assert.equals(@/, "pattern\\d")
endfunction

function! s:suite.inc_last_pattern_reset()
  call s:assert.skip("Skip because Segmentation fault occurs with histdel()")
  call s:assert.equals(getline('.'), s:line_texts[0])
  let @/ = ''
  call histdel('/')
  Throws /Vim(normal):E35: No previous regular expression/
  \   :exec "normal" "/\<Tab>\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[0])
endfunction

function! s:suite.match_at_cursor_pos_with_nowrapscan() abort
  set nowrapscan
  :3
  exec "normal" "/pattern\<Tab>\<Tab>\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[5])
  set wrapscan
  :3
  exec "normal" "/pattern\<Tab>\<Tab>\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[1])
endfunction

function! s:suite.match_at_cursor_pos_with_nowrapscan_backward() abort
  set nowrapscan
  :5
  exec "normal" "?pattern\<Tab>\<Tab>\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[1])
  set wrapscan
  :5
  exec "normal" "?pattern\<Tab>\<Tab>\<Tab>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[5])
endfunction
