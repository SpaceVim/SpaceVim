" MIT License. Copyright (c) 2017-2019 YoungHoon Rhiu et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('g:XkbSwitchLib')
  finish
endif

function! airline#extensions#xkblayout#status()
  let keyboard_layout = libcall(g:XkbSwitchLib, 'Xkb_Switch_getXkbLayout', '')
  let keyboard_layout = split(keyboard_layout, '\.')[-1]
  let short_codes = get(g:, 'airline#extensions#xkblayout#short_codes', {'2SetKorean': 'KR', 'Chinese': 'CN', 'Japanese': 'JP'})

  if has_key(short_codes, keyboard_layout)
    let keyboard_layout = short_codes[keyboard_layout]
  endif

  return keyboard_layout
endfunction

function! airline#extensions#xkblayout#init(ext)
  call airline#parts#define_function('xkblayout', 'airline#extensions#xkblayout#status')
endfunction
