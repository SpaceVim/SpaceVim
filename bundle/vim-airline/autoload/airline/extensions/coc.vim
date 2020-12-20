" MIT License. Copyright (c) 2019 Peng Guanwen et al.
" vim: et ts=2 sts=2 sw=2
" Plugin: https://github.com/neoclide/coc

scriptencoding utf-8

let s:error_symbol = get(g:, 'airline#extensions#coc#error_symbol', 'E:')
let s:warning_symbol = get(g:, 'airline#extensions#coc#warning_symbol', 'W:')

function! airline#extensions#coc#get_warning() abort
  return airline#extensions#coc#get('warning')
endfunction

function! airline#extensions#coc#get_error() abort
  return airline#extensions#coc#get('error')
endfunction

function! airline#extensions#coc#get(type) abort
  if !exists(':CocCommand')
    return ''
  endif
  let _backup = get(g:, 'coc_stl_format', '')
  let is_err = (a:type  is# 'error')
  if is_err
    let g:coc_stl_format = get(g:, 'airline#extensions#coc#stl_format_err', '%E{[%e(#%fe)]}')
  else
    let g:coc_stl_format = get(g:, 'airline#extensions#coc#stl_format_warn', '%W{[%w(#%fw)]}')
  endif
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif


  let cnt = get(info, a:type, 0)
  if !empty(_backup)
    let g:coc_stl_format = _backup
  endif

  if empty(cnt)
    return ''
  else
    return (is_err ? s:error_symbol : s:warning_symbol).cnt
  endif
endfunction

function! airline#extensions#coc#get_status() abort
  " Shorten text for windows < 91 characters
  return airline#util#shorten(get(g:, 'coc_status', ''), 91, 9)
endfunction

function! airline#extensions#coc#init(ext) abort
  call airline#parts#define_function('coc_error_count', 'airline#extensions#coc#get_error')
  call airline#parts#define_function('coc_warning_count', 'airline#extensions#coc#get_warning')
  call airline#parts#define_function('coc_status', 'airline#extensions#coc#get_status')
endfunction
