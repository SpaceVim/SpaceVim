"=============================================================================
" FILE: bookmark.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
" The version of bookmark file format.
let s:VERSION = '0.1.0'

let s:bookmarks = {}

call unite#util#set_default('g:unite_source_bookmark_directory',
      \ unite#get_data_directory() . '/bookmark')
"}}}

function! unite#sources#bookmark#define() abort "{{{
  return s:source
endfunction"}}}
function! unite#sources#bookmark#_append(filename) abort "{{{
  if !isdirectory(g:unite_source_bookmark_directory)
        \ && !unite#util#is_sudo()
    call mkdir(g:unite_source_bookmark_directory, 'p')
  endif

  if a:filename == ''
    " Append the current buffer to the bookmark list.
    let path = expand('%:p')
    let linenr = line('.')
    let pattern = '^' . escape(getline('.'), '~"\.^*$[]') . '$'
  else
    let path = fnamemodify(a:filename, ':p')
    let linenr = ''
    let pattern = ''
  endif
  let path = unite#util#substitute_path_separator(path)

  let filename = unite#util#substitute_path_separator(
        \ a:filename == '' ? expand('%') : a:filename)
  if bufexists(filename) && a:filename == ''
    " Detect vimfiler and vimshell.
    if &filetype ==# 'vimfiler'
      let path = getbufvar(bufnr(filename), 'vimfiler').current_dir
    elseif &filetype ==# 'vimshell'
      let path = getbufvar(bufnr(filename), 'vimshell').current_dir
    elseif &filetype ==# 'vinarise'
      let path = getbufvar(bufnr(filename), 'vinarise').filename
    endif
  endif

  let path = unite#util#substitute_path_separator(
        \ path =~ '^[^:]\+://' ? path :
        \ simplify(unite#util#expand(path)))

  redraw
  echo 'Path: ' . path
  let bookmark_name = input(
        \ 'Please input bookmark file name (default): ',
        \ '', 'customlist,' . s:SID_PREFIX() . 'complete_bookmark_filename')
  if bookmark_name == ''
    let bookmark_name = 'default'
  endif
  let entry_name = input('Please input bookmark entry name : ')

  let bookmark = s:load(bookmark_name)
  call insert(bookmark.files, [entry_name, path, linenr, pattern])
  call s:save(bookmark_name, bookmark)
endfunction"}}}

let s:source = {
      \ 'name' : 'bookmark',
      \ 'description' : 'candidates from bookmark list',
      \ 'syntax' : 'uniteSource__Bookmark',
      \ 'action_table' : {},
      \ 'hooks' : {},
      \}

function! s:source.gather_candidates(args, context) abort "{{{
  let bookmark_name = s:get_bookmark_name(a:args)

  if stridx(bookmark_name, '*') != -1
    let bookmarks = map(filter(
          \ unite#util#glob(
          \     g:unite_source_bookmark_directory . '/' . bookmark_name),
          \ 'filereadable(v:val)'),
          \ 'fnamemodify(v:val, ":t:r")'
          \)
  else
    let bookmarks = [bookmark_name]
  endif

  let candidates = []
  for bookmark_name in bookmarks
    let bookmark = s:load(bookmark_name)
    let candidates += map(copy(bookmark.files), "{
          \ 'word' : (v:val[0] != '' ? '[' . v:val[0] . '] ' : '') .
          \          (fnamemodify(v:val[1], ':~:.') != '' ?
          \           fnamemodify(v:val[1], ':~:.') : v:val[1]),
          \ 'kind' : (isdirectory(fnamemodify(v:val[1],':p')) ? 'directory' : 'jump_list'),
          \ 'source__bookmark_name' : bookmark_name,
          \ 'source__bookmark_orig' : v:val,
          \ 'action__path' : substitute(v:val[1], '[/\\\\]$', '', ''),
          \ 'action__line' : v:val[2],
          \ 'action__pattern' : v:val[3],
          \   }")
  endfor
  return candidates
endfunction"}}}
function! s:source.hooks.on_syntax(args, context) abort "{{{
  syntax match uniteSource__Bookmark_Name /\[.\{-}\] /
        \ contained containedin=uniteSource__Bookmark
  highlight default link uniteSource__Bookmark_Name Statement
endfunction"}}}
function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return ['_', '*', 'default'] + map(split(glob(
        \ g:unite_source_bookmark_directory . '/' . a:arglead . '*'), '\n'),
        \ "fnamemodify(v:val, ':t')")
