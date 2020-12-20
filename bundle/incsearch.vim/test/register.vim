let s:suite = themis#suite('register')
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
  normal! G
  call s:add_lines(range(100))
  normal! Gddgg0zt
endfunction

function! s:suite.before_each()
  call s:reset_buffer()
endfunction

function! s:suite.unnamed_register()
  call s:add_line('1pattern 2pattern 3pattern 4pattern')
  normal! gg0
  call setreg(v:register, '')
  call s:assert.equals(getreg(v:register), '')
  exec "normal" "d/\\dpattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  call s:assert.equals(getreg(v:register), '1pattern ')
endfunction

function! s:suite.quote_register()
  call s:add_line('1pattern 2pattern 3pattern 4pattern')
  normal! gg0
  call setreg('a', '')
  call s:assert.equals(getreg('a'), '')
  exec "normal" "\"ad/\\dpattern\<CR>"
  call s:assert.equals(getreg('a'), '1pattern ')
endfunction
