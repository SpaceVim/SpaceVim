"=============================================================================
" projectmanager.vim --- project manager for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================



if $SPACEVIM_LUA && has('nvim-0.5.0')
  function! SpaceVim#plugins#projectmanager#complete_project(ArgLead, CmdLine, CursorPos) abort
    return luaeval('require("spacevim.plugin.projectmanager").complete('
          \ .'require("spacevim").eval("a:ArgLead"),'
          \ .'require("spacevim").eval("a:CmdLine"),'
          \ .'require("spacevim").eval("a:CursorPos"))')
  endfunction
  function! SpaceVim#plugins#projectmanager#OpenProject(p) abort
    lua require("spacevim.plugin.projectmanager").OpenProject(
          \ require("spacevim").eval("a:p")
          \ )
  endfunction
  function! SpaceVim#plugins#projectmanager#list() abort
    lua require("spacevim.plugin.projectmanager").list()
  endfunction
  function! SpaceVim#plugins#projectmanager#open(project) abort
    lua require("spacevim.plugin.projectmanager").open(
          \ require("spacevim").eval("a:project")
          \ )
  endfunction
  function! SpaceVim#plugins#projectmanager#current_name() abort
    return luaeval('require("spacevim.plugin.projectmanager").current_name()')
  endfunction
  function! SpaceVim#plugins#projectmanager#RootchandgeCallback() abort
    lua require("spacevim.plugin.projectmanager").RootchandgeCallback()
  endfunction
  function! SpaceVim#plugins#projectmanager#reg_callback(func) abort
    lua require("spacevim.plugin.projectmanager").reg_callback(
          \ require("spacevim").eval("string(a:func)")
          \ )
  endfunction
  function! SpaceVim#plugins#projectmanager#current_root() abort
    return luaeval('require("spacevim.plugin.projectmanager").current_root()')
  endfunction
  function! SpaceVim#plugins#projectmanager#kill_project() abort
    lua require("spacevim.plugin.projectmanager").kill_project()
  endfunction
