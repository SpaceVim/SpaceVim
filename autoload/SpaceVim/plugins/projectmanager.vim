"=============================================================================
" projectmanager.vim --- project manager for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

" project item:
" {
"   "path" : "path/to/root",
"   "name" : "name of the project, by default it is name of root directory",
"   "type" : "git maven or svn",
" }
"



let s:project_paths = {}

function! s:cache_project(prj) abort
    if !has_key(s:project_paths, a:prj.path)
        let s:project_paths[a:prj.path] = a:prj
    endif
endfunction


function! SpaceVim#plugins#projectmanager#list() abort

    

endfunction



