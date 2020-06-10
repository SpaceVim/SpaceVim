" MIT License. Copyright (c) 2018-2019 mox et al.
" Plugin: https://github.com/mox-mox/localsearch
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:enabled = get(g:, 'airline#extensions#localsearch#enabled', 1)
if !get(g:, 'loaded_localsearch', 0) || !s:enabled || get(g:, 'airline#extensions#localsearch#loaded', 0)
  finish
endif
let g:airline#extensions#localsearch#loaded = 001

let s:spc = g:airline_symbols.space

function! airline#extensions#localsearch#load_theme(palette)
  call airline#highlighter#exec('localsearch_dark', [ '#ffffff' , '#000000' , 15  , 1 , ''])
endfunction


function! airline#extensions#localsearch#init(ext)
	call a:ext.add_theme_func('airline#extensions#localsearch#load_theme')
	call a:ext.add_statusline_func('airline#extensions#localsearch#apply')
endfunction


function! airline#extensions#localsearch#apply(...)
  " first variable is the statusline builder
  let builder = a:1

  """"" WARNING: the API for the builder is not finalized and may change
  if exists('#localsearch#WinEnter') " If localsearch mode is enabled
    call builder.add_section('localsearch_dark', s:spc.airline#section#create('LS').s:spc)
  endif
  return 0
endfunction

