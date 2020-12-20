"=============================================================================
" FILE: file.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:is_windows = unite#util#is_windows()

" Variables  "{{{
call unite#util#set_default(
      \ 'g:unite_source_file_async_command', 'ls -a')

let s:cache_files = {}
"}}}

function! unite#sources#file#define() abort "{{{
  return [s:source_file, s:source_file_new, s:source_file_async]
endfunction"}}}

function! unite#sources#file#get_file_source() abort "{{{
  return s:source_file
endfunction"}}}

let s:source_file = {
      \ 'name' : 'file',
      \ 'description' : 'candidates from file list',
      \ 'ignore_globs' : [
      \         '.', '..', '*~', '*.o', '*.exe', '*.bak',
      \         'DS_Store', '*.pyc', '*.sw[po]', '*.class',
      \         '.hg/**', '.git/**', '.bzr/**', '.svn/**',
      \ ],
      \ 'default_kind' : 'file',
      \ 'matchers' : [ 'matcher_default', 'matcher_hide_hidden_files' ],
      \ 'hooks' : {},
      \}

function! s:source_file.change_candidates(args, context) abort "{{{
  let path = unite#sources#file#_get_path(a:args, a:context)

  if !isdirectory(path) && filereadable(path)
    return [ unite#sources#file#create_file_dict(
          \      path, a:context.input) ]
  endif

  let input = unite#sources#file#_get_input(path, a:context)
  return map(unite#sources#file#_get_files(input, a:context),
          \ 'unite#sources#file#create_file_dict(v:val, a:context.input)')
endfunction"}}}
function! s:source_file.vimfiler_check_filetype(args, context) abort "{{{
  let path = s:parse_path(a:args)

  if isdirectory(path)
    let type = 'directory'
    let info = path
  elseif filereadable(path)
    let type = 'file'
    let info = [readfile(path),
          \ unite#sources#file#create_file_dict(path, '')]
  else
    " Ignore.
    return []
  endif

  return [type, info]
endfunction"}}}
function! s:source_file.vimfiler_gather_candidates(args, context) abort "{{{
  let path = s:parse_path(a:args)

  if isdirectory(path)
    " let start = reltime()

    let context = deepcopy(a:context)
    let context.is_vimfiler = 1
    let context.path .= path
    let candidates = self.change_candidates(a:args, context)
    call filter(candidates, 'v:val.action__path !~ "/\\.\\.\\?$"')

    " echomsg reltimestr(reltime(start))
  elseif filereadable(path)
    let candidates = [ unite#sources#file#create_file_dict(path, '') ]
  else
    let candidates = []
  endif

  let exts = s:is_windows ?
        \ escape(substitute($PATHEXT . ';.LNK', ';', '\\|', 'g'), '.') : ''

  let old_dir = getcwd()
  if path !=# old_dir
    try
      call unite#util#lcd(path)
    catch
      call unite#print_error('cd failed in "' . path . '"')
      return []
    endtry
  endif

  " Set vimfiler property.
  for candidate in candidates
    call unite#sources#file#create_vimfiler_dict(candidate, exts)
  endfor

  if path !=# old_dir
    call unite#util#lcd(old_dir)
  endif

  return candidates
endfunction"}}}
function! s:source_file.vimfiler_dummy_candidates(args, context) abort "{{{
  let path = s:parse_path(a:args)

  if path == ''
    return []
  endif

  let old_dir = getcwd()
  if path !=# old_dir
    call unite#util#lcd(path)
  endif

  let exts = s:is_windows ?
        \ escape(substitute($PATHEXT . ';.LNK', ';', '\\|', 'g'), '.') : ''

  " Set vimfiler property.
  let candidates = [ unite#sources#file#create_file_dict(path, '') ]
  for candidate in candidates
    call unite#sources#file#create_vimfiler_dict(candidate, exts)
  endfor

  if path !=# old_dir
    call unite#util#lcd(old_dir)
  endif

  return candidates
endfunction"}}}
function! s:source_file.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return unite#sources#file#complete_file(
        \ a:args, a:context, a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}
function! s:source_file.vimfiler_complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return self.complete(
        \ a:args, a:context, a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}

function! s:source_file.hooks.on_close(args, context) abort "{{{
  call unite#sources#file#_clear_cache()
endfunction "}}}

let s:source_file_new = {
      \ 'name' : 'file/new',
      \ 'description' : 'file candidates from input',
      \ 'default_kind' : 'file',
      \ }

function! s:source_file_new.change_candidates(args, context) abort "{{{
  let path = unite#sources#file#_get_path(a:args, a:context)
  let input = unite#sources#file#_get_input(path, a:context)
  let input = substitute(input, '\*', '', 'g')

  if input == '' || filereadable(input) || isdirectory(input)
    return []
  endif

  return [unite#sources#file#create_file_dict(
        \ input, a:context.input, 1)]
endfunction"}}}

let s:source_file_async = deepcopy(s:source_file)
let s:source_file_async.name = 'file/async'
let s:source_file_async.description = 'asynchronous candidates from file list'

function! s:source_file_async.hooks.on_close(args, context) abort "{{{
  if has_key(a:context, 'source__proc')
    call a:context.source__proc.kill()
  endif
endfunction "}}}

function! s:source_file_async.change_candidates(args, context) abort "{{{
  if !has_key(a:context, 'source__cache') || a:context.is_redraw
        \ || a:context.is_invalidate
    " Initialize cache.
    let a:context.source__cache = {}
    let a:context.is_async = 1
  endif

  if !unite#util#has_vimproc()
    call unite#print_source_message(
          \ 'vimproc plugin is not installed.', self.name)
    let a:context.is_async = 0
    return []
  endif

  let path = unite#sources#file#_get_path(a:args, a:context)
  let input = unite#sources#file#_get_input(path, a:context)
  " Glob by directory name.
  let directory = substitute(input, '[^/]*$', '', '')

  let command = g:unite_source_file_async_command
  let args = split(command)
  if empty(args) || !executable(args[0])
    call unite#print_source_message('async command : "'.
          \ command.'" is not executable.', self.name)
    let a:context.is_async = 0
    return []
  endif

  if has_key(a:context, 'source__proc') && a:context.is_async
    call a:context.source__proc.kill()
  endif

  if directory == ''
    let directory = unite#util#substitute_path_separator(getcwd())
  endif
  if directory !~ '/$'
    let directory .= '/'
  endif
  let command .= ' ' . string(directory)
  let a:context.source__proc = vimproc#pgroup_open(command, 0)
  let a:context.source__directory = directory
  let a:context.source__candidates = []

  " Close handles.
  call a:context.source__proc.stdin.close()

  return []
