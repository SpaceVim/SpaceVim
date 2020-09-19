" MIT License. Copyright (c) 2015-2019 Evgeny Firsov et al.
" Plugin: https://github.com/ycm-core/YouCompleteMe
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_youcompleteme', 0)
  finish
endif

let s:spc = g:airline_symbols.space
let s:error_symbol = get(g:, 'airline#extensions#ycm#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#ycm#warning_symbol', 'W:')

function! airline#extensions#ycm#init(ext)
  call airline#parts#define_function('ycm_error_count', 'airline#extensions#ycm#get_error_count')
  call airline#parts#define_function('ycm_warning_count', 'airline#extensions#ycm#get_warning_count')
endfunction

function! airline#extensions#ycm#get_error_count() abort
  if exists("*youcompleteme#GetErrorCount")
    let cnt = youcompleteme#GetErrorCount()

    if cnt != 0
      return s:error_symbol.cnt
    endif
  endif

  return ''
endfunction

function! airline#extensions#ycm#get_warning_count()
  if exists("*youcompleteme#GetWarningCount")
    let cnt = youcompleteme#GetWarningCount()

    if cnt != 0
      return s:warning_symbol.cnt.s:spc
    endif
  endif

  return ''
endfunction
