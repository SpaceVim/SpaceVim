" MIT License. Copyright (c) 2013-2019 Bailey Ling et al.
" Plugin: https://github.com/majutsushi/tagbar
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists(':TagbarToggle')
  finish
endif

let s:flags = get(g:, 'airline#extensions#tagbar#flags', '')
let s:spc = g:airline_symbols.space
let s:init=0

" Arguments: current, sort, fname
function! airline#extensions#tagbar#get_status(...)
  let builder = airline#builder#new({ 'active': a:1 })
  call builder.add_section('airline_a', s:spc.'Tagbar'.s:spc)
  call builder.add_section('airline_b', s:spc.a:2.s:spc)
  call builder.add_section('airline_c', s:spc.a:3.s:spc)
  return builder.build()
endfunction

function! airline#extensions#tagbar#inactive_apply(...)
  if getwinvar(a:2.winnr, '&filetype') == 'tagbar'
    return -1
  endif
endfunction

let s:airline_tagbar_last_lookup_time = 0
let s:airline_tagbar_last_lookup_val = ''
function! airline#extensions#tagbar#currenttag()
  if get(w:, 'airline_active', 0)
    if !s:init
      try
        " try to load the plugin, if filetypes are disabled,
        " this will cause an error, so try only once
        let a=tagbar#currenttag('%', '', '')
      catch
      endtry
      unlet! a
      let s:init=1
    endif
    " function tagbar#currenttag does not exist, if filetype is not enabled
    if s:airline_tagbar_last_lookup_time != localtime() && exists("*tagbar#currenttag")
      let s:airline_tagbar_last_lookup_val = tagbar#currenttag('%s', '', s:flags)
      let s:airline_tagbar_last_lookup_time = localtime()
    endif
    return s:airline_tagbar_last_lookup_val
  endif
  return ''
endfunction

function! airline#extensions#tagbar#init(ext)
  call a:ext.add_inactive_statusline_func('airline#extensions#tagbar#inactive_apply')
  let g:tagbar_status_func = 'airline#extensions#tagbar#get_status'

  call airline#parts#define_function('tagbar', 'airline#extensions#tagbar#currenttag')
endfunction
