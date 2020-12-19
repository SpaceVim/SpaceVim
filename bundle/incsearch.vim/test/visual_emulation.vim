let s:suite = themis#suite('visual_emulation')
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
  call s:add_lines(['1pattern_a', '2pattern_b', '3pattern_c', '4pattern_d', '5pattern_e'])
  normal! G
  call s:add_lines(range(100))
  normal! Gddgg0zt
endfunction

function! s:suite.before_each()
  call s:reset_buffer()
endfunction

function! s:assert.equal_matches(pattern, ...)
  " :h getmatches()
  let m = getmatches()[0]
  call s:assert.equals(m.pattern, a:pattern)
endfunction

function! s:assert.equal_view(view)
  for key in keys(a:view)
    call s:assert.equals(winsaveview()[key], a:view[key])
  endfor
endfunction

function! s:assert.equal_line(line)
  call s:assert.equals(getline('.'), a:line)
endfunction

function! s:assert.equal_pos_char(char)
  call s:assert.equals(s:get_pos_char(), a:char)
endfunction

function! s:suite.emulate_v()
  normal! v3jy
  call s:assert.equals(visualmode(), "v")
  call incsearch#highlight#emulate_visual_highlight()
  call s:assert.equal_matches('\v%1l%1c\_.{-}%4l|%4l\_.*%4l%1c')
  call incsearch#highlight#emulate_visual_highlight('v')
  call s:assert.equal_matches('\v%1l%1c\_.{-}%4l|%4l\_.*%4l%1c')
endfunction

function! s:suite.emulate_V()
  normal! V3jy
  call s:assert.equals(visualmode(), "V")
  call incsearch#highlight#emulate_visual_highlight()
  call s:assert.equal_matches('\v%1l\_.*%4l')
  call incsearch#highlight#emulate_visual_highlight('V')
  call s:assert.equal_matches('\v%1l\_.*%4l')
endfunction

function! s:suite.emulate_ctrl_v()
  exec "normal! \<C-v>2j2ly"
  call s:assert.equals(visualmode(), "\<C-v>")
  call incsearch#highlight#emulate_visual_highlight()
  call s:assert.equal_matches('\v%1l%1c.*%4c|%2l%1c.*%4c|%3l%1c.*%4c')
  call incsearch#highlight#emulate_visual_highlight("\<C-v>")
  call s:assert.equal_matches('\v%1l%1c.*%4c|%2l%1c.*%4c|%3l%1c.*%4c')
endfunction

function! s:suite.emulate_v_End()
  normal! v3j$y
  call s:assert.equals(visualmode(), 'v')
  call incsearch#highlight#emulate_visual_highlight()
  call s:assert.equal_matches('\v%1l%1c\_.{-}%4l|%4l\_.*%4l%11c')
  call incsearch#highlight#emulate_visual_highlight('v')
  call s:assert.equal_matches('\v%1l%1c\_.{-}%4l|%4l\_.*%4l%11c')
endfunction

function! s:suite.emulate_V_End()
  normal! V3j$y
  call s:assert.equals(visualmode(), 'V')
  call incsearch#highlight#emulate_visual_highlight()
  call s:assert.equal_matches('\v%1l\_.*%4l')
  call incsearch#highlight#emulate_visual_highlight('V')
  call s:assert.equal_matches('\v%1l\_.*%4l')
endfunction

function! s:suite.emulate_ctrl_v_End()
  exec "normal! \<C-v>3j$y"
  call s:assert.equals(visualmode(), "\<C-v>")
  call incsearch#highlight#emulate_visual_highlight()
  call s:assert.equal_matches('\v%1l%1c.*%11c|%2l%1c.*%11c|%3l%1c.*%11c|%4l%1c.*%11c')
  call incsearch#highlight#emulate_visual_highlight("\<C-v>")
  call s:assert.equal_matches('\v%1l%1c.*%11c|%2l%1c.*%11c|%3l%1c.*%11c|%4l%1c.*%11c')
endfunction

function! s:suite.custom_highlight()
  normal! v3jy
  call s:assert.equals(visualmode(), 'v')
  call incsearch#highlight#emulate_visual_highlight()
  let visual_hl = incsearch#highlight#capture('Visual')
  call s:assert.equals(getmatches()[0].group, '_IncSearchVisual')
  let h = incsearch#highlight#capture('_IncSearchVisual')
  call s:assert.equals(h.highlight, visual_hl.highlight)

  let error_hl = incsearch#highlight#capture('ErrorMsg')
  call incsearch#highlight#emulate_visual_highlight('v', error_hl)
  let h = incsearch#highlight#capture('_IncSearchVisual')
  call s:assert.equals(h.highlight, error_hl.highlight)
endfunction

function! s:suite.get_pattern_v()
  let r = incsearch#highlight#get_visual_pattern('v', [5,2], [2,4])
  call s:assert.equals(r, '\v%2l%4c\_.{-}%5l|%5l\_.*%5l%2c')
endfunction

function! s:suite.get_pattern_V()
  let r = incsearch#highlight#get_visual_pattern('V', [5,2], [2,4])
  call s:assert.equals(r, '\v%2l\_.*%5l')
endfunction

function! s:suite.get_pattern_ctrl_v()
  let r = incsearch#highlight#get_visual_pattern("\<C-v>", [5,2], [2,4])
  call s:assert.equals(r, '\v%2l%2c.*%5c|%3l%2c.*%5c|%4l%2c.*%5c|%5l%2c.*%5c')
endfunction

function! s:suite.over_win_height()
  normal! 100ggzz
  let r = incsearch#highlight#get_visual_pattern('V', [1,1], [100,100])
  let e = incsearch#highlight#get_visual_pattern('V', [line('w0'),1], [100,100])
  call s:assert.equals(r, e)
  normal! ggzt
  let r2 = incsearch#highlight#get_visual_pattern('V', [1,1], [100,100])
  let e2 = '\v%1l\_.*%' . line('w$') . 'l'
  call s:assert.equals(r2, e2)
endfunction

function! s:suite.unexpected_mode()
  let throwed = 0
  try
    let r = incsearch#highlight#get_visual_pattern('a', [1,1], [100,100])
  catch /incsearch.vim:/
    let throwed = 1
    call s:assert.equals(v:exception, 'incsearch.vim: unexpected mode a')
  endtry
  call s:assert.equals(throwed, 1)
endfunction

function! s:suite.update_highlight_on_colorscheme()
  colorscheme default
  let old_hl = incsearch#highlight#get_visual_hlobj()
  colorscheme desert
  let new_hl = incsearch#highlight#get_visual_hlobj()
  call s:assert.not_equals(old_hl, new_hl)
endfunction

