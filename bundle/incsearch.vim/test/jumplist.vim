let s:suite = themis#suite('jumplist')
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
  let s:line_texts = ['1pattern', '2pattern', '3pattern', '4pattern']
  call s:reset_buffer()
endfunction

function! s:suite.before_each()
  :1
endfunction

function! s:suite.after()
  unmap /
  unmap ?
  unmap g/
  :1,$delete
endfunction


function! s:suite.forward()
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "/2pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "/3pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '3')
  exec "normal! \<C-o>"
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal! \<C-o>"
  call s:assert.equals(s:get_pos_char(), '1')
  exec "normal" "/4pattern/e\<CR>"
  call s:assert.equals(s:get_pos_char(), 'n')
  exec "normal! \<C-o>"
  call s:assert.equals(s:get_pos_char(), '1')
endfunction

function! s:suite.backward()
  :$
  call s:assert.equals(s:get_pos_char(), '4')
  exec "normal" "?3pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '3')
  exec "normal" "?2pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal! \<C-o>"
  call s:assert.equals(s:get_pos_char(), '3')
  exec "normal! \<C-o>"
  call s:assert.equals(s:get_pos_char(), '4')
endfunction

function! s:suite.stay_does_not_update_jumplist()
  normal! m`
  call s:assert.equals(s:get_pos_char(), '1')
  keepjumps normal! 3j
  call s:assert.equals(s:get_pos_char(), '4')
  exec "normal! \<C-o>"
  call s:assert.equals(s:get_pos_char(), '1')
  normal! m`
  keepjumps normal! j
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "g/3pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal! \<C-o>"
  call s:assert.equals(s:get_pos_char(), '1')
endfunction

function! s:suite.stay_offset()
  call s:assert.skip("because you cannot set {offset} information with Vim script unless excuting search command")
  call s:assert.equals(s:get_pos_char(), '1')
  normal! m`
  keepjumps normal! j
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "g/3pattern/e\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal! \<C-o>"
  call s:assert.equals(s:get_pos_char(), '1') " -> 2
endfunction

function! s:suite.exit_stay_does_update_jumplist()
  normal! m`
  call s:assert.equals(s:get_pos_char(), '1')
  keepjumps normal! 3j
  call s:assert.equals(s:get_pos_char(), '4')
  exec "normal! \<C-o>"
  call s:assert.equals(s:get_pos_char(), '1')
  normal! m`
  keepjumps normal! j
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "g/3pattern\<Tab>\<CR>"
  call s:assert.equals(s:get_pos_char(), '3')
  exec "normal! \<C-o>"
  call s:assert.equals(s:get_pos_char(), '2')
endfunction