endfunction"}}}

function! s:source_file_async.async_gather_candidates(args, context) abort "{{{
  let stderr = a:context.source__proc.stderr
  if !stderr.eof
    " Print error.
    let errors = filter(unite#util#read_lines(stderr, 200),
          \ "v:val !~ '^\\s*$'")
    if !empty(errors)
      call unite#print_source_error(errors, self.name)
    endif
  endif

  let stdout = a:context.source__proc.stdout

  let paths = map(filter(
        \   unite#util#read_lines(stdout, 2000),
        \   "v:val != '' && v:val !=# '.'"),
        \   "a:context.source__directory .
        \    unite#util#iconv(v:val, 'char', &encoding)")
  if unite#util#is_windows()
    let paths = map(paths, 'unite#util#substitute_path_separator(v:val)')
  endif

  let candidates = unite#helper#paths2candidates(paths)
  for candidate in filter(copy(candidates),
        \ 'isdirectory(v:val.action__path)')
    let candidate.abbr = candidate.action__path .  '/'
    let candidate.kind = 'directory'
  endfor
  let a:context.source__candidates += candidates

  if stdout.eof
    " Disable async.
    let a:context.is_async = 0
    call a:context.source__proc.waitpid()
  endif

  return deepcopy(candidates)
endfunction"}}}

function! unite#sources#file#_get_path(args, context) abort "{{{
  let path = unite#util#substitute_path_separator(
        \ unite#util#expand(join(a:args, ':')))
  if path == ''
    let path = a:context.path
  endif
  if path != '' && path !~ '/$' && isdirectory(path)
    let path .= '/'
  endif

  return path
endfunction"}}}

function! unite#sources#file#_get_input(path, context) abort "{{{
  let input = unite#util#expand(a:context.input)
  if input !~ '^\%(/\|\a\+:/\)' && a:path != ''
    let input = a:path . input
  endif

  if s:is_windows && getftype(input) == 'link'
    " Resolve link.
    let input = resolve(input)
  endif

  return input
endfunction"}}}

function! unite#sources#file#_get_files(input, context) abort "{{{
  " Glob by directory name.
  let input = substitute(a:input, '[^/]*$', '', '')

  let directory = substitute(input, '\*', '', 'g')
  if directory == ''
    let directory = getcwd()
  endif
  let directory = unite#util#substitute_path_separator(
        \ fnamemodify(directory, ':p'))

  let is_vimfiler = get(a:context, 'is_vimfiler', 0)
  if !a:context.is_redraw
        \ && has_key(s:cache_files, directory)
        \ && getftime(directory) <= s:cache_files[directory].time
        \ && input ==# s:cache_files[directory].input
    return copy(s:cache_files[directory].files)
  endif

  let glob = input . (input =~ '\*$' ? '' : '*')
  " Substitute *. -> .* .
  let glob = substitute(glob, '\*\.', '.*', 'g')

  let files = unite#util#glob(glob, !is_vimfiler)

  if !is_vimfiler
    let files = sort(filter(copy(files),
          \ "v:val != '.' && isdirectory(v:val)"), 1) +
          \ sort(filter(copy(files), "!isdirectory(v:val)"), 1)

    let s:cache_files[directory] = {
          \ 'time' : getftime(directory),
          \ 'input' : input,
          \ 'files' : files,
          \ }
  endif

  return copy(files)
