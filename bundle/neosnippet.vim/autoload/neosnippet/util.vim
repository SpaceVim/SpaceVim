"=============================================================================
" FILE: util.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! neosnippet#util#get_vital() abort
  if !exists('s:V')
    let s:V = vital#neosnippet#new()
  endif
  return s:V
endfunction
function! s:get_prelude() abort
  if !exists('s:Prelude')
    let s:Prelude = neosnippet#util#get_vital().import('Prelude')
  endif
  return s:Prelude
endfunction
function! s:get_list() abort
  if !exists('s:List')
    let s:List = neosnippet#util#get_vital().import('Data.List')
  endif
  return s:List
endfunction
function! s:get_string() abort
  if !exists('s:String')
    let s:String = neosnippet#util#get_vital().import('Data.String')
  endif
  return s:String
endfunction
function! s:get_process() abort
  if !exists('s:Process')
    let s:Process = neosnippet#util#get_vital().import('Process')
  endif
  return s:Process
endfunction

function! neosnippet#util#substitute_path_separator(...) abort
  return call(s:get_prelude().substitute_path_separator, a:000)
endfunction
function! neosnippet#util#system(...) abort
  return call(s:get_process().system, a:000)
endfunction
function! neosnippet#util#has_vimproc(...) abort
  return call(s:get_process().has_vimproc, a:000)
endfunction
function! neosnippet#util#is_windows(...) abort
  return call(s:get_prelude().is_windows, a:000)
endfunction
function! neosnippet#util#is_mac(...) abort
  return call(s:get_prelude().is_mac, a:000)
endfunction
function! neosnippet#util#get_last_status(...) abort
  return call(s:get_process().get_last_status, a:000)
endfunction
function! neosnippet#util#escape_pattern(...) abort
  return call(s:get_string().escape_pattern, a:000)
endfunction
function! neosnippet#util#iconv(...) abort
  return call(s:get_process().iconv, a:000)
endfunction
function! neosnippet#util#truncate(...) abort
  return call(s:get_string().truncate, a:000)
endfunction
function! neosnippet#util#strwidthpart(...) abort
  return call(s:get_string().strwidthpart, a:000)
endfunction

function! neosnippet#util#expand(path) abort
  return neosnippet#util#substitute_path_separator(
        \ expand(escape(a:path, '*?[]"={}'), 1))
endfunction
function! neosnippet#util#set_default(var, val, ...) abort 
  let old_var = get(a:000, 0, '')
  if exists(old_var)
    let {a:var} = {old_var}
  elseif !exists(a:var)
    let {a:var} = a:val
  endif
endfunction
function! neosnippet#util#set_dictionary_helper(...) abort
  return call(s:get_prelude().set_dictionary_helper, a:000)
endfunction

function! neosnippet#util#get_cur_text() abort
  return
        \ (mode() ==# 'i' ? (col('.')-1) : col('.')) >= len(getline('.')) ?
        \      getline('.') :
        \      matchstr(getline('.'),
        \         '^.*\%' . col('.') . 'c' . (mode() ==# 'i' ? '' : '.'))
endfunction
function! neosnippet#util#get_next_text() abort
  return getline('.')[len(neosnippet#util#get_cur_text()) :]
endfunction
function! neosnippet#util#print_error(string) abort
  echohl Error | echomsg '[neosnippet] ' . a:string | echohl None
endfunction

function! neosnippet#util#parse_options(args, options_list) abort
  let args = []
  let options = {}
  for arg in split(a:args, '\%(\\\@<!\s\)\+')
    let arg = substitute(arg, '\\\( \)', '\1', 'g')

    let matched_list = filter(copy(a:options_list),
          \  'stridx(arg, v:val) == 0')
    for option in matched_list
      let key = substitute(substitute(option, '-', '_', 'g'), '=$', '', '')[1:]
      let options[key] = (option =~# '=$') ?
            \ arg[len(option) :] : 1
      break
    endfor

    if empty(matched_list)
      call add(args, arg)
    endif
  endfor

  return [args, options]
endfunction
function! neosnippet#util#get_buffer_config(
      \ filetype, buffer_var, user_var, default_var, ...) abort
  let default_val = get(a:000, 0, '')

  if exists(a:buffer_var)
    return {a:buffer_var}
  endif

  let filetype = !has_key({a:user_var}, a:filetype)
        \ && !has_key(eval(a:default_var), a:filetype) ? '_' : a:filetype

  return get({a:user_var}, filetype,
        \   get(eval(a:default_var), filetype, default_val))
endfunction

" Sudo check.
function! neosnippet#util#is_sudo() abort
  return $SUDO_USER !=# '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)
endfunction

function! neosnippet#util#option2list(str) abort
  return type(a:str) == type('') ? split(a:str, '\s*,\s*') : a:str
endfunction

function! neosnippet#util#uniq(list) abort
  let list = copy(a:list)
  let i = 0
  let seen = {}
  while i < len(list)
    let key = list[i]
    if key !=# '' && has_key(seen, key)
      call remove(list, i)
    else
      if key !=# ''
        let seen[key] = 1
      endif
      let i += 1
    endif
  endwhile
  return list
endfunction
