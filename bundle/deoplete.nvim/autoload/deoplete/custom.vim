"=============================================================================
" FILE: custom.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! deoplete#custom#_init() abort
  let s:custom = {}
  let s:custom.source = {}
  let s:custom.source._ = {}
  let s:custom.option = deoplete#init#_option()
  let s:custom.filter = {}

  let s:cached = {}
  let s:cached.option = {}
  let s:cached.filter = {}
  let s:cached.buffer_option = {}
  let s:cached.source_vars = {}
endfunction
function! deoplete#custom#_init_buffer() abort
  let b:custom = {}
  let b:custom.option = {}
  let b:custom.source_vars = {}
  let b:custom.filter = {}
endfunction

function! deoplete#custom#_update_cache() abort
  if !exists('s:custom')
    call deoplete#custom#_init()
  endif

  let custom_buffer = deoplete#custom#_get_buffer()

  let s:cached.option = copy(s:custom.option)
  let s:cached.buffer_option = copy(custom_buffer.option)
  call extend(s:cached.option, s:cached.buffer_option)

  let s:cached.source_vars = {}
  for [name, source] in items(s:custom.source)
    let s:cached.source_vars[name] = get(source, 'vars', {})
  endfor
  for [name, vars] in items(custom_buffer.source_vars)
    if !has_key(s:cached.source_vars, name)
      let s:cached.source_vars[name] = {}
    endif
    call extend(s:cached.source_vars[name], vars)
  endfor
  let s:cached.filter = {}
  for [name, vars] in items(s:custom.filter)
    let s:cached.filter[name] = vars
  endfor
  for [name, vars] in items(custom_buffer.filter)
    if !has_key(s:cached.filter, name)
      let s:cached.filter[name] = {}
    endif
    call extend(s:cached.filter[name], vars)
  endfor
endfunction

function! deoplete#custom#_get() abort
  if !exists('s:custom')
    call deoplete#custom#_init()
  endif

  return s:custom
endfunction
function! deoplete#custom#_get_buffer() abort
  if !exists('b:custom')
    call deoplete#custom#_init_buffer()
  endif

  return b:custom
endfunction

function! deoplete#custom#_get_source(source_name) abort
  let custom = deoplete#custom#_get().source

  if !has_key(custom, a:source_name)
    let custom[a:source_name] = {}
  endif

  return custom[a:source_name]
endfunction
function! deoplete#custom#_get_option(name) abort
  return s:cached.option[a:name]
endfunction
function! deoplete#custom#_get_filetype_option(name, filetype, default) abort
  let buffer_option = s:cached.buffer_option
  if has_key(buffer_option, a:name)
    " Use buffer_option instead
    return buffer_option[a:name]
  endif

  let option = s:cached.option[a:name]
  let filetype = has_key(option, a:filetype) ? a:filetype : '_'
  return get(option, filetype, a:default)
endfunction
function! deoplete#custom#_get_source_vars(name) abort
  return get(s:cached.source_vars, a:name, {})
endfunction
function! deoplete#custom#_get_filter(name) abort
  return get(s:cached.filter, a:name, {})
endfunction

function! deoplete#custom#source(source_name, name_or_dict, ...) abort
  for key in deoplete#util#split(a:source_name)
    let custom_source = deoplete#custom#_get_source(key)
    call s:set_custom(custom_source, a:name_or_dict, get(a:000, 0, ''))
  endfor
endfunction

function! deoplete#custom#var(source_name, name_or_dict, ...) abort
  for key in deoplete#util#split(a:source_name)
    let custom_source = deoplete#custom#_get_source(key)
    let vars = get(custom_source, 'vars', {})
    call s:set_custom(vars, a:name_or_dict, get(a:000, 0, ''))
    call deoplete#custom#source(key, 'vars', vars)
  endfor
endfunction
function! deoplete#custom#buffer_var(source_name, name_or_dict, ...) abort
  let custom = deoplete#custom#_get_buffer().source_vars
  for key in deoplete#util#split(a:source_name)
    if !has_key(custom, key)
      let custom[key] = {}
    endif
    let vars = custom[key]
    call s:set_custom(vars, a:name_or_dict, get(a:000, 0, ''))
  endfor
endfunction

function! deoplete#custom#filter(filter_name, name_or_dict, ...) abort
  let custom = deoplete#custom#_get().filter
  for key in deoplete#util#split(a:filter_name)
    if !has_key(custom, key)
      let custom[key] = {}
    endif
    let vars = custom[key]
    call s:set_custom(vars, a:name_or_dict, get(a:000, 0, ''))
  endfor
endfunction
function! deoplete#custom#buffer_filter(filter_name, name_or_dict, ...) abort
  let custom = deoplete#custom#_get_buffer().filter
  for key in deoplete#util#split(a:filter_name)
    if !has_key(custom, key)
      let custom[key] = {}
    endif
    let vars = custom[key]
    call s:set_custom(vars, a:name_or_dict, get(a:000, 0, ''))
  endfor
endfunction

function! deoplete#custom#option(name_or_dict, ...) abort
  let custom = deoplete#custom#_get().option
  call s:set_custom(custom, a:name_or_dict, get(a:000, 0, ''))
endfunction
function! deoplete#custom#buffer_option(name_or_dict, ...) abort
  let custom = deoplete#custom#_get_buffer().option
  call s:set_custom(custom, a:name_or_dict, get(a:000, 0, ''))
endfunction

function! s:set_custom(dest, name_or_dict, value) abort
  if type(a:name_or_dict) == v:t_dict
    call extend(a:dest, a:name_or_dict)
  else
    call s:set_value(a:dest, a:name_or_dict, a:value)
  endif
endfunction
function! s:set_value(dest, name, value) abort
  if type(a:value) == v:t_dict && !empty(a:value)
    if !has_key(a:dest, a:name)
      let a:dest[a:name] = {}
    endif
    call extend(a:dest[a:name], a:value)
  else
    let a:dest[a:name] = a:value
  endif
endfunction
