" MIT License. Copyright (c) 2013-2020
" Plugin: https://github.com/lambdalisue/gina.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8
if !get(g:, 'loaded_gina', 0)
  finish
endif

function! airline#extensions#gina#apply(...) abort
  if (&ft =~# 'gina' && &ft !~# 'blame') || &ft ==# 'diff'
    call a:1.add_section('airline_a', ' gina ')
    call a:1.add_section('airline_b', ' %{gina#component#repo#branch()} ')
    call a:1.split()
    call a:1.add_section('airline_y', ' staged %{gina#component#status#staged()} ')
    call a:1.add_section('airline_z', ' unstaged %{gina#component#status#unstaged()} ')
    return 1
  endif
endfunction

function! airline#extensions#gina#init(ext) abort
  let g:gina_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#gina#apply')
endfunction
