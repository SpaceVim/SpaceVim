" MIT Licsense.
" Plugin: https://github.com/vheon/vim-cursormode
" Copyright (C) 2014 Andrea Cedraro <a.cedraro@gmail.com>,
" Copyright (C) 2017 Eduardo Suarez-Santana <e.suarezsantana@gmail.com>

scriptencoding utf-8

if exists('g:loaded_cursormode')
  finish
endif

let g:loaded_cursormode = 1

let s:is_win = has('win32') || has('win64')
let s:is_iTerm = exists('$TERM_PROGRAM') && $TERM_PROGRAM =~# 'iTerm.app'
let s:is_AppleTerminal = exists('$TERM_PROGRAM') && $TERM_PROGRAM =~# 'Apple_Terminal'

let s:is_good = !has('gui_running') && !s:is_win && !s:is_AppleTerminal

let s:last_mode = ''

if !exists('g:cursormode_exit_mode')
  let g:cursormode_exit_mode='n'
endif

function! airline#extensions#cursormode#tmux_escape(escape)
  return '\033Ptmux;'.substitute(a:escape, '\\033', '\\033\\033', 'g').'\033\\'
endfunction

let s:iTerm_escape_template = '\033]Pl%s\033\\'
let s:xterm_escape_template = '\033]12;%s\007'

function! s:get_mode()
  return call(get(g:, 'cursormode_mode_func', 'mode'), [])
endfunction

function! airline#extensions#cursormode#set(...)
  let mode = s:get_mode()
  if mode !=# s:last_mode
    let s:last_mode = mode
  call s:set_cursor_color_for(mode)
  endif
  return ''
endfunction

function! s:set_cursor_color_for(mode)
  let mode = a:mode
  for mode in [a:mode, a:mode.&background]
    if has_key(s:color_map, mode)
      try
        let save_eventignore = &eventignore
        set eventignore=all
        let save_shelltemp = &shelltemp
        set noshelltemp

        silent call system(s:build_command(s:color_map[mode]))
        return
      finally
        let &shelltemp = save_shelltemp
        let &eventignore = save_eventignore
      endtry
    endif
  endfor
endfunction

function! s:build_command(color)
  if s:is_iTerm
    let color = substitute(a:color, '^#', '', '')
    let escape_template = s:iTerm_escape_template
  else
    let color = a:color
    let escape_template = s:xterm_escape_template
  endif

  let escape = printf(escape_template, color)
  if exists('$TMUX')
    let escape = airline#extensions#cursormode#tmux_escape(escape)
  endif
  return "printf '".escape."' > /dev/tty"
endfunction

function! s:get_color_map()
  if exists('g:cursormode_color_map')
    return g:cursormode_color_map
  endif

  try
    let map = g:cursormode#{g:colors_name}#color_map
    return map
  catch
    return {
          \   "nlight": "#000000",
          \   "ndark":  "#BBBBBB",
          \   "i":      "#0000BB",
          \   "v":      "#FF5555",
          \   "V":      "#BBBB00",
          \   "\<C-V>": "#BB00BB",
          \ }
  endtry
endfunction

augroup airline#extensions#cursormode
  autocmd!
  autocmd VimLeave * nested call s:set_cursor_color_for(g:cursormode_exit_mode)
  " autocmd VimEnter * call airline#extensions#cursormode#activate()
  autocmd Colorscheme * call airline#extensions#cursormode#activate()
augroup END

function! airline#extensions#cursormode#activate()
  let s:color_map = s:get_color_map()
  call airline#extensions#cursormode#set()
endfunction

function! airline#extensions#cursormode#apply(...)
  let w:airline_section_a = get(w:, 'airline_section_a', g:airline_section_a)
  let w:airline_section_a .= '%{airline#extensions#cursormode#set()}'
endfunction

function! airline#extensions#cursormode#init(ext)
  let s:color_map = s:get_color_map()
  call a:ext.add_statusline_func('airline#extensions#cursormode#apply')
endfunction
