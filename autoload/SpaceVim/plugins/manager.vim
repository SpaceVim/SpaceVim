"=============================================================================
" manager.vim --- UI for dein in SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Load SpaceVim APIs {{{
let s:VIM_CO = SpaceVim#api#import('vim#compatible')
let s:JOB = SpaceVim#api#import('job')
let s:LIST = SpaceVim#api#import('data#list')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:TERM = SpaceVim#api#import('term')
" }}}

" init values {{{
let s:plugins = []
let s:pulling_repos = {}
let s:building_repos = {}
let s:plugin_status = {}
" key : plugin name, value : buf line number in manager buffer.
let s:plugin_nrs = {}

" plugin manager buffer
let s:buffer_id = 0
let s:buffer_lines = []
" }}}

" func: install plugin manager {{{
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
      let g:spacevim_neobundle_installed = 1
    else
      if s:need_cmd('git')
        call s:VIM_CO.system([
              \ 'git',
              \ 'clone',
              \ 'https://github.com/Shougo/neobundle.vim',
              \ expand(g:spacevim_plugin_bundle_dir) . 'neobundle.vim'
              \ ])
        let g:spacevim_neobundle_installed = 1
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
      let g:spacevim_dein_installed = 1
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
        let g:spacevim_dein_installed = 1
      endif
    endif
    exec 'set runtimepath+='. fnameescape(g:spacevim_plugin_bundle_dir)
          \ . join(['repos', 'github.com', 'Shougo',
          \ 'dein.vim'], s:Fsep)
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
    "auto install vim-plug
    if filereadable(expand('~/.cache/vim-plug/autoload/plug.vim'))
      let g:spacevim_vim_plug_installed = 1
    else
      if s:need_cmd('curl')

        call s:VIM_CO.system([
              \ 'curl',
              \ '-fLo',
              \ expand('~/.cache/vim-plug/autoload/plug.vim'),
              \ '--create-dirs',
              \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
              \ ])
        let g:spacevim_vim_plug_installed = 1
      endif
    endif
    exec 'set runtimepath+=~/.cache/vim-plug/'
  endif
endf
" }}}

" func: need_cmd {{{
function! s:need_cmd(cmd) abort
  if executable(a:cmd)
    return 1
  else
    call SpaceVim#logger#warn(' [ plug manager ] need command: ' . a:cmd)
    return 0
  endif
endfunction
" }}}

