"=============================================================================
" FILE: include.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! neoinclude#include#initialize() abort
  let s:include_info = {}
  let s:include_cache = {}
  let s:async_include_cache = {}
  let s:cached_pattern = {}

  augroup neoinclude
    autocmd BufWritePost * call s:check_buffer('', 0)
  augroup END
endfunction

function! neoinclude#include#get_include_files(...) abort
  call neoinclude#initialize()

  call s:check_buffer('', 0)

  let bufnr = get(a:000, 0, bufnr('%'))
  if has_key(s:include_info, bufnr)
    return copy(s:include_info[bufnr].include_files)
  else
    return s:get_buffer_include_files(bufnr)
  endif
endfunction

function! neoinclude#include#get_tag_files(...) abort
  call neoinclude#initialize()

  call s:check_buffer('', 0)

  let bufnr = get(a:000, 0, bufnr('%'))
  let include_files = neoinclude#include#get_include_files(bufnr)
  return filter(map(filter(map(include_files,
        \ 'get(s:async_include_cache, v:val, {})'),
        \ '!empty(v:val)'), 'v:val.cachename'), 'filereadable(v:val)')
endfunction

" For Debug.
function! neoinclude#include#get_current_include_files() abort
  call neoinclude#initialize()

  return s:get_buffer_include_files(bufnr('%'))
endfunction

function! s:check_buffer(bufnr, is_force) abort
  let bufnr = (a:bufnr == '') ? bufnr('%') : a:bufnr
  let filename = fnamemodify(bufname(bufnr), ':p')

  if !has_key(s:include_info, bufnr)
    " Initialize.
    let s:include_info[bufnr] = {
          \ 'include_files' : [], 'lines' : [],
          \ 'async_files' : {},
          \ }
  endif

  let include_info = s:include_info[bufnr]

  if a:is_force || include_info.lines !=# getbufline(bufnr, 1, 100)
    let include_info.lines = getbufline(bufnr, 1, 100)

    " Check include files contained bufname.
    let include_files = s:get_buffer_include_files(bufnr)

    " Check include files from function.
    let filetype = getbufvar(a:bufnr, '&filetype')
    let function = neoinclude#get_function(filetype)
    if function != '' && getbufvar(bufnr, '&buftype') !~ 'nofile'
      let path = neoinclude#get_path(a:bufnr, filetype)
      let include_files += call(function,
            \ [getbufline(bufnr, 1, (a:is_force ? '$' : 1000)), path])
    endif

    if getbufvar(bufnr, '&buftype') !~ 'nofile'
          \ && filereadable(filename)
      call add(include_files, filename)
    endif
    let include_info.include_files = neoinclude#util#uniq(include_files)
  endif

  let filetype = getbufvar(bufnr, '&filetype')
  if filetype == ''
    let filetype = 'nothing'
  endif

  let ctags = neoinclude#util#get_buffer_config(filetype,
        \ 'b:neoinclude_ctags_commands',
        \ g:neoinclude#ctags_commands,
        \ g:neoinclude#_ctags_commands, '')

  if g:neoinclude#max_processes <= 0 || !executable(ctags)
    return
  endif

  for filename in include_info.include_files
    if (a:is_force || !has_key(include_info.async_files, filename))
          \ && !has_key(s:include_cache, filename)
      if !a:is_force && has_key(s:async_include_cache, filename)
            \ && len(s:async_include_cache[filename])
            \            >= g:neoinclude#max_processes
        break
      endif

      let s:async_include_cache[filename]
            \ = s:initialize_include(filename, filetype, ctags, a:is_force)
      let include_info.async_files[filename] = 1
    endif
  endfor
endfunction

function! s:get_buffer_include_files(bufnr) abort
  let filetype = getbufvar(a:bufnr, '&filetype')
  if filetype == ''
    return []
  endif

  call neoinclude#set_filetype_paths(a:bufnr, filetype)

  let pattern = neoinclude#get_pattern(a:bufnr, filetype)
  if pattern == ''
    return []
  endif
  let path = neoinclude#get_path(a:bufnr, filetype)
  let expr = neoinclude#get_expr(a:bufnr, filetype)
  let suffixes = &l:suffixesadd

  " Change current directory.
  let buffer_dir = fnamemodify(bufname(a:bufnr), ':p:h')
  let cwd_save = neoinclude#util#cd(buffer_dir)

  try
    let include_files = s:get_include_files(0,
          \ getbufline(a:bufnr, 1, 100), filetype, pattern, path, expr)
  finally
    if !empty(cwd_save)
      execute cwd_save[0] fnameescape(cwd_save[1])
    endif

    " Restore option.
    let &l:suffixesadd = suffixes
  endtry

  return neoinclude#util#uniq(include_files)
endfunction
function! s:get_include_files(nestlevel, lines, filetype, pattern, path, expr) abort
  let include_files = []
  for line in a:lines
    if line =~ a:pattern
      let match_end = matchend(line, a:pattern)
      if a:expr != ''
        let eval = substitute(a:expr, 'v:fname',
              \ string(matchstr(line[match_end :], '\f\+')), 'g')
        try
          let filename = fnamemodify(findfile(eval(eval), a:path), ':p')
        catch
          " Error
          let filename = ''
        endtry
      else
        let filename = fnamemodify(findfile(
              \ matchstr(line[match_end :], '\f\+'), a:path), ':p')
      endif

      if filereadable(filename)
        call add(include_files, filename)

        if a:nestlevel < 1
          " Nested include files.
          let include_files += s:get_include_files(
                \ a:nestlevel + 1, readfile(filename, '', 100),
                \ a:filetype, a:pattern, a:path, a:expr)
        endif
      elseif isdirectory(filename) && a:filetype ==# 'java'
        " For Java import with *.
        " Ex: import lejos.nxt.*
        let include_files += neoinclude#util#glob(filename . '/*.java')
      endif
    endif
  endfor

  return include_files
endfunction

function! s:initialize_include(filename, filetype, ctags, is_force) abort
  " Initialize include list from tags.
  let tags_file_name = tempname()
  let args = neoinclude#util#get_buffer_config(a:filetype,
        \ 'b:neoinclude_ctags_arguments',
        \ g:neoinclude#ctags_arguments,
        \ g:neoinclude#_ctags_arguments, '')
  if a:ctags == 'jsctags'
    let command = printf('%s ''%s'' %s >''%s''',
          \ a:ctags, a:filename, args, tags_file_name)
  elseif has('win32') || has('win64')
    let filename =
          \ neoinclude#util#substitute_path_separator(a:filename)
    let command = printf('%s -f "%s" %s "%s" ',
          \ a:ctags, tags_file_name, args, filename)
  else
    let command = printf('%s -f ''%s'' 2>/dev/null %s ''%s''',
          \ a:ctags, tags_file_name, args, a:filename)
  endif

  if a:is_force
    call neoinclude#util#system(command)
  else
    call neoinclude#util#async_system(command)
  endif

  return {
        \ 'filename' : a:filename,
        \ 'cachename' : tags_file_name,
        \ }
endfunction
function! neoinclude#include#make_cache(bufname) abort
  call neoinclude#initialize()

  let bufnr = (a:bufname == '') ? bufnr('%') : bufnr(a:bufname)

  " Initialize.
  if has_key(s:include_info, bufnr)
    call remove(s:include_info, bufnr)
  endif

  call s:check_buffer(bufnr, 1)
endfunction
