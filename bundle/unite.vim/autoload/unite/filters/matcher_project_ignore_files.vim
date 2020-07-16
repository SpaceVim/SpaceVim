"=============================================================================
" FILE: matcher_project_ignore_files.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_project_ignore_files#define() abort "{{{
  return s:matcher
endfunction"}}}

let s:matcher = {
      \ 'name' : 'matcher_project_ignore_files',
      \ 'description' : 'project ignore files matcher',
      \}

let s:cache_ignore_files = {}

function! s:matcher.filter(candidates, context) abort "{{{
  let path = a:context.path != '' ? a:context.path : getcwd()
  let project = unite#util#path2project_directory(path) . '/'

  if project ==# unite#util#substitute_path_separator($HOME . '/')
    return a:candidates
  endif

  if !has_key(a:context, 'filter__project_ignore_path')
        \ || a:context.filter__project_ignore_path !=# project
        \ || a:context.is_redraw
    let a:context.filter__project_ignore_path = project
    let [a:context.filter__project_ignore_patterns,
          \ a:context.filter__project_ignore_whites] =
          \ unite#filters#matcher_project_ignore_files#get_ignore_results(project)
  endif

  if empty(a:context.filter__project_ignore_patterns)
    return a:candidates
  endif

  return unite#filters#filter_patterns(a:candidates,
        \ a:context.filter__project_ignore_patterns,
        \ a:context.filter__project_ignore_whites)
endfunction"}}}

function! unite#filters#matcher_project_ignore_files#get_ignore_results(path) abort "{{{
  let globs = []
  let whites = []
  for ignore in [
        \ '.gitignore', '.hgignore', '.agignore', '.uniteignore',
        \ ]
    for f in split(globpath(a:path, '**/' . ignore), '\n')
      let _ = s:parse_ignore_file(
            \ fnamemodify(f, ':p'), fnamemodify(f, ':h'))
      let globs += _[0]
      let whites += _[1]
    endfor
  endfor

  return [unite#filters#globs2patterns(globs),
        \ unite#filters#globs2patterns(whites)]
endfunction"}}}

function! s:parse_ignore_file(file, prefix) abort "{{{
  " Note: whitelist "!glob" and "syntax: regexp" in .hgignore features is not
  " supported.
  let patterns = []
  let whites = []
  for line in filter(readfile(a:file),
        \ "v:val !~ '^\\s*$\\|\\s*syntax:\\|\\s*#'")
    if line[0] == '!'
      call add(whites, line[1:])
    else
      call add(patterns, line)
    endif
  endfor

  let func = "a:prefix.'/' . (stridx(v:val, '/') >= 0 ? '' : '**/') . v:val"
  return [map(patterns, func), map(whites, func)]
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
