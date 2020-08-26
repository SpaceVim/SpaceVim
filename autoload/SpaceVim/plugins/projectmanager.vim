"=============================================================================
" projectmanager.vim --- project manager for SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" project item:
" {
"   "path" : "path/to/root",
"   "name" : "name of the project, by default it is name of root directory",
"   "type" : "git maven or svn",
" }
"

let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:FILE = SpaceVim#api#import('file')
" the name projectmanager is too long
" use rooter instead
let s:LOGGER =SpaceVim#logger#derive('rooter')

function! s:update_rooter_patterns() abort
  let s:project_rooter_patterns = filter(copy(g:spacevim_project_rooter_patterns), 'v:val !~# "^!"')
  let s:project_rooter_ignores = map(filter(copy(g:spacevim_project_rooter_patterns), 'v:val =~# "^!"'), 'v:val[1:]')
endfunction

function! s:is_ignored_dir(dir) abort
  return len(filter(copy(s:project_rooter_ignores), 'a:dir =~# v:val')) > 0
endfunction


call add(g:spacevim_project_rooter_patterns, '.SpaceVim.d/')
let s:spacevim_project_rooter_patterns = copy(g:spacevim_project_rooter_patterns)
call s:update_rooter_patterns()

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

" this function will use fuzzy find layer, now only denite and unite are
" supported.

function! SpaceVim#plugins#projectmanager#list() abort
  if SpaceVim#layers#isLoaded('unite')
    Unite menu:Projects
  elseif SpaceVim#layers#isLoaded('denite')
    Denite menu:Projects
  elseif SpaceVim#layers#isLoaded('fzf')
    FzfMenu Projects
  else
    call SpaceVim#logger#warn('fuzzy find layer is needed to find project!')
  endif
endfunction

function! SpaceVim#plugins#projectmanager#open(project) abort
  let path = s:project_paths[a:project]['path']
  tabnew
  exe 'lcd ' . path
  if g:spacevim_filemanager ==# 'vimfiler'
    Startify | VimFiler
  elseif g:spacevim_filemanager ==# 'nerdtree'
    Startify | NERDTree
  endif
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
  " @todo skip some plugin buffer
  if bufname('%') =~# '\[denite\]'
        \ || bufname('%') ==# 'denite-filter'
        \ || bufname('%') ==# '\[defx\]'
    return
  endif
  if join(g:spacevim_project_rooter_patterns, ':') !=# join(s:spacevim_project_rooter_patterns, ':')
    call s:LOGGER.info('project_rooter_patterns option has been change, clear b:rootDir')
    call setbufvar('%', 'rootDir', '')
    let s:spacevim_project_rooter_patterns = copy(g:spacevim_project_rooter_patterns)
    call s:update_rooter_patterns()
  endif
  let rootdir = getbufvar('%', 'rootDir', '')
  if empty(rootdir)
    let rootdir = s:find_root_directory()
    if empty(rootdir)
      let rootdir = s:FILE.unify_path(getcwd())
    endif
    call setbufvar('%', 'rootDir', rootdir)
  endif
  call s:change_dir(rootdir)
  call SpaceVim#plugins#projectmanager#RootchandgeCallback()
  return rootdir
endfunction

function! s:change_dir(dir) abort
  let bufname = bufname('%')
  if empty(bufname)
    let bufname = 'No Name'
  endif
  call s:LOGGER.info('buffer name: ' . bufname)
  if a:dir ==# s:FILE.unify_path(getcwd())
    call s:LOGGER.info('same as current directory, no need to change.')
  else
    call s:LOGGER.info('change to root: ' . a:dir)
    exe 'cd ' . fnameescape(fnamemodify(a:dir, ':p'))
    try
      let b:git_dir = fugitive#extract_git_dir(expand('%:p'))
    catch
    endtry
  endif
endfunction

function! SpaceVim#plugins#projectmanager#kill_project() abort
  let name = get(b:, '_spacevim_project_name', '')
  if name !=# ''
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

if g:spacevim_project_rooter_automatically
  augroup spacevim_project_rooter
    autocmd!
    autocmd VimEnter,BufEnter * call SpaceVim#plugins#projectmanager#current_root()
    autocmd BufWritePost * :call setbufvar('%', 'rootDir', '') | call SpaceVim#plugins#projectmanager#current_root()
  augroup END
endif
function! s:find_root_directory() abort
  " @question confused about expand and fnamemodify
  " ref: https://github.com/vim/vim/issues/6793
  
  " get the current path of buffer
  " If it is a empty buffer, do nothing?
  let fd = expand('%:p')
  if empty(fd)
    call s:LOGGER.info('buffer name is empty, skipped!')
    return ''
  endif
  let dirs = []
  call SpaceVim#logger#info('Start to find root for: ' . s:FILE.unify_path(fd))
  for pattern in s:project_rooter_patterns
    if stridx(pattern, '/') != -1
      let find_path = SpaceVim#util#findDirInParent(pattern, fd)
    else
      let find_path = SpaceVim#util#findFileInParent(pattern, fd)
    endif
    let path_type = getftype(find_path)
    if ( path_type ==# 'dir' || path_type ==# 'file' ) 
          \ && find_path !=# expand('~/.SpaceVim.d/')
          \ && find_path !=# expand('~/.Rprofile')
          \ && !s:is_ignored_dir(find_path)
      let find_path = s:FILE.unify_path(find_path, ':p')
      if path_type ==# 'dir'
        let dir = s:FILE.unify_path(find_path, ':h:h')
      else
        let dir = s:FILE.unify_path(find_path, ':h')
      endif
      call SpaceVim#logger#info('        (' . pattern . '):' . dir)
      call add(dirs, dir)
    endif
  endfor
  return s:sort_dirs(deepcopy(dirs))
endfunction


function! s:sort_dirs(dirs) abort
  let dir = get(sort(a:dirs, function('s:compare')), 0, '')
  let bufdir = getbufvar('%', 'rootDir', '')
  if bufdir ==# dir
    return ''
  else
    return dir
  endif
endfunction

function! s:compare(d1, d2) abort
  if g:spacevim_project_rooter_outermost
    return len(split(a:d2, '/')) - len(split(a:d1, '/'))
  else
    return len(split(a:d1, '/')) - len(split(a:d2, '/'))
  endif
endfunction

let s:FILE = SpaceVim#api#import('file')

function! SpaceVim#plugins#projectmanager#complete_project(ArgLead, CmdLine, CursorPos) abort
  call SpaceVim#commands#debug#completion_debug(a:ArgLead, a:CmdLine, a:CursorPos)
  let dir = get(g:,'spacevim_src_root', '~')
  "return globpath(dir, '*')
  let result = split(globpath(dir, '*'), "\n")
  let ps = []
  for p in result
    if isdirectory(p) && isdirectory(p . s:FILE.separator . '.git')
      call add(ps, fnamemodify(p, ':t'))
    endif
  endfor
  return join(ps, "\n")
endfunction

function! SpaceVim#plugins#projectmanager#OpenProject(p) abort
  let dir = get(g:, 'spacevim_src_root', '~') . a:p
  exe 'CtrlP '. dir
endfunction


" vim:set et nowrap sw=2 cc=80:
