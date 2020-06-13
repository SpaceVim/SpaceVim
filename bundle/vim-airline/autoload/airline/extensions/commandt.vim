" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" Plugin: https://github.com/wincent/command-t
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'command_t_loaded', 0)
  finish
endif

function! airline#extensions#commandt#apply(...)
  if bufname('%') ==# 'GoToFile'
    call airline#extensions#apply_left_override('CommandT', '')
  endif
endfunction

function! airline#extensions#commandt#init(ext)
  call a:ext.add_statusline_func('airline#extensions#commandt#apply')
endfunction