" func: get_uninstalled_plugins {{{
function! s:get_uninstalled_plugins() abort
  return filter(values(dein#get()), '!isdirectory(v:val.path)')
endfunction
" }}}

" Public API: SpaceVim#plugins#manager#reinstall {{{
function! SpaceVim#plugins#manager#reinstall(...) abort
  call dein#reinstall(a:1)
endfunction
" }}}

" Public API: SpaceVim#plugins#manager#terminal {{{
function! SpaceVim#plugins#manager#terminal()
  for id in keys(s:pulling_repos)
    call s:JOB.stop(str2nr(id))
  endfor
  for id in keys(s:building_repos)
    call s:JOB.stop(str2nr(id))
  endfor
endfunction
" }}}


" Public API: SpaceVim#plugins#manager#install {{{
" @vimlint(EVL102, 1, l:i)
function! SpaceVim#plugins#manager#install(...) abort
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
  call s:setline(1, 'Installing plugins (' . s:pct_done . '/' . s:total . ')')
  call s:setline(2, s:status_bar())
  call s:setline(3, '')
  let s:start_time = reltime()
  for i in range(g:spacevim_plugin_manager_max_processes)
    if !empty(s:plugins)
      let repo = dein#get(s:LIST.shift(s:plugins))
      if !empty(repo)
        call s:install(repo)
      endif
    endif
  endfor
endfunction
" }}}

" Public API: SpaceVim#plugins#manager#update {{{
function! SpaceVim#plugins#manager#update(...) abort
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
  let s:plugins = a:0 == 0 ? sort(keys(dein#get())) : sort(copy(a:1))
  if a:0 == 0
    call add(s:plugins, 'SpaceVim')
  endif
  let s:total = len(s:plugins)
  call s:setline(1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
  call s:setline(2, s:status_bar())
  call s:setline(3, '')
  let s:start_time = reltime()
  for i in range(g:spacevim_plugin_manager_max_processes)
    if !empty(s:plugins)
      let reponame = s:LIST.shift(s:plugins)
      let repo = dein#get(reponame)
      if !empty(repo)
        call s:pull(repo)
      elseif reponame ==# 'SpaceVim'
        let repo = {
              \ 'name' : 'SpaceVim',
              \ 'path' : fnamemodify(g:_spacevim_root_dir, ':h')
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
" }}}

" Actions:

"  pull {{{
function! s:pull(repo) abort
  let s:pct += 1
  let s:plugin_nrs[a:repo.name] = s:pct
  let argv = ['git', 'pull', '--progress']
  let jobid = s:JOB.start(argv,{
        \ 'on_stderr' : function('s:on_git_stdout'),
        \ 'cwd' : a:repo.path,
        \ 'on_exit' : function('s:on_pull_exit')
        \ })
  if jobid != 0
    let s:pulling_repos[jobid] = a:repo
    call s:msg_on_update_start(a:repo.name)
  endif
endfunction
" }}}

" install {{{
function! s:install(repo) abort
  let s:pct += 1
  let s:plugin_nrs[a:repo.name] = s:pct
  let url = 'https://github.com/' . a:repo.repo
  let argv = ['git', 'clone', '--recursive', '--progress', url, a:repo.path]
  let jobid = s:JOB.start(argv,{
        \ 'on_stderr' : function('s:on_git_stdout'),
        \ 'on_exit' : function('s:on_install_exit')
        \ })
  if jobid != 0
    let s:pulling_repos[jobid] = a:repo
    call s:msg_on_install_start(a:repo.name)
  endif
endfunction
" }}}

" build {{{
function! s:build(repo) abort
  let argv = type(a:repo.build) != 4 ? a:repo.build : s:get_build_argv(a:repo.build)
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
endfunction
" }}}

" call back functions

" on_pull_exit {{{
" here if a:data == 0, git pull succeed
function! s:on_pull_exit(id, data, event) abort
  let id = a:id
  if a:data == 0 && a:event ==# 'exit'
    call s:msg_on_update_done(s:pulling_repos[id].name)
  else
    if a:data == 1
      call s:msg_on_updated_failed(s:pulling_repos[id].name, ' The plugin dir is dirty')
    else
      call s:msg_on_updated_failed(s:pulling_repos[id].name)
    endif
  endif
  if !empty(get(s:pulling_repos[id], 'build', '')) && a:data == 0
    call s:build(s:pulling_repos[id])
  else
    let s:pct_done += 1
    call s:setline(1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
    call s:setline(2, s:status_bar())
  endif
  call remove(s:pulling_repos, string(id))
  if !empty(s:plugins)
    let name = s:LIST.shift(s:plugins)
    if name ==# 'SpaceVim'
      let repo = {
            \ 'name' : 'SpaceVim',
            \ 'path' : expand('~/.SpaceVim')
            \ }
    else
      let repo = dein#get(name)
    endif
    call s:pull(repo)
  endif
  call s:recache_rtp()
endfunction
" }}}

" on_git_stdout : {{{

" @vimlint(EVL103, 1, a:event)
function! s:on_git_stdout(id, data, event) abort
  let id = a:id
  let name = s:pulling_repos[id].name
  for str in a:data
    let status = matchstr(str,'\d\+%\s(\d\+/\d\+)')
    if !empty(status)
      call s:msg_on_install_process(name, status)
    elseif !empty(str)
      call s:setline(s:plugin_nrs[name] + 3,
            \ '* ' . name . ': ' . str)
      if has_key(s:plugin_status, name)
        let s:plugin_status[name] += [str]
      else
        call extend(s:plugin_status, {name : [str]})
      endif
    endif
  endfor
endfunction
" @vimlint(EVL103, 0, a:event)
" }}}

" on_install_exit {{{
" here if a:data == 0, git pull succeed
function! s:on_install_exit(id, data, event) abort
  let id = a:id
  if a:data == 0 && a:event ==# 'exit'
    call s:msg_on_install_done(s:pulling_repos[id].name)
  else
    call s:msg_on_install_failed(s:pulling_repos[id].name)
  endif
  if get(s:pulling_repos[id], 'rev', '') !=# ''
    call s:lock_revision(s:pulling_repos[id])
  endif
  if !empty(get(s:pulling_repos[id], 'build', '')) && a:data == 0
    call s:build(s:pulling_repos[id])
  else
    let s:pct_done += 1
    call s:setline(1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
    call s:setline(2, s:status_bar())
  endif
  call remove(s:pulling_repos, string(id))
  if !empty(s:plugins)
    call s:install(dein#get(s:LIST.shift(s:plugins)))
  endif
  call s:recache_rtp()
endfunction
" }}}

" on_build_exit {{{
function! s:on_build_exit(id, data, event) abort
  let id = a:id
  if a:data == 0 && a:event ==# 'exit'
    call s:msg_on_build_done(s:building_repos[id].name)
  else
    call s:msg_on_build_failed(s:building_repos[id].name)
  endif
  let s:pct_done += 1
  call s:setline(1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
  call s:setline(2, s:status_bar())
  call remove(s:building_repos, string(id))
  call s:recache_rtp()
endfunction
" }}}

" message func for update UI

" update plugins {{{
function! s:msg_on_update_start(name) abort
  call s:setline(s:plugin_nrs[a:name] + 3, '+ ' . a:name . ': Updating...')
endfunction

function! s:msg_on_update_done(name) abort
  call s:setline(s:plugin_nrs[a:name] + 3, '- ' . a:name . ': Updating done.')
endfunction

function! s:msg_on_updated_failed(name, ...) abort
  call s:setline(s:plugin_nrs[a:name] + 3, 'x ' . a:name . ': Updating failed. ' . get(a:000, 0, ''))
endfunction

" }}}

" install plugins {{{
function! s:msg_on_install_start(name) abort
  call s:setline(s:plugin_nrs[a:name] + 3, '+ ' . a:name . ': Installing...')
endfunction

function! s:msg_on_install_process(name, status) abort
  call s:setline(s:plugin_nrs[a:name] + 3,
        \ '* ' . a:name . ': Installing ' . a:status)
endfunction

" - foo.vim: Updating done.
function! s:msg_on_install_done(name) abort
  call s:setline(s:plugin_nrs[a:name] + 3, '- ' . a:name . ': Installing done.')
endfunction

" - foo.vim: Updating failed.
function! s:msg_on_install_failed(name, ...) abort
  call s:setline(s:plugin_nrs[a:name] + 3, 'x ' . a:name . ': Installing failed. ' . get(a:000, 0, ''))
endfunction

" }}}

" build plugins {{{

function! s:msg_on_build_start(name) abort
  call s:setline(s:plugin_nrs[a:name] + 3,
        \ '* ' . a:name . ': Building ')
endfunction
" - foo.vim: Updating failed.
function! s:msg_on_build_failed(name, ...) abort
  call s:setline(s:plugin_nrs[a:name] + 3, 'x ' . a:name . ': Building failed, ' . get(a:000, 0, ''))
endfunction

" - foo.vim: Updating done.
function! s:msg_on_build_done(name) abort
  call s:setline(s:plugin_nrs[a:name] + 3, '- ' . a:name . ': Building done.')
endfunction
" }}}

" new window {{{
function! s:new_window() abort
  if s:buffer_id != 0 && bufexists(s:buffer_id)
    " buffer exist, process has not finished!
    return 0
  elseif s:buffer_id != 0 && !bufexists(s:buffer_id)
    " buffer is hidden, process has not finished!
    call s:resume_window()
    return 1
  else
    execute get(g:, 'spacevim_window', 'vertical topleft new')
    let s:buffer_id = bufnr('%')
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nomodifiable nospell
    setf SpaceVimPlugManager
    nnoremap <silent> <buffer> q :bd<CR>
    nnoremap <silent> <buffer> gf :call <SID>open_plugin_dir()<cr>
    nnoremap <silent> <buffer> gi :call <SID>view_plugin_status()<cr>
    " process has finished or does not start.
    return 2
  endif
endfunction
" }}}

" resume window {{{
function! s:resume_window() abort
  execute get(g:, 'spacevim_window', 'vertical topleft new')
  let s:buffer_id = bufnr('%')
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell
  setf SpaceVimPlugManager
  nnoremap <silent> <buffer> q :bd<CR>
  call setline(1, s:buffer_lines)
  setlocal nomodifiable 
endfunction
" }}}

" func: open_plugin_dir {{{
function! s:open_plugin_dir() abort
  let line = line('.') - 3
  let plugin = filter(copy(s:plugin_nrs), 's:plugin_nrs[v:key] == line')
  if !empty(plugin)
    exe 'topleft split'
    enew
    exe 'resize ' . &lines * 30 / 100
    let shell = empty($SHELL) ? SpaceVim#api#import('system').isWindows ? 'cmd.exe' : 'bash' : $SHELL
    if has('nvim')
      call termopen(shell, {'cwd' : dein#get(keys(plugin)[0]).path})
    else
      call term_start(shell, {'curwin' : 1, 'term_finish' : 'close', 'cwd' : dein#get(keys(plugin)[0]).path})
    endif
  endif
endfunction
" }}}

function! s:view_plugin_status() abort
  let line = line('.') - 3
  let plugin = filter(copy(s:plugin_nrs), 's:plugin_nrs[v:key] == line')
  if !empty(plugin) && has_key(s:plugin_status, keys(plugin)[0])
    topleft split __plugin_info__
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap nocursorline nospell nonu norelativenumber
    exe 'resize ' . &lines * 30 / 100
    call setline(1, s:plugin_status[keys(plugin)[0]])
  endif
endfunction

" func setline, first line number is 1 {{{
function! s:setline(nr, line) abort
  if bufexists(s:buffer_id)
    call s:BUFFER.buf_set_lines(s:buffer_id, a:nr -1 , a:nr , 0, [a:line])
  endif
  if len(s:buffer_lines) >= a:nr
    let s:buffer_lines[a:nr - 1] = a:line
  else
    call add(s:buffer_lines, a:line)
  endif
endfunction
" }}}

" func: status_bar {{{
function! s:status_bar() abort
  let bar = '['
  let ct = 50 * s:pct / s:total
  let bar .= repeat('=', ct)
  let bar .= repeat(' ', 50 - ct)
  let bar .= ']'
  return bar
endfunction
" }}}

" func: recache_rtp {{{
function! s:recache_rtp() abort
  if empty(s:pulling_repos) && empty(s:building_repos) && !exists('s:recache_done')
    call s:setline(1, 'Updated. Elapsed time: '
          \ . split(reltimestr(reltime(s:start_time)))[0] . ' sec.')
    let s:buffer_id = 0
    if g:spacevim_plugin_manager ==# 'dein'
      call dein#recache_runtimepath()
    endif
    let s:recache_done = 1
  endif

endfunction
" }}}

" func lock_revision {{{
function! s:lock_revision(repo) abort
  let cmd = ['git', '--git-dir', a:repo.path . '/.git', 'checkout', a:repo.rev]
  call s:VIM_CO.system(cmd)
endfunction
" }}}

" func: get_build_argv {{{
function! s:get_build_argv(build) abort
  " TODO check os
  return a:build
endfunction
" }}}

