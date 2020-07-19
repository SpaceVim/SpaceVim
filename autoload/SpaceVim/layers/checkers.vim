"=============================================================================
" checkers.vim --- SpaceVim checkers layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section checkers, layer-checkers
" @parentsection layers
" SpaceVim uses neomake as default syntax checker.

let s:SIG = SpaceVim#api#import('vim#signatures')
let s:STRING = SpaceVim#api#import('data#string')

function! SpaceVim#layers#checkers#plugins() abort
  let plugins = []

  if g:spacevim_enable_neomake && g:spacevim_enable_ale == 0
    call add(plugins, [g:_spacevim_root_dir . 'bundle/neomake', {'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}])
  elseif g:spacevim_enable_ale
    call add(plugins, ['dense-analysis/ale', {'merged' : 0, 'loadconf_before' : 1}])
  else
    call add(plugins, ['wsdjeg/syntastic', {'on_event': 'WinEnter', 'loadconf' : 1, 'merged' : 0}])
  endif

  return plugins
endfunction

if has('timers')
  let s:show_cursor_error = 1
else
  let s:show_cursor_error = 0
endif

function! SpaceVim#layers#checkers#set_variable(var) abort

  let s:show_cursor_error = get(a:var, 'show_cursor_error', 1)

  if s:show_cursor_error && !has('timers')
    call SpaceVim#logger#warn('show_cursor_error in checkers layer needs timers feature')
    let s:show_cursor_error = 0
  endif
endfunction

function! SpaceVim#layers#checkers#get_options() abort

  return ['show_cursor_error']

endfunction


function! SpaceVim#layers#checkers#config() abort
  "" neomake/neomake {{{
  " This setting will echo the error for the line your cursor is on, if any.
  let g:neomake_echo_current_error = get(g:, 'neomake_echo_current_error', !s:show_cursor_error)
  let g:neomake_cursormoved_delay = get(g:, 'neomake_cursormoved_delay', 300)
  "" }}}

  let g:neomake_virtualtext_current_error = get(g:, 'neomake_virtualtext_current_error', !s:show_cursor_error)

  "" w0rp/ale {{{
  let g:ale_echo_delay = get(g:, 'ale_echo_delay', 300)
  "" }}}

  call SpaceVim#mapping#space#def('nnoremap', ['e', 'c'], 'call call('
        \ . string(s:_function('s:clear_errors')) . ', [])',
        \ 'clear-all-errors', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'h'], '', 'describe-a-syntax-checker', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'v'], '', 'verify-syntax-checker-setup', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'n'], 'call call('
        \ . string(s:_function('s:jump_to_next_error')) . ', [])',
        \ 'next-error', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'l'], 'call call('
        \ . string(s:_function('s:toggle_show_error')) . ', [0])',
        \ 'toggle-showing-the-error-list', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'L'], 'call call('
        \ . string(s:_function('s:toggle_show_error')) . ', [1])',
        \ 'toggle-showing-the-error-list', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'p'], 'call call('
        \ . string(s:_function('s:jump_to_previous_error')) . ', [])',
        \ 'previous-error', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'N'], 'call call('
        \ . string(s:_function('s:jump_to_previous_error')) . ', [])',
        \ 'previous-error', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'v'], 'call call('
        \ . string(s:_function('s:verify_syntax_setup')) . ', [])',
        \ 'verify-syntax-setup', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', '.'], 'call call('
        \ . string(s:_function('s:error_transient_state')) . ', [])',
        \ 'error-transient-state', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 's'], 'call call('
        \ . string(s:_function('s:toggle_syntax_checker')) . ', [])',
        \ 'toggle-syntax-checker', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'e'], 'call call('
        \ . string(s:_function('s:explain_the_error')) . ', [])',
        \ 'explain-the-error', 1)
  augroup SpaceVim_layer_checker
    autocmd!
    if g:spacevim_enable_neomake
      if SpaceVim#layers#isLoaded('core#statusline')
        autocmd User NeomakeFinished nested
              \ let &l:statusline = SpaceVim#layers#core#statusline#get(1)
      endif
      if s:show_cursor_error
        " when move cursor, the error message will be shown below current line
        " after a delay
        autocmd CursorMoved * call <SID>neomake_cursor_move_delay()

        " when switch to Insert mode, stop timer and clear the signature
        if exists('##CmdLineEnter')
          autocmd InsertEnter,WinLeave *
                \ call <SID>neomake_signatures_clear()
          autocmd CmdLineEnter *
                \ call <SID>neomake_signatures_clear()
        else
          autocmd InsertEnter,WinLeave * call <SID>neomake_signatures_clear()
        endif
      endif
    elseif g:spacevim_enable_ale && SpaceVim#layers#isLoaded('core#statusline')
      autocmd User ALELint 
            \ let &l:statusline = SpaceVim#layers#core#statusline#get(1)
    endif
  augroup END
