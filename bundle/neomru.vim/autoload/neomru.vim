"=============================================================================
" FILE: neomru.vim
" AUTHOR:  Zhao Cai <caizhaoff@gmail.com>
"          Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! neomru#set_default(var, val, ...) abort
  if !exists(a:var) || type({a:var}) != type(a:val)
    let alternate_var = get(a:000, 0, '')

    let {a:var} = exists(alternate_var) ?
          \ {alternate_var} : a:val
  endif
endfunction
function! s:substitute_path_separator(path) abort
  return s:is_windows ? substitute(a:path, '\\', '/', 'g') : a:path
endfunction
function! s:expand(path) abort
  return s:substitute_path_separator(expand(a:path))
endfunction
function! s:fnamemodify(fname, mods) abort
  return s:substitute_path_separator(fnamemodify(a:fname, a:mods))
endfunction

" Variables
" The version of MRU file format.
let s:VERSION = '0.3.0'

let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')

let s:base = s:expand($XDG_CACHE_HOME != '' ?
        \   $XDG_CACHE_HOME . '/neomru' : '~/.cache/neomru')

call neomru#set_default(
      \ 'g:neomru#do_validate', 1,
      \ 'g:unite_source_mru_do_validate')
call neomru#set_default(
      \ 'g:neomru#update_interval', 0,
      \ 'g:unite_source_mru_update_interval')
call neomru#set_default(
      \ 'g:neomru#time_format', '',
      \ 'g:unite_source_file_mru_time_format')
call neomru#set_default(
      \ 'g:neomru#filename_format', '',
      \ 'g:unite_source_file_mru_filename_format')
call neomru#set_default(
      \ 'g:neomru#file_mru_path',
      \ s:substitute_path_separator(s:base.'/file'))
call neomru#set_default(
      \ 'g:neomru#file_mru_limit',
      \ 1000, 'g:unite_source_file_mru_limit')
call neomru#set_default(
      \ 'g:neomru#file_mru_ignore_pattern',
      \'\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$'.
      \'\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
      \'\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'.
      \'\|\%(^\%(fugitive\)://\)'.
      \'\|\%(^\%(term\)://\)'
      \, 'g:unite_source_file_mru_ignore_pattern')

call neomru#set_default(
      \ 'g:neomru#directory_mru_path',
      \ s:substitute_path_separator(s:base.'/directory'))
call neomru#set_default(
      \ 'g:neomru#directory_mru_limit',
      \ 1000, 'g:unite_source_directory_mru_limit')
call neomru#set_default(
      \ 'g:neomru#directory_mru_ignore_pattern',
      \'\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
      \'\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)',
      \ 'g:unite_source_directory_mru_ignore_pattern')
call neomru#set_default('g:neomru#follow_links', 0)


" MRUs
let s:MRUs = {}

" Template MRU: 2
"---------------------%>---------------------
" @candidates:
" ------------
" [full_path, ... ]
"
" @mtime
" ------
" the last modified time of the mru file.
" - set once when loading the mru_file
" - update when #save()
"
" @is_loaded
" ----------
" 0: empty
" 1: loaded
" -------------------%<---------------------

let s:mru = {
      \ 'candidates'      : [],
      \ 'type'            : '',
      \ 'mtime'           : 0,
      \ 'update_interval' : g:neomru#update_interval,
      \ 'mru_file'        : '',
      \ 'limit'           : {},
      \ 'do_validate'     : g:neomru#do_validate,
      \ 'is_loaded'       : 0,
      \ 'version'         : s:VERSION,
      \ }

function! s:mru.is_a(type) abort
  return self.type == a:type
endfunction 
function! s:mru.validate() abort
    throw 'unite(mru) umimplemented method: validate()!'
endfunction

function! s:mru.gather_candidates(args, context) abort
  if !self.is_loaded
    call self.load()
  endif

  if a:context.is_redraw && g:neomru#do_validate
    call self.reload()
  endif

  return copy(self.candidates)
endfunction
function! s:mru.delete(candidates) abort
  for candidate in a:candidates
    call filter(self.candidates,
          \ 'v:val !=# candidate.action__path')
  endfor

  call self.save()
endfunction
function! s:mru.has_external_update() abort
  return self.mtime < getftime(self.mru_file)
endfunction