endfunction"}}}
function! unite#sources#file#_clear_cache() abort "{{{
  " Don't save cache when using glob
  call filter(s:cache_files, "stridx(v:val.input, '*') < 0")
endfunction"}}}

function! s:parse_path(args) abort "{{{
  let path = unite#util#substitute_path_separator(
        \ unite#util#expand(join(a:args, ':')))
  let path = unite#util#substitute_path_separator(
        \ fnamemodify(path, ':p'))

  return path
endfunction"}}}

function! unite#sources#file#create_file_dict(file, input, ...) abort "{{{
  let is_newfile = get(a:000, 0, 0)

  let dict = {
        \ 'word' : a:file,
        \ 'action__path' : a:file,
        \}
  if a:input !~ '/'
    let dict.word = fnamemodify(a:file, ':t')
  endif
  let dict.abbr = dict.word
  let dict.vimfiler__is_directory = isdirectory(dict.action__path)

  if a:file !~ '^\%(/\|\a\+:/\)'
    let dict.action__path = unite#util#substitute_path_separator(
        \                    fnamemodify(a:file, ':p'))
  endif

  if dict.vimfiler__is_directory
    if a:file !~ '^\%(/\|\a\+:/\)$'
      let dict.abbr .= '/'
    endif

    let dict.kind = 'directory'
  elseif is_newfile
    let dict.abbr = unite#util#substitute_path_separator(
        \ fnamemodify(a:file, ':~:.'))
    if is_newfile == 1
      " New file.
      let dict.abbr = '[new file] ' . dict.abbr
      let dict.kind = 'file'
    elseif is_newfile == 2
      " New directory.
      let dict.abbr = '[new directory] ' . dict.abbr
      let dict.kind = 'directory'
      let dict.action__directory = dict.action__path
    endif
  else
    let dict.kind = 'file'
  endif

  return dict
