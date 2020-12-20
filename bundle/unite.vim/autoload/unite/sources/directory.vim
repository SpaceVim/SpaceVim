"=============================================================================
" FILE: directory.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:is_windows = unite#util#is_windows()

function! unite#sources#directory#define() abort "{{{
  return [s:source_directory, s:source_directory_new]
endfunction"}}}

let s:source_directory = {
      \ 'name' : 'directory',
      \ 'description' : 'candidates from directory list',
      \ 'default_kind' : 'directory',
      \ 'matchers' : [ 'matcher_default', 'matcher_hide_hidden_files' ],
      \ 'alias_table' : { 'unite__new_candidate' : 'vimfiler__mkdir' },
      \ 'hooks' : {},
      \}

function! s:source_directory.change_candidates(args, context) abort "{{{
  let path = unite#sources#file#_get_path(a:args, a:context)
  let input = unite#sources#file#_get_input(path, a:context)

  return map(sort(filter(unite#sources#file#_get_files(input, a:context),
          \ "isdirectory(v:val) && v:val !~
          \ '^\\%(/\\|\\a\\+:/\\)$\\|\\%(^\\|/\\)\\.$'"), 1),
          \ "unite#sources#file#create_file_dict(v:val, '')")
endfunction"}}}
function! s:source_directory.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return map(filter(split(glob(a:arglead . '*'), '\n'),
        \ 'isdirectory(v:val)'), "v:val.'/'")
endfunction"}}}
function! s:source_directory.hooks.on_close(args, context) abort "{{{
  call unite#sources#file#_clear_cache()
endfunction "}}}

let s:source_directory_new = {
      \ 'name' : 'directory/new',
      \ 'description' : 'directory candidates from input',
      \ 'default_kind' : 'directory',
      \ 'alias_table' : { 'unite__new_candidate' : 'vimfiler__mkdir' },
      \ }

function! s:source_directory_new.change_candidates(args, context) abort "{{{
  let path = unite#sources#file#_get_path(a:args, a:context)
  let input = unite#sources#file#_get_input(path, a:context)
  let input = substitute(input, '\*', '', 'g')

  if input == '' || filereadable(input) || isdirectory(input)
    return []
  endif

  return [unite#sources#file#create_file_dict(input, a:context.input, 2)]
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
