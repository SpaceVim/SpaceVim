" MIT License. Copyright (c) 2013-2019 Doron Behar, C.Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !has('keymap')
  finish
endif

function! airline#extensions#keymap#status()
  if (get(g:, 'airline#extensions#keymap#enabled', 1) && has('keymap'))
    return printf('%s', (!empty(&keymap) ? (g:airline_symbols.keymap . ' '. &keymap) : ''))
  else
    return ''
  endif
endfunction

function! airline#extensions#keymap#init(ext)
  call airline#parts#define_function('keymap', 'airline#extensions#keymap#status')
endfunction
