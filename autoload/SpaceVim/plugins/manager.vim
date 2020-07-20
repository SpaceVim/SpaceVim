"=============================================================================
" manager.vim --- plugin manager for SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3 license
"=============================================================================

" Load SpaceVim api
let s:VIM_CO = SpaceVim#api#import('vim#compatible')
let s:JOB = SpaceVim#api#import('job')
let s:LIST = SpaceVim#api#import('data#list')
let s:SYS = SpaceVim#api#import('system')


" init values
let s:plugins = []
let s:failed_plugins = []
let s:pulling_repos = {}
let s:building_repos = {}
let s:retry_cnt = get(g:, 'spacevim_update_retry_cnt', 3)
let s:on_reinstall = 0
" key : plugin name, value : buf line number in manager buffer.
let s:ui_buf = {}
let s:plugin_manager_buffer = 0
let s:plugin_manager_buffer_lines = []
let s:jobpid = 0

" install plugin manager
function! s:install_manager() abort
  " Fsep && Psep
  if has('win16') || has('win32') || has('win64')
    let s:Psep = ';'
    let s:Fsep = '\'
  else
    let s:Psep = ':'
    let s:Fsep = '/'
  endif
  " auto install plugin manager
  if g:spacevim_plugin_manager ==# 'neobundle'
    "auto install neobundle
    if filereadable(expand(g:spacevim_plugin_bundle_dir)
          \ . 'neobundle.vim'. s:Fsep. 'README.md')
      let g:_spacevim_neobundle_installed = 1
    else
      if s:need_cmd('git')
        call s:VIM_CO.system([
              \ 'git',
              \ 'clone',
              \ 'https://github.com/Shougo/neobundle.vim',
              \ expand(g:spacevim_plugin_bundle_dir) . 'neobundle.vim'
              \ ])
        let g:_spacevim_neobundle_installed = 1
      endif
    endif
    exec 'set runtimepath+='
          \ . fnameescape(g:spacevim_plugin_bundle_dir)
          \ . 'neobundle.vim'
  elseif g:spacevim_plugin_manager ==# 'dein'
    "auto install dein
    if filereadable(expand(g:spacevim_plugin_bundle_dir)
          \ . join(['repos', 'github.com',
          \ 'Shougo', 'dein.vim', 'README.md'],
          \ s:Fsep))
      let g:_spacevim_dein_installed = 1
    else
      if s:need_cmd('git')
        call s:VIM_CO.system([
              \ 'git',
              \ 'clone',
              \ 'https://github.com/Shougo/dein.vim',
              \ expand(g:spacevim_plugin_bundle_dir)
              \ . join(['repos', 'github.com',
              \ 'Shougo', 'dein.vim"'], s:Fsep)
              \ ])
        let g:_spacevim_dein_installed = 1
      endif
    endif
    exec 'set runtimepath+='. fnameescape(g:spacevim_plugin_bundle_dir)
          \ . join(['repos', 'github.com', 'Shougo',
          \ 'dein.vim'], s:Fsep)
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
    "auto install vim-plug
    if filereadable(expand(g:spacevim_data_dir.'/vim-plug/autoload/plug.vim'))
      let g:_spacevim_vim_plug_installed = 1
    else
      if s:need_cmd('curl')

        call s:VIM_CO.system([
              \ 'curl',
              \ '-fLo',
              \ expand(g:spacevim_data_dir.'/vim-plug/autoload/plug.vim'),
              \ '--create-dirs',
              \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
              \ ])
        let g:_spacevim_vim_plug_installed = 1
      endif
    endif
    exec 'set runtimepath+='.g:spacevim_data_dir.'/vim-plug/'
  endif
endf

function! s:need_cmd(cmd) abort
  if executable(a:cmd)
    return 1
  else
    call SpaceVim#logger#warn(' [ plug manager ] need command: ' . a:cmd)
    return 0
  endif
endfunction

