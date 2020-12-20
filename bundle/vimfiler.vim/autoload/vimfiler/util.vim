"=============================================================================
" FILE: util.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! vimfiler#util#get_vital() abort
  if !exists('s:V')
    let s:V = vital#vimfiler#new()
  endif
  return s:V
endfunction
function! vimfiler#util#get_vital_cache() abort
  if !exists('s:Cache')
    let s:Cache = vimfiler#util#get_vital().import('System.Cache.Deprecated')
  endif
  return s:Cache
endfunction
function! vimfiler#util#get_vital_buffer() abort
  return vimfiler#util#get_vital().import('Vim.Buffer')
endfunction
function! s:get_prelude() abort
  if !exists('s:Prelude')
    let s:Prelude = vimfiler#util#get_vital().import('Prelude')
  endif
  return s:Prelude
endfunction
function! s:get_list() abort
  if !exists('s:List')
    let s:List = vimfiler#util#get_vital().import('Data.List')
  endif
  return s:List
endfunction
function! s:get_message() abort
  if !exists('s:Message')
    let s:Message = vimfiler#util#get_vital().import('Vim.Message')
  endif
  return s:Message
endfunction
function! s:get_process() abort
  if !exists('s:Process')
    let s:Process = vimfiler#util#get_vital().import('Process')
  endif
  return s:Process
endfunction
function! s:get_string() abort
  if !exists('s:String')
    let s:String = vimfiler#util#get_vital().import('Data.String')
  endif
  return s:String
endfunction

let s:is_windows = has('win16') || has('win32') || has('win64')

function! vimfiler#util#truncate_smart(...) abort
  return call(s:get_string().truncate_skipping, a:000)
endfunction
function! vimfiler#util#truncate(...) abort
  return call(s:get_string().truncate, a:000)
endfunction
function! vimfiler#util#is_windows(...) abort
  return s:is_windows
endfunction
function! vimfiler#util#is_win_path(path) abort
  return a:path =~ '^\a\?:' || a:path =~ '^\\\\[^\\]\+\\'
endfunction
function! vimfiler#util#print_error(msg) abort
  let msg = '[vimfiler] ' . a:msg
  return call(s:get_message().error, [msg])
endfunction
function! vimfiler#util#escape_file_searching(...) abort
  return call(s:get_prelude().escape_file_searching, a:000)
endfunction
function! vimfiler#util#escape_pattern(...) abort
  return call(s:get_string().escape_pattern, a:000)
endfunction
function! vimfiler#util#set_default(...) abort
  return call(s:get_prelude().set_default, a:000)
endfunction
function! vimfiler#util#set_dictionary_helper(...) abort
  return call(s:get_prelude().set_dictionary_helper, a:000)
endfunction
function! vimfiler#util#substitute_path_separator(...) abort
  return call(s:get_prelude().substitute_path_separator, a:000)
endfunction
function! vimfiler#util#path2directory(...) abort
  return call(s:get_prelude().path2directory, a:000)
endfunction
function! vimfiler#util#path2project_directory(...) abort
  return call(s:get_prelude().path2project_directory, a:000)
endfunction
function! vimfiler#util#has_vimproc(...) abort
  return call(s:get_process().has_vimproc, a:000)
endfunction
function! vimfiler#util#system(...) abort
  return call(s:get_process().system, a:000)
endfunction
function! vimfiler#util#get_last_status(...) abort
  return call(s:get_process().get_last_status, a:000)
endfunction
function! vimfiler#util#sort_by(...) abort
  return call(s:get_list().sort_by, a:000)
endfunction
function! vimfiler#util#escape_file_searching(...) abort
  return call(s:get_prelude().escape_file_searching, a:000)
endfunction

function! vimfiler#util#has_lua() abort
  " Note: Disabled if_lua feature if less than 7.3.885.
  " Because if_lua has double free problem.
  return has('lua') && (v:version > 703 || v:version == 703 && has('patch885'))
endfunction

function! vimfiler#util#is_cmdwin() abort
  return bufname('%') ==# '[Command Line]'
endfunction

function! vimfiler#util#expand(path) abort
  return s:get_prelude().substitute_path_separator(
        \ (a:path =~ '^\~') ? substitute(a:path, '^\~', expand('~'), '') :
        \ (a:path =~ '^\$\h\w*') ? substitute(a:path,
        \               '^\$\h\w*', '\=eval(submatch(0))', '') :
        \ a:path)
endfunction
function! vimfiler#util#set_default_dictionary_helper(variable, keys, value) abort
  for key in split(a:keys, '\s*,\s*')
    if !has_key(a:variable, key)
      let a:variable[key] = a:value
    endif
  endfor
