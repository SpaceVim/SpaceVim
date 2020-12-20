let s:suite = themis#suite('insert_register')
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
  \   , 'pattern_vim_2'
  \   , 'emacs vim3'
  \   , 's:4pattern4 4'
  \   , 's:4pattern4 5'
  \ ]
  call s:reset_buffer()
endfunction

function! s:suite.before_each()
  :1
  set incsearch
endfunction

function! s:suite.after()
  unmap /
  unmap ?
  unmap g/
  :1,$ delete
  set incsearch&
  let @/ = ''
endfunction


function! s:suite.cword_noincsearch()
  set noincsearch
  Throws /Vim(normal):E486: Pattern not found: ppattern1/
  \   :exec "normal" "/p\<C-r>\<C-w>/e\<CR>"
endfunction

function! s:suite.cword_incsearch()
  exec "normal" "/p\<C-r>\<C-w>/e\<CR>"
  call s:assert.equals(s:get_pos_char(), 1)
endfunction

function! s:suite.cword_incsearch_middle()
  exec "normal" "/pa\<Left>\<C-r>\<C-w>\<Right>\<BS>/e\<CR>"
  call s:assert.equals(s:get_pos_char(), 1)
endfunction

function! s:suite.cword_incsearch_cli_cursor_middle()
  exec "normal" "/pa\<Left>\<C-r>\<C-w>\<Right>\<BS>/e\<CR>"
  call s:assert.equals(s:get_pos_char(), 1)
endfunction

function! s:suite.cword_incsearch_middle_word()
  Throws /Vim(normal):E486: Pattern not found: vimpattern_vim_2/
  \   :exec "normal" "/vim\<C-r>\<C-w>/e\<CR>"
endfunction

function! s:suite.cword_from_last_matched_pos()
  exec "normal" "/emacs \<C-r>\<C-w>/e\<CR>"
  call s:assert.equals(s:get_pos_char(), 3)
endfunction

function! s:suite.cWord()
  call s:assert.equals(getline('.'), s:line_texts[0])
  call cursor(4 + 1, 3)
  call s:assert.equals(getline('.'), s:line_texts[4])
  exec "normal" "/p\<C-r>\<C-a>\<Home>\<Del>\<CR>"
  call s:assert.equals(getline('.'), s:line_texts[5])
  call s:assert.equals(@/, 's:4pattern4')
endfunction

function! s:suite.search()
  let @/ = 'emacs'
  exec "normal" "/\<C-r>/ vim3/e\<CR>"
  call s:assert.equals(s:get_pos_char(), 3)
endfunction

