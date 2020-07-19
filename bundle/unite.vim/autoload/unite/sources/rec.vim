"=============================================================================
" FILE: rec.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

if exists('g:unite_source_rec_async_command') &&
      \ type(g:unite_source_rec_async_command) == type('')
  call unite#print_error(
        \ 'g:unite_source_rec_async_command must be list type.')
endif

" Variables  "{{{
call unite#util#set_default(
      \ 'g:unite_source_rec_min_cache_files', 100,
      \ 'g:unite_source_file_rec_min_cache_files')
call unite#util#set_default(
      \ 'g:unite_source_rec_max_cache_files', 20000,
      \ 'g:unite_source_file_rec_max_cache_files')
call unite#util#set_default('g:unite_source_rec_unit',
      \ unite#util#is_windows() ? 1000 : 2000)
" -L follows symbolic links to have the same behaviour as file_rec
call unite#util#set_default(
      \ 'g:unite_source_rec_async_command', (
      \  !unite#util#is_windows() && executable('find') ?
      \    ['find',  '-L'] : []),
      \ 'g:unite_source_file_rec_async_command')
call unite#util#set_default(
      \ 'g:unite_source_rec_find_args',
      \ ['-path', '*/.git/*', '-prune', '-o', '-type', 'l', '-print'])
call unite#util#set_default(
      \ 'g:unite_source_rec_git_command', 'git')
"}}}

let s:Cache = unite#util#get_vital_cache()

let s:continuation = { 'directory' : {}, 'file' : {} }

" Source rec.
let s:source_file_rec = {
      \ 'name' : 'file_rec',
      \ 'description' : 'candidates from directory by recursive',
      \ 'hooks' : {},
      \ 'default_kind' : 'file',
      \ 'max_candidates' : 1000,
      \ 'ignore_globs' : [
      \         '.', '*~', '*.o', '*.exe', '*.bak',
      \         'DS_Store', '*.pyc', '*.sw[po]', '*.class',
      \         '.hg/**', '.git/**', '.bzr/**', '.svn/**',
      \         'tags', 'tags-*'
      \ ],
      \ 'matchers' : [ 'converter_relative_word', 'matcher_default' ],
      \ }

function! s:source_file_rec.gather_candidates(args, context) abort "{{{
  let a:context.source__directory =
        \ get(s:get_paths(a:args, a:context), 0, '')

  let directory = a:context.source__directory
  if directory == ''
    " Not in project directory.
    call unite#print_source_message(
          \ 'Not in project directory.', self.name)
    let a:context.is_async = 0
    return []
  endif

  call unite#print_source_message(
        \ 'directory: ' . directory, self.name)

  call s:init_continuation(a:context, directory)

  let continuation = a:context.source__continuation

  if empty(continuation.rest) || continuation.end
    " Disable async.
    let a:context.is_async = 0
    let continuation.end = 1
  endif

  return deepcopy(continuation.files)
endfunction"}}}

function! s:source_file_rec.async_gather_candidates(args, context) abort "{{{
  let continuation = a:context.source__continuation

  let ignore_dir = get(a:context, 'custom_rec_ignore_directory_pattern',
              \ '/\.\+$\|/\%(\.hg\|\.git\|\.bzr\|\.svn\)/')

  let [continuation.rest, files] =
        \ s:get_files(a:context, continuation.rest,
        \   1, g:unite_source_rec_unit, ignore_dir)

  if empty(continuation.rest) || (
        \  g:unite_source_rec_max_cache_files > 0 &&
        \    len(continuation.files) >
        \        g:unite_source_rec_max_cache_files)
    if !empty(continuation.rest)
      call unite#print_source_message(
            \ 'Too many candidates.', self.name)
    endif

    " Disable async.
    let a:context.is_async = 0
    let continuation.end = 1
  endif

  let candidates = unite#helper#ignore_candidates(
        \ unite#helper#paths2candidates(files), a:context)

  let continuation.files += candidates
  if empty(continuation.rest)
    call s:write_cache(a:context,
          \ a:context.source__directory, continuation.files)
  endif

  return deepcopy(candidates)
endfunction"}}}

function! s:source_file_rec.hooks.on_init(args, context) abort "{{{
  let a:context.source__is_directory = 0
  call s:on_init(a:args, a:context, s:source_file_rec.name)
endfunction"}}}

function! s:source_file_rec.vimfiler_check_filetype(args, context) abort "{{{
  let path = unite#util#substitute_path_separator(
        \ unite#util#expand(join(a:args, ':')))
  let path = unite#util#substitute_path_separator(
        \ simplify(fnamemodify(path, ':p')))

  if isdirectory(path)
    let type = 'directory'
    let lines = []
    let dict = {}
  else
    return []
  endif

  return [type, lines, dict]
endfunction"}}}
function! s:source_file_rec.vimfiler_gather_candidates(args, context) abort "{{{
  let path = get(s:get_paths(a:args, a:context), 0, '')

  if !isdirectory(path)
    let a:context.source__directory = path

    return []
  endif

  " Initialize.
  let candidates = copy(self.gather_candidates(a:args, a:context))
  while a:context.is_async
    " Gather all candidates.

    " User input check.
    echo 'File searching...(if press any key, will cancel.)'
    redraw
    if getchar(0)
      break
    endif

    let candidates += self.async_gather_candidates(a:args, a:context)
  endwhile
  redraw!

  let old_dir = getcwd()
  if path !=# old_dir
    call unite#util#lcd(path)
  endif

  let exts = unite#util#is_windows() ?
        \ escape(substitute($PATHEXT . ';.LNK', ';', '\\|', 'g'), '.') : ''

  " Set vimfiler property.
  for candidate in candidates
    call unite#sources#file#create_vimfiler_dict(candidate, exts)
  endfor

  if path !=# old_dir
    call unite#util#lcd(old_dir)
  endif

  return deepcopy(candidates)
endfunction"}}}
function! s:source_file_rec.vimfiler_dummy_candidates(args, context) abort "{{{
  let path = unite#util#substitute_path_separator(
        \ unite#util#expand(join(a:args, ':')))
  let path = unite#util#substitute_path_separator(
        \ simplify(fnamemodify(path, ':p')))

  if path == ''
    return []
  endif

  let old_dir = getcwd()
  if path !=# old_dir
    call unite#util#lcd(path)
  endif

  let exts = unite#util#is_windows() ?
        \ escape(substitute($PATHEXT . ';.LNK', ';', '\\|', 'g'), '.') : ''

  " Set vimfiler property.
  let candidates = [ unite#sources#file#create_file_dict(path, '') ]
  for candidate in candidates
    call unite#sources#file#create_vimfiler_dict(candidate, exts)
  endfor

  if path !=# old_dir
    call unite#util#lcd(old_dir)
  endif

  return deepcopy(candidates)
endfunction"}}}
function! s:source_file_rec.vimfiler_complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return unite#sources#file#complete_directory(
        \ a:args, a:context, a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}
function! s:source_file_rec.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return unite#sources#file#complete_directory(
        \ a:args, a:context, a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}

" Source async.
let s:source_file_async = deepcopy(s:source_file_rec)
let s:source_file_async.name = 'file_rec/async'
let s:source_file_async.description =
      \ 'asynchronous candidates from directory by recursive'

function! s:source_file_async.gather_candidates(args, context) abort "{{{
  let paths = s:get_paths(a:args, a:context)
  let a:context.source__directory = join(paths, "\n")

  if !unite#util#has_vimproc()
    call unite#print_source_message(
          \ 'vimproc plugin is not installed.', self.name)
    let a:context.is_async = 0
    return []
  endif

  let directory = a:context.source__directory

  call unite#print_source_message(
        \ 'directory: ' . directory, self.name)

  call s:init_continuation(a:context, directory)

  let continuation = a:context.source__continuation

  if empty(continuation.rest) || continuation.end
    " Disable async.
    let a:context.is_async = 0
    let continuation.end = 1

    return deepcopy(continuation.files)
  endif

  if type(g:unite_source_rec_async_command) == type('')
    " You must specify list type.
    call unite#print_source_message(
          \ 'g:unite_source_rec_async_command must be list type.', self.name)
    let a:context.is_async = 0
    return []
  endif

  let args = g:unite_source_rec_async_command
  if a:context.source__is_directory
    " Use find command.
    let args = ['find', '-L']
  endif

  if empty(args) || !executable(args[0])
    if empty(args)
      call unite#print_source_message(
            \ 'You must install file list command and specify '
            \  . 'g:unite_source_rec_async_command variable.', self.name)
    else
      call unite#print_source_message('async command : "'.
            \ args[0].'" is not executable.', self.name)
    endif
    let a:context.is_async = 0
    return []
  endif

  " Note: If find command and args used, uses whole command line.
  let commands = args + paths
  if args[0] ==# 'find'
    " Default option.
    let commands += g:unite_source_rec_find_args
    let commands +=
          \ ['-o', '-type',
          \ (a:context.source__is_directory ? 'd' : 'f'), '-print']
  endif

  call unite#add_source_message(
        \ 'Command-line: ' . string(commands), self.name)

  let a:context.source__proc = vimproc#popen3(commands,
        \ unite#helper#is_pty(args[0]))

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

  let continuation = a:context.source__continuation
  let stdout = a:context.source__proc.stdout

  let paths = map(filter(
        \   unite#util#read_lines(stdout, 2000), 'v:val != ""'),
        \   "unite#util#iconv(v:val, 'char', &encoding)")
  if unite#util#is_windows()
    let paths = map(paths, 'unite#util#substitute_path_separator(v:val)')
  endif

  let candidates = unite#helper#ignore_candidates(
        \ unite#helper#paths2candidates(paths), a:context)

  if stdout.eof || (
        \  g:unite_source_rec_max_cache_files > 0 &&
        \    len(continuation.files) >
        \        g:unite_source_rec_max_cache_files)
    " Disable async.
    if !stdout.eof
      call unite#print_source_message(
            \ 'Too many candidates.', self.name)
    endif
    let a:context.is_async = 0
    let continuation.end = 1

    call a:context.source__proc.waitpid()
  endif

  let continuation.files += candidates
  if stdout.eof
    call s:write_cache(a:context,
          \ a:context.source__directory, continuation.files)
  endif

  return deepcopy(candidates)
endfunction"}}}

function! s:source_file_async.hooks.on_init(args, context) abort "{{{
  let a:context.source__is_directory = 0
  call s:on_init(a:args, a:context, s:source_file_async.name)
endfunction"}}}
function! s:source_file_async.hooks.on_close(args, context) abort "{{{
  if has_key(a:context, 'source__proc')
    call a:context.source__proc.kill()
  endif
endfunction "}}}

" Source neovim.
let s:source_file_neovim = deepcopy(s:source_file_rec)
let s:source_file_neovim.name = 'file_rec/neovim'
let s:source_file_neovim.description =
      \ 'neovim asynchronous candidates from directory by recursive'

let s:job_info = {}
function! s:job_handler(job_id, data, event) abort "{{{
  if !has_key(s:job_info, a:job_id)
    let s:job_info[a:job_id] = {
          \ 'candidates' : [],
          \ 'errors' : [],
          \ 'eof' : 0,
          \ }
  endif

  let job = s:job_info[a:job_id]

  if a:event ==# 'exit'
    let job.eof = 1
    return
  endif

  let lines = a:data

  let candidates = (a:event ==# 'stdout') ? job.candidates : job.errors
  if !empty(lines) && !empty(candidates)
        \ && !filereadable(candidates[-1]) && candidates[-1] !~ '\r$'
    " Join to the previous line
    let candidates[-1] .= lines[0]
    call remove(lines, 0)
  endif

  call map(filter(lines, 'v:val != ""'),
          \ "substitute(unite#util#iconv(
          \    v:val, 'char', &encoding), '\\r$', '', '')")

  if unite#util#is_windows()
    call map(lines,
          \ 'unite#util#substitute_path_separator(v:val)')
  endif

  let candidates += lines
endfunction"}}}

function! s:source_file_neovim.gather_candidates(args, context) abort "{{{
  let paths = s:get_paths(a:args, a:context)
  let a:context.source__directory = join(paths, "\n")

  if !has('nvim')
    call unite#print_source_message(
          \ 'Your vim is not neovim.', self.name)
    let a:context.is_async = 0
    return []
  endif

  let directory = a:context.source__directory

  call unite#print_source_message(
        \ 'directory: ' . directory, self.name)

  call s:init_continuation(a:context, directory)

  let continuation = a:context.source__continuation

  if empty(continuation.rest) || continuation.end
    " Disable async.
    let a:context.is_async = 0
    let continuation.end = 1

    return deepcopy(continuation.files)
  endif

  if type(g:unite_source_rec_async_command) == type('')
    " You must specify list type.
    call unite#print_source_message(
          \ 'g:unite_source_rec_async_command must be list type.', self.name)
    let a:context.is_async = 0
    return []
  endif

  let args = g:unite_source_rec_async_command
  if a:context.source__is_directory
    " Use find command.
    let args = ['find', '-L']
  endif

  if empty(args) || !executable(args[0])
    if empty(args)
      call unite#print_source_message(
            \ 'You must install file list command and specify '
            \  . 'g:unite_source_rec_async_command variable.', self.name)
    else
      call unite#print_source_message('async command : "'.
            \ args[0].'" is not executable.', self.name)
    endif
    let a:context.is_async = 0
    return []
  endif

  " Note: If find command and args used, uses whole command line.
  let commands = args + paths
  if args[0] ==# 'find'
    " Default option.
    let commands += g:unite_source_rec_find_args
    let commands +=
          \ ['-o', '-type',
          \ (a:context.source__is_directory ? 'd' : 'f'), '-print']
  endif

  call unite#add_source_message(
        \ 'Command-line: ' . string(commands), self.name)

  let a:context.source__job = jobstart(commands, {
        \ 'on_stdout' : function('s:job_handler'),
        \ 'on_stderr' : function('s:job_handler'),
        \ 'on_exit' : function('s:job_handler'),
        \ 'pty' : unite#helper#is_pty(args[0]),
        \ })

  return []
endfunction"}}}

function! s:source_file_neovim.async_gather_candidates(args, context) abort "{{{
  if !has_key(s:job_info, a:context.source__job)
    return []
  endif

  let job = s:job_info[a:context.source__job]

  if !empty(job.errors)
    " Print error.
    call unite#print_source_error(job.errors[: -2], self.name)
    let job.errors = job.errors[-1:]
  endif

  let continuation = a:context.source__continuation
  let candidates = job.eof ? job.candidates : job.candidates[: -2]
  let candidates = unite#helper#ignore_candidates(
        \ unite#helper#paths2candidates(candidates), a:context)
  let job.candidates = job.eof ? [] : job.candidates[-1:]

  if job.eof
    " Disable async.
    let a:context.is_async = 0
    let continuation.end = 1
    call s:source_file_neovim.hooks.on_close(a:args, a:context)
  endif

  let continuation.files += candidates
  if job.eof
    call s:write_cache(a:context,
          \ a:context.source__directory, continuation.files)
  endif

  return deepcopy(candidates)
endfunction"}}}

function! s:source_file_neovim.hooks.on_init(args, context) abort "{{{
  let a:context.source__is_directory = 0
  call s:on_init(a:args, a:context, s:source_file_neovim.name)
endfunction"}}}
function! s:source_file_neovim.hooks.on_close(args, context) abort "{{{
  if has_key(a:context, 'source__job')
        \ && has_key(s:job_info, a:context.source__job)
    silent! call jobstop(a:context.source__job)
    call remove(s:job_info, a:context.source__job)
  endif
endfunction "}}}

" Source git.
let s:source_file_git = deepcopy(s:source_file_async)
let s:source_file_git.name = 'file_rec/git'
let s:source_file_git.description =
      \ 'git candidates from directory by recursive'
function! s:source_file_git.gather_candidates(args, context) abort "{{{
  if !unite#util#has_vimproc()
    call unite#print_source_message(
          \ 'vimproc plugin is not installed.', self.name)
    let a:context.is_async = 0
    return []
  endif

  let directory = fnamemodify(finddir('.git', ';'), ':p:h:h')
  if directory == ''
    let directory = fnamemodify(findfile('.git', ';'), ':p:h')
  endif
  let directory = unite#util#substitute_path_separator(directory)
  if directory == ''
    " Not in git directory.
    call unite#print_source_message(
          \ 'Not in git directory.', self.name)
    let a:context.is_async = 0
    return []
  endif

  let a:context.source__directory =
        \ unite#util#substitute_path_separator(getcwd()) . '/'

  call unite#print_source_message(
        \ 'directory: ' . directory, self.name)

  call s:init_continuation(a:context, directory)

  let continuation = a:context.source__continuation

  if empty(continuation.rest) || continuation.end
    " Disable async.
    let a:context.is_async = 0
    let continuation.end = 1

    return deepcopy(continuation.files)
  endif

  let command = g:unite_source_rec_git_command
        \ . ' ls-files ' . join(a:args)
  let args = vimproc#parser#split_args(command) + a:args
  if empty(args) || !executable(args[0])
    call unite#print_source_message('git command : "'.
          \ args[0].'" is not executable.', self.name)
    let a:context.is_async = 0
    return []
  endif

  call unite#add_source_message(
        \ 'Command-line: ' . command, self.name)

  let a:context.source__proc = vimproc#popen3(command)

  " Close handles.
  call a:context.source__proc.stdin.close()

  return []
endfunction"}}}
function! s:source_file_git.async_gather_candidates(args, context) abort "{{{
  return map(s:source_file_async.async_gather_candidates(
        \ a:args, a:context), "{
        \   'word' : a:context.source__directory . v:val.word,
        \   'action__path' : a:context.source__directory . v:val.word,
        \}")
endfunction"}}}
function! s:source_file_git.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return []
endfunction"}}}
function! s:source_file_git.hooks.on_init(args, context) abort "{{{
  let a:context.source__is_directory = 0
  call s:on_init(a:args, a:context, s:source_file_git.name)
endfunction"}}}

" Source directory.
let s:source_directory_rec = deepcopy(s:source_file_rec)
let s:source_directory_rec.name = 'directory_rec'
let s:source_directory_rec.description =
      \ 'candidates from directory by recursive'
let s:source_directory_rec.default_kind = 'directory'

function! s:source_directory_rec.hooks.on_init(args, context) abort "{{{
  let a:context.source__is_directory = 1
  call s:on_init(a:args, a:context, s:source_directory_rec.name)
endfunction"}}}
function! s:source_directory_rec.hooks.on_post_filter(args, context) abort "{{{
  for candidate in filter(copy(a:context.candidates),
        \ "v:val.word[-1:] != '/'")
    let candidate.abbr = candidate.word . '/'
  endfor
endfunction"}}}

" Source directory/async.
let s:source_directory_async = deepcopy(s:source_file_async)
let s:source_directory_async.name = 'directory_rec/async'
let s:source_directory_async.description =
      \ 'asynchronous candidates from directory by recursive'
let s:source_directory_async.default_kind = 'directory'

function! s:source_directory_async.hooks.on_init(args, context) abort "{{{
  let a:context.source__is_directory = 1
  call s:on_init(a:args, a:context, s:source_directory_async.name)
endfunction"}}}
function! s:source_directory_async.hooks.on_post_filter(args, context) abort "{{{
  for candidate in filter(copy(a:context.candidates),
        \ "v:val.word[-1:] != '/'")
    let candidate.abbr = candidate.word . '/'
  endfor
endfunction"}}}

