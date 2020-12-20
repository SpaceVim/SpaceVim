"=============================================================================
" FILE: file_vimfiler_base.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Global options definition. "{{{
call unite#util#set_default(
      \ 'g:unite_kind_file_delete_file_command',
      \ unite#util#is_windows() ? 'rmdir /S /Q $srcs' :
      \ executable('trash-put') ? 'trash-put $srcs' :
      \ executable('rmtrash') ? 'rmtrash $srcs' :
      \ 'rm $srcs')
call unite#util#set_default(
      \ 'g:unite_kind_file_delete_directory_command',
      \ unite#util#is_windows() ? 'rmdir /S /Q $srcs' :
      \ executable('trash-put') ? 'trash-put $srcs' :
      \ executable('rmtrash') ? 'rmtrash $srcs' :
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

function! unite#kinds#file_vimfiler_base#define() abort "{{{
  return s:kind
endfunction"}}}

let s:System = unite#util#get_vital().import('System.File')

let s:kind = {
      \ 'name' : 'file_vimfiler_base',
      \ 'default_action' : 'open',
      \ 'action_table' : {},
      \ 'parents' : [],
      \}

" Actions "{{{
" For vimfiler.
let s:kind.action_table.vimfiler__move = {
      \ 'description' : 'move files',
      \ 'is_quit' : 0,
      \ 'is_invalidate_cache' : 1,
      \ 'is_selectable' : 1,
      \ 'is_listed' : 0,
      \ }
function! s:kind.action_table.vimfiler__move.func(candidates) abort "{{{
  if !unite#util#input_yesno('Really move files?')
    echo 'Canceled.'
    return
  endif

  let vimfiler_current_dir =
        \ get(unite#get_context(), 'vimfiler__current_directory', '')
  if vimfiler_current_dir == ''
    let vimfiler_current_dir = getcwd()
  endif
  let current_dir = getcwd()

  try
    call unite#util#lcd(vimfiler_current_dir)

    if g:unite_kind_file_move_command == ''
      call unite#print_error('Please install mv.exe.')
      return 1
    endif

    let context = unite#get_context()
    let dest_dir = get(context, 'action__directory', '')
    if dest_dir == ''
      let dest_dir = unite#util#input_directory(
            \ 'Input destination directory: ')
    endif

    if dest_dir == ''
      return
    elseif isdirectory(dest_dir) && dest_dir !~ '/$'
      let dest_dir .= '/'
    endif
    let context.action__directory = dest_dir

    let dest_drive = matchstr(dest_dir, '^\a\+\ze:')

    let candidates = []
    for candidate in a:candidates
      let filename = candidate.action__path

      if isdirectory(filename) && unite#util#is_windows()
            \ && matchstr(filename, '^\a\+\ze:') !=? dest_drive
        call s:move_to_other_drive(candidate, filename)
      else
        call add(candidates, candidate)
      endif
    endfor

    if dest_dir =~ '^\h\w\+:'
      " Use protocol move method.
      let protocol = matchstr(dest_dir, '^\h\w\+')
      call unite#sources#{protocol}#move_files(
            \ dest_dir, candidates)
    else
      let filename = unite#kinds#file#do_action(
            \ candidates, dest_dir, 'move')

      call s:search_cursor(filename, dest_dir, a:candidates[-1])
    endif
  finally
    call unite#util#lcd(current_dir)
  endtry
endfunction"}}}

let s:kind.action_table.move =
      \ deepcopy(s:kind.action_table.vimfiler__move)
let s:kind.action_table.move.is_listed = 1
function! s:kind.action_table.move.func(candidates) abort "{{{
  return s:kind.action_table.vimfiler__move.func(a:candidates)
endfunction"}}}

let s:kind.action_table.vimfiler__copy = {
      \ 'description' : 'copy files',
      \ 'is_quit' : 0,
      \ 'is_invalidate_cache' : 1,
      \ 'is_selectable' : 1,
      \ 'is_listed' : 0,
      \ }
function! s:kind.action_table.vimfiler__copy.func(candidates) abort "{{{
  let vimfiler_current_dir =
        \ get(unite#get_context(), 'vimfiler__current_directory', '')
  if vimfiler_current_dir == ''
    let vimfiler_current_dir = getcwd()
  endif
  let current_dir = getcwd()

  try
    call unite#util#lcd(vimfiler_current_dir)

    if g:unite_kind_file_copy_file_command == ''
          \ || g:unite_kind_file_copy_directory_command == ''
      call unite#print_error('Please install cp.exe.')
      return 1
    endif

    let context = unite#get_context()
    let dest_dir = get(context, 'action__directory', '')
    if dest_dir == ''
      let dest_dir = unite#util#input_directory(
            \ 'Input destination directory: ')
    endif

    if dest_dir == ''
      return
    elseif isdirectory(dest_dir) && dest_dir !~ '/$'
      let dest_dir .= '/'
    endif

    if dest_dir =~ '^\h\w\+:'
      " Use protocol move method.
      let protocol = matchstr(dest_dir, '^\h\w\+')
      call unite#sources#{protocol}#copy_files(dest_dir, a:candidates)
    else
      let filename = unite#kinds#file#do_action(
            \ a:candidates, dest_dir, 'copy')
      call s:search_cursor(filename, dest_dir, a:candidates[-1])
    endif
  finally
    call unite#util#lcd(current_dir)
  endtry
endfunction"}}}

let s:kind.action_table.copy = deepcopy(s:kind.action_table.vimfiler__copy)
let s:kind.action_table.copy.is_listed = 1
function! s:kind.action_table.copy.func(candidates) abort "{{{
  return s:kind.action_table.vimfiler__copy.func(a:candidates)
endfunction"}}}

let s:kind.action_table.vimfiler__delete = {
      \ 'description' : 'delete files',
      \ 'is_quit' : 0,
      \ 'is_invalidate_cache' : 1,
      \ 'is_selectable' : 1,
      \ 'is_listed' : 0,
      \ }
function! s:kind.action_table.vimfiler__delete.func(candidates) abort "{{{
  if g:unite_kind_file_delete_file_command == ''
        \ || g:unite_kind_file_delete_directory_command == ''
    call unite#print_error('Please install rm.exe.')
    return 1
  endif

  if !unite#util#input_yesno('Really force delete files?')
    echo 'Canceled.'
    return
  endif

  call unite#kinds#file#do_action(a:candidates, '', 'delete')
endfunction"}}}

let s:kind.action_table.vimfiler__rename = {
      \ 'description' : 'rename files',
      \ 'is_quit' : 0,
      \ 'is_invalidate_cache' : 1,
      \ 'is_listed' : 0,
      \ }
function! s:kind.action_table.vimfiler__rename.func(candidate) abort "{{{
  let vimfiler_current_dir =
        \ get(unite#get_context(), 'vimfiler__current_directory', '')
  if vimfiler_current_dir == ''
    let vimfiler_current_dir = getcwd()
  endif
  let current_dir = getcwd()

  try
    call unite#util#lcd(vimfiler_current_dir)

    let context = unite#get_context()
    let filename = has_key(context, 'action__filename') ?
          \ context.action__filename :
          \ input(printf('New file name: %s -> ',
          \       a:candidate.action__path), a:candidate.action__path)

    if !has_key(context, 'action__filename')
      redraw
    endif

    if filename != '' && filename !=# a:candidate.action__path
      call unite#kinds#file#do_rename(a:candidate.action__path, filename)
      call s:search_cursor(filename, '', {})
    endif
  finally
    call unite#util#lcd(current_dir)
  endtry
endfunction"}}}

let s:kind.action_table.vimfiler__newfile = {
      \ 'description' : 'make this file',
      \ 'is_quit' : 0,
      \ 'is_invalidate_cache' : 1,
      \ 'is_listed' : 0,
      \ }
function! s:kind.action_table.vimfiler__newfile.func(candidate) abort "{{{
  let vimfiler_current_dir =
        \ get(unite#get_context(),
        \   'vimfiler__current_directory', '')
  if vimfiler_current_dir == ''
    let vimfiler_current_dir = getcwd()
  endif
  let current_dir = getcwd()

  try
    call unite#util#lcd(vimfiler_current_dir)

    let filenames = input('New files name(comma separated): ',
          \               '', 'file')
    if filenames == ''
      redraw
      echo 'Canceled.'
      return
    endif

    for filename in split(filenames, ',')
      call unite#util#lcd(vimfiler_current_dir)

      if filereadable(filename)
        redraw
        call unite#print_error(filename . ' is already exists.')
        continue
      endif

      let dir = fnamemodify(filename, ':h')
      if dir != '' && !isdirectory(dir) && !unite#util#is_sudo()
        " Auto create directory.
        call mkdir(dir, 'p')
      endif

      if filename !~ '/$'
        let file = unite#sources#file#create_file_dict(filename, '')
        let file.source = 'file'

        call writefile([], filename)
      endif

      call s:search_cursor(filename, '', {})
    endfor
  finally
    call unite#util#lcd(current_dir)
  endtry
endfunction"}}}

let s:kind.action_table.unite__new_candidate =
      \ deepcopy(s:kind.action_table.vimfiler__newfile)

let s:kind.action_table.vimfiler__shell = {
      \ 'description' : 'popup shell',
      \ 'is_listed' : 0,
      \ }
function! s:kind.action_table.vimfiler__shell.func(candidate) abort "{{{
  if !exists(':VimShellPop')
    shell
    return
  endif

  call vimshell#init#_start(
        \ unite#helper#get_candidate_directory(a:candidate),
        \ { 'popup' : 1, 'toggle' : 0 })

  let files = unite#get_context().vimfiler__files
  if !empty(files)
    call setline(line('.'), getline('.') . ' ' . join(files))
    call cursor(0, col('.')+1)
  endif
endfunction"}}}

let s:kind.action_table.vimfiler__shellcmd = {
      \ 'description' : 'execute shell command',
      \ 'is_listed' : 0,
      \ 'is_start' : 1,
      \ }
function! s:kind.action_table.vimfiler__shellcmd.func(candidate) abort "{{{
  let vimfiler_current_dir =
        \ get(unite#get_context(), 'vimfiler__current_directory', '')
  if vimfiler_current_dir == ''
    let vimfiler_current_dir = getcwd()
  endif
  let current_dir = getcwd()

  try
    call unite#util#lcd(vimfiler_current_dir)
    let command = unite#get_context().vimfiler__command
    let output = split(unite#util#system(command), '\n\|\r\n')

    if !empty(output)
      call unite#start_script([['output', output]])
    endif
  finally
    call unite#util#lcd(current_dir)
  endtry
endfunction"}}}

let s:kind.action_table.vimfiler__mkdir = {
      \ 'description' : 'make this directory and parents directory',
      \ 'is_quit' : 0,
      \ 'is_invalidate_cache' : 1,
      \ 'is_listed' : 0,
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.vimfiler__mkdir.func(candidates) abort "{{{
  let context = unite#get_context()
  let vimfiler_current_dir = get(context, 'vimfiler__current_directory', '')
  if vimfiler_current_dir == ''
    let vimfiler_current_dir = getcwd()
  endif
  let current_dir = getcwd()

  try
    call unite#util#lcd(vimfiler_current_dir)

    let dirnames = split(input(
          \ 'New directory names(comma separated): ', '', 'dir'), ',')
    redraw

    if empty(dirnames)
      echo 'Canceled.'
      return
    endif

    for dirname in dirnames
      let dirname = unite#util#substitute_path_separator(
            \ fnamemodify(dirname, ':p'))

      if filereadable(dirname) || isdirectory(dirname)
        redraw
        call unite#print_error(dirname . ' is already exists.')
        continue
      endif

      call mkdir(dirname, 'p')
    endfor

    " Move marked files.
    if !get(context, 'vimfiler__is_dummy', 1) && len(dirnames) == 1
      call unite#sources#file#move_files(dirname, a:candidates)
    endif

    call s:search_cursor(dirname, '', {})
  finally
    call unite#util#lcd(current_dir)
  endtry
endfunction"}}}

let s:kind.action_table.vimfiler__execute = {
      \ 'description' : 'open files with associated program',
      \ 'is_selectable' : 1,
      \ 'is_listed' : 0,
      \ }
function! s:kind.action_table.vimfiler__execute.func(candidates) abort "{{{
  let vimfiler_current_dir =
        \ get(unite#get_context(), 'vimfiler__current_directory', '')
  if vimfiler_current_dir == ''
    let vimfiler_current_dir = getcwd()
  endif
  let current_dir = getcwd()

  try
    call unite#util#lcd(vimfiler_current_dir)

    for candidate in a:candidates
      let path = candidate.action__path
      if unite#util#is_windows() && path =~ '^//'
        " substitute separator for UNC.
        let path = substitute(path, '/', '\\', 'g')
      endif

      call s:System.open(path)
    endfor
  finally
    call unite#util#lcd(current_dir)
  endtry
endfunction"}}}

let s:kind.action_table.vimfiler__external_filer = {
      \ 'description' : 'open file with external file explorer',
      \ 'is_listed' : 0,
      \ }
function! s:kind.action_table.vimfiler__external_filer.func(candidate) abort "{{{
  let vimfiler_current_dir =
        \ get(unite#get_context(), 'vimfiler__current_directory', '')
  if vimfiler_current_dir == ''
    let vimfiler_current_dir = getcwd()
  endif
  let current_dir = getcwd()

  try
    call unite#util#lcd(vimfiler_current_dir)

    let path = a:candidate.action__path
    if unite#util#is_windows()
      let path = substitute(path, '/', '\\', 'g')
    endif

    let filer = ''
    if unite#util#is_mac()
      let filer = 'open -a Finder -R '
    elseif unite#util#is_windows()
      let filer = 'explorer /SELECT,'
    elseif executable('nautilus')
      " Note: Older nautilus does not support "-s" option...
      let filer = 'nautilus '

      if isdirectory(path)
        " Use parent path
        let path = fnamemodify(path, ':h')
      endif
    else
      " Not supported
      call s:System.open(fnamemodify(path, ':h'))
      return
    endif

    if unite#util#is_windows()
      let output = system(filer . '"' . path . '"')
    else
      let output = unite#util#system(filer . "'" . path . "' &")
    endif
    if output != ''
      call unite#util#print_error(output)
    endif
  finally
    call unite#util#lcd(current_dir)
  endtry
endfunction"}}}
let s:kind.action_table.vimfiler__write = {
      \ 'description' : 'save file',
      \ 'is_listed' : 0,
      \ }
function! s:kind.action_table.vimfiler__write.func(candidate) abort "{{{
  let context = unite#get_context()
  let lines = getline(context.vimfiler__line1, context.vimfiler__line2)

  if context.vimfiler__eventname ==# 'FileAppendCmd'
    " Append.
    let lines = readfile(a:candidate.action__path) + lines
  endif
  call writefile(lines, a:candidate.action__path)
endfunction"}}}
"}}}

function! s:move_to_other_drive(candidate, filename) abort "{{{
  " move command doesn't supported directory over drive move in Windows.
  if g:unite_kind_file_copy_file_command == ''
        \ || g:unite_kind_file_copy_directory_command == ''
    call unite#print_error('Please install cp.exe.')
    return 1
  elseif g:unite_kind_file_delete_file_command == ''
          \ || g:unite_kind_file_delete_directory_command == ''
    call unite#print_error('Please install rm.exe.')
    return 1
  endif

  if s:kind.action_table.vimfiler__copy.func([a:candidate])
    call unite#print_error('Failed file move: ' . a:filename)
    return 1
  endif

  if s:kind.action_table.vimfiler__delete.func([a:candidate])
    call unite#print_error('Failed file delete: ' . a:filename)
    return 1
  endif
endfunction"}}}

function! s:search_cursor(filename, dest_dir, candidate) abort "{{{
  if &filetype !=# 'vimfiler'
    return
  endif

  if a:filename ==# a:dest_dir
        \ && vimfiler#exists_another_vimfiler()
    " Search from another vimfiler
    call vimfiler#mappings#switch_another_vimfiler()
    call vimfiler#view#_force_redraw_screen()
    call vimfiler#mappings#search_cursor(
          \ unite#util#substitute_path_separator(
          \   a:dest_dir . a:candidate.vimfiler__filename))
    call vimfiler#mappings#switch_another_vimfiler()
  else
    " Search current vimfiler
    call vimfiler#view#_force_redraw_screen()
    call vimfiler#mappings#search_cursor(
          \ unite#util#substitute_path_separator(
          \   fnamemodify(a:filename, ':p')))
  endif
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
