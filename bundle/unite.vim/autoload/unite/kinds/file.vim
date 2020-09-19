"=============================================================================
" FILE: file.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Global options definition. "{{{
call unite#util#set_default(
      \ 'g:unite_kind_file_delete_file_command',
      \ unite#util#is_windows() && !executable('rm') ? '' :
      \ executable('rmtrash') ? 'rmtrash $srcs' :
      \ executable('trash-put') ? 'trash-put $srcs' :
      \ 'rm $srcs')
call unite#util#set_default(
      \ 'g:unite_kind_file_delete_directory_command',
      \ unite#util#is_windows() && !executable('rm') ? '' :
      \ executable('rmtrash') ? 'rmtrash $srcs' :
      \ executable('trash-put') ? 'trash-put $srcs' :
      \ 'rm -r $srcs')
call unite#util#set_default(
      \ 'g:unite_kind_file_copy_file_command',
      \ unite#util#is_windows() && !executable('cp') ? '' :
      \ 'cp -p $srcs $dest')
call unite#util#set_default(
      \ 'g:unite_kind_file_copy_directory_command',
      \ unite#util#is_windows() && !executable('cp') ? '' :
      \ 'cp -p -r $srcs $dest')
call unite#util#set_default(
      \ 'g:unite_kind_file_move_command',
      \ unite#util#is_windows() && !executable('mv') ?
      \  'move /Y $srcs $dest' : 'mv $srcs $dest')
call unite#util#set_default('g:unite_kind_file_use_trashbox',
      \ unite#util#is_windows() && unite#util#has_vimproc())
"}}}

function! unite#kinds#file#define() abort "{{{
  return s:kind
endfunction"}}}

let s:System = unite#util#get_vital().import('System.File')

let s:kind = {
      \ 'name' : 'file',
      \ 'default_action' : 'open',
      \ 'action_table' : {},
      \ 'parents' : ['file_base', 'openable',
      \              'file_vimfiler_base', 'cdable', 'uri'],
      \}

function! s:external(command, dest_dir, src_files) abort "{{{
  let dest_dir = a:dest_dir
  if dest_dir =~ '[^:]/$'
    " Delete last /.
    let dest_dir = dest_dir[: -2]
  endif

  let src_files = map(a:src_files, 'substitute(v:val, "[^:]\zs/$", "", "")')
  let command_line = g:unite_kind_file_{a:command}_command

  " Substitute pattern.
  let command_line = substitute(command_line,
        \'\$srcs\>', escape(join(
        \   map(src_files, '''"''.v:val.''"''')), '&'), 'g')
  let command_line = substitute(command_line,
        \'\$dest\>', escape('"'.dest_dir.'"', '&'), 'g')
  let command_line = escape(command_line, '`')

  call unite#util#system(command_line)

  return unite#util#get_last_status()
endfunction"}}}
function! s:input_overwrite_method(dest, src) abort "{{{
  redraw
  echo 'File already exists!'
  echo printf('dest: %s %d bytes %s', a:dest, getfsize(a:dest),
        \ strftime('%y/%m/%d %H:%M', getftime(a:dest)))
  echo printf('src:  %s %d bytes %s', a:src, getfsize(a:src),
        \ strftime('%y/%m/%d %H:%M', getftime(a:src)))

  echo 'Please select overwrite method(Upper case is all).'
  let method = ''
  while method !~? '^\%(f\%[orce]\|t\%[ime]\|u\%[nderbar]\|n\%[o]\|r\%[ename]\)$'
    " Retry.
    let method = input('f[orce]/t[ime]/u[nderbar]/n[o]/r[ename] : ',
        \ '', 'customlist,unite#kinds#file#complete_overwrite_method')
  endwhile

  redraw

  return method
endfunction"}}}
function! unite#kinds#file#complete_overwrite_method(arglead, cmdline, cursorpos) abort "{{{
  return filter(['force', 'time', 'underbar', 'no', 'rename'],
        \ 'stridx(v:val, a:arglead) == 0')
endfunction"}}}
function! s:check_over_write(dest_dir, filename, overwrite_method, is_reset_method) abort "{{{
  let is_reset_method = a:is_reset_method
  let dest_filename = a:dest_dir . fnamemodify(a:filename, ':t')
  let is_continue = 0
  let filename = fnamemodify(a:filename, ':t')
  let overwrite_method = a:overwrite_method

  if filereadable(dest_filename) || isdirectory(dest_filename) "{{{
    if overwrite_method == ''
      let overwrite_method =
            \ s:input_overwrite_method(dest_filename, a:filename)
      if overwrite_method =~ '^\u'
        " Same overwrite.
        let is_reset_method = 0
      endif
    endif

    if overwrite_method =~? '^f'
      " Ignore.
    elseif overwrite_method =~? '^t'
      if getftime(a:filename) <= getftime(dest_filename)
        let is_continue = 1
      endif
    elseif overwrite_method =~? '^u'
      let filename .= '_'
    elseif overwrite_method =~? '^n'
      if is_reset_method
        let overwrite_method = ''
      endif

      let is_continue = 1
    elseif overwrite_method =~? '^r'
      let filename =
            \ input(printf('New name: %s -> ', filename), filename, 'file')
    endif

    if is_reset_method
      let overwrite_method = ''
    endif
  endif"}}}

  let dest_filename = a:dest_dir . fnamemodify(filename, ':t')

  if dest_filename ==#
        \ a:dest_dir . fnamemodify(a:filename, ':t')
    let dest_filename = a:dest_dir
  endif

  return [dest_filename, overwrite_method, is_reset_method, is_continue]
