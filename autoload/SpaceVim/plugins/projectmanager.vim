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
    let desc = '[' . a:prj.name . '] ' . a:prj.path
    let cmd = "call SpaceVim#plugins#projectmanager#open('" . a:prj.path . "')"
    call add(g:unite_source_menu_menus.Projects.command_candidates, [desc,cmd])
  endif
endfunction

let g:unite_source_menu_menus =
      \ get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.Projects = {'description':
      \ 'Custom mapped keyboard shortcuts                   [SPC] p p'}
let g:unite_source_menu_menus.Projects.command_candidates =
      \ get(g:unite_source_menu_menus.Projects,'command_candidates', [])

function! SpaceVim#plugins#projectmanager#list() abort
  Unite menu:Projects
endfunction

function! SpaceVim#plugins#projectmanager#open(project) abort
  let path = s:project_paths[a:project]['path']
  tabnew
  exe 'lcd ' . path
  Startify | VimFiler
endfunction

function! SpaceVim#plugins#projectmanager#current_name() abort
  return get(b:, '_spacevim_project_name', '')
endfunction

" this func is called when vim-rooter change the dir, That means the project
" is changed, so will call call the registered function.
function! SpaceVim#plugins#projectmanager#RootchandgeCallback() abort
 let project = {
        \ 'path' : getcwd(),
        \ 'name' : fnamemodify(getcwd(), ':t')
        \ }
  call s:cache_project(project)
  let g:_spacevim_project_name = project.name
  let b:_spacevim_project_name = g:_spacevim_project_name
  for Callback in s:project_callback
    call call(Callback, [])
  endfor
endfunction

let s:project_callback = []
function! SpaceVim#plugins#projectmanager#reg_callback(func) abort
 if type(a:func) == 2
   call add(s:project_callback, a:func)
 else
   call SpaceVim#logger#warn('can not register the project callback: ' . string(a:func))
 endif
endfunction

function! SpaceVim#plugins#projectmanager#current_root() abort
  try
    Rooter
  catch
  endtry
  return getcwd()
endfunction

let s:BUFFER = SpaceVim#api#import('vim#buffer')

function! SpaceVim#plugins#projectmanager#kill_project() abort
  let name = get(b:, '_spacevim_project_name', '')
  if name != ''
    call s:BUFFER.filter_do(
          \ {
          \ 'expr' : [
          \ 'buflisted(v:val)',
          \ 'getbufvar(v:val, "_spacevim_project_name") == "' . name . '"',
          \ ],
          \ 'do' : 'bd %d'
          \ }
          \ )
  endif

endfunction

let g:spacevim_project_rooter_patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']

function! s:find_root_directory() abort
  let fd = expand('%:p')
  let dirs = []
  for pattern in g:spacevim_project_rooter_patterns
    call add(dirs, SpaceVim#util#findFileInParent(pattern, fd))
  endfor
endfunction


function! s:sort_dirs(dirs) abort
  
endfunction

function! s:change_to_root_directory() abort
  
endfunction