function! s:mru.save(...) abort
  if s:is_sudo()
    return
  endif

  let opts = a:0 >= 1 && type(a:1) == type({}) ? a:1 : {}

  if self.has_external_update() && filereadable(self.mru_file)
    " only need to get the list which contains the latest MRUs
    let lines = readfile(self.mru_file)
    if !empty(lines)
      let [ver; items] = lines
      if self.version_check(ver)
        call extend(self.candidates, items)
      endif
    endif
  endif

  let self.candidates = s:uniq(self.candidates)
  if len(self.candidates) > self.limit
    let self.candidates = self.candidates[: self.limit - 1]
  endif

  if get(opts, 'event') ==# 'VimLeavePre'
    call self.validate()
  endif

  call s:writefile(self.mru_file,
        \ [self.version] + self.candidates)

  let self.mtime = getftime(self.mru_file)
endfunction

function! s:mru.load(...) abort
  let is_force = get(a:000, 0, 0)

  " everything is loaded, done!
  if !is_force && self.is_loaded && !self.has_external_update()
    return
  endif

  let mru_file = self.mru_file

  if !filereadable(mru_file)
    return
  endif

  let file = readfile(mru_file)
  if empty(file)
    return
  endif

  let [ver; items] = file
  if !self.version_check(ver)
    return
  endif

  if self.type ==# 'file'
  endif

  " Assume properly saved and sorted. unique sort is not necessary here
  call extend(self.candidates, items)

  if self.is_loaded
    let self.candidates = s:uniq(self.candidates)
  endif

  let self.mtime = getftime(mru_file)
  let self.is_loaded = 1
endfunction
function! s:mru.reload() abort
  call self.load(1)

  call filter(self.candidates,
        \ ((self.type == 'file') ?
        \ "s:is_file_exist(v:val)" : "s:is_directory_exist(v:val)"))
endfunction
function! s:mru.append(path) abort
  call self.load()
  let index = index(self.candidates, a:path)
  if index == 0
    return
  endif

  if index > 0
    call remove(self.candidates, index)
  endif
  call insert(self.candidates, a:path)

  if len(self.candidates) > self.limit
    let self.candidates = self.candidates[: self.limit - 1]
  endif

  if localtime() > getftime(self.mru_file) + self.update_interval
    call self.save()
  endif
endfunction
function! s:mru.version_check(ver) abort
  let check = 1
  try
    let check = str2float(string(a:ver)) < str2float(string(self.version))
  catch
    " Ignore errors
  endtry

  if check
    call s:print_error('Sorry, the version of MRU file is too old.')
    return 0
  else
    return 1
  endif
endfunction

function! s:resolve(fpath) abort
  return g:neomru#follow_links ? resolve(a:fpath) : a:fpath
endfunction