endfunction
function! vimfiler#util#set_dictionary_helper(variable, keys, value) abort
  for key in split(a:keys, '\s*,\s*')
    let a:variable[key] = a:value
  endfor
endfunction
function! vimfiler#util#resolve(filename) abort
  return ((vimfiler#util#is_windows() && fnamemodify(a:filename, ':e') ==? 'LNK') || getftype(a:filename) ==# 'link') ?
        \ vimfiler#util#substitute_path_separator(resolve(a:filename)) : a:filename
endfunction

function! vimfiler#util#set_variables(variables) abort
  let variables_save = {}
  for [key, value] in items(a:variables)
    let save_value = exists(key) ? eval(key) : ''

    let variables_save[key] = save_value
    execute 'let' key '=' string(value)
  endfor

  return variables_save
endfunction
function! vimfiler#util#restore_variables(variables_save) abort
  for [key, value] in items(a:variables_save)
    execute 'let' key '=' string(value)
  endfor
endfunction

function! vimfiler#util#hide_buffer(...) abort
  let bufnr = get(a:000, 0, bufnr('%'))

  let vimfiler = getbufvar(bufnr, 'vimfiler')
  let context = vimfiler.context

  if vimfiler#winnr_another_vimfiler() > 0
    " Hide another vimfiler.
    call vimfiler#util#winclose(
          \ bufwinnr(vimfiler.another_vimfiler_bufnr), context)
    call vimfiler#util#hide_buffer()
  elseif winnr('$') != 1 && (context.split || context.toggle)
    call vimfiler#util#winclose(bufwinnr(bufnr), context)
  else
    call vimfiler#util#alternate_buffer(context)
  endif
endfunction
function! vimfiler#util#alternate_buffer(context) abort
  if buflisted(a:context.alternate_buffer)
        \ && getbufvar(a:context.alternate_buffer, '&filetype') !=# 'vimfiler'
        \ && g:vimfiler_restore_alternate_file
    execute 'buffer' a:context.alternate_buffer
    keepjumps call winrestview(a:context.prev_winsaveview)
    return
  endif

  let listed_buffer = filter(range(1, bufnr('$')),
        \ "s:buflisted(v:val) &&
        \  (v:val == bufnr('%') || getbufvar(v:val, '&filetype') !=# 'vimfiler')")
  if empty(listed_buffer)
    enew
    return
  endif

  let current = index(listed_buffer, bufnr('%'))
  if current < 0
    execute 'buffer' listed_buffer[0]
  else
    execute 'buffer' ((current < len(listed_buffer) / 2) ?
          \ listed_buffer[current+1] : listed_buffer[current-1])
  endif

  silent call vimfiler#force_redraw_all_vimfiler()
endfunction
function! vimfiler#util#delete_buffer(...) abort
  let bufnr = get(a:000, 0, bufnr('%'))

  call vimfiler#util#hide_buffer(bufnr)

  silent execute 'bwipeout!' bufnr
endfunction
function! s:buflisted(bufnr) abort
  return exists('t:vimfiler') ?
        \ has_key(t:vimfiler, a:bufnr) && buflisted(a:bufnr) :
        \ buflisted(a:bufnr)
endfunction

function! vimfiler#util#convert2list(expr) abort
  return type(a:expr) ==# type([]) ? copy(a:expr) : [a:expr]
endfunction
function! vimfiler#util#get_vimfiler_winnr(buffer_name) abort
  for winnr in filter(range(1, winnr('$')),
        \ "getbufvar(winbufnr(v:val), '&filetype') =~# 'vimfiler'")
    let buffer_context = getbufvar(
          \ winbufnr(winnr), 'vimfiler').context
    if buffer_context.buffer_name ==# a:buffer_name
      return winnr
    endif
  endfor

  return -1
endfunction

function! vimfiler#util#is_sudo() abort
  return $SUDO_USER != '' && $USER !=# $SUDO_USER
        \ && $HOME !=# expand('~'.$USER)
        \ && $HOME ==# expand('~'.$SUDO_USER)
endfunction

function! vimfiler#util#winmove(winnr) abort
  if a:winnr > 0
    silent execute a:winnr.'wincmd w'
  endif
endfunction
function! vimfiler#util#winclose(winnr, context) abort
  if winnr('$') != 1
    let winnr = (winnr() == a:winnr) ? winnr('#') : winnr()
    let prev_winnr = (winnr < a:winnr) ? winnr : winnr - 1
    call vimfiler#util#winmove(a:winnr)
    close!
    call vimfiler#util#winmove(prev_winnr)
  else
    call vimfiler#util#alternate_buffer(a:context)
  endif
endfunction
