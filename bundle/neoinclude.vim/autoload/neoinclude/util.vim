"=============================================================================
" FILE: util.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!isdirectory('/proc') && executable('sw_vers')))
let s:is_unix = has('unix')

function! neoinclude#util#is_windows() abort
  return s:is_windows
endfunction

function! neoinclude#util#is_cygwin() abort
  return s:is_cygwin
endfunction

function! neoinclude#util#is_mac() abort
  return s:is_mac
endfunction

function! neoinclude#util#uniq(list) abort
  let dict = {}
  for item in a:list
    if !has_key(dict, item)
      let dict[item] = item
    endif
  endfor

  return values(dict)
endfunction

function! neoinclude#util#glob(pattern) abort
  " Escape [.
  if neoinclude#util#is_windows()
    let glob = substitute(a:pattern, '\[', '\\[[]', 'g')
  else
    let glob = escape(a:pattern, '[')
  endif

  return split(neoinclude#util#substitute_path_separator(glob(glob)), '\n')
endfunction

function! neoinclude#util#substitute_path_separator(path) abort
  return s:is_windows ? substitute(a:path, '\\', '/', 'g') : a:path
endfunction

function! neoinclude#util#set_default_dictionary(variable, keys, value) abort
  call neoinclude#util#set_dictionary_helper({a:variable}, a:keys, a:value)
endfunction
function! neoinclude#util#set_dictionary_helper(variable, keys, pattern) abort
  for key in split(a:keys, '\s*,\s*')
    if !has_key(a:variable, key)
      let a:variable[key] = a:pattern
    endif
  endfor
endfunction

function! neoinclude#util#system(command) abort
  let command = s:iconv(a:command, &encoding, 'char')
  let output = s:iconv(system(command), 'char', &encoding)

  return substitute(output, '\n$', '', '')
endfunction
function! neoinclude#util#async_system(command) abort
  let command = s:iconv(a:command, &encoding, 'char')

  if has('job')
    return job_start(command)
  elseif has('nvim')
    return jobstart(command)
  else
    return neoinclude#util#system(a:command)
  endif
endfunction

function! s:iconv(expr, from, to) abort
  if a:from == '' || a:to == '' || a:from ==? a:to
    return a:expr
  endif
  let result = iconv(a:expr, a:from, a:to)
  return result != '' ? result : a:expr
endfunction

function! neoinclude#util#get_context_filetype() abort
  " context_filetype.vim installation check.
  if !exists('s:exists_context_filetype')
    try
      call context_filetype#version()
      let s:exists_context_filetype = 1
    catch
      let s:exists_context_filetype = 0
    endtry
  endif

  return s:exists_context_filetype ?
        \ context_filetype#get_filetype() : &filetype
endfunction

function! neoinclude#util#get_buffer_config(
      \ filetype, buffer_var, user_var, default_var, ...)
  let default_val = get(a:000, 0, '')

  if exists(a:buffer_var)
    return {a:buffer_var}
  endif

  let filetype = !has_key(a:user_var, a:filetype)
        \ && !has_key(a:default_var, a:filetype) ? '_' : a:filetype

  return get(a:user_var, filetype,
        \   get(a:default_var, filetype, default_val))
endfunction

function! neoinclude#util#head_match(checkstr, headstr) abort
  let checkstr = &ignorecase ?
        \ tolower(a:checkstr) : a:checkstr
  let headstr = &ignorecase ?
        \ tolower(a:headstr) : a:headstr
  return stridx(checkstr, headstr) == 0
endfunction

function! neoinclude#util#cd(dir) abort
  let cwd = getcwd()
  if !isdirectory(a:dir) || a:dir ==# cwd
    return []
  endif

  let cd_command = haslocaldir() ? 'lcd' :
        \ (exists(':tcd') == 2 && haslocaldir(-1, 0)) ? 'tcd' : 'cd'
  silent! execute cd_command fnameescape(a:dir)
  return [cd_command, cwd]
endfunction
