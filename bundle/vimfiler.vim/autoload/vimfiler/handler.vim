"=============================================================================
" FILE: handler.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! vimfiler#handler#_event_handler(event_name, ...)
  let user_context = get(a:000, 0, {})
  let context = vimfiler#initialize_context(user_context)
  let path = vimfiler#util#substitute_path_separator(
        \ get(user_context, 'path', expand('<afile>')))

  if filereadable(path)
    let source_name = 'file'
    let source_args = [path]
  else
    let ret = vimfiler#parse_path(path)
    let source_name = ret[0]
    let source_args = ret[1:]
  endif

  return s:on_{a:event_name}(source_name, source_args, context)
endfunction

function! s:on_BufReadCmd(source_name, source_args, context)
  " Check path.
  let ret = unite#vimfiler_check_filetype(
        \ [insert(a:source_args, a:source_name)])
  if empty(ret)
    if !empty(unite#loaded_sources_list()) && a:source_name !=# 'file'
      " File not found.
      call vimfiler#util#print_error(
            \ printf('Can''t open "%s".', join(a:source_args, ':')))
    endif

    doautocmd BufRead
    return
  endif
  let [type, info] = ret

  let bufnr = bufnr('%')

  let b:vimfiler = {}
  let b:vimfiler.source = a:source_name
  let b:vimfiler.context = a:context
  let b:vimfiler.bufnr = bufnr('%')
  if type ==# 'directory'
    call vimfiler#init#_vimfiler_directory(info, a:context)
  elseif type ==# 'file'
    call vimfiler#init#_vimfiler_file(
          \ a:source_args, info[0], info[1])
  else
    call vimfiler#util#print_error('Unknown filetype.')
  endif

  if bufnr('%') != bufnr
    " Restore window.
    call vimfiler#util#winmove(bufwinnr(bufnr))
  endif
endfunction

function! s:on_BufWriteCmd(source_name, source_args, context)
  " BufWriteCmd is published by :write or other commands with 1,$ range.
  return s:write(a:source_name, a:source_args, 1, line('$'), 'BufWriteCmd')
endfunction


function! s:on_FileAppendCmd(source_name, source_args, context)
  " FileAppendCmd is published by :write or other commands with >>.
  return s:write(a:source_name, a:source_args, line("'["), line("']"), 'FileAppendCmd')
endfunction

function! s:on_FileReadCmd(source_name, source_args, context)
  " Check path.
  let ret = unite#vimfiler_check_filetype(
        \ [insert(a:source_args, a:source_name)])
  if empty(ret)
    if !empty(unite#loaded_sources_list()) && a:source_name !=# 'file'
      " File not found.
      call vimfiler#util#print_error(
            \ printf('Can''t open "%s".', join(a:source_args, ':')))
    endif

    return
  endif
  let [type, info] = ret

  if type !=# 'file'
    call vimfiler#util#print_error(
          \ printf('"%s" is not a file.', join(a:source_args, ':')))
    return
  endif

  call append(line('.'), info[0])
endfunction


function! s:on_FileWriteCmd(source_name, source_args, context) abort
  " FileWriteCmd is published by :write or other commands with partial range
  " such as 1,2 where 2 < line('$').
  return s:write(a:source_name, a:source_args, line("'["), line("']"), 'FileWriteCmd')
endfunction

function! s:write(source_name, source_args, line1, line2, event_name) abort
  if !exists('b:vimfiler') || !has_key(b:vimfiler, 'current_file') || !&l:modified
    return
  endif

  try
    setlocal nomodified

    call unite#mappings#do_action('vimfiler__write',
          \ [b:vimfiler.current_file], {
          \ 'vimfiler__line1' : a:line1,
          \ 'vimfiler__line2' : a:line2,
          \ 'vimfiler__eventname' : a:event_name,
          \ })
  catch
    call vimfiler#util#print_error(v:exception . ' ' . v:throwpoint)
    setlocal modified
  endtry
endfunction

" Event functions.
function! vimfiler#handler#_event_bufwin_enter(bufnr) abort
  if a:bufnr != bufnr('%') && bufwinnr(a:bufnr) > 0
    let winnr = winnr()
    call vimfiler#util#winmove(bufwinnr(a:bufnr))
  endif

  try
    if !exists('b:vimfiler') ||
          \ len(filter(range(1, winnr('$')),
          \    'winbufnr(v:val) == a:bufnr')) > 1
      return
    endif

    let vimfiler = b:vimfiler
    if !has_key(vimfiler, 'context')
      return
    endif

    let context = b:vimfiler.context
    if context.winwidth > 0
      execute 'vertical resize' context.winwidth

      let context.vimfiler__winfixwidth = &l:winfixwidth
      if context.split
        setlocal winfixwidth
      endif
    elseif context.winheight > 0
      execute 'resize' context.winheight
      if line('.') < winheight(0)
        normal! zb
      endif

      let context.vimfiler__winfixheight = &l:winfixheight
      if context.split
        setlocal winfixheight
      endif
    endif

    let winwidth = (winwidth(0)+1)/2*2
    if exists('vimfiler.winwidth')
      if vimfiler.winwidth != winwidth
        call vimfiler#view#_redraw_screen()
      endif
    endif
  finally
    if exists('winnr')
      call vimfiler#util#winmove(winnr)
    endif
  endtry
endfunction

function! vimfiler#handler#_event_bufwin_leave(bufnr) abort
  let vimfiler = getbufvar(str2nr(a:bufnr), 'vimfiler')

  if type(vimfiler) != type({})
    return
  endif

  " Restore winfix.
  let context = vimfiler.context
  if context.winwidth > 0 && context.split
    let &l:winfixwidth = context.vimfiler__winfixwidth
  elseif context.winheight > 0 && context.split
    let &l:winfixheight = context.vimfiler__winfixheight
  endif
endfunction

function! vimfiler#handler#_event_cursor_moved() abort
  if !exists('b:vimfiler')
    return
  endif

  if line('.') <= line('$') / 2 ||
        \ b:vimfiler.all_files_len == len(b:vimfiler.current_files)
    return
  endif

  " Update current files.
  let len_files = len(b:vimfiler.current_files)
  let new_files = b:vimfiler.all_files[
        \ len_files : (len_files + winheight(0) * 2)]
  let b:vimfiler.current_files += new_files

  setlocal modifiable
  try
    call append('$', vimfiler#view#_get_print_lines(new_files))
  finally
    setlocal nomodifiable
  endtry
endfunction
