" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" Plugin: https://github.com/vim-syntastic/syntastic
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':SyntasticCheck')
  finish
endif

let s:error_symbol = get(g:, 'airline#extensions#syntastic#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#syntastic#warning_symbol', 'W:')

function! airline#extensions#syntastic#get_warning()
  return airline#extensions#syntastic#get('warning')
endfunction

function! airline#extensions#syntastic#get_error()
  return airline#extensions#syntastic#get('error')
endfunction

function! airline#extensions#syntastic#get(type)
  let _backup = get(g:, 'syntastic_stl_format', '')
  let is_err = (a:type  is# 'error')
  if is_err
    let g:syntastic_stl_format = get(g:, 'airline#extensions#syntastic#stl_format_err', '%E{[%fe(#%e)]}')
  else
    let g:syntastic_stl_format = get(g:, 'airline#extensions#syntastic#stl_format_warn', '%W{[%fw(#%w)]}')
  endif
  let cnt = SyntasticStatuslineFlag()
  if !empty(_backup)
    let g:syntastic_stl_format = _backup
  endif
  if empty(cnt)
    return ''
  else
    return (is_err ? s:error_symbol : s:warning_symbol).cnt
  endif
endfunction

function! airline#extensions#syntastic#init(ext)
  call airline#parts#define_function('syntastic-warn', 'airline#extensions#syntastic#get_warning')
  call airline#parts#define_function('syntastic-err', 'airline#extensions#syntastic#get_error')
endfunction