" Misc.
function! s:get_paths(args, context) abort "{{{
  let args = unite#helper#parse_source_args(a:args)
  let directory = get(args, 0, '')
  if directory == ''
    let directory = isdirectory(a:context.path) ?
          \ a:context.path : getcwd()
  endif

  let paths = []
  for path in split(directory, "\n")
    let path = unite#util#substitute_path_separator(
          \ fnamemodify(unite#util#expand(path), ':p'))

    if path != '/' && path =~ '/$'
      let path = path[: -2]
    endif

    call add(paths, path)
  endfor

  return paths
endfunction"}}}
function! s:get_files(context, files, level, max_unit, ignore_dir) abort "{{{
  let continuation_files = []
  let ret_files = []
  let files_index = 0
  let ret_files_len = 0
  for file in a:files
    let files_index += 1

    if isdirectory(file)
      if file =~? a:ignore_dir
        continue
      endif
      if getftype(file) ==# 'link'
        let real_file = s:resolve(file)
        if real_file == ''
          continue
        endif
      endif

      if file != '/' && file =~ '/$'
        let file = file[: -2]
      endif

      if a:context.source__is_directory &&
            \ file !=# a:context.source__directory
        call add(ret_files, file)
        let ret_files_len += 1
      endif

      let child_index = 0
      let children = exists('*vimproc#readdir') ?
            \ vimproc#readdir(file) :
            \ unite#util#glob(file.'/*')
      for child in children
        let child = substitute(child, '\/$', '', '')
        let child_index += 1

        if child =~? a:ignore_dir
          continue
        endif

        if isdirectory(child)
          if getftype(child) ==# 'link'
            let real_file = s:resolve(child)
            if real_file == ''
              continue
            endif
          endif

          if a:context.source__is_directory
            call add(ret_files, child)
            let ret_files_len += 1
          endif

          if a:level < 5 && ret_files_len < a:max_unit
            let [continuation_files_child, ret_files_child] =
                  \ s:get_files(a:context, [child], a:level + 1,
                  \  a:max_unit - ret_files_len, a:ignore_dir)
            let continuation_files += continuation_files_child

            if !a:context.source__is_directory
              let ret_files += ret_files_child
              let ret_files_len += len(ret_files_child)
            endif
          else
            call add(continuation_files, child)
          endif
        elseif !a:context.source__is_directory
          call add(ret_files, child)

          let ret_files_len += 1

          if ret_files_len > a:max_unit
            let continuation_files += children[child_index :]
            break
          endif
        endif
      endfor
    elseif !a:context.source__is_directory
      call add(ret_files, file)
      let ret_files_len += 1
    endif

    if ret_files_len > a:max_unit
      break
    endif
  endfor

  let continuation_files += a:files[files_index :]
  return [continuation_files, map(ret_files,
        \ "unite#util#substitute_path_separator(fnamemodify(v:val, ':p'))")]
endfunction"}}}
function! s:on_init(args, context, name) abort "{{{
  augroup plugin-unite-source-file_rec
    autocmd!
    autocmd BufEnter,BufWinEnter,BufFilePost,BufWritePost *
          \ call unite#sources#rec#_append()
  augroup END

  let a:context.source__name = a:name
endfunction"}}}
function! s:init_continuation(context, directory) abort "{{{
  let cache_dir = printf('%s/%s/%s',
        \ unite#get_data_directory(),
        \ a:context.source__name,
        \ (a:context.source__is_directory ? 'directory' : 'file'))
  let continuation = (a:context.source__is_directory) ?
        \ s:continuation.directory : s:continuation.file

  if a:context.is_redraw
    " Delete old cache files.
    call s:Cache.deletefile(cache_dir, a:directory)
  endif

  if s:Cache.filereadable(cache_dir, a:directory)
    " Use cache file.

    let files = unite#helper#paths2candidates(
          \ s:Cache.readfile(cache_dir, a:directory))

    let continuation[a:directory] = {
          \ 'files' : files,
          \ 'rest' : [],
          \ 'directory' : a:directory, 'end' : 1,
          \ }
  else
    let a:context.is_async = 1

    let continuation[a:directory] = {
          \ 'files' : [], 'rest' : [a:directory],
          \ 'directory' : a:directory, 'end' : 0,
          \ }
  endif

  let a:context.source__continuation = continuation[a:directory]
  let a:context.source__continuation.files =
        \ filter(copy(a:context.source__continuation.files),
        \ (a:context.source__is_directory) ?
        \   'isdirectory(v:val.action__path)' :
        \   'filereadable(v:val.action__path)')
endfunction"}}}
function! s:write_cache(context, directory, files) abort "{{{
  let cache_dir = printf('%s/%s/%s',
        \ unite#get_data_directory(),
        \ a:context.source__name,
        \ (a:context.source__is_directory ? 'directory' : 'file'))

  if g:unite_source_rec_min_cache_files >= 0
        \ && !unite#util#is_sudo()
        \ && len(a:files) >
        \ g:unite_source_rec_min_cache_files
    call s:Cache.writefile(cache_dir, a:directory,
          \ map(copy(a:files), 'v:val.action__path'))
  elseif s:Cache.filereadable(cache_dir, a:directory)
    " Delete old cache files.
    call s:Cache.deletefile(cache_dir, a:directory)
  endif
endfunction"}}}

function! unite#sources#rec#_append() abort "{{{
  let path = expand('%:p')
  if path !~ '\a\+:'
    let path = simplify(resolve(path))
  endif

  " Append the current buffer to the mru list.
  if !filereadable(path) || &l:buftype =~# 'help\|nofile'
    return
  endif

  let path = unite#util#substitute_path_separator(path)

  " Check continuation.
  let base_path = unite#util#substitute_path_separator(
        \ fnamemodify(path, ':h')) . '/'
  for continuation in values(filter(copy(s:continuation.file),
        \ "stridx(v:key.'/', base_path) == 0"))
    let continuation.files = unite#util#uniq(add(
          \ continuation.files, {
            \ 'word' : path, 'action__path' : path,
            \ }))
  endfor
endfunction"}}}

function! unite#sources#rec#define() abort "{{{
  let sources = [ s:source_file_rec, s:source_directory_rec ]
  let sources += [ s:source_file_async, s:source_directory_async]
  let sources += [ s:source_file_git ]
  let sources += [ s:source_file_neovim ]
  return sources
endfunction"}}}

function! s:resolve(file) abort "{{{
  " Detect symbolic link loop.
  let file_link = unite#util#substitute_path_separator(
        \ resolve(a:file))
  return stridx(a:file, file_link.'/') == 0 ? '' : file_link
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
