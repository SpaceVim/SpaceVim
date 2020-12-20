let s:suite = themis#suite('nomagic')
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
  :1,$ delete
  call s:add_lines(copy(s:line_texts))
  normal! Gddgg0zt
endfunction

function! s:suite.before()
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  let s:line_texts = ['1pattern_a', '2pattern_b', '3pattern_c', '4pattern_d', '5pattern_e']
  call s:reset_buffer()
endfunction

function! s:suite.before_each()
  :1
  normal! zt
  set nomagic
endfunction

function! s:suite.after()
  unmap /
  unmap ?
  unmap g/
  :1,$ delete
  set magic&
endfunction


function! s:suite.works_with_nomagic()
  exec "normal" "/\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "/\\dpattern_\\[a-z]/e\<CR>"
  call s:assert.equals(s:get_pos_char(), 'b')
  exec "normal" "?\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "?\\dpattern_\\[a-z]?e\<CR>"
  call s:assert.equals(s:get_pos_char(), 'a')
endfunction

function! s:suite.works_with_nomagic_stay()
  exec "normal" "g/\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "g/\\dpattern\<Tab>\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "g/\\dpattern_\\[a-z]/e\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "g/\\dpattern_\\[a-z]/e\<Tab>\<CR>"
  call s:assert.equals(s:get_pos_char(), 'b')
endfunction

function! s:suite.nomagic_as_a_pattern()
  exec "normal" "/.pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "/pat*ern\<CR>"
  call s:assert.equals(s:get_pos_char(), '1')
endfunction

