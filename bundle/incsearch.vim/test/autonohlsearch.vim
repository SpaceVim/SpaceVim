let s:suite = themis#suite('autonlsearch')
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
  call s:add_lines(['1pattern_a', '2pattern_b', '3pattern_c', '4pattern_d', '5pattern_e'])
  normal! G
  call s:add_lines(range(100))
  normal! Gddgg0zt
endfunction

function! s:suite.before()
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  map n  <Plug>(incsearch-nohl-n)
  map N  <Plug>(incsearch-nohl-N)
  map *  <Plug>(incsearch-nohl-*)
  map #  <Plug>(incsearch-nohl-#)
  map g* <Plug>(incsearch-nohl-g*)
  map g# <Plug>(incsearch-nohl-g#)
  call s:reset_buffer()
endfunction

function! s:suite.before_each()
  :1
  normal! zt
  silent! autocmd! incsearch-auto-nohlsearch
  let g:incsearch#auto_nohlsearch = 1
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
endfunction

function! s:suite.after()
  :1,$ delete
  let g:incsearch#auto_nohlsearch = 0
  unmap /
  unmap ?
  unmap g/
  " :unmap workaround
  noremap n  n
  noremap N  N
  noremap *  *
  noremap #  #
  noremap g* g*
  noremap g# g#
  unmap n
  unmap N
  unmap *
  unmap #
  unmap g*
  unmap g#
endfunction

function! s:suite.function_works()
  let g:incsearch#auto_nohlsearch = 0
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
  call incsearch#autocmd#auto_nohlsearch(1)
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
  let g:incsearch#auto_nohlsearch = 1
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
  call incsearch#autocmd#auto_nohlsearch(1)
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
endfunction

function! s:suite.nolsearch_with_cursormove_0()
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
  call incsearch#autocmd#auto_nohlsearch(0)
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  doautocmd CursorMoved
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
endfunction

function! s:suite.nolsearch_with_cursormove_1()
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
  call incsearch#autocmd#auto_nohlsearch(1)
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  doautocmd CursorMoved
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  doautocmd CursorMoved
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
endfunction

function! s:suite.nolsearch_with_cursormove_2()
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
  call incsearch#autocmd#auto_nohlsearch(2)
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  doautocmd CursorMoved
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  doautocmd CursorMoved
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  doautocmd CursorMoved
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
endfunction

function! s:suite.nolsearch_with_insert_enter()
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
  call incsearch#autocmd#auto_nohlsearch(10)
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#InsertEnter'), 1)
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#InsertLeave'), 0, 'do not set InsertLeave until InsertEnter')
  doautocmd InsertEnter
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
  call s:assert.equals(exists('#incsearch-auto-nohlsearch-on-insert-leave#InsertLeave'), 1)
  doautocmd InsertLeave
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1, 'trigger auto nohlsearch again')
  call s:assert.equals(exists('#incsearch-auto-nohlsearch-on-insert-leave#InsertLeave'), 0, 'remove insert leave')
  doautocmd CursorMoved
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  doautocmd CursorMoved
  call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
  call s:assert.equals(exists('#incsearch-auto-nohlsearch-on-insert-leave#InsertLeave'), 0)
endfunction

function! s:suite.work_with_search()
  for key in ['/', '?', 'g/']
    silent! autocmd! incsearch-auto-nohlsearch
    call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
    exec "normal" key . "pattern\<CR>"
    call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  endfor
endfunction

function! s:suite.work_with_search_offset()
  for key in ['/', '?', 'g/']
    silent! autocmd! incsearch-auto-nohlsearch
    call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
    exec "silent! normal" key . "pattern/e\<CR>"
    call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  endfor
endfunction

function! s:suite.work_with_other_search_mappings()
  for key in ['n', 'N', '*', '#', 'g*', 'g#']
    autocmd! incsearch-auto-nohlsearch
    call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
    exec "silent! normal!" key
    call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 0)
    exec "silent! normal" key
    call s:assert.equals(exists('#incsearch-auto-nohlsearch#CursorMoved'), 1)
  endfor
endfunction
