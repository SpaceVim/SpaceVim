"=============================================================================
" FILE: matcher_project_files.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_project_files#define() abort "{{{
  return s:matcher
endfunction"}}}

let s:matcher = {
      \ 'name' : 'matcher_project_files',
      \ 'description' : 'project files matcher',
      \}

function! s:matcher.filter(candidates, context) abort "{{{
  let path = a:context.path != '' ? a:context.path : getcwd()
  let project = unite#util#path2project_directory(path) . '/'

  return filter(a:candidates, "!has_key(v:val, 'action__path')
        \ || stridx(v:val.action__path, project) == 0")
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