" File MRU:  2
"
let s:file_mru = extend(deepcopy(s:mru), {
      \ 'type'          : 'file',
      \ 'mru_file'      : s:expand(g:neomru#file_mru_path),
      \ 'limit'         : g:neomru#file_mru_limit,
      \ }
      \)
function! s:file_mru.validate() abort
  if self.do_validate
    call filter(self.candidates, 's:is_file_exist(v:val)')
  endif
endfunction

" Directory MRU:  2
let s:directory_mru = extend(deepcopy(s:mru), {
      \ 'type'          : 'directory',
      \ 'mru_file'      : s:expand(g:neomru#directory_mru_path),
      \ 'limit'         : g:neomru#directory_mru_limit,
      \ }
      \)

function! s:directory_mru.validate() abort
  if self.do_validate
    call filter(self.candidates, 'getftype(v:val) ==# "dir"')
  endif
endfunction


" Public Interface:  2

let s:MRUs.file = s:file_mru
let s:MRUs.directory = s:directory_mru
function! neomru#init() abort
endfunction
function! neomru#_import_file(path) abort
  let path = a:path
  if path == ''
    let path = s:expand('~/.unite/file_mru')
  endif

  let candidates = s:file_mru.candidates
  let candidates += s:import(path)

  " Load from v:oldfiles
  let candidates += map(v:oldfiles, "s:substitute_path_separator(v:val)")

  let s:file_mru.candidates = s:uniq(candidates)
  call s:file_mru.save()
endfunction
function! neomru#_import_directory(path) abort
  let path = a:path
  if path == ''
    let path = s:expand('~/.unite/directory_mru')
  endif

  let s:directory_mru.candidates = s:uniq(
        \ s:directory_mru.candidates + s:import(path))
  call s:directory_mru.save()
endfunction
function! neomru#_get_mrus() abort
  return s:MRUs
endfunction
function! neomru#_append() abort
  if &l:buftype =~ 'help\|nofile' || &l:previewwindow
    return
  endif
  call neomru#append(s:expand('%:p'))
endfunction
function! neomru#_gather_file_candidates() abort
  return neomru#_get_mrus().file.gather_candidates([], {'is_redraw': 0})
endfunction
function! neomru#_gather_directory_candidates() abort
  return neomru#_get_mrus().directory.gather_candidates([], {'is_redraw': 0})
endfunction

function! neomru#append(filename) abort
  let path = s:fnamemodify(a:filename, ':p')
  if path !~ '\a\+:'
    let path = s:substitute_path_separator(
          \ simplify(s:resolve(path)))
  endif

  " Append the current buffer to the mru list.
  if s:is_file_exist(path)
    call s:file_mru.append(path)
  endif

  let filetype = getbufvar(bufnr(a:filename), '&filetype')
  if filetype ==# 'vimfiler' &&
        \ type(getbufvar(bufnr(a:filename), 'vimfiler')) == type({})
    let path = getbufvar(bufnr(a:filename), 'vimfiler').current_dir
  elseif filetype ==# 'vimshell' &&
        \ type(getbufvar(bufnr(a:filename), 'vimshell')) == type({})
    let path = getbufvar(bufnr(a:filename), 'vimshell').current_dir
  else
    let path = s:fnamemodify(path, ':p:h')
  endif

  let path = s:substitute_path_separator(simplify(s:resolve(path)))
  " Chomp last /.
  let path = substitute(path, '/$', '', '')

  " Append the current buffer to the mru list.
  if s:is_directory_exist(path)
    call s:directory_mru.append(path)
  endif
endfunction
function! neomru#_reload() abort
  for m in values(s:MRUs)
    call m.reload()
  endfor
endfunction
function! neomru#_save(...) abort
  let opts = a:0 >= 1 && type(a:1) == type({}) ? a:1 : {}

  for m in values(s:MRUs)
    call m.save(opts)
  endfor
endfunction
function! neomru#_abbr(path, time) abort
  let abbr = (g:neomru#time_format == '') ? '' :
          \ strftime('(' . g:neomru#time_format . ') ', a:time)
  let abbr .= a:path
  return abbr
endfunction



" Misc
function! s:writefile(path, list) abort
  let path = fnamemodify(a:path, ':p')
  if !isdirectory(fnamemodify(path, ':h'))
    call mkdir(fnamemodify(path, ':h'), 'p')
  endif

  call writefile(a:list, path)
endfunction
function! s:uniq(list, ...) abort
  return s:uniq_by(a:list, 'tolower(v:val)')
endfunction
function! s:uniq_by(list, f) abort
  let list = map(copy(a:list), printf('[v:val, %s]', a:f))
  let i = 0
  let seen = {}
  while i < len(list)
    let key = string(list[i][1])
    if has_key(seen, key)
      call remove(list, i)
    else
      let seen[key] = 1
      let i += 1
    endif
  endwhile
  return map(list, 'v:val[0]')
endfunction
function! s:is_file_exist(path) abort
  let ignore = !empty(g:neomru#file_mru_ignore_pattern)
        \ && a:path =~ g:neomru#file_mru_ignore_pattern
  return !ignore && (getftype(a:path) ==# 'file' ||
			  \ getftype(a:path) ==# 'link' ||
			  \ a:path =~ '^\h\w\+:')
endfunction
function! s:is_directory_exist(path) abort
  let ignore = !empty(g:neomru#directory_mru_ignore_pattern)
        \ && a:path =~ g:neomru#directory_mru_ignore_pattern
  return !ignore && (isdirectory(a:path) || a:path =~ '^\h\w\+:')
endfunction
function! s:import(path) abort
  if !filereadable(a:path)
    call s:print_error(printf('path "%s" is not found.', a:path))
    return []
  endif

  let [ver; items] = readfile(a:path)
  if ver != '0.2.0'
    call s:print_error('Sorry, the version of MRU file is too old.')
    return []
  endif

  let candidates = map(items, "split(v:val, '\t')[0]")
  " Load long file.
  if filereadable(a:path . '_long')
    let [ver; items] = readfile(a:path . '_long')
    let candidates += map(items, "split(v:val, '\t')[0]")
  endif

  return map(candidates, "substitute(s:substitute_path_separator(
        \ v:val), '/$', '', '')")
endfunction
function! s:print_error(msg) abort
  echohl Error | echomsg '[neomru] ' . a:msg | echohl None
endfunction
function! s:is_sudo() abort
  return $SUDO_USER != '' && $USER !=# $SUDO_USER
        \ && $HOME !=# expand('~'.$USER)
        \ && $HOME ==# expand('~'.$SUDO_USER)
endfunction