endfunction"}}}
function! s:source.vimfiler_complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return self.complete(a:args, a:context, a:arglead, a:cmdline, a:cursorpos)
endfunction"}}}
function! s:source.vimfiler_check_filetype(args, context) abort "{{{
  return ['directory', s:get_bookmark_name(a:args)]
endfunction"}}}
function! s:source.vimfiler_gather_candidates(args, context) abort "{{{
  let exts = unite#util#is_windows() ?
        \ escape(substitute($PATHEXT . ';.LNK', ';', '\\|', 'g'), '.') : ''

  let candidates = self.gather_candidates(a:args, a:context)
  for candidate in candidates
    let candidate.vimfiler__is_directory =
          \ isdirectory(candidate.action__path)
    call unite#sources#file#create_vimfiler_dict(candidate, exts)
    let candidate.vimfiler__filename =
          \ fnamemodify(candidate.action__path, ':t')
  endfor

  return candidates
endfunction"}}}

" Actions "{{{
let s:source.action_table.delete = {
      \ 'description' : 'delete from bookmark list',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ 'is_selectable' : 1,
      \ }
function! s:source.action_table.delete.func(candidates) abort "{{{
  for candidate in a:candidates
    let bookmark = get(s:bookmarks, candidate.source__bookmark_name, [])
    call filter(bookmark.files, 'v:val !=# ' .
          \ string(candidate.source__bookmark_orig))
    call s:save(candidate.source__bookmark_name, bookmark)
  endfor
endfunction"}}}

let s:source.action_table.unite__new_candidate = {
      \ 'description' : 'add new bookmark',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:source.action_table.unite__new_candidate.func(candidates) abort "{{{
  let filename = input('Please input bookmark filename: ', '', 'file')
  if filename == ''
    redraw
    echo 'Canceled.'
    return
  endif

  call unite#sources#bookmark#_append(filename)
endfunction"}}}
"}}}

" Misc
function! s:save(filename, bookmark) abort  "{{{
  if unite#util#is_sudo()
    return
  endif

  let filename = g:unite_source_bookmark_directory . '/' . a:filename
  call writefile([s:VERSION] + map(copy(a:bookmark.files), 'join(v:val, "\t")'),
        \ filename)
  let a:bookmark.file_mtime = getftime(filename)
endfunction"}}}
function! s:load(filename) abort  "{{{
  let filename = g:unite_source_bookmark_directory . '/' . a:filename

  call s:init_bookmark(a:filename)

  let bookmark = s:bookmarks[a:filename]
  if filereadable(filename)
        \  && bookmark.file_mtime != getftime(filename)
    let [ver; bookmark.files] = readfile(filename)
    if ver !=# s:VERSION
      echohl WarningMsg
      echomsg 'Sorry, the version of bookmark file is old.  Clears the bookmark list.'
      echohl None
      let bookmark.files = []
      return
    endif
    let bookmark.files = map(bookmark.files, 'split(v:val, "\t", 1)')
    for files in bookmark.files
      let files[1] = unite#util#substitute_path_separator(
            \ unite#util#expand(files[1]))
    endfor
    let bookmark.file_mtime = getftime(filename)
  endif

  return bookmark
endfunction"}}}
function! s:init_bookmark(filename) abort  "{{{
  if !has_key(s:bookmarks, a:filename)
    " file_mtime: the last modified time of the bookmark file.
    " files: [ [ name, full_path, linenr, search pattern ], ... ]
    let s:bookmarks[a:filename] = { 'file_mtime' : 0,  'files' : [] }
  endif
endfunction"}}}
function! s:complete_bookmark_filename(arglead, cmdline, cursorpos) abort "{{{
  return sort(filter(map(split(glob(g:unite_source_bookmark_directory . '/*'), '\n'),
        \ 'fnamemodify(v:val, ":t")'), 'stridx(v:val, a:arglead) == 0'))
endfunction"}}}
function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
function! s:get_bookmark_name(args) abort "{{{
  let bookmark_name = get(a:args, 0, '')
  if bookmark_name =~ '/$'
    let bookmark_name = bookmark_name[: -2]
  endif
  if bookmark_name == ''
    let bookmark_name = 'default'
  endif

  if bookmark_name == '_'
    let bookmark_name = '*'
  endif

  return bookmark_name
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
