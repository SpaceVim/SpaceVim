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

function! SpaceVim#plugins#projectmanager#current_()
    return get(b:, '_spacevim_project_name', '')
endfunction

let s:BUFFER = SpaceVim#api#import('vim#buffer')

function! SpaceVim#plugins#projectmanager#kill_project() abort
    let name = get(b:, '_spacevim_project_name', '')
    if name != ''
        call s:BUFFER.filter_do(
                    \ {
                    \ 'expr' : [
                    \ 'buflisted(v:val)',
                    \ 'index(tabpagebuflist(), v:val) == -1',
                    \ 'getbufvar(v:val, "_spacevim_project_name") == ' . name,
                    \ ],
                    \ 'do' : 'bd %d'
                    \ }
                    \ )
    endif

endfunction