endfunction

function! s:neomake_cursor_move_delay() abort
  call s:neomake_signatures_clear()
  let s:neomake_cursormoved_timer = timer_start(g:neomake_cursormoved_delay,
        \ function('s:neomake_signatures_current_error'))
endfunction

function! s:toggle_show_error(...) abort
  let llist = getloclist(0, {'size' : 1, 'winid' : 1})
  let qlist = getqflist({'size' : 1, 'winid' : 1})
  if llist.size == 0 && qlist.size == 0
    echohl WarningMsg
    echon 'There is no errors!'
    echohl None
    return
  endif
  if llist.winid > 0
    lclose
  elseif qlist.winid > 0
    cclose
  elseif llist.size > 0
    botright lopen
  elseif qlist.size > 0
    botright copen
  endif
  if a:1 == 1
    wincmd w
  endif
endfunction

function! s:jump_to_next_error() abort
  try
    lnext
  catch
    try
      cnext
    catch
      echohl WarningMsg
      echon 'There is no errors!'
      echohl None
    endtry
  endtry
endfunction

function! s:jump_to_previous_error() abort
  try
    lprevious
  catch
    try
      cprevious
    catch
      echohl WarningMsg
      echon 'There is no errors!'
      echohl None
    endtry
  endtry
endfunction

let s:last_echoed_error = ''
function! s:neomake_signatures_current_error(...) abort
  call s:neomake_signatures_clear()
  try
    let message = neomake#GetCurrentErrorMsg()
  catch /^Vim\%((\a\+)\)\=:E117/
    let message = ''
  endtry
  if empty(message)
    if exists('s:last_echoed_error')
      unlet s:last_echoed_error
    endif
    return
  endif
  if exists('s:last_echoed_error')
        \ && s:last_echoed_error == message
    return
  endif
  let s:last_echoed_error = message
  if len(line('.') + 1) > len(message)
    let message = s:STRING.fill(message, len(line('.') + 1))
  endif
  call s:SIG.info(line('.') + 1, 1, message)
endfunction

function! s:neomake_signatures_clear() abort
  if exists('s:neomake_cursormoved_timer') && s:neomake_cursormoved_timer != 0
    call timer_stop(s:neomake_cursormoved_timer)
  endif
  let s:last_echoed_error = ''
  call s:SIG.clear()
endfunction

function! s:verify_syntax_setup() abort
  if g:spacevim_enable_neomake
    NeomakeInfo
  elseif g:spacevim_enable_ale
  else
  endif
endfunction

function! s:toggle_syntax_checker() abort
  call SpaceVim#layers#core#statusline#toggle_section('syntax checking')
  call SpaceVim#layers#core#statusline#toggle_mode('syntax-checking')
  verbose NeomakeToggle
endfunction


function! s:explain_the_error() abort
  if g:spacevim_enable_neomake
    try
      let message = neomake#GetCurrentErrorMsg()
    catch /^Vim\%((\a\+)\)\=:E117/
      let message = ''
    endtry
  elseif g:spacevim_enable_ale
    try
      let message = neomake#GetCurrentErrorMsg()
    catch /^Vim\%((\a\+)\)\=:E117/
      let message = ''
    endtry
  endif
  if !empty(message)
    echo message
  else
    echo 'no error message at this point!'
  endif
endfunction

function! s:error_transient_state() abort
  if g:spacevim_enable_neomake
    let num_errors = neomake#statusline#LoclistCounts()
  elseif g:spacevim_enable_ale
    let counts = ale#statusline#Count(buffer_name('%'))
    let num_errors = counts.error + counts.warning + counts.style_error
          \ + counts.style_warning
  else
    let num_errors = 0
  endif
  if empty(num_errors)
    echo 'no buffers contain error message locations'
    return
  endif
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Error Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ {
        \ 'key' : 'n',
        \ 'desc' : 'next error',
        \ 'func' : '',
        \ 'cmd' : 'try | lnext | catch | endtry',
        \ 'exit' : 0,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : ['p', 'N'],
        \ 'desc' : 'previous error',
        \ 'func' : '',
        \ 'cmd' : 'try | lprevious | catch | endtry',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'q',
        \ 'desc' : 'quit',
        \ 'func' : '',
        \ 'cmd' : '',
        \ 'exit' : 1,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif

" TODO clear errors
function! s:clear_errors() abort
  sign unplace *
endfunction