else


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
  let s:TIME = SpaceVim#api#import('time')
  let s:JSON = SpaceVim#api#import('data#json')
  let s:LIST = SpaceVim#api#import('data#list')
  let s:VIM = SpaceVim#api#import('vim')

  " use cd or lcd or tcd
  "
  if exists(':tcd')
    let s:cd = 'tcd'
  elseif exists(':lcd')
    let s:cd = 'lcd'
  else
    let s:cd = 'cd'
  endif

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
  let s:project_cache_path = s:FILE.unify_path(g:spacevim_data_dir, ':p') . 'SpaceVim/projects.json'

  function! s:cache() abort
    call writefile([s:JSON.json_encode(s:project_paths)], s:FILE.unify_path(s:project_cache_path, ':p'))
  endfunction

  function! s:load_cache() abort
    if filereadable(s:project_cache_path)
      call s:LOGGER.info('Load projects cache from: ' . s:project_cache_path)
      let cache_context = join(readfile(s:project_cache_path, ''), '')
      if !empty(cache_context)
        let cache_object = s:JSON.json_decode(cache_context)
        if s:VIM.is_dict(cache_object)
          let s:project_paths = filter(cache_object, '!empty(v:key)')
        endif
      endif
    else
      call s:LOGGER.info('projects cache file does not exists!')
    endif
  endfunction

  if g:spacevim_enable_projects_cache
    call s:load_cache()
  endif

  let g:unite_source_menu_menus =
        \ get(g:,'unite_source_menu_menus',{})
  let g:unite_source_menu_menus.Projects = {'description':
        \ 'Custom mapped keyboard shortcuts                   [SPC] p p'}
  let g:unite_source_menu_menus.Projects.command_candidates =
        \ get(g:unite_source_menu_menus.Projects,'command_candidates', [])

  function! s:cache_project(prj) abort
    let s:project_paths[a:prj.path] = a:prj
    let g:unite_source_menu_menus.Projects.command_candidates = []
    for key in s:sort_by_opened_time()
      let desc = '[' . s:project_paths[key].name . '] ' . s:project_paths[key].path . ' <' . strftime('%Y-%m-%d %T', s:project_paths[key].opened_time) . '>'
      let cmd = "call SpaceVim#plugins#projectmanager#open('" . s:project_paths[key].path . "')"
      call add(g:unite_source_menu_menus.Projects.command_candidates, [desc,cmd])
    endfor
    if g:spacevim_enable_projects_cache
      call s:cache()
    endif
  endfunction

  " sort projects based on opened_time, and remove extra projects based on
  " projects_cache_num
  function! s:sort_by_opened_time() abort
    let paths = keys(s:project_paths)
    let paths = sort(paths, function('s:compare_time'))
    if g:spacevim_projects_cache_num > 0 && s:LIST.has_index(paths, g:spacevim_projects_cache_num)
      for path in paths[g:spacevim_projects_cache_num :]
        call remove(s:project_paths, path)
      endfor
      let paths = paths[:g:spacevim_projects_cache_num - 1]
    endif
    return paths
  endfunction

  function! s:compare_time(d1, d2) abort
    let proj1 = get(s:project_paths, a:d1, {})
    let proj1time = get(proj1, 'opened_time', 0)
    let proj2 = get(s:project_paths, a:d2, {})
    let proj2time = get(proj2, 'opened_time', 0)
    return proj2time - proj1time
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
      exe s:cd fnameescape(fnamemodify(a:dir, ':p'))
      try
        let b:git_dir = fugitive#extract_git_dir(expand('%:p'))
      catch
      endtry
    endif
  endfunction


  if g:spacevim_project_auto_root
    augroup spacevim_project_rooter
      autocmd!
      autocmd VimEnter,BufEnter * call SpaceVim#plugins#projectmanager#current_root()
      autocmd BufWritePost * :call setbufvar('%', 'rootDir', '') | call SpaceVim#plugins#projectmanager#current_root()
    augroup END
  endif
  function! s:find_root_directory() abort
    " @question confused about expand and fnamemodify
    " ref: https://github.com/vim/vim/issues/6793


    " get the current path of buffer or working dir

    let fd = expand('%:p')
    if empty(fd)
      let fd = getcwd()
    endif

    let dirs = []
    call s:LOGGER.info('Start to find root for: ' . s:FILE.unify_path(fd))
    for pattern in s:project_rooter_patterns
      if stridx(pattern, '/') != -1
        if g:spacevim_project_rooter_outermost
          let find_path = s:FILE.finddir(pattern, fd, -1)
        else
          let find_path = s:FILE.finddir(pattern, fd)
        endif
      else
        if g:spacevim_project_rooter_outermost
          let find_path = s:FILE.findfile(pattern, fd, -1)
        else
          let find_path = s:FILE.findfile(pattern, fd)
        endif
      endif
      let path_type = getftype(find_path)
      if ( path_type ==# 'dir' || path_type ==# 'file' ) 
            \ && !s:is_ignored_dir(find_path)
        let find_path = s:FILE.unify_path(find_path, ':p')
        if path_type ==# 'dir'
          let dir = s:FILE.unify_path(find_path, ':h:h')
        else
          let dir = s:FILE.unify_path(find_path, ':h')
        endif
        if dir !=# s:FILE.unify_path(expand('$HOME'))
          call s:LOGGER.info('        (' . pattern . '):' . dir)
          call add(dirs, dir)
        endif
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
    if !g:spacevim_project_rooter_outermost
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
  " this function will use fuzzy find layer, now only denite and unite are
  " supported.

  function! SpaceVim#plugins#projectmanager#list() abort
    if SpaceVim#layers#isLoaded('unite')
      Unite menu:Projects
    elseif SpaceVim#layers#isLoaded('denite')
      Denite menu:Projects
    elseif SpaceVim#layers#isLoaded('fzf')
      FzfMenu Projects
    elseif SpaceVim#layers#isLoaded('leaderf')
      call SpaceVim#layers#leaderf#run_menu('Projects')
    else
      call SpaceVim#logger#warn('fuzzy find layer is needed to find project!')
    endif
  endfunction

  function! SpaceVim#plugins#projectmanager#open(project) abort
    let path = s:project_paths[a:project]['path']
    tabnew
    exe s:cd path
    if g:spacevim_filemanager ==# 'vimfiler'
      Startify | VimFiler
    elseif g:spacevim_filemanager ==# 'nerdtree'
      Startify | NERDTree
    elseif g:spacevim_filemanager ==# 'defx'
      Startify | Defx
    endif
  endfunction

  function! SpaceVim#plugins#projectmanager#current_name() abort
    return get(b:, '_spacevim_project_name', '')
  endfunction

  " This function is called when projectmanager change the directory.
  "
  " What should be cached?
  " only the directory and project name.
  function! SpaceVim#plugins#projectmanager#RootchandgeCallback() abort
    let project = {
          \ 'path' : getcwd(),
          \ 'name' : fnamemodify(getcwd(), ':t'),
          \ 'opened_time' : localtime()
          \ }
    if empty(project.path)
      return
    endif
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
endif


" vim:set et nowrap sw=2 cc=80:
