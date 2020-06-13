"=============================================================================
" FILE: custom.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! defx#custom#_get() abort
  if !exists('s:custom')
    call defx#custom#_init()
  endif

  return s:custom
endfunction

function! defx#custom#_init() abort
  let s:custom = {}
  let s:custom.column = {}
  let s:custom.option = {}
  let s:custom.source = {}
endfunction

function! defx#custom#column(column_name, name_or_dict, ...) abort
  let custom = defx#custom#_get().column

  for key in defx#util#split(a:column_name)
    if !has_key(custom, key)
      let custom[key] = {}
    endif
    call s:set_custom(custom[key], a:name_or_dict, get(a:000, 0, ''))
  endfor
endfunction

function! defx#custom#option(buffer_name, name_or_dict, ...) abort
  let custom = defx#custom#_get().option

  for key in defx#util#split(a:buffer_name)
    if !has_key(custom, key)
      let custom[key] = {}
    endif

    call s:set_custom(custom[key], a:name_or_dict, get(a:000, 0, ''))
  endfor
endfunction

function! defx#custom#source(source_name, name_or_dict, ...) abort
  let custom = defx#custom#_get().source

  for key in defx#util#split(a:source_name)
    if !has_key(custom, key)
      let custom[key] = {}
    endif
    call s:set_custom(custom[key], a:name_or_dict, get(a:000, 0, ''))
  endfor
endfunction

function! s:set_custom(dest, name_or_dict, value) abort
  if type(a:name_or_dict) == v:t_dict
    call extend(a:dest, a:name_or_dict)
  else
    let a:dest[a:name_or_dict] = a:value
  endif
endfunction
