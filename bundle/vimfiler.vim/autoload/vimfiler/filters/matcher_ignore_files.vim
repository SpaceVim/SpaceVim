"=============================================================================
" FILE: matcher_ignore_files.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! vimfiler#filters#matcher_ignore_files#define() abort
  return s:filter
endfunction

let s:filter = {
      \ 'name' : 'matcher_ignore_files',
      \ 'description' : 'ignore project ignore files',
      \ }

function! s:filter.filter(files, context) abort
  let path = b:vimfiler.current_dir
  let project = unite#util#path2project_directory(path) . '/'

  if project ==# vimfiler#util#substitute_path_separator($HOME . '/')
    " Ignore
    return a:files
  endif

  let [project_ignore_patterns, project_ignore_whites] =
        \ unite#filters#matcher_project_ignore_files#get_ignore_results(project)

  return unite#filters#filter_patterns(a:files,
        \ project_ignore_patterns, project_ignore_whites)
endfunction