if g:spacevim_plugin_manager ==# 'neobundle'
  function! s:get_uninstalled_plugins() abort
    return filter(neobundle#config#get_neobundles(), '!isdirectory(v:val.path)')
  endfunction
elseif g:spacevim_plugin_manager ==# 'dein'
  function! s:get_uninstalled_plugins() abort
    return filter(values(dein#get()), '!isdirectory(v:val.path)')
  endfunction
endif

if g:spacevim_plugin_manager ==# 'neobundle'
  function! SpaceVim#plugins#manager#reinstall(...) abort
    call neobundle#commands#reinstall(a:1)
  endfunction
elseif g:spacevim_plugin_manager ==# 'dein'
  function! SpaceVim#plugins#manager#reinstall(...) abort
    call dein#reinstall(a:1)
  endfunction
endif


" @vimlint(EVL102, 1, l:i)
function! SpaceVim#plugins#manager#install(...) abort
  if !s:JOB.vim_job && !s:JOB.nvim_job
    let &maxfuncdepth = 2000
  endif
  let plugins = a:0 == 0 ? sort(map(s:get_uninstalled_plugins(), 'v:val.name')) : sort(copy(a:1))
  if empty(plugins)
    call SpaceVim#logger#warn(' [ plug manager ] All of the plugins are already installed.', 1)
    return
  endif
  let status = s:new_window()
  if status == 0
    call SpaceVim#logger#warn(' [ plug manager ] plugin manager process is not finished.', 1)
    return
  elseif status == 1
    " resume window
    return
  endif
  let s:plugins = plugins
  let s:pct = 0
  let s:pct_done = 0
  let s:total = len(s:plugins)
  call s:set_buf_line(s:plugin_manager_buffer, 1, 'Installing plugins (' . s:pct_done . '/' . s:total . ')')
  if has('nvim')
    call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    call s:set_buf_line(s:plugin_manager_buffer, 3, '')
  elseif s:VIM_CO.has('python')
    call s:append_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    call s:append_buf_line(s:plugin_manager_buffer, 3, '')
  else
    call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    call s:set_buf_line(s:plugin_manager_buffer, 3, '')
  endif
  let s:start_time = reltime()
  for i in range(g:spacevim_plugin_manager_processes)
    if !empty(s:plugins)
      let repo = {}
      if g:spacevim_plugin_manager ==# 'dein'
        let repo = dein#get(s:LIST.shift(s:plugins))
      elseif g:spacevim_plugin_manager ==# 'neobundle'
        let repo = neobundle#get(s:LIST.shift(s:plugins))
      endif
      if !empty(repo)
        call s:install(repo)
      endif
    endif
  endfor
  if !s:JOB.vim_job && !s:JOB.nvim_job
    let &maxfuncdepth = 100
  endif
endfunction
" @vimlint(EVL102, 0, l:i)

" @vimlint(EVL102, 1, l:i)
function! SpaceVim#plugins#manager#update(...) abort
  if !s:JOB.vim_job && !s:JOB.nvim_job
    let &maxfuncdepth = 2000
  endif
  let status = s:new_window()
  if status == 0
    echohl WarningMsg
    echom '[SpaceVim] [plugin manager] plugin updating is not finished.'
    echohl None
    return
  elseif status == 1
    return
  endif
  redraw!
  let s:pct = 0
  let s:pct_done = 0
  if exists('s:recache_done')
    unlet s:recache_done
  endif
  if g:spacevim_plugin_manager ==# 'dein'
    let s:plugins = a:0 == 0 ? sort(keys(dein#get())) : sort(copy(a:1))
  elseif g:spacevim_plugin_manager ==# 'neobundle'
    let s:plugins = a:0 == 0 ? sort(map(neobundle#config#get_neobundles(), 'v:val.name')) : sort(copy(a:1))
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
  endif
  " make dein-ui only update SpaceVim for SpaceVim users
  if a:0 == 0 && exists('g:spacevim_version')
    call add(s:plugins, 'SpaceVim')
  endif
  let s:total = len(s:plugins)
  call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
  if has('nvim')
    call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    call s:set_buf_line(s:plugin_manager_buffer, 3, '')
  elseif s:VIM_CO.has('python')
    call s:append_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    call s:append_buf_line(s:plugin_manager_buffer, 3, '')
  else
    call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    call s:set_buf_line(s:plugin_manager_buffer, 3, '')
  endif
  let s:start_time = reltime()
  for i in range(g:spacevim_plugin_manager_processes)
    if !empty(s:plugins)
      let repo = {}
      let reponame = ''
      if g:spacevim_plugin_manager ==# 'dein'
        let reponame = s:LIST.shift(s:plugins)
        let repo = dein#get(reponame)
      elseif g:spacevim_plugin_manager ==# 'neobundle'
        let reponame = s:LIST.shift(s:plugins)
        let repo = neobundle#get(reponame)
      endif
      if !empty(repo) && !get(repo, 'local', 0) && isdirectory(repo.path . '/.git') && !filereadable(repo.path . '/.git/shallow.lock')
        call s:pull(repo)
      elseif !empty(repo) && !get(repo, 'local', 0) && isdirectory(repo.path . '/.git') && filereadable(repo.path . '/.git/shallow.lock')
        call delete(repo.path, 'rf')
        call s:install(repo)
      elseif !empty(repo) && !isdirectory(repo.path . '/.git') && get(repo, 'local', 0)
        call s:pull(repo)
      elseif reponame ==# 'SpaceVim'
        let repo = {
              \ 'name' : 'SpaceVim',
              \ 'path' : g:_spacevim_root_dir
              \ }
        call s:pull(repo)
      endif
    endif
  endfor
  if !s:JOB.vim_job && !s:JOB.nvim_job
    let &maxfuncdepth = 100
  endif
endfunction
" @vimlint(EVL102, 0, l:i)

function! s:status_bar() abort
  let bar = '['
  let ct = 50 * s:pct / s:total
  let bar .= repeat('=', ct)
  let bar .= repeat(' ', 50 - ct)
  let bar .= ']'
  return bar
endfunction

" here if a:data == 0, git pull succeed
function! s:on_pull_exit(id, data, event) abort
  if a:id == -1
    let id = s:jobpid
  else
    let id = a:id
  endif
  if !has_key(s:pulling_repos, id)
    return
  endif
  if a:data == 0 && a:event ==# 'exit'
    call s:msg_on_updated_done(s:pulling_repos[id].name)
  else
    call s:add_to_failed_list(s:pulling_repos[id].name)
    if a:data == 1
      call s:msg_on_updated_failed(s:pulling_repos[id].name, ' The plugin dir is dirty')
    else
      call s:msg_on_updated_failed(s:pulling_repos[id].name)
    endif
  endif
  if a:id == -1
    redraw!
  endif
  if !empty(get(s:pulling_repos[id], 'build', '')) && a:data == 0
    call s:build(s:pulling_repos[id])
  else
    let s:pct_done += 1
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
    call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
  endif
  call remove(s:pulling_repos, string(id))
  if !empty(s:plugins)
    let name = s:LIST.shift(s:plugins)
    let repo = {}
    if name ==# 'SpaceVim'
      let repo = {
            \ 'name' : 'SpaceVim',
            \ 'path' : expand('~/.SpaceVim')
            \ }
    elseif g:spacevim_plugin_manager ==# 'dein'
      let repo = dein#get(name)
    elseif g:spacevim_plugin_manager ==# 'neobundle'
      let repo = neobundle#get(name)
    endif
    call s:pull(repo)
  endif
  call s:recache_rtp(a:id)
endfunction


function! s:recache_rtp(id) abort
  if empty(s:pulling_repos) && empty(s:building_repos) && !exists('s:recache_done')
    " TODO add elapsed time info.
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updated. Elapsed time: '
          \ . split(reltimestr(reltime(s:start_time)))[0] . ' sec.')
    let s:on_reinstall = 0
    if len(s:failed_plugins) > 0 && s:retry_cnt > 0
      call s:reinstall_update_failed()
    elseif len(s:failed_plugins) > 0 && s:retry_cnt <= 0
      " Reset retry cnt
      let s:failed_plugins = []
      let s:retry_cnt = get(g:, 'spacevim_update_retry_cnt')
      let s:plugin_manager_buffer = 0
      if g:spacevim_plugin_manager ==# 'dein'
        call dein#recache_runtimepath()
      endif
    else
      let s:plugin_manager_buffer = 0
      if g:spacevim_plugin_manager ==# 'dein'
        call dein#recache_runtimepath()
      endif
    endif
    if a:id == -1
      let s:recache_done = 1
    endif
  endif

endfunction

" @vimlint(EVL103, 1, a:event)
function! s:on_install_stdout(id, data, event) abort
  if a:id == -1
    let id = s:jobpid
  else
    let id = a:id
  endif
  for str in a:data
    let status = matchstr(str,'\d\+%\s(\d\+/\d\+)')
    if !empty(status)
      call s:msg_on_install_process(s:pulling_repos[id].name, status)
    endif
  endfor
endfunction
" @vimlint(EVL103, 0, a:event)

function! s:on_build_exit(id, data, event) abort
  if a:id == -1
    let id = s:jobpid
  else
    let id = a:id
  endif
  if a:data == 0 && a:event ==# 'exit'
    call s:msg_on_build_done(s:building_repos[id].name)
  else
    call s:add_to_failed_list(s:building_repos[id].name)
    call s:msg_on_build_failed(s:building_repos[id].name)
  endif
  let s:pct_done += 1
  call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
  call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
  call remove(s:building_repos, string(id))
  call s:recache_rtp(a:id)
endfunction

" here if a:data == 0, git pull succeed
function! s:on_install_exit(id, data, event) abort
  if a:id == -1
    let id = s:jobpid
  else
    let id = a:id
  endif
  if !has_key(s:pulling_repos, id)
    return
  endif
  if a:data == 0 && a:event ==# 'exit'
    call s:msg_on_install_done(s:pulling_repos[id].name)
  else
    call s:add_to_failed_list(s:pulling_repos[id].name)
    call s:msg_on_install_failed(s:pulling_repos[id].name)
  endif
  if !empty(get(s:pulling_repos[id], 'build', '')) && a:data == 0
    call s:build(s:pulling_repos[id])
  else
    let s:pct_done += 1
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Installing plugins (' . s:pct_done . '/' . s:total . ')')
    call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
  endif
  call remove(s:pulling_repos, string(id))
  if !empty(s:plugins)
    if g:spacevim_plugin_manager ==# 'dein'
      call s:install(dein#get(s:LIST.shift(s:plugins)))
    elseif g:spacevim_plugin_manager ==# 'neobundle'
      call s:install(neobundle#get(s:LIST.shift(s:plugins)))
    endif
  endif
  call s:recache_rtp(a:id)
endfunction

function! s:pull(repo) abort
  let s:pct += 1
  let s:ui_buf[a:repo.name] = s:pct
  if !get(a:repo, 'local', 0)
    let argv = ['git', 'pull', '--progress']
    if s:JOB.vim_job || s:JOB.nvim_job
      let jobid = s:JOB.start(argv,{
            \ 'on_stderr' : function('s:on_install_stdout'),
            \ 'cwd' : a:repo.path,
            \ 'on_exit' : function('s:on_pull_exit')
            \ })
      if jobid != 0
        let s:pulling_repos[jobid] = a:repo
        call s:msg_on_start(a:repo.name)
      endif
    else
      let s:jobpid += 1
      let s:pulling_repos[s:jobpid] = a:repo
      call s:msg_on_start(a:repo.name)
      redraw!
      call s:JOB.start(argv,{
            \ 'on_stderr' : function('s:on_install_stdout'),
            \ 'cwd' : a:repo.path,
            \ 'on_exit' : function('s:on_pull_exit')
            \ })

    endif
  else
    call s:msg_on_local(a:repo.name)
    let s:pct_done += 1
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
    call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    if !empty(s:plugins)
      let name = s:LIST.shift(s:plugins)
      let repo = {}
      if name ==# 'SpaceVim'
        let repo = {
              \ 'name' : 'SpaceVim',
              \ 'path' : expand('~/.SpaceVim')
              \ }
      elseif g:spacevim_plugin_manager ==# 'dein'
        let repo = dein#get(name)
      elseif g:spacevim_plugin_manager ==# 'neobundle'
        let repo = neobundle#get(name)
      endif
      call s:pull(repo)
    endif
  endif
endfunction

function! s:get_uri(repo) abort
  if a:repo.repo =~# '^[^/]\+/[^/]\+$'
    let url = 'https://github.com/' . (has_key(a:repo, 'repo') ? a:repo.repo : a:repo.orig_path)
    return url
  else
    return a:repo.repo
  endif
endfunction

function! s:install(repo) abort
  let s:pct += 1
  let s:ui_buf[a:repo.name] = s:pct
  if !get(a:repo, 'local', 0)
    let url = s:get_uri(a:repo)
    let argv = ['git', 'clone', '--depth=1', '--recursive', '--progress', url, a:repo.path]
    if get(a:repo, 'rev', '') !=# ''
      let argv = argv + ['-b', a:repo.rev]
    endif
    if s:JOB.vim_job || s:JOB.nvim_job
      let jobid = s:JOB.start(argv,{
            \ 'on_stderr' : function('s:on_install_stdout'),
            \ 'on_exit' : function('s:on_install_exit')
            \ })
      if jobid != 0
        let s:pulling_repos[jobid] = a:repo
        call s:msg_on_install_start(a:repo.name)
      endif
    else
      let s:jobpid += 1
      let s:pulling_repos[s:jobpid] = a:repo
      call s:msg_on_start(a:repo.name)
      redraw!
      call s:JOB.start(argv,{
            \ 'on_stderr' : function('s:on_install_stdout'),
            \ 'on_exit' : function('s:on_install_exit')
            \ })

    endif
  else
    call s:msg_on_local(a:repo.name)
  endif
endfunction

function! s:build(repo) abort
  let argv = type(a:repo.build) != 4 ? a:repo.build : s:get_build_argv(a:repo.build)
  if s:JOB.vim_job || s:JOB.nvim_job
    let jobid = s:JOB.start(argv,{
          \ 'on_exit' : function('s:on_build_exit'),
          \ 'cwd' : a:repo.path,
          \ })
    if jobid > 0
      let s:building_repos[jobid . ''] = a:repo
      call s:msg_on_build_start(a:repo.name)
    elseif jobid == 0
      call s:msg_on_build_failed(a:repo.name)
    elseif jobid == -1
      if type(argv) == type([])
        call s:msg_on_build_failed(a:repo.name, argv[0] . ' is not executable')
      else
        call s:msg_on_build_failed(a:repo.name)
      endif
    endif
  else
    let s:building_repos[s:jobpid] = a:repo
    call s:msg_on_build_start(a:repo.name)
    redraw!
    call s:JOB.start(argv,{
          \ 'on_exit' : function('s:on_build_exit'),
          \ 'cwd' : a:repo.path,
          \ })

  endif
endfunction

function! s:msg_on_build_start(name) abort
  call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3,
        \ '* ' . a:name . ': Building ')
endfunction

function! s:get_build_argv(build) abort
  return a:build[s:SYS.name]
endfunction
" + foo.vim: Updating...
if has('nvim')
  function! s:msg_on_start(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Updating...')
  endfunction
  function! s:msg_on_local(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Skip local')
  endfunction
  function! s:msg_on_install_start(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Installing...')
  endfunction
elseif s:VIM_CO.has('python')
  function! s:msg_on_start(name) abort
    call s:append_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Updating...')
  endfunction
  function! s:msg_on_local(name) abort
    call s:append_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Skip local')
  endfunction
  function! s:msg_on_install_start(name) abort
    call s:append_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Installing...')
  endfunction
else
  function! s:msg_on_start(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Updating...')
  endfunction
  function! s:msg_on_local(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Skip local')
  endfunction
  function! s:msg_on_install_start(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Installing...')
  endfunction
endif

" - foo.vim: Updating done.
function! s:msg_on_updated_done(name) abort
  call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Updating done.')
endfunction

" - foo.vim: Updating failed.
function! s:msg_on_updated_failed(name, ...) abort
  if a:0 == 1
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, 'x ' . a:name . ': Updating failed, ' . a:1)
  else
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, 'x ' . a:name . ': Updating failed.')
  endif
endfunction

function! s:msg_on_install_process(name, status) abort
  call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3,
        \ '* ' . a:name . ': Installing ' . a:status)
endfunction

" - foo.vim: Updating done.
function! s:msg_on_install_done(name) abort
  call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Installing done.')
endfunction

" - foo.vim: Updating failed.
function! s:msg_on_install_failed(name, ...) abort
  if a:0 == 1
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, 'x ' . a:name . ': Installing failed. ' . a:1)
  else
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, 'x ' . a:name . ': Installing failed.')
  endif
endfunction

" - foo.vim: Updating done.
function! s:msg_on_build_done(name) abort
  call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Building done.')
endfunction

" - foo.vim: Updating failed.
function! s:msg_on_build_failed(name, ...) abort
  if a:0 == 1
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, 'x ' . a:name . ': Building failed, ' . a:1)
  else
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, 'x ' . a:name . ': Building failed.')
  endif
endfunction

" - foo.vim: Updating failed.
function! s:add_to_failed_list(name) abort
  if index(s:failed_plugins, a:name) < 0
    call add(s:failed_plugins, a:name)
  endif
endfunction

function! s:reinstall_update_failed() abort
  if len(s:failed_plugins) > 0 && s:retry_cnt > 0
    " close plugin manager
    let s:on_reinstall = 1
    call SpaceVim#logger#warn(' [ plug manager ] Reinstalling Failed Plugins. Remaining Retries: '.s:retry_cnt)
    call SpaceVim#plugins#manager#update(s:failed_plugins)
    let s:failed_plugins = []
    let s:retry_cnt -= 1
  endif
endfunction

function! s:new_window() abort
  if s:plugin_manager_buffer != 0 && bufexists(s:plugin_manager_buffer) && s:on_reinstall == 0
    " buffer exist, process has not finished!
    return 0
  elseif s:plugin_manager_buffer != 0 && !bufexists(s:plugin_manager_buffer) && s:on_reinstall == 0
    " buffer is hidden, process has not finished!
    call s:resume_window()
    return 1
  elseif s:plugin_manager_buffer != 0 && bufexists(s:plugin_manager_buffer) && s:on_reinstall == 1
    call setbufvar(s:plugin_manager_buffer, '&ma', 1)
    let current_nr = winnr()
    let winnr = bufwinnr(s:plugin_manager_buffer)
    if winnr > -1
      exe winnr . 'wincmd w'
      silent normal! gg"_dG
      redraw!
    endif
    exe current_nr . 'wincmd w'
    return 3
  else
    execute get(g:, 'spacevim_window', 'vertical topleft new')
    let s:plugin_manager_buffer = bufnr('%')
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nomodifiable nospell
    setf SpaceVimPlugManager
    nnoremap <silent> <buffer> q :bd<CR>
    nnoremap <silent> <buffer> gf :call <SID>open_plugin_dir()<cr>
    nnoremap <silent> <buffer> gr :call <SID>fix_install()<cr>
    " process has finished or does not start.
    return 2
  endif
endfunction

function! s:open_plugin_dir() abort
  let plugin = get(split(getline('.')), 1, ':')[:-2]
  if !empty(plugin)
    let shell = empty($SHELL) ? SpaceVim#api#import('system').isWindows ? 'cmd.exe' : 'bash' : $SHELL
    let path = ''
    if g:spacevim_plugin_manager ==# 'dein'
      let path = dein#get(plugin).path
    elseif g:spacevim_plugin_manager ==# 'neobundle'
      let path = neobundle#get(plugin).path
    elseif g:spacevim_plugin_manager ==# 'vim-plug'
    endif
    if isdirectory(path)
      topleft new
      exe 'resize ' . &lines * 30 / 100
      if has('nvim') && exists('*termopen')
        call termopen(shell, {'cwd' : path})
      elseif exists('*term_start')
        call term_start(shell, {'curwin' : 1, 'term_finish' : 'close', 'cwd' : path})
      elseif exists(':VimShell')
        exe 'VimShell ' .  path
      else
        close
        echohl WarningMsg
        echo 'Do not support terminal!'
        echohl None
      endif
    else
      echohl WarningMsg
      echo 'Plugin(' . keys(plugin)[0] . ') has not been installed!'
      echohl None
    endif
  endif
endfunction

function! s:fix_install() abort
  let plugin = get(split(getline('.')), 1, ':')[:-2]
  if !empty(plugin)
    if g:spacevim_plugin_manager ==# 'dein'
      let repo = dein#get(plugin)
    elseif g:spacevim_plugin_manager ==# 'neobundle'
      let repo = neobundle#get(plugin)
    else
      let repo = {}
    endif
    if has_key(repo, 'path') && isdirectory(repo.path)
      if index(s:failed_plugins, plugin) > 0
        call remove(s:failed_plugins, plugin)
      endif
      let argv = 'git checkout . && git pull --progress'
      let jobid = s:JOB.start(argv,{
            \ 'on_stderr' : function('s:on_install_stdout'),
            \ 'cwd' : repo.path,
            \ 'on_exit' : function('s:on_pull_exit')
            \ })
      if jobid != 0
        let s:pulling_repos[jobid] = repo
        call s:msg_on_start(repo.name)
      endif
    else
      echohl WarningMsg
      echo 'Plugin(' . plugin . ') has not been installed!'
      echohl None
    endif
  endif
endfunction

function! s:resume_window() abort
  execute get(g:, 'spacevim_window', 'vertical topleft new')
  let s:plugin_manager_buffer = bufnr('%')
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell
  setf SpaceVimPlugManager
  nnoremap <silent> <buffer> q :bd<CR>
  call setline(1, s:plugin_manager_buffer_lines)
  setlocal nomodifiable 
endfunction

" change modifiable before setline
if has('nvim') && exists('*nvim_buf_set_lines')
  function! s:set_buf_line(bufnr, nr, line) abort
    call setbufvar(s:plugin_manager_buffer,'&ma', 1)
    if bufexists(s:plugin_manager_buffer)
      call nvim_buf_set_lines(a:bufnr, a:nr - 1, a:nr, 0, [a:line])
    endif
    if len(s:plugin_manager_buffer_lines) >= a:nr
      let s:plugin_manager_buffer_lines[a:nr - 1] = a:line
    else
      call add(s:plugin_manager_buffer_lines, a:line)
    endif
    call setbufvar(s:plugin_manager_buffer,'&ma', 0)
  endfunction
elseif s:VIM_CO.has('python')
  py import vim
  py import string
  " @vimlint(EVL103, 1, a:bufnr)
  " @vimlint(EVL103, 1, a:nr)
  " @vimlint(EVL103, 1, a:line)
  function! s:set_buf_line(bufnr, nr, line) abort
    call setbufvar(s:plugin_manager_buffer,'&ma', 1)
    if bufexists(s:plugin_manager_buffer)
      py bufnr = string.atoi(vim.eval("a:bufnr"))
      py linr = string.atoi(vim.eval("a:nr")) - 1
      py str = vim.eval("a:line")
      py vim.buffers[bufnr][linr] = str
    endif
    if len(s:plugin_manager_buffer_lines) >= a:nr
      let s:plugin_manager_buffer_lines[a:nr - 1] = a:line
    else
      call add(s:plugin_manager_buffer_lines, a:line)
    endif
    call setbufvar(s:plugin_manager_buffer,'&ma', 0)
  endfunction

  function! s:append_buf_line(bufnr, nr, line) abort
    call setbufvar(s:plugin_manager_buffer,'&ma', 1)
    if bufexists(s:plugin_manager_buffer)
      py bufnr = string.atoi(vim.eval("a:bufnr"))
      py linr = string.atoi(vim.eval("a:nr")) - 1
      py str = vim.eval("a:line")
      py vim.buffers[bufnr].append(str)
    endif
    call add(s:plugin_manager_buffer_lines, a:line)
    call setbufvar(s:plugin_manager_buffer,'&ma', 0)
  endfunction
  " @vimlint(EVL103, 0, a:bufnr)
  " @vimlint(EVL103, 0, a:nr)
  " @vimlint(EVL103, 0, a:line)
else
  function! s:focus_main_win() abort
    let winnr = bufwinnr(s:plugin_manager_buffer)
    if winnr > -1
      exe winnr . 'wincmd w'
    endif
    return winnr
  endfunction
  function! s:set_buf_line(bufnr, nr, line) abort
    call setbufvar(a:bufnr,'&ma', 1)
    if bufexists(s:plugin_manager_buffer)
      if s:focus_main_win() >= 0
        call setline(a:nr, a:line)
      endif
    endif
    if len(s:plugin_manager_buffer_lines) >= a:nr
      let s:plugin_manager_buffer_lines[a:nr - 1] = a:line
    else
      call add(s:plugin_manager_buffer_lines, a:line)
    endif
    call setbufvar(a:bufnr,'&ma', 0)
  endfunction
endif

" Public API: SpaceVim#plugins#manager#terminal {{{
function! SpaceVim#plugins#manager#terminal() abort
  for id in keys(s:pulling_repos)
    call s:JOB.stop(str2nr(id))
  endfor
  for id in keys(s:building_repos)
    call s:JOB.stop(str2nr(id))
  endfor
endfunction
" }}}