endfunction"}}}
function! unite#kinds#file#do_rename(old_filename, new_filename) abort "{{{
  if a:old_filename ==# a:new_filename
    return 0
  endif

  if a:old_filename !=? a:new_filename &&
        \ (filereadable(a:new_filename) || isdirectory(a:new_filename))
    " Failed.
    call unite#print_error(
          \ printf('file: "%s" is already exists!', a:new_filename))
    return 1
  endif

  " Convert to relative path.
  let old_filename = substitute(fnamemodify(a:old_filename, ':p'),
        \ '[/\\]$', '', '')
  let new_filename = substitute(fnamemodify(a:new_filename, ':p'),
        \ '[/\\]$', '', '')
  let directory = unite#util#substitute_path_separator(
        \ fnamemodify(old_filename, ':h'))
  let current_dir_save = getcwd()
  call unite#util#lcd(directory)

  let hidden_save = &l:hidden
  try
    let old_filename = unite#util#substitute_path_separator(
          \ fnamemodify(old_filename, ':.'))
    let new_filename = unite#util#substitute_path_separator(
          \ fnamemodify(new_filename, ':.'))

    " create if the destination directory does not exist
    if !isdirectory(fnamemodify(new_filename, ':h'))
      call mkdir(fnamemodify(new_filename, ':h'), 'p')
    endif

    let bufnr = get(filter(range(bufnr('$')), 'bufname(v:val) ==# old_filename'), 0, -1)
    if bufnr > 0
      " Buffer rename.
      setlocal hidden
      let bufnr_save = bufnr('%')
      noautocmd silent execute 'buffer' bufnr
      silent execute (&l:buftype == '' ? 'saveas!' : 'file')
            \ fnameescape(new_filename)
      if &l:buftype == ''
        " Remove old buffer.
        silent! bdelete! #
      endif
      noautocmd silent execute 'buffer' bufnr_save
    endif

    if !unite#util#move(old_filename, new_filename)
      call unite#print_error(
            \ printf('Failed rename: "%s" to "%s".',
            \   a:old_filename, a:new_filename))
      return 1
    endif
  finally
    " Restore path.
    call unite#util#lcd(current_dir_save)
    let &l:hidden = hidden_save
  endtry

  return 0
endfunction"}}}

function! unite#kinds#file#do_action(candidates, dest_dir, action_name) abort "{{{
  let overwrite_method = ''
  let is_reset_method = 1
  let dest_filename = ''

  let cnt = 1
  let max = len(a:candidates)

  echo ''
  redraw

  for candidate in a:candidates
    let filename = candidate.action__path

    if a:action_name == 'move' || a:action_name == 'copy'
      " Overwrite check.
      let [dest_filename, overwrite_method,
            \ is_reset_method, is_continue] =
            \ s:check_over_write(a:dest_dir, filename,
            \    overwrite_method, is_reset_method)
      if is_continue
        let cnt += 1
        continue
      endif
    else
      let dest_filename = ''
    endif

    " Print progress.
    echo printf('%d%% %s %s',
          \ ((cnt*100) / max), a:action_name,
          \ (filename . (dest_filename == '' ? '' :
          \              ' -> ' . dest_filename)))
    redraw

    if a:action_name == 'delete'
          \ && g:unite_kind_file_use_trashbox && unite#util#is_windows()
          \ && unite#util#has_vimproc() && exists('*vimproc#delete_trash')
      " Environment check.
      let ret = vimproc#delete_trash(filename)
      if ret
        call unite#print_error(printf('Failed file %s: %s',
              \ a:action_name, filename))
        call unite#print_error(printf('Error code is %d', ret))
      endif
    else
      let command = a:action_name

      if a:action_name ==# 'copy'
        let command = s:check_copy_func(filename)
      elseif a:action_name ==# 'delete'
        let command = s:check_delete_func(filename)
      endif

      if s:external(command, dest_filename, [filename])
        call unite#print_error(printf('Failed file %s: %s',
              \ a:action_name, filename))
      endif
    endif

    let cnt += 1
  endfor

  echo ''
  redraw

  if dest_filename == '' || dest_filename ==# a:dest_dir
    let dest_filename = unite#util#substitute_path_separator(
          \ fnamemodify(dest_filename, ':p'))
  endif
  return dest_filename
endfunction"}}}
function! s:check_delete_func(filename) abort "{{{
  return isdirectory(a:filename) ?
        \ 'delete_directory' : 'delete_file'
endfunction"}}}
function! s:check_copy_func(filename) abort "{{{
  return isdirectory(a:filename) ?
        \ 'copy_directory' : 'copy_file'
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