endfunction"}}}
function! unite#sources#file#create_vimfiler_dict(candidate, exts) abort "{{{
  try
    if len(a:candidate.action__path) > 200
      " Convert to relative path.
      let current_dir_save = getcwd()
      call unite#util#lcd(unite#helper#get_candidate_directory(a:candidate))

      let filename = unite#util#substitute_path_separator(
            \ fnamemodify(a:candidate.action__path, ':.'))
    else
      let filename = a:candidate.action__path
    endif

    let a:candidate.vimfiler__ftype = getftype(filename)
  finally
    if exists('current_dir_save')
      " Restore path.
      call unite#util#lcd(current_dir_save)
    endif
  endtry

  let a:candidate.vimfiler__filename =
        \       fnamemodify(a:candidate.action__path, ':t')
  let a:candidate.vimfiler__abbr = a:candidate.vimfiler__filename

  if !a:candidate.vimfiler__is_directory
    let a:candidate.vimfiler__is_executable =
          \ s:is_windows ?
          \ ('.'.fnamemodify(a:candidate.vimfiler__filename, ':e') =~? a:exts) :
          \ executable(a:candidate.action__path)

    let a:candidate.vimfiler__filesize =
          \ getfsize(a:candidate.action__path)
    if !s:is_windows
      let a:candidate.vimfiler__is_writable =
            \ filewritable(a:candidate.action__path)
    endif
  elseif !s:is_windows
    let a:candidate.vimfiler__is_writable =
          \ filewritable(a:candidate.action__path)
  endif

  let a:candidate.vimfiler__filetime = getftime(a:candidate.action__path)
endfunction"}}}

function! unite#sources#file#complete_file(args, context, arglead, cmdline, cursorpos) abort "{{{
  let files = filter(unite#util#glob(a:arglead . '*'),
        \ "stridx(tolower(v:val), tolower(a:arglead)) == 0")
  if a:arglead =~ '^\~'
    let home_pattern = '^'.
          \ unite#util#substitute_path_separator(expand('~')).'/'
    call map(files, "substitute(v:val, home_pattern, '~/', '')")
  endif
  call map(files, "isdirectory(v:val) ? v:val.'/' : v:val")
  call map(files, "escape(v:val, ' \\')")
  return files
endfunction"}}}
function! unite#sources#file#complete_directory(args, context, arglead, cmdline, cursorpos) abort "{{{
  let files = unite#util#glob(a:arglead . '*')
  let files = filter(files, 'isdirectory(v:val)')
  if a:arglead =~ '^\~'
    let home_pattern = '^'.
          \ unite#util#substitute_path_separator(expand('~')).'/'
    call map(files, "substitute(v:val, home_pattern, '~/', '')")
  endif
  call map(files, "escape(v:val, ' \\')")
  return files
endfunction"}}}

function! unite#sources#file#copy_files(dest, srcs) abort "{{{
  return unite#kinds#file#do_action(a:srcs, a:dest, 'copy')
endfunction"}}}
function! unite#sources#file#move_files(dest, srcs) abort "{{{
  return unite#kinds#file#do_action(a:srcs, a:dest, 'move')
endfunction"}}}
function! unite#sources#file#delete_files(srcs) abort "{{{
  return unite#kinds#file#do_action(a:srcs, '', 'delete')
endfunction"}}}

" Add custom action table. "{{{
let s:cdable_action_file = {
      \ 'description' : 'open this directory by file source',
      \ 'is_start' : 1,
      \}

function! s:cdable_action_file.func(candidate) abort
  call unite#start_script([['file',
        \ unite#helper#get_candidate_directory(a:candidate)]])
endfunction

call unite#custom_action('cdable', 'file', s:cdable_action_file)
unlet! s:cdable_action_file
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
