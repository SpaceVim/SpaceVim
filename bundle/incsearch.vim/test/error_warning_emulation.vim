scriptencoding utf-8

let s:suite = themis#suite('error_warning_emulation')
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

" NOTE:
" :h v:errmsg
" :h v:warningmsg

function! s:reset_buffer()
  :1,$ delete
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

function! s:suite.after()
  unmap /
  unmap ?
  unmap g/
  :1,$ delete
  set wrapscan&
endfunction


function! s:suite.before_each()
  :1
  set wrapscan&
endfunction

function! s:suite.after_each()
  set wrapscan&
endfunction

function! s:suite.error_forward_backward()
  for keyseq in ['/', '?']
    normal! gg0
    let v:errmsg = 'old errormsg'
    call s:assert.equals(s:get_pos_char(), '1')
    normal! j
    call s:assert.equals(s:get_pos_char(), '2')
    " silent! exec "normal" keyseq . "びむぅぅぅぅ\<CR>"
    " call s:assert.equals(v:errmsg, 'E486: Pattern not found: びむぅぅぅぅ')
    silent! exec "normal" keyseq . "bbb\<CR>"
    call s:assert.equals(v:errmsg, 'E486: Pattern not found: bbb')
    " feedkeys()
    silent! exec "normal" keyseq . "aaa" . keyseq . "e\<CR>"
    call s:assert.equals(v:errmsg, 'E486: Pattern not found: aaa')
    " silent! exec "normal" keyseq . "びむぅぅぅぅ\\(\<CR>"
    silent! exec "normal" keyseq . "pattern\\(\<CR>"
    call s:assert.equals(v:errmsg, 'E54: Unmatched \(')
    silent! exec "normal" keyseq . "pattern\\)\<CR>"
    call s:assert.equals(v:errmsg, 'E55: Unmatched \)')
    silent! exec "normal" keyseq . "bbb\\zA\<CR>"
    call s:assert.equals(v:errmsg, 'E68: Invalid character after \z')
  endfor
endfunction

function! s:suite.error_stay()
  let v:errmsg = 'old errormsg'
  call s:assert.equals(s:get_pos_char(), '1')
  normal! j
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "g/びむぅぅぅぅ\<CR>"
  call s:assert.equals(v:errmsg, 'E486: Pattern not found: びむぅぅぅぅ')
  " feedkeys()
  silent! exec "normal" "g/aaa/e\<CR>"
  call s:assert.equals(v:errmsg, 'E486: Pattern not found: aaa')
  exec "normal" "g/びむぅぅぅぅ\\(\<CR>"
  call s:assert.equals(v:errmsg, 'E54: Unmatched \(')
  exec "normal" "g/びむぅぅぅぅ\\)\<CR>"
  call s:assert.equals(v:errmsg, 'E55: Unmatched \)')
  exec "normal" "g/びむぅぅぅぅ\\zA\<CR>"
  call s:assert.equals(v:errmsg, 'E68: Invalid character after \z')
endfunction

function! s:suite.two_error_E383_and_E367()
  if ! exists('&regexpengine')
    call s:assert.skip("Skip because vim version are too low to test it")
  endif
  " NOTE: incsearch doesn't support more than three errors unfortunately
  let g:incsearch#do_not_save_error_message_history = 0
  let v:errmsg = ''
  exec "normal" "/びむぅぅぅぅ\\zA\<CR>"
  let save_verbose = &verbose
  let &verbose = 0
  try
    redir => messages_text
    messages
    redir END
  finally
    let &verbose = save_verbose
  endtry
  let errmsgs = reverse(split(messages_text, "\n"))
  call s:assert.equals(v:errmsg, 'E68: Invalid character after \z')
  call s:assert.equals(errmsgs[0], 'E68: Invalid character after \z')
  call s:assert.equals(errmsgs[1], "E867: (NFA) Unknown operator '\\zA'")
  let g:incsearch#do_not_save_error_message_history = 1
endfunction

function! s:suite.nowrapscan_forward_error()
  set nowrapscan
  let v:errmsg = 'old errormsg'
  call s:assert.equals(s:get_pos_char(), '1')
  normal! j
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "/1pattern\<CR>"
  call s:assert.equals(v:errmsg, 'E385: search hit BOTTOM without match for: 1pattern')
  exec "normal" "/aaa\<CR>"
  call s:assert.equals(v:errmsg, 'E385: search hit BOTTOM without match for: aaa')
  silent! exec "normal" "/aaa/e\<CR>"
  call s:assert.equals(v:errmsg, 'E385: search hit BOTTOM without match for: aaa')
endfunction

function! s:suite.nowrapscan_backward_error()
  set nowrapscan
  normal! G
  let v:errmsg = 'old errormsg'
  call s:assert.equals(s:get_pos_char(), '4')
  normal! k
  call s:assert.equals(s:get_pos_char(), '3')
  exec "normal" "?4pattern\<CR>"
  call s:assert.equals(v:errmsg, 'E384: search hit TOP without match for: 4pattern')
  exec "normal" "?aaa\<CR>"
  call s:assert.equals(v:errmsg, 'E384: search hit TOP without match for: aaa')
  silent! exec "normal" "?aaa?e\<CR>"
  call s:assert.equals(v:errmsg, 'E384: search hit TOP without match for: aaa')
endfunction

function! s:suite.nowrapscan_stay_error()
  set nowrapscan
  let v:errmsg = 'old errormsg'
  call s:assert.equals(s:get_pos_char(), '1')
  normal! j
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "g/1pattern\<CR>"
  call s:assert.equals(v:errmsg, 'E385: search hit BOTTOM without match for: 1pattern')
  exec "normal" "g/aaa\<CR>"
  call s:assert.equals(v:errmsg, 'E385: search hit BOTTOM without match for: aaa')
  silent! exec "normal" "g/aaa/e\<CR>"
  call s:assert.equals(v:errmsg, 'E385: search hit BOTTOM without match for: aaa')
endfunction

function! s:suite.E888__multi_after_zs_and_ze()
  " Vim will crash with version 7.4 under 421
  " http://ftp.vim.org/vim/patches/7.4/7.4.421
  if v:version == 704 && !has('patch421')
    " Vim will clash!
    " exec "normal" "/emacs\\ze*vim\<CR>"
  elseif v:version == 704 && has('patch421')
    set regexpengine=2
    let v:errmsg = ''
    exec "normal" "/emacs\\ze*vim\<CR>"
    " call s:assert.equals(v:errmsg, 'E888: (NFA regexp) cannot repeat \ze')
    call s:assert.match(v:errmsg, 'E888: (NFA regexp) cannot repeat')
    let v:errmsg = ''
    set regexpengine&
  elseif v:version == 703
    exec "normal" "/emacs\\ze*vim\<CR>"
  endif
endfunction

" Warning

function! s:suite.warning_forward()
  set wrapscan
  let v:warningmsg = 'old warning'
  call s:assert.equals(s:get_pos_char(), '1')
  normal! j
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "/3pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '3')
  call s:assert.equals(v:warningmsg, 'old warning')
  exec "normal" "/1pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '1')
  call s:assert.equals(v:warningmsg, 'search hit BOTTOM, continuing at TOP')
endfunction

function! s:suite.warning_backward()
  set wrapscan
  normal! G
  let v:warningmsg = 'old warning'
  call s:assert.equals(s:get_pos_char(), '4')
  normal! k
  call s:assert.equals(s:get_pos_char(), '3')
  exec "normal" "?2pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  call s:assert.equals(v:warningmsg, 'old warning')
  exec "normal" "?4pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '4')
  call s:assert.equals(v:warningmsg, 'search hit TOP, continuing at BOTTOM')
endfunction

function! s:suite.do_not_show_search_hit_TOP_or_BOTTOM_warning_with_stay()
  let g:incsearch#do_not_save_error_message_history = 1
  set wrapscan
  let v:warningmsg = 'old warning'
  call s:assert.equals(s:get_pos_char(), '1')
  normal! j
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "g/3pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  call s:assert.equals(v:warningmsg, 'old warning')
  exec "normal" "g/1pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '2')
  call s:assert.equals(v:warningmsg, 'old warning')
  let g:incsearch#do_not_save_error_message_history = 0
endfunction

function! s:suite.handle_shortmess()
  " :h shortmess
  set shortmess+=s
  set wrapscan
  call s:assert.match(&shortmess, 's')
  let v:warningmsg = 'old warning'
  call s:assert.equals(s:get_pos_char(), '1')
  normal! j
  call s:assert.equals(s:get_pos_char(), '2')
  exec "normal" "/3pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '3')
  call s:assert.equals(v:warningmsg, 'old warning')
  exec "normal" "/1pattern\<CR>"
  call s:assert.equals(s:get_pos_char(), '1')
  call s:assert.equals(v:warningmsg, 'old warning')
  set shortmess&
endfunction

