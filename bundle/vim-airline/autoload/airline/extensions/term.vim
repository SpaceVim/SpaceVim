" MIT License. Copyright (c) 2013-2020 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

call airline#parts#define_function('tmode', 'airline#extensions#term#termmode')
call airline#parts#define('terminal', {'text': get(g:airline_mode_map, 't', 't'), 'accent': 'bold'})
let s:section_a = airline#section#create_left(['terminal', 'tmode'])

function! airline#extensions#term#apply(...)
  if &buftype == 'terminal' || bufname('%')[0] == '!'
    let spc = g:airline_symbols.space

    call a:1.add_section('airline_a', spc.s:section_a.spc)
    call a:1.add_section('airline_b', '')
    call a:1.add_section('airline_term', spc.s:termname())
    call a:1.split()
    call a:1.add_section('airline_y', '')
    call a:1.add_section('airline_z', spc.airline#section#create_right(['linenr', 'maxlinenr']))
    return 1
  endif
endfunction

function! airline#extensions#term#inactive_apply(...)
  if getbufvar(a:2.bufnr, '&buftype') == 'terminal'
    let spc = g:airline_symbols.space
    call a:1.add_section('airline_a', spc.'TERMINAL'.spc)
    call a:1.add_section('airline_b', spc.'%f')
    let neoterm_id = getbufvar(a:2.bufnr, 'neoterm_id')
    if neoterm_id != ''
      call a:1.add_section('airline_c', spc.'neoterm_'.neoterm_id.spc)
    endif
    return 1
  endif
endfunction

function! airline#extensions#term#termmode()
  let mode = airline#parts#mode()[0]
  if mode ==? 'T'
    " don't need to output T, statusline already says "TERMINAL"
    let mode=''
  endif
  return mode
endfunction

function! s:termname()
  let bufname = bufname('%')
  if has('nvim')
    return matchstr(bufname, 'term.*:\zs.*')
  else
    " get rid of leading '!'
    if bufname[0] is# '!'
      return bufname[1:]
    else
      return bufname
    endif
  endif
endfunction

function! airline#extensions#term#init(ext)
  call a:ext.add_statusline_func('airline#extensions#term#apply')
  call a:ext.add_inactive_statusline_func('airline#extensions#term#inactive_apply')
endfunction
