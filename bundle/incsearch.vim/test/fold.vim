let s:suite = themis#suite('fold')
let s:assert = themis#helper('assert')

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

function! s:add_lines(lines)
  for line in reverse(a:lines)
    put! =line
  endfor
endfunction

function! s:reset_buffer()
  :1,$ delete
  call s:add_lines(copy(s:line_texts))
  normal! Gddgg0zt
endfunction

function! s:suite.before()
  set foldmethod=marker
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  let s:line_texts = [
  \    '1'
  \  , '2'
  \  , '3'
  \  , '4fold {{{'
  \  , '5    inner fold {{{'
  \  , '6        destination'
  \  , '7    }}}'
  \  , '8}}}'
  \ ]
  call s:reset_buffer()
endfunction

function! s:suite.before_each()
  :1
  normal! zM
  call s:assert.equals(foldclosed(6), 4)
endfunction

function! s:suite.after()
  unmap /
  unmap ?
  unmap g/
  :1,$ delete
  set foldmethod&
endfunction


function! s:suite.unfold_after_search_forward_backward()
  exec "normal" "/destination\<CR>"
  call s:assert.equals(foldclosed(6), -1)
endfunction

function! s:suite.unfold_after_search_forward_offset()
  exec "normal" "/destination/e\<CR>"
  call s:assert.equals(foldclosed(6), -1)
endfunction

function! s:suite.unfold_after_search_backward()
  exec "normal" "?destination\<CR>"
  call s:assert.equals(foldclosed(6), -1)
endfunction

function! s:suite.unfold_after_search_backward()
  exec "normal" "?destination?e\<CR>"
  call s:assert.equals(foldclosed(6), -1)
endfunction

function! s:suite.do_not_unfold_after_just_stay()
  exec "normal" "g/destination\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  exec "normal" "g/destination/e\<CR>"
  call s:assert.equals(foldclosed(6), 4)
endfunction

function! s:suite.unfold_after_exit_stay()
  exec "normal" "g/destination\<Tab>\<CR>"
  call s:assert.equals(foldclosed(6), -1)
endfunction

function! s:suite.unfold_after_exit_stay_offset()
  exec "normal" "g/destination/e\<Tab>\<CR>"
  call s:assert.equals(foldclosed(6), -1)
endfunction

function! s:suite.do_not_unfold_if_foldopen_does_not_contain_search()
  set foldopen-=search
  call s:assert.equals(foldclosed(6), 4)
  exec "normal" "/destination\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  exec "normal" "/destination/e\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  exec "normal" "?destination\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  exec "normal" "?destination?e\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  exec "normal" "g/destination\<Tab>\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  exec "normal" "g/destination/e\<Tab>\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  set foldopen&
endfunction

function! s:suite.unfold_if_foldopen_does_contain_all()
  set foldopen=all
  call s:assert.equals(foldclosed(6), 4)
  exec "normal" "/destination\<CR>"
  call s:assert.equals(foldclosed(6), -1)
  normal! ggzM
  exec "normal" "/destination/e\<CR>"
  call s:assert.equals(foldclosed(6), -1)
  normal! ggzM
  exec "normal" "?destination\<CR>"
  call s:assert.equals(foldclosed(6), -1)
  normal! ggzM
  exec "normal" "?destination?e\<CR>"
  call s:assert.equals(foldclosed(6), -1)
  normal! ggzM
  exec "normal" "g/destination\<Tab>\<CR>"
  call s:assert.equals(foldclosed(6), -1)
  normal! ggzM
  exec "normal" "g/destination/e\<Tab>\<CR>"
  call s:assert.equals(foldclosed(6), -1)
  normal! ggzM
  set foldopen&
endfunction

function! s:suite.do_not_unfold_when_operator_pending()
  set foldopen&
  call s:assert.equals(foldclosed(6), 4)
  exec "normal" "gu/destination\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  exec "normal" "gu/destination/e\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  exec "normal" "gu?destination\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  exec "normal" "gu?destination?e\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  exec "normal" "gug/destination\<Tab>\<CR>"
  call s:assert.equals(foldclosed(6), 4)
  normal! gg
  exec "normal" "gug/destination/e\<Tab>\<CR>"
  call s:assert.equals(foldclosed(6), 4)
endfunction


