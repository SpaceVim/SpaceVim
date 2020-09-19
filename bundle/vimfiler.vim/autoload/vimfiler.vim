"=============================================================================
" FILE: vimfiler.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

if !exists('g:loaded_vimfiler')
  runtime! plugin/vimfiler.vim
endif

" Check unite.vim. "{{{
try
  let s:exists_unite_version = unite#version()
catch
  echomsg 'Error occurred while loading unite.vim.'
  echomsg 'Please install unite.vim Ver.3.0 or above.'
  finish
endtry
if s:exists_unite_version < 300
  echomsg 'Your unite.vim is too old.'
  echomsg 'Please install unite.vim Ver.3.0 or above.'
  finish
endif"}}}

" Variables "{{{
let s:current_vimfiler = {}
"}}}

" User utility functions. "{{{
function! vimfiler#default_settings() abort "{{{
  return vimfiler#init#_default_settings()
endfunction"}}}
function! vimfiler#set_execute_file(exts, command) abort "{{{
  let g:vimfiler_execute_file_list =
        \ get(g:, 'vimfiler_execute_file_list', {})
  return vimfiler#util#set_dictionary_helper(g:vimfiler_execute_file_list,
        \ a:exts, a:command)
endfunction"}}}
function! vimfiler#set_extensions(kind, exts) abort "{{{
  let g:vimfiler_extensions =
        \ get(g:, 'vimfiler_extensions', {})

  let g:vimfiler_extensions[a:kind] = {}
  for ext in split(a:exts, '\s*,\s*')
    let g:vimfiler_extensions[a:kind][ext] = 1
  endfor
endfunction"}}}
function! vimfiler#do_action(action) abort "{{{
  return printf(":\<C-u>call vimfiler#mappings#do_action(b:vimfiler,%s)\<CR>",
        \             string(a:action))
endfunction"}}}
function! vimfiler#do_switch_action(action) abort "{{{
  return printf(":\<C-u>call vimfiler#mappings#do_switch_action(
        \ b:vimfiler, %s)\<CR>", string(a:action))
endfunction"}}}
function! vimfiler#smart_cursor_map(directory_map, file_map) abort "{{{
  return vimfiler#mappings#smart_cursor_map(a:directory_map, a:file_map)
endfunction"}}}
function! vimfiler#get_status_string() abort "{{{
  return !exists('b:vimfiler') ? '' : b:vimfiler.status
endfunction"}}}
"}}}

" vimfiler plugin utility functions. "{{{
function! vimfiler#start(path, ...) abort "{{{
  return call('vimfiler#init#_start', [a:path] + a:000)
endfunction"}}}
function! vimfiler#get_directory_files(directory, ...) abort "{{{
  return call('vimfiler#helper#_get_directory_files',
        \ [a:directory] + a:000)
endfunction"}}}
function! vimfiler#force_redraw_screen(...) abort "{{{
  return call('vimfiler#view#_force_redraw_screen', a:000)
endfunction"}}}
function! vimfiler#redraw_screen() abort "{{{
  return vimfiler#view#_redraw_screen()
endfunction"}}}
function! vimfiler#get_marked_files(vimfiler) abort "{{{
  return filter(copy(a:vimfiler.current_files),
        \ 'v:val.vimfiler__is_marked')
endfunction"}}}
function! vimfiler#get_marked_filenames(vimfiler) abort "{{{
  return map(vimfiler#get_marked_files(a:vimfiler), 'v:val.action__path')
endfunction"}}}
function! vimfiler#get_escaped_marked_files(vimfiler) abort "{{{
  return map(vimfiler#get_marked_filenames(a:vimfiler),
        \ '"\"" . v:val . "\""')
endfunction"}}}
function! vimfiler#get_filename(...) abort "{{{
  let line_num = get(a:000, 0, line('.'))
  return getline(line_num) == '..' ? '..' :
   \ (line_num < b:vimfiler.prompt_linenr ||
   \  empty(b:vimfiler.current_files)) ? '' :
   \ b:vimfiler.current_files[
   \    vimfiler#get_file_index(b:vimfiler, line_num)].action__path
endfunction"}}}
function! vimfiler#get_file(vimfiler, ...) abort "{{{
  let line_num = get(a:000, 0, line('.'))
  let index = vimfiler#get_file_index(a:vimfiler, line_num)
  return index < 0 ? {} :
        \ get(a:vimfiler.current_files, index, {})
endfunction"}}}
function! vimfiler#get_file_directory(...) abort "{{{
  return call('vimfiler#helper#_get_file_directory', a:000)
endfunction"}}}
function! vimfiler#get_file_index(vimfiler, line_num) abort "{{{
  return a:line_num - vimfiler#get_file_offset(a:vimfiler) - 1
endfunction"}}}
function! vimfiler#get_original_file_index(line_num) abort "{{{
  return index(b:vimfiler.original_files,
        \ vimfiler#get_file(b:vimfiler, a:line_num))
endfunction"}}}
function! vimfiler#get_line_number(vimfiler, index) abort "{{{
  return a:index + vimfiler#get_file_offset(a:vimfiler) + 1
endfunction"}}}
function! vimfiler#get_file_offset(vimfiler) abort "{{{
  return a:vimfiler.prompt_linenr
endfunction"}}}
function! vimfiler#force_redraw_all_vimfiler(...) abort "{{{
  return call('vimfiler#view#_force_redraw_all_vimfiler', a:000)
endfunction"}}}
function! vimfiler#redraw_all_vimfiler() abort "{{{
  return vimfiler#view#_redraw_all_vimfiler()
endfunction"}}}
function! vimfiler#get_datemark(file) abort "{{{
  return vimfiler#init#_get_datemark(a:file)
endfunction"}}}
function! vimfiler#get_filetype(file) abort "{{{
  return vimfiler#init#_get_filetype(a:file)
endfunction"}}}
function! vimfiler#exists_another_vimfiler() abort "{{{
  return exists('b:vimfiler')
        \ && bufnr('%') != b:vimfiler.another_vimfiler_bufnr
        \ && getbufvar(b:vimfiler.another_vimfiler_bufnr,
        \         '&filetype') ==# 'vimfiler'
        \ && bufloaded(b:vimfiler.another_vimfiler_bufnr) > 0
endfunction"}}}
function! vimfiler#winnr_another_vimfiler() abort "{{{
  return (!exists('b:vimfiler')
        \ || winnr() == bufwinnr(b:vimfiler.another_vimfiler_bufnr)) ?
        \ -1 : bufwinnr(b:vimfiler.another_vimfiler_bufnr)
endfunction"}}}
function! vimfiler#get_another_vimfiler() abort "{{{
  return vimfiler#exists_another_vimfiler() ?
        \ getbufvar(b:vimfiler.another_vimfiler_bufnr, 'vimfiler') : ''
endfunction"}}}
function! vimfiler#parse_path(path) abort "{{{
  return vimfiler#helper#_parse_path(a:path)
endfunction"}}}
function! vimfiler#initialize_context(context) abort "{{{
  return vimfiler#init#_context(a:context)
endfunction"}}}
function! vimfiler#get_histories() abort "{{{
  if !exists('s:vimfiler_current_histories')
    let s:vimfiler_current_histories = []
  endif
  return copy(s:vimfiler_current_histories)
endfunction"}}}
function! vimfiler#set_histories(histories) abort "{{{
  let s:vimfiler_current_histories = a:histories
endfunction"}}}
function! vimfiler#complete(arglead, cmdline, cursorpos) abort "{{{
  return vimfiler#helper#_complete(a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}
function! vimfiler#complete_path(arglead, cmdline, cursorpos) abort "{{{
  return vimfiler#helper#_complete_path(a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}
"}}}

" vim: foldmethod=marker
