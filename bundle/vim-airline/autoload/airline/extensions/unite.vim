" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" Plugin: https://github.com/Shougo/unite.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_unite', 0)
  finish
endif

function! airline#extensions#unite#apply(...)
  if &ft == 'unite'
    call a:1.add_section('airline_a', ' Unite ')
    call a:1.add_section('airline_b', ' %{get(unite#get_context(), "buffer_name", "")} ')
    call a:1.add_section('airline_c', ' %{unite#get_status_string()} ')
    call a:1.split()
    call a:1.add_section('airline_y', ' %{get(unite#get_context(), "real_buffer_name", "")} ')
    return 1
  endif
endfunction

function! airline#extensions#unite#init(ext)
  let g:unite_force_overwrite_statusline = 0
  call a:ext.add_statusline_func('airline#extensions#unite#apply')
endfunction
