let s:suite = themis#suite('operator_pending_behavior')
let s:assert = themis#helper('assert')

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" NOTE: Also see repetition.vim spec
" :h o_v
" :h o_V
" :h o_CTRL-V

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

function! s:suite.before_each()
  call s:reset_buffer()
  :1
  call s:assert.equals(s:get_pos_char(), '1')
endfunction

function! s:suite.before()
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  let s:line_texts = ['1pattern_a', '2pattern_b', '3pattern_c', '4pattern_d', '5pattern_e']
endfunction

function! s:suite.after()
  unmap /
  unmap ?
  unmap g/
  :1,$ delete
endfunction

function! s:suite.force_exclusive()
  call s:assert.skip("because it seems vim has no way to restore o_v, o_V, and o_Ctrl-V information once Escaping")
  " NOTE:
  "   - http://lingr.com/room/vim/archives/2014/09/22#message-20239719
  "   - https://groups.google.com/forum/#!topic/vim_dev/MNtX3jHkNWw
  "   - https://groups.google.com/forum/#!msg/vim_dev/lR5rONDwgs8/iLsVCrxo_WsJ
  :1,$ delete
  call s:add_line('1pattern 2pattern 3pattern 4pattern 5pattern')
  normal! gg0
  call s:assert.equals(getline('.'), '1pattern 2pattern 3pattern 4pattern 5pattern')
  exec "normal" "dv/\\dpattern\<CR>"
  call s:assert.equals(getline('.'), 'pattern 3pattern 4pattern 5pattern')
endfunction

function! s:suite.operator_c()
  call s:assert.equals(getline('.'), '1pattern_a')
  exec "normal" "c/_a\<CR>vimvim\<Esc>"
  call s:assert.equals(getline('.'), 'vimvim_a')
  normal! j0
  call s:assert.equals(getline('.'), '2pattern_b')
  exec "normal" "c/_b/e\<CR>vimvimvim~?\<Esc>"
  call s:assert.equals(getline('.'), 'vimvimvim~?')
  normal! j$
  call s:assert.equals(getline('.'), '3pattern_c')
  exec "normal" "c?pattern\<CR>vimvimvim\<Esc>"
  call s:assert.equals(getline('.'), '3vimvimvimc')
  normal! j$
  call s:assert.equals(getline('.'), '4pattern_d')
  exec "normal" "c?pattern?b3\<CR>vim\<Esc>"
  call s:assert.equals(getline('.'), '4patvimd')
endfunction

function! s:suite.stay_cancell_operator_c()
  call s:assert.equals(getline('.'), '1pattern_a')
  exec "normal" "cg/_a\<CR>e\<Esc>"
  call s:assert.not_equals(getline('.'), 'e_a')
  call s:assert.equals(s:get_pos_char(), 'a')
endfunction

function! s:suite.exit_stay_works_with_operator_c()
  call s:assert.equals(getline('.'), '1pattern_a')
  exec "normal" "cg/_a\<Tab>\<CR>e\<Esc>"
  call s:assert.equals(getline('.'), 'e_a')
endfunction

function! s:suite.another_search_offset()
  call s:assert.equals(getline('.'), '1pattern_a')
  exec "normal" "c/b/;/pattern_/e\<CR>vim\<Esc>"
  call s:assert.equals(getline('.'), 'vimc')
endfunction
