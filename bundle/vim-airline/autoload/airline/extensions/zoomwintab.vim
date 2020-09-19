" MIT License. Copyright (c) 2020 Dmitry Geurkov (d.geurkov@gmail.com)
" Plugin: https://github.com/troydm/zoomwintab.vim
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8


" Avoid installing twice
if exists('g:loaded_vim_airline_zoomwintab')
  finish
endif

let g:loaded_vim_airline_zoomwintab = 1

let s:zoomwintab_status_zoomed_in =
  \ get(g:, 'airline#extensions#zoomwintab#status_zoomed_in', g:airline_left_alt_sep.' Zoomed')
let s:zoomwintab_status_zoomed_out =
  \ get(g:, 'airline#extensions#zoomwintab#status_zoomed_out', '')

function! airline#extensions#zoomwintab#apply(...) abort
  call airline#extensions#prepend_to_section('gutter',
    \ exists('t:zoomwintab') ? s:zoomwintab_status_zoomed_in : s:zoomwintab_status_zoomed_out)
endfunction

function! airline#extensions#zoomwintab#init(ext) abort
  call a:ext.add_statusline_func('airline#extensions#zoomwintab#apply')
endfunction
