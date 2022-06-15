" Variables
let s:global_context = {}
let s:log = []
let s:updates_log = []
let s:progress = ''
let s:failed_plugins = []
let s:progress_winid = -1

" Global options definition.
let g:dein#install_max_processes =
      \ get(g:, 'dein#install_max_processes',
      \     dein#util#_is_windows() ? 16 : 8)
let g:dein#install_progress_type =
      \ get(g:, 'dein#install_progress_type', 'echo')
let g:dein#install_message_type =
      \ get(g:, 'dein#install_message_type', 'echo')
let g:dein#install_process_timeout =
      \ get(g:, 'dein#install_process_timeout', 120)
let g:dein#install_log_filename =
      \ get(g:, 'dein#install_log_filename', '')
let g:dein#install_github_api_token =
      \ get(g:, 'dein#install_github_api_token', '')
let g:dein#install_curl_command =
      \ get(g:, 'dein#install_curl_command', 'curl')
let g:dein#install_check_diff =
      \ get(g:, 'dein#install_check_diff', v:false)
let g:dein#install_check_remote_threshold =
      \ get(g:, 'dein#install_check_remote_threshold', 0)
let g:dein#install_copy_vim =
      \ get(g:, 'dein#install_copy_vim',
      \     has('nvim') && !dein#util#_is_windows())

function! s:get_job() abort
  if !exists('s:Job')
    let s:Job = vital#dein#import('System.Job')
  endif
  return s:Job
endfunction

function! dein#install#_update(plugins, update_type, async) abort
  if g:dein#_is_sudo
    call s:error('update/install is disabled in sudo session.')
    return
  endif

  let plugins = dein#util#_get_plugins(a:plugins)

  if a:update_type ==# 'install'
    let plugins = filter(plugins, { _, val -> !isdirectory(val.path) })
  endif

  if a:async && !empty(s:global_context) &&
        \ confirm('The installation has not finished. Cancel now?',
        \         "yes\nNo", 2) != 1
    return
  endif

  " Set context.
  let context = s:init_context(plugins, a:update_type, a:async)

  call s:init_variables(context)

  if empty(plugins)
    call s:notify('Target plugins are not found.')
    call s:notify('You may have used the wrong plugin name,'.
          \ ' or all of the plugins are already installed.')
    let s:global_context = {}
    return
  endif

  call s:start()

  if !a:async || has('vim_starting')
    return s:update_loop(context)
  endif

  augroup dein-install
    autocmd!
  augroup END

  if exists('s:timer')
    call timer_stop(s:timer)
    unlet s:timer
  endif

  let s:timer = timer_start(50, {-> dein#install#_polling()}, {'repeat': -1})
endfunction
function! s:update_loop(context) abort
  let errored = 0
  try
    if has('vim_starting')
      while !empty(s:global_context)
        let errored = s:install_async(a:context)
        sleep 50ms
        redraw
      endwhile
    else
      let errored = s:install_blocking(a:context)
    endif
  catch
    call s:error(v:exception)
    call s:error(v:throwpoint)
    return 1
  endtry

  return errored
endfunction

function! dein#install#_get_updated_plugins(plugins, async) abort
  if g:dein#install_github_api_token ==# ''
    call s:error('You need to set g:dein#install_github_api_token' .
          \ ' for the feature.')
    return []
  endif
  if !executable(g:dein#install_curl_command)
    call s:error('curl must be executable for the feature.')
    return []
  endif

  let context = s:init_context(a:plugins, 'check_update', 0)
  call s:init_variables(context)

  let query_max = 100
  let plugins = dein#util#_get_plugins(a:plugins)
  let processes = []
  for index in range(0, len(plugins) - 1, query_max)
    call s:print_progress_message(
          \ s:get_progress_message('send query', index, len(plugins)))

    let query = ''
    for plug_index in range(index,
          \ min([index + query_max, len(plugins)]) - 1)
      let plugin_names = split(plugins[plug_index].repo, '/')
      if len(plugin_names) < 2
        " Invalid repository name.
        continue
      endif

      " Note: "repository" API is faster than "search" API
      let query .= printf('a%d:repository(owner:\"%s\", name: \"%s\")' .
            \ '{ pushedAt nameWithOwner }',
            \ plug_index, plugin_names[-2], plugin_names[-1])
    endfor

    let commands = [
         \ g:dein#install_curl_command, '-H', 'Authorization: bearer ' .
         \ g:dein#install_github_api_token,
         \ '-X', 'POST', '-d',
         \ '{ "query": "query {' . query . '}" }',
         \ 'https://api.github.com/graphql'
         \ ]

    let process = {'candidates': []}
    function! process.on_out(data) abort
      let candidates = self.candidates
      if empty(candidates)
        call add(candidates, a:data[0])
      else
        let candidates[-1] .= a:data[0]
      endif

      let candidates += a:data[1:]
    endfunction
    let process.job = s:get_job().start(
        \ s:convert_args(commands),
        \ {'on_stdout': function(process.on_out, [], process)})

    call add(processes, process)
  endfor

  " Get outputs
  let results = []
  for process in processes
    call process.job.wait(g:dein#install_process_timeout * 1000)

    if !empty(process.candidates)
      let result = process.candidates[0]
      try
        let json = json_decode(result)
        let results += filter(values(json['data']),
              \ { _, val -> type(val) == v:t_dict
              \             && has_key(val, 'pushedAt') })
      catch
        call s:error('json output decode error: ' + string(result))
      endtry
    endif
  endfor

  " Get pushed time.

  let check_pushed = {}
  for node in results
    let format = '%Y-%m-%dT%H:%M:%SZ'
    let pushed_at = node['pushedAt']
    let check_pushed[node['nameWithOwner']] =
          \ exists('*strptime') ?
          \  strptime(format, pushed_at) :
          \  dein#DateTime#from_format(pushed_at, format).unix_time()
  endfor

  " Get the last updated time by rollbackfile timestamp.
  " Note: .git timestamp may be changed by git commands.
  let rollbacks = reverse(sort(glob(
        \ s:get_rollback_directory() . '/*', v:true, v:true)))
  let rollback_time = empty(rollbacks) ? -1 : getftime(rollbacks[0])

  " Compare with .git directory updated time.
  let updated = []
  let index = 1
  for plugin in plugins
    if !has_key(check_pushed, plugin.repo)
      let index += 1
      continue
    endif

    call s:print_progress_message(
          \ s:get_progress_message('compare plugin', index, len(plugins)))

    let git_path = plugin.path . '/.git'
    let repo_time = isdirectory(plugin.path) ? getftime(git_path) : -1

    call s:log(printf('%s: pushed_time=%d, repo_time=%d, rollback_time=%d',
          \ plugin.name, check_pushed[plugin.repo], repo_time, rollback_time))

    let local_update = min([repo_time, rollback_time])
    if local_update < check_pushed[plugin.repo]
      call add(updated, plugin)
    elseif abs(local_update - check_pushed[plugin.repo]) <
          \ g:dein#install_check_remote_threshold
      " Note: github Graph QL API may use cached value
      " If the repository is updated recently, use "git ls-remote" instead.
      let remote = matchstr(s:system_cd(
            \ ['git', 'ls-remote', 'origin', 'HEAD'], plugin.path), '^\x\+')
      let local = s:get_revision_number(plugin)
      call s:log(printf('%s: remote=%s, local=%s',
            \ plugin.name, remote, local))
      if remote !=# '' && local !=# remote
        call add(updated, plugin)
      endif
    endif

    let index += 1
  endfor

  redraw | echo ''

  if s:progress_winid > 0
    call timer_start(1000, { -> s:close_progress_popup() })
  endif

  " Clear global context
  let s:global_context = {}

  return updated
endfunction
function! dein#install#_check_update(plugins, force, async) abort
  let updated = dein#install#_get_updated_plugins(a:plugins, a:async)
  if empty(updated)
    call s:notify(strftime('Done: (%Y/%m/%d %H:%M:%S)'))
    return
  endif

  let updated_msg = 'Updated plugins: ' .
        \ string(map(copy(updated), { _, val -> val.name }))
  call s:log(updated_msg)

  " Note: Use echomsg to display it in confirm
  call s:echo(updated_msg, 'echomsg')
  if !a:force && confirm(
        \ 'Updated plugins are exists. Update now?', "yes\nNo", 2) != 1
    return
  endif

  call dein#install#_update(updated, 'update', a:async)
endfunction

function! dein#install#_reinstall(plugins) abort
  if g:dein#_is_sudo
    call s:error('update/install is disabled in sudo session.')
    return
  endif

  let plugins = dein#util#_get_plugins(a:plugins)

  for plugin in plugins
    " Remove the plugin
    if plugin.type ==# 'none'
          \ || get(plugin, 'local', 0)
          \ || (plugin.sourced &&
          \     index(['dein'], plugin.normalized_name) >= 0)
      call dein#util#_error(
            \ printf('|%s| Cannot reinstall the plugin!', plugin.name))
      continue
    endif

    " Reinstall.
    call s:print_progress_message(printf('|%s| Reinstalling...', plugin.name))

    if isdirectory(plugin.path)
      call dein#install#_rm(plugin.path)
    endif
  endfor

  call dein#install#_update(dein#util#_convert2list(a:plugins),
        \ 'install', 0)
endfunction
function! dein#install#_direct_install(repo, options) abort
  if g:dein#_is_sudo
    call s:error('update/install is disabled in sudo session.')
    return
  endif

  let options = copy(a:options)
  let options.merged = 0

  let plugin = dein#add(a:repo, options)
  if empty(plugin)
    return
  endif

  call dein#install#_update(plugin.name, 'install', 0)
  call dein#source(plugin.name)

  " Add to direct_install.vim
  let file = dein#get_direct_plugins_path()
  let line = printf('call dein#add(%s, %s)',
        \ string(a:repo), string(options))
  if !filereadable(file)
    call dein#util#_safe_writefile([line], file)
  else
    call dein#util#_safe_writefile(add(readfile(file), line), file)
  endif
endfunction
function! dein#install#_rollback(date, plugins) abort
  if g:dein#_is_sudo
    call s:error('update/install is disabled in sudo session.')
    return
  endif

  let glob = s:get_rollback_directory() . '/' . a:date . '*'
  let rollbacks = reverse(sort(glob(glob, v:true, v:true)))
  if empty(rollbacks)
    return
  endif

  call dein#install#_load_rollback(rollbacks[0], a:plugins)
endfunction

function! dein#install#_recache_runtimepath() abort
  if g:dein#_is_sudo
    return
  endif

  let start = reltime()

  " Clear runtime path.
  call s:clear_runtimepath()

  let plugins = values(dein#get())

  let merged_plugins = filter(copy(plugins), { _, val -> val.merged })
  let lazy_merged_plugins = filter(copy(merged_plugins),
        \ { _, val -> val.lazy })
  let nolazy_merged_plugins = filter(copy(merged_plugins),
        \ { _, val -> !val.lazy })
  let merge_ftdetect_plugins = filter(copy(plugins),
        \ { _, val -> get(val, 'merge_ftdetect', 0)
        \             || (val.merged && !val.lazy) })

  call s:copy_files(lazy_merged_plugins, '')

  let runtime = dein#util#_get_runtime_path()

  " Remove plugin directory
  call dein#install#_rm(runtime . '/plugin')
  call dein#install#_rm(runtime . '/after/plugin')

  call s:copy_files(nolazy_merged_plugins, '')

  call s:helptags()

  call s:generate_ftplugin()

  " Clear ftdetect and after/ftdetect directories.
  call dein#install#_rm(runtime . '/ftdetect')
  call dein#install#_rm(runtime . '/after/ftdetect')

  call s:merge_files(merge_ftdetect_plugins, 'ftdetect')
  call s:merge_files(merge_ftdetect_plugins, 'after/ftdetect')

  if get(g:, 'dein#auto_remote_plugins', v:true)
    silent call dein#remote_plugins()
  endif

  call dein#call_hook('post_source')

  call dein#install#_save_rollback(
        \ s:get_rollback_directory() . '/' . strftime('%Y%m%d%H%M%S'), [])

  call dein#util#_clear_state()

  call s:log(strftime('Runtimepath updated: (%Y/%m/%d %H:%M:%S)'))
  call s:log('recache_runtimepath: ' . split(reltimestr(reltime(start)))[0])
endfunction
function! s:clear_runtimepath() abort
  if dein#util#_get_cache_path() ==# ''
    call dein#util#_error('Invalid base path.')
    return
  endif

  let runtimepath = dein#util#_get_runtime_path()

  " Remove runtime path
  call dein#install#_rm(runtimepath)

  if !isdirectory(runtimepath)
    " Create runtime path
    call dein#util#_safe_mkdir(runtimepath)
  endif
endfunction
function! s:helptags() abort
  if g:dein#_runtime_path ==# ''
    return ''
  endif

  try
    let tags = dein#util#_get_runtime_path() . '/doc'
    call dein#util#_safe_mkdir(tags)
    call s:copy_files(filter(values(dein#get()),
          \ { _, val -> !val.merged && !get(val, 'local', v:false) }), 'doc')
    silent execute 'helptags' fnameescape(tags)
  catch /^Vim(helptags):E151:/
    " Ignore an error that occurs when there is no help file
  catch
    call s:error('Error generating helptags:')
    call s:error(v:exception)
    call s:error(v:throwpoint)
  endtry
endfunction
function! s:copy_files(plugins, directory) abort
  let directory = (a:directory ==# '' ? '' : '/' . a:directory)
  let srcs = filter(map(copy(a:plugins), { _, val -> val.rtp . directory }),
        \ { _, val -> isdirectory(val) })
  let stride = 50
  for start in range(0, len(srcs), stride)
    call dein#install#_copy_directories(srcs[start : start + stride-1],
          \ dein#util#_get_runtime_path() . directory)
  endfor
endfunction
function! s:merge_files(plugins, directory) abort
  let vimfiles = []
  let luafiles = []
  for plugin in a:plugins
    for file in filter(globpath(
          \ plugin.rtp, a:directory.'/**/*', v:true, v:true),
          \ { _, val -> !isdirectory(val) })
      if fnamemodify(file, ':e') ==# 'vim'
        let vimfiles += readfile(file, ':t')
      elseif fnamemodify(file, ':e') ==# 'lua'
        let luafiles += readfile(file, ':t')
      endif
    endfor
  endfor

  if !empty(vimfiles)
    call dein#util#_cache_writefile(vimfiles,
          \ printf('.dein/%s/%s.vim', a:directory, a:directory))
  endif
  if !empty(luafiles)
    call dein#util#_cache_writefile(luafiles,
          \ printf('.dein/%s/%s.lua', a:directory, a:directory))
  endif
endfunction
function! dein#install#_save_rollback(rollbackfile, plugins) abort
  let revisions = {}
  for plugin in filter(dein#util#_get_plugins(a:plugins),
        \ { _, val -> s:check_rollback(val) })
    let rev = s:get_revision_number(plugin)
    if rev !=# ''
      let revisions[plugin.name] = rev
    endif
  endfor

  call dein#util#_safe_writefile(
        \ [json_encode(revisions)], expand(a:rollbackfile))
endfunction
function! dein#install#_load_rollback(rollbackfile, plugins) abort
  let revisions = json_decode(readfile(a:rollbackfile)[0])

  let plugins = dein#util#_get_plugins(a:plugins)
  call filter(plugins, { _, val -> has_key(revisions, val.name)
        \ && has_key(dein#util#_get_type(val.type),
        \            'get_rollback_command')
        \ && s:check_rollback(val)
        \ && s:get_revision_number(val) !=# revisions[val.name]
        \ })
  if empty(plugins)
    return
  endif

  for plugin in plugins
    let type = dein#util#_get_type(plugin.type)
    let cmd = type.get_rollback_command(
          \ dein#util#_get_type(plugin.type), revisions[plugin.name])
    call dein#install#_each(cmd, plugin)
  endfor

  call dein#recache_runtimepath()
  call s:error('Rollback to '.fnamemodify(a:rollbackfile, ':t').' version.')
endfunction
function! s:get_rollback_directory() abort
  let parent = printf('%s/rollbacks/%s',
        \ dein#util#_get_cache_path(), g:dein#_progname)
  call dein#util#_safe_mkdir(parent)

  return parent
endfunction
function! s:check_rollback(plugin) abort
  return !has_key(a:plugin, 'local') && !get(a:plugin, 'frozen', 0)
endfunction

function! dein#install#_get_default_ftplugin() abort
  return [
        \ 'if exists("g:did_load_after_ftplugin")',
        \ '  finish',
        \ 'endif',
        \ 'let g:did_load_after_ftplugin = 1',
        \ '',
        \ 'augroup filetypeplugin',
        \ '  autocmd!',
        \ '  autocmd FileType * call s:ftplugin()',
        \ 'augroup END',
        \ '',
        \ 'function! s:ftplugin()',
        \ '  if exists("b:undo_ftplugin")',
        \ '    silent! execute b:undo_ftplugin',
        \ '    unlet! b:undo_ftplugin b:did_ftplugin',
        \ '  endif',
        \ '',
        \ '  let filetype = expand("<amatch>")',
        \ '  if filetype !=# ""',
        \ '    if &cpoptions =~# "S" && exists("b:did_ftplugin")',
        \ '      unlet b:did_ftplugin',
        \ '    endif',
        \ '    for ft in split(filetype, ''\.'')',
        \ '      execute "runtime! ftplugin/" . ft . ".vim"',
        \ '      \ "ftplugin/" . ft . "_*.vim"',
        \ '      \ "ftplugin/" . ft . "/*.vim"',
        \ '      if has("nvim")',
        \ '        execute "runtime! ftplugin/" . ft . ".lua"',
        \ '        \ "ftplugin/" . ft . "_*.lua"',
        \ '        \ "ftplugin/" . ft . "/*.lua"',
        \ '      endif',
        \ '    endfor',
        \ '  endif',
        \ '  call s:after_ftplugin()',
        \ 'endfunction',
        \ '',
        \]
endfunction
function! s:generate_ftplugin() abort
  if empty(g:dein#_ftplugin)
    return
  endif

  " Create after/ftplugin
  let after = dein#util#_get_runtime_path() . '/after/ftplugin'
  call dein#util#_safe_mkdir(after)

  " Merge g:dein#_ftplugin
  let ftplugin = {}
  for [key, string] in items(g:dein#_ftplugin)
    for ft in (key ==# '_' ? ['_'] : split(key, '_'))
      if !has_key(ftplugin, ft)
        let ftplugin[ft] = (ft ==# '_') ? [] : [
              \ "if exists('b:undo_ftplugin')",
              \ "  let b:undo_ftplugin .= '|'",
              \ 'else',
              \ "  let b:undo_ftplugin = ''",
              \ 'endif',
              \ ]
      endif
      let ftplugin[ft] += split(string, '\n')
    endfor
  endfor

  " Generate ftplugin.vim
  call dein#util#_safe_writefile(
        \ dein#install#_get_default_ftplugin() + [
        \ 'function! s:after_ftplugin()',
        \ ] + get(ftplugin, '_', []) + ['endfunction'],
        \ dein#util#_get_runtime_path() . '/after/ftplugin.vim')

  " Generate after/ftplugin
  for [filetype, list] in filter(items(ftplugin),
        \ { _, val -> val[0] !=# '_' })
    call dein#util#_safe_writefile(
          \ list, printf('%s/%s.vim', after, filetype))
  endfor
endfunction

function! dein#install#_is_async() abort
  return g:dein#install_max_processes > 1
endfunction

function! dein#install#_polling() abort
  if exists('+guioptions')
    " Note: guioptions-! does not work in async state
    let save_guioptions = &guioptions
    set guioptions-=!
  endif

  call s:install_async(s:global_context)

  if exists('+guioptions')
    let &guioptions = save_guioptions
  endif
endfunction

function! dein#install#_remote_plugins() abort
  if !has('nvim') || g:dein#_is_sudo
    return
  endif

  if has('vim_starting')
    " Note: UpdateRemotePlugins is not defined in vim_starting
    autocmd dein VimEnter * silent call dein#remote_plugins()
    return
  endif

  if exists(':UpdateRemotePlugins') != 2
    return
  endif

  " Load not loaded neovim remote plugins
  let remote_plugins = filter(values(dein#get()), { _, val ->
        \  isdirectory(val.rtp . '/rplugin') && !val.sourced &&
        \  !empty(glob(val.rtp . '/rplugin/*/*/__init__.py', 1, 1))
        \ })
  if empty(remote_plugins)
    return
  endif

  call dein#autoload#_source(remote_plugins)

  call s:log('loaded remote plugins: ' .
        \ string(map(copy(remote_plugins), { _, val -> val.name })))

  let &runtimepath = dein#util#_join_rtp(dein#util#_uniq(
        \ dein#util#_split_rtp(&runtimepath)), &runtimepath, '')

  let result = execute('UpdateRemotePlugins', '')
  call s:log(result)
endfunction

function! dein#install#_each(cmd, plugins) abort
  let plugins = filter(dein#util#_get_plugins(a:plugins),
        \ { _, val -> isdirectory(val.path) })

  let global_context_save = s:global_context

  let context = s:init_context(plugins, 'each', 0)
  call s:init_variables(context)

  let cwd = getcwd()
  let error = 0
  try
    for plugin in plugins
      call dein#install#_cd(plugin.path)

      if dein#install#_execute(a:cmd)
        let error = 1
      endif
    endfor
  catch
    call s:error(v:exception . ' ' . v:throwpoint)
    return 1
  finally
    let s:global_context = global_context_save
    call dein#install#_cd(cwd)
  endtry

  return error
endfunction
function! dein#install#_build(plugins) abort
  let error = 0
  for plugin in filter(dein#util#_get_plugins(a:plugins),
        \ { _, val -> isdirectory(val.path) && has_key(val, 'build') })
    call s:print_progress_message('Building: ' . plugin.name)
    if dein#install#_each(plugin.build, plugin)
      let error = 1
    endif
  endfor
  return error
endfunction

function! dein#install#_get_log() abort
  return s:log
endfunction
function! dein#install#_get_updates_log() abort
  return s:updates_log
endfunction
function! dein#install#_get_context() abort
  return s:global_context
endfunction
function! dein#install#_get_progress() abort
  return s:progress
endfunction
function! dein#install#_get_failed_plugins() abort
  return s:failed_plugins
endfunction

function! s:get_progress_message(name, number, max) abort
  return printf('(%'.len(a:max).'d/%'.len(a:max).'d) [%s%s] %s',
        \ a:number, a:max,
        \ repeat('+', (a:number*20/a:max)),
        \ repeat('-', 20 - (a:number*20/a:max)),
        \ a:name)
endfunction
function! s:get_plugin_message(plugin, number, max, message) abort
  return printf('(%'.len(a:max).'d/%d) |%-20s| %s',
        \ a:number, a:max, a:plugin.name, a:message)
endfunction
function! s:get_short_message(plugin, number, max, message) abort
  return printf('(%'.len(a:max).'d/%d) %s', a:number, a:max, a:message)
endfunction
function! s:get_sync_command(plugin, update_type, number, max) abort "{{{i
  let type = dein#util#_get_type(a:plugin.type)

  if has_key(type, 'get_sync_command')
    let cmd = type.get_sync_command(a:plugin)
  else
    return ['', '']
  endif

  if empty(cmd)
    return ['', '']
  endif

  let message = s:get_plugin_message(a:plugin, a:number, a:max, string(cmd))

  return [cmd, message]
endfunction
function! s:get_revision_number(plugin) abort
  if !isdirectory(a:plugin.path)
    return ''
  endif

  let type = dein#util#_get_type(a:plugin.type)

  if has_key(type, 'get_revision_number')
    return type.get_revision_number(a:plugin)
  endif

  if !has_key(type, 'get_revision_number_command')
    return ''
  endif

  let cmd = type.get_revision_number_command(a:plugin)
  if empty(cmd)
    return ''
  endif

  let rev = s:system_cd(cmd, a:plugin.path)

  " If rev contains spaces, it is error message
  if rev =~# '\s'
    call s:error(a:plugin.name)
    call s:error('Error revision number: ' . rev)
    return ''
  elseif rev ==# ''
    call s:error(a:plugin.name)
    call s:error('Empty revision number: ' . rev)
    return ''
  endif
  return rev
endfunction
function! s:get_updated_log_message(plugin, new_rev, old_rev) abort
  let type = dein#util#_get_type(a:plugin.type)

  let cmd = has_key(type, 'get_log_command') ?
        \ type.get_log_command(a:plugin, a:new_rev, a:old_rev) : ''
  let log = empty(cmd) ? '' : s:system_cd(cmd, a:plugin.path)
  return log !=# '' ? log :
        \            (a:old_rev  == a:new_rev) ? ''
        \            : printf('%s -> %s', a:old_rev, a:new_rev)
endfunction
function! s:lock_revision(process, context) abort
  let num = a:process.number
  let max = a:context.max_plugins
  let plugin = a:process.plugin

  let type = dein#util#_get_type(plugin.type)
  if !has_key(type, 'get_revision_lock_command')
    return 0
  endif

  let cmd = type.get_revision_lock_command(plugin)

  if empty(cmd)
    " Skipped.
    return 0
  elseif type(cmd) == v:t_string && cmd =~# '^E: '
    " Errored.
    call s:error(plugin.path)
    call s:error(cmd[3:])
    return -1
  endif

  if get(plugin, 'rev', '') !=# ''
    call s:log(s:get_plugin_message(plugin, num, max, 'Locked'))
  endif

  let result = s:system_cd(cmd, plugin.path)
  let status = dein#install#_status()

  if status
    call s:error(plugin.path)
    call s:error(result)
    return -1
  endif
endfunction
function! s:get_updated_message(context, plugins) abort
  "if empty(a:plugins)
  "  return ''
  "endif

  " Diff check
  if g:dein#install_check_diff
    call s:check_diff(a:plugins)
  endif

  return "Updated plugins:\n".
        \ join(map(copy(a:plugins),
        \ { _, val -> '  ' . val.name . (val.commit_count == 0 ? ''
        \                     : printf('(%d change%s)',
        \                              val.commit_count,
        \                              (val.commit_count == 1 ? '' : 's')))
        \    . ((val.old_rev !=# ''
        \        && val.uri =~# '^\h\w*://github.com/') ? "\n"
        \      . printf('    %s/compare/%s...%s',
        \        substitute(substitute(val.uri, '\.git$', '', ''),
        \          '^\h\w*:', 'https:', ''),
        \        val.old_rev, val.new_rev) : '')
        \ }) , "\n")
endfunction
function! s:get_errored_message(plugins) abort
  if empty(a:plugins)
    return ''
  endif

  let msg = "Error installing plugins:\n".join(
        \ map(copy(a:plugins), { _, val -> '  ' . val.name }), "\n")
  let msg .= "\n"
  let msg .= "Please read the error message log with the :message command.\n"

  return msg
endfunction

function! s:check_diff(plugins) abort
  for plugin in a:plugins
    let type = dein#util#_get_type(plugin.type)
    if !has_key(type, 'get_diff_command') || plugin.old_rev ==# ''
      continue
    endif

    " Note: execute diff command in background
    let cmd = type.get_diff_command(plugin, plugin.old_rev, plugin.new_rev)
    let cwd = getcwd()
    try
      call dein#install#_cd(plugin.path)
      call s:get_job().start(
            \ s:convert_args(cmd), {
            \   'on_stdout': function('s:check_diff_on_out')
            \ })
    finally
      call dein#install#_cd(cwd)
    endtry
  endfor
endfunction
function! s:check_diff_on_out(data) abort
  let bufname = 'dein-diff'
  if !bufexists(bufname)
    let bufnr = bufadd(bufname)
  else
    let bufnr = bufnr(bufname)
  endif

  if bufwinnr(bufnr) < 0
    let cmd = 'setlocal bufhidden=wipe filetype=diff buftype=nofile nolist'
          \ . '| syntax enable'
    execute printf('sbuffer +%s', escape(cmd, ' ')) bufnr
  endif

  let current = getbufline(bufnr, '$')[0]
  call setbufline(bufnr, '$', current . a:data[0])
  call appendbufline(bufnr, '$', a:data[1:])
endfunction


" Helper functions
function! dein#install#_cd(path) abort
  if !isdirectory(a:path)
    return
  endif

  try
    noautocmd execute (haslocaldir() ? 'lcd' : 'cd') fnameescape(a:path)
  catch
    call s:error('Error cd to: ' . a:path)
    call s:error('Current directory: ' . getcwd())
    call s:error(v:exception)
    call s:error(v:throwpoint)
  endtry
endfunction

function! dein#install#_system(command) abort
  return s:job_system.system(a:command)
endfunction
let s:job_system = {}
function! s:job_system.on_out(data) abort
  let candidates = s:job_system.candidates
  if empty(candidates)
    call add(candidates, a:data[0])
  else
    let candidates[-1] .= a:data[0]
  endif
  let candidates += a:data[1:]
endfunction
function! s:job_system.system(cmd) abort
  let self.candidates = []

  let job = s:get_job().start(
        \ s:convert_args(a:cmd),
        \ {'on_stdout': self.on_out})
  let s:job_system.status = job.wait(
        \ g:dein#install_process_timeout * 1000)
  return join(s:job_system.candidates, "\n")
endfunction
function! dein#install#_status() abort
  return s:job_system.status
endfunction
function! s:system_cd(command, path) abort
  let cwd = getcwd()
  try
    call dein#install#_cd(a:path)
    return dein#install#_system(a:command)
  finally
    call dein#install#_cd(cwd)
  endtry
  return ''
endfunction

function! dein#install#_execute(command) abort
  return s:job_execute.execute(a:command)
endfunction
let s:job_execute = {}
function! s:job_execute.on_out(data) abort
  for line in a:data
    echo line
  endfor

  let candidates = s:job_execute.candidates
  if empty(candidates)
    call add(candidates, a:data[0])
  else
    let candidates[-1] .= a:data[0]
  endif
  let candidates += a:data[1:]
endfunction
function! s:job_execute.execute(cmd) abort
  let self.candidates = []

  let job = s:get_job().start(
        \ s:convert_args(a:cmd),
        \ {'on_stdout': self.on_out})

  return job.wait(g:dein#install_process_timeout * 1000)
endfunction

function! dein#install#_system_bg(command) abort
  let job = s:get_job().start(
        \ s:convert_args(a:command),
        \ {
        \   'on_stderr': {
        \     v -> map(copy(v), { _, val -> dein#util#_error(val) })
        \   }
        \ })
  return job
endfunction

function! dein#install#_rm(path) abort
  if !isdirectory(a:path) && !filereadable(a:path)
    return
  endif

  try
    call delete(a:path, 'rf')
  catch
    call s:error('Error deleting directory: ' . a:path)
    call s:error(v:exception)
    call s:error(v:throwpoint)
  endtry
endfunction

function! dein#install#_copy_directories(srcs, dest) abort
  if empty(a:srcs)
    return 0
  endif

  if g:dein#install_copy_vim
    " Note: For neovim, vim.loop.fs_{sym}link is faster
    return dein#install#_copy_directories_vim(a:srcs, a:dest)
  endif

  if dein#util#_is_windows() && has('python3')
        \ && dein#install#_python_version_check()
    " In Windows, copy directory is too slow!
    " Note: Python 3.8.0 is needed
    return dein#install#_copy_directories_py(a:srcs, a:dest)
  endif

  let status = 0
  if dein#util#_is_windows()
    if !executable('robocopy')
      call dein#util#_error('robocopy command is needed.')
      return 1
    endif

    let status = dein#install#_copy_directories_robocopy(a:srcs, a:dest)
  else " Not Windows
    let srcs = map(filter(copy(a:srcs),
          \ { _, val -> len(glob(val . '/*', v:true, v:true)) }),
          \ { _, val -> shellescape(val . '/') })
    let is_rsync = executable('rsync')
    if is_rsync
      let cmdline = printf("rsync -a -q --exclude '/.git/' %s %s",
            \ join(srcs), shellescape(a:dest))
      let result = dein#install#_system(cmdline)
      let status = dein#install#_status()
    else
      for src in srcs
        let cmdline = printf('cp -Ra %s* %s', src, shellescape(a:dest))
        let result = dein#install#_system(cmdline)
        let status = dein#install#_status()
        if status
          break
        endif
      endfor
    endif
    if status
      call dein#util#_error('copy command failed.')
      call dein#util#_error(result)
      call dein#util#_error('cmdline: ' . cmdline)
    endif
  endif

  return status
endfunction
function! dein#install#_copy_directories_robocopy(srcs, dest) abort
  let jobs = []
  let format = 'robocopy.exe %s /E /NJH /NJS '
        \ . '/NDL /NC /NS /MT:8 /XO /XD ".git"'
  let srcs = a:srcs
  let MAX_LINES = 8
  while !empty(srcs)
    let temp = tempname() . '.bat'
    let lines = ['@echo off']

    while len(lines) < MAX_LINES && !empty(srcs)
      let path = substitute(printf('"%s" "%s"', srcs[0], a:dest),
            \               '/', '\\', 'g')
      call add(lines, printf(format, path))

      let srcs = srcs[1:]
    endwhile

    call dein#util#_safe_writefile(lines, temp)

    let job = dein#install#_system_bg(temp)
    call add(jobs, { 'commands': lines, 'job': job })
  endwhile

  " Async check
  let ret = 0
  while !empty(jobs)
    let i = 0
    for job in jobs
      let status = job.job.wait(100)
      if status == -1
        " Next check
        let i += 1
        continue
      endif

      " Robocopy returns between 0 and 7 upon success
      let status = (status > 7) ? status : 0

      if status
        call dein#util#_error('copy command failed.')
        call dein#util#_error('cmdline: ' . string(job.commands))
        let ret = 1
      endif

      call remove(jobs, i)

      break
    endfor
  endwhile

  return ret
endfunction
function! dein#install#_copy_directories_py(srcs, dest) abort
  py3 << EOF
import shutil
import vim
for src in vim.eval('a:srcs'):
  shutil.copytree(src, vim.eval('a:dest'),
                  dirs_exist_ok=True,
                  ignore=shutil.ignore_patterns('.git'))
EOF
endfunction
function! dein#install#_python_version_check() abort
  python3 << EOF
import vim
import sys
vim.vars['dein#_python_version_check'] = (
    sys.version_info.major,
    sys.version_info.minor,
    sys.version_info.micro) >= (3, 8, 0)
EOF
  return get(g:, 'dein#_python_version_check', 0)
endfunction
function! dein#install#_copy_directories_vim(srcs, dest) abort
  for src in a:srcs
    for srcpath in glob(src . '/**/*', 1, 1)
      let destpath = substitute(srcpath,
            \ dein#util#escape_match(src),
            \ dein#util#escape_match(a:dest), '')
      let parent = fnamemodify(destpath, ':p:h')
      if !isdirectory(parent)
        call mkdir(parent, 'p')
      endif

      if isdirectory(srcpath)
        call mkdir(destpath, 'p')
      elseif srcpath !~# 'tags\%(-\w*\)\?$'
        " Ignore tags
        call dein#install#_copy_file_vim(srcpath, destpath)
      endif
    endfor
  endfor
endfunction
function! dein#install#_copy_file_vim(src, dest) abort
  " Note: In Windows, v:lua.vim.loop.fs_symlink does not work.
  if has('nvim')
    if dein#util#_is_windows()
      call v:lua.vim.loop.fs_link(a:src, a:dest)
    else
      call v:lua.vim.loop.fs_symlink(a:src, a:dest)
    endif
  else
    let raw = readfile(a:src, 'b')
    call writefile(raw, a:dest, 'b')
  endif
endfunction

function! dein#install#_deno_cache(...) abort
  if !executable('deno')
    return
  endif

  let plugins = dein#util#_get_plugins(get(a:000, 0, []))

  for plugin in plugins
    if !isdirectory(plugin.rtp . '/denops')
      continue
    endif

    call dein#install#_system(
          \ ['deno', 'cache', '--no-check'] +
          \ glob(plugin.rtp . '/denops/**/*.ts', 1, 1))
  endfor
endfunction

function! dein#install#_post_sync(plugins) abort
  if empty(a:plugins)
    return
  endif

  call dein#install#_recache_runtimepath()

  call dein#install#_deno_cache(a:plugins)

  call dein#source(a:plugins)

  " Execute done_update hooks
  let done_update_plugins = filter(dein#util#_get_plugins(a:plugins),
        \ { _, val -> has_key(val, 'hook_done_update') })
  if !empty(done_update_plugins)
    if has('vim_starting')
      let s:done_updated_plugins = done_update_plugins
      autocmd dein VimEnter * call s:call_done_update_hooks(
            \ s:done_updated_plugins)
    else
      call s:call_done_update_hooks(done_update_plugins)
    endif
  endif
endfunction

function! s:install_blocking(context) abort
  try
    while 1
      call s:check_loop(a:context)

      if empty(a:context.processes)
            \ && a:context.number == a:context.max_plugins
        break
      endif
    endwhile
  finally
    call s:done(a:context)
  endtry

  return len(a:context.errored_plugins)
endfunction
function! s:install_async(context) abort
  if empty(a:context)
    return
  endif

  call s:check_loop(a:context)

  if empty(a:context.processes)
        \ && a:context.number == a:context.max_plugins
    call s:done(a:context)
  elseif a:context.number != a:context.prev_number
        \ && a:context.number < len(a:context.plugins)
    let plugin = a:context.plugins[a:context.number]
    call s:print_progress_message(
          \ s:get_progress_message(plugin.name,
          \   a:context.number, a:context.max_plugins))
    let a:context.prev_number = a:context.number
  endif

  return len(a:context.errored_plugins)
endfunction
function! s:check_loop(context) abort
  while a:context.number < a:context.max_plugins
        \ && len(a:context.processes) < g:dein#install_max_processes

    let plugin = a:context.plugins[a:context.number]
    call s:sync(plugin, a:context)

    if !a:context.async
      call s:print_progress_message(
            \ s:get_progress_message(plugin.name,
            \   a:context.number, a:context.max_plugins))
    endif
  endwhile

  for process in a:context.processes
    call s:check_output(a:context, process)
  endfor

  " Filter eof processes.
  call filter(a:context.processes, { _, val -> !val.eof })
endfunction
function! s:restore_view(context) abort
  if a:context.progress_type ==# 'tabline'
    let &g:showtabline = a:context.showtabline
    let &g:tabline = a:context.tabline
  elseif a:context.progress_type ==# 'title'
    let &g:title = a:context.title
    let &g:titlestring = a:context.titlestring
  endif
endfunction
function! s:init_context(plugins, update_type, async) abort
  let context = {}
  let context.update_type = a:update_type
  let context.async = a:async
  let context.synced_plugins = []
  let context.errored_plugins = []
  let context.processes = []
  let context.number = 0
  let context.prev_number = -1
  let context.plugins = a:plugins
  let context.max_plugins = len(context.plugins)
  let context.progress_type = (has('vim_starting')
        \ && g:dein#install_progress_type !=# 'none') ?
        \ 'echo' : g:dein#install_progress_type
  if !has('nvim') && context.progress_type ==# 'title'
    let context.progress_type = 'echo'
  endif
  let context.message_type = (has('vim_starting')
        \ && g:dein#install_message_type !=# 'none') ?
        \ 'echo' : g:dein#install_message_type
  let context.laststatus = &g:laststatus
  let context.showtabline = &g:showtabline
  let context.tabline = &g:tabline
  let context.title = &g:title
  let context.titlestring = &g:titlestring
  return context
endfunction
function! s:init_variables(context) abort
  let s:progress = ''
  let s:global_context = a:context
  let s:log = []
  let s:updates_log = []
endfunction
function! s:convert_args(args) abort
  let args = s:iconv(a:args, &encoding, 'char')
  if type(args) != v:t_list
    let args = split(&shell) + split(&shellcmdflag) + [args]
  endif
  return args
endfunction
function! s:start() abort
  call s:notify(strftime('Update started: (%Y/%m/%d %H:%M:%S)'))
endfunction
function! s:close_progress_popup() abort
  if winbufnr(s:progress_winid) < 0
    return
  endif

  if has('nvim')
    silent! call nvim_win_close(s:progress_winid, v:true)
  else
    silent! call popup_close(s:progress_winid)
  endif
  let s:progress_winid = -1
endfunction
function! s:done(context) abort
  call s:restore_view(a:context)

  let s:failed_plugins = map(copy(a:context.errored_plugins),
        \ { _, val -> val.name })

  if !empty(a:context.synced_plugins)
    let names = map(copy(a:context.synced_plugins), { _, val -> val.name })
    call dein#install#_post_sync(names)
  endif

  if !has('vim_starting')
    call s:notify(s:get_updated_message(a:context, a:context.synced_plugins))
    call s:notify(s:get_errored_message(a:context.errored_plugins))
  endif

  redraw | echo ''

  if s:progress_winid > 0
    call timer_start(1000, { -> s:close_progress_popup() })
  endif

  call s:notify(strftime('Done: (%Y/%m/%d %H:%M:%S)'))

  " Disable installation handler
  let s:global_context = {}
  let s:progress = ''
  augroup dein-install
    autocmd!
  augroup END
  if exists('s:timer')
    call timer_stop(s:timer)
    unlet s:timer
  endif
endfunction
function! s:call_done_update_hooks(plugins) abort
  let cwd = getcwd()
  try
    for plugin in a:plugins
      call dein#install#_cd(plugin.path)
      call dein#call_hook('done_update', plugin)
    endfor
  finally
    call dein#install#_cd(cwd)
  endtry
endfunction

function! s:sync(plugin, context) abort
  let a:context.number += 1

  let num = a:context.number
  let max = a:context.max_plugins

  if isdirectory(a:plugin.path) && get(a:plugin, 'frozen', 0)
    " Skip frozen plugin
    call s:log(s:get_plugin_message(a:plugin, num, max, 'is frozen.'))
    return
  endif

  let [cmd, message] = s:get_sync_command(
        \   a:plugin, a:context.update_type,
        \   a:context.number, a:context.max_plugins)

  if empty(cmd)
    " Skip
    call s:log(s:get_plugin_message(a:plugin, num, max, message))
    return
  endif

  if type(cmd) == v:t_string && cmd =~# '^E: '
    " Errored.

    call s:print_progress_message(s:get_plugin_message(
          \ a:plugin, num, max, 'Error'))
    call s:error(cmd[3:])
    call add(a:context.errored_plugins,
          \ a:plugin)
    return
  endif

  if !a:context.async
    call s:print_progress_message(message)
  endif

  let process = s:init_process(a:plugin, a:context, cmd)
  if !empty(process)
    call add(a:context.processes, process)
  endif
endfunction
function! s:init_process(plugin, context, cmd) abort
  let process = {}

  let cwd = getcwd()
  let lang_save = $LANG
  let prompt_save = $GIT_TERMINAL_PROMPT
  try
    let $LANG = 'C'
    " Disable git prompt (git version >= 2.3.0)
    let $GIT_TERMINAL_PROMPT = 0

    call dein#install#_cd(a:plugin.path)

    let rev = s:get_revision_number(a:plugin)

    let process = {
          \ 'number': a:context.number,
          \ 'max_plugins': a:context.max_plugins,
          \ 'rev': rev,
          \ 'plugin': a:plugin,
          \ 'output': '',
          \ 'status': -1,
          \ 'eof': 0,
          \ 'installed': isdirectory(a:plugin.path),
          \ }

    let rev_save = get(a:plugin, 'rev', '')
    if isdirectory(a:plugin.path)
          \ && !get(a:plugin, 'local', 0)
          \ && rev_save !=# ''
      try
        " Force checkout HEAD revision.
        " The repository may be checked out.
        let a:plugin.rev = ''

        call s:lock_revision(process, a:context)
      finally
        let a:plugin.rev = rev_save
      endtry
    endif

    call s:init_job(process, a:context, a:cmd)
  finally
    let $LANG = lang_save
    let $GIT_TERMINAL_PROMPT = prompt_save
    call dein#install#_cd(cwd)
  endtry

  return process
endfunction
function! s:init_job(process, context, cmd) abort
  let a:process.start_time = localtime()

  if !a:context.async
    let a:process.output = dein#install#_system(a:cmd)
    let a:process.status = dein#install#_status()
    return
  endif

  let a:process.async = {'eof': 0}
  function! a:process.async.job_handler(data) abort
    if !has_key(self, 'candidates')
      let self.candidates = []
    endif
    let candidates = self.candidates
    if empty(candidates)
      call add(candidates, a:data[0])
    else
      let candidates[-1] .= a:data[0]
    endif

    call s:print_progress_message(candidates[-1])

    let candidates += a:data[1:]
  endfunction

  function! a:process.async.on_exit(exitval) abort
    let self.exitval = a:exitval
  endfunction

  function! a:process.async.get(process) abort
    " Check job status
    let status = -1
    if has_key(a:process.job, 'exitval')
      let self.eof = 1
      let status = a:process.job.exitval
    endif

    let candidates = get(a:process.job, 'candidates', [])
    let output = join((self.eof ? candidates : candidates[: -2]), "\n")
    if output !=# '' && a:process.output !=# output
      let a:process.output = output
      let a:process.start_time = localtime()
    endif
    let self.candidates = self.eof ? [] : candidates[-1:]

    let is_timeout = (localtime() - a:process.start_time)
          \             >= get(a:process.plugin, 'timeout',
          \                    g:dein#install_process_timeout)

    if self.eof
      let is_timeout = 0
      let is_skip = 0
    else
      let is_skip = 1
    endif

    if is_timeout
      call a:process.job.stop()
      let status = -1
    endif

    return [is_timeout, is_skip, status]
  endfunction

  let a:process.job = s:get_job().start(
        \ s:convert_args(a:cmd), {
        \   'on_stdout': a:process.async.job_handler,
        \   'on_stderr': a:process.async.job_handler,
        \   'on_exit': a:process.async.on_exit,
        \ })
  let a:process.id = a:process.job.pid()
  let a:process.job.candidates = []
endfunction
function! s:check_output(context, process) abort
  if a:context.async
    let [is_timeout, is_skip, status] = a:process.async.get(a:process)
  else
    let [is_timeout, is_skip, status] = [0, 0, a:process.status]
  endif

  if is_skip && !is_timeout
    return
  endif

  let num = a:process.number
  let max = a:context.max_plugins
  let plugin = a:process.plugin

  if isdirectory(plugin.path)
       \ && get(plugin, 'rev', '') !=# ''
       \ && !get(plugin, 'local', 0)
    " Restore revision.
    call s:lock_revision(a:process, a:context)
  endif

  let new_rev = s:get_revision_number(plugin)

  if is_timeout || status
    call s:log(s:get_plugin_message(plugin, num, max, 'Error'))
    call s:error(plugin.path)
    if !a:process.installed
      if !isdirectory(plugin.path)
        call s:error('Maybe wrong username or repository.')
      elseif isdirectory(plugin.path)
        call s:error('Remove the installed directory:' . plugin.path)
        call dein#install#_rm(plugin.path)
      endif
    endif

    call s:error((is_timeout ?
          \    strftime('Process timeout: (%Y/%m/%d %H:%M:%S)') :
          \    split(a:process.output, '\n')
          \ ))

    call add(a:context.errored_plugins,
          \ plugin)
  elseif a:process.rev ==# new_rev
    call s:log(s:get_plugin_message(
          \ plugin, num, max, 'Same revision'))
  else
    call s:log(s:get_plugin_message(plugin, num, max, 'Updated'))

    let log_messages = split(s:get_updated_log_message(
          \   plugin, new_rev, a:process.rev), '\n')
    let plugin.commit_count = len(log_messages)
    call s:log(map(log_messages,
          \   { _, val -> s:get_short_message(plugin, num, max, val) }))

    let plugin.old_rev = a:process.rev
    let plugin.new_rev = new_rev

    " Execute "post_update" before "build"
    if has_key(plugin, 'hook_post_update')
      " To load plugin is needed to execute "post_update"
      call dein#source(plugin.name)
      call dein#call_hook('post_update', plugin)
    endif

    let type = dein#util#_get_type(plugin.type)
    let plugin.uri = has_key(type, 'get_uri') ?
          \ type.get_uri(plugin.repo, plugin) : ''

    if dein#install#_build([plugin.name])
      call s:log(s:get_plugin_message(plugin, num, max, 'Build failed'))
      call s:error(plugin.path)
      " Remove.
      call add(a:context.errored_plugins, plugin)
    else
      call add(a:context.synced_plugins, plugin)
    endif
  endif

  let a:process.eof = 1
endfunction

function! s:iconv(expr, from, to) abort
  if a:from ==# '' || a:to ==# '' || a:from ==? a:to
    return a:expr
  endif

  if type(a:expr) == v:t_list
    return map(copy(a:expr), { _, val -> iconv(val, a:from, a:to) })
  else
    let result = iconv(a:expr, a:from, a:to)
    return result !=# '' ? result : a:expr
  endif
endfunction
function! s:print_progress_message(msg) abort
  let msg = dein#util#_convert2list(a:msg)
  let context = s:global_context
  if empty(msg) || empty(context)
    return
  endif

  redraw

  let progress_type = context.progress_type
  let lines = join(msg, "\n")
  if progress_type ==# 'tabline'
    set showtabline=2
    let &g:tabline = lines
  elseif progress_type ==# 'title'
    set title
    let &g:titlestring = lines
  elseif progress_type ==# 'floating'
    if s:progress_winid <= 0
      let s:progress_winid = s:new_progress_window()
    endif

    let bufnr = winbufnr(s:progress_winid)
    if getbufline(bufnr, 1) ==# ['']
      call setbufline(bufnr, 1, msg)
    else
      call appendbufline(bufnr, '$', msg)
    endif
    call win_execute(s:progress_winid, "call cursor('$', 0) | redraw")
  elseif progress_type ==# 'echo'
    call s:echo(msg, 'echo')
  endif

  call s:log(msg)

  let s:progress = lines
endfunction
function! s:new_progress_window() abort
  let winrow = 0
  let wincol = &columns / 4
  let winwidth = 80
  let winheight = 20

  if has('nvim')
    let winid = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, {
          \ 'relative': 'editor',
          \ 'row': winrow,
          \ 'col': wincol,
          \ 'focusable': v:false,
          \ 'noautocmd': v:true,
          \ 'style': 'minimal',
          \ 'width': winwidth,
          \ 'height': winheight,
          \})
  else
    let winid = popup_create([], {
          \ 'pos': 'topleft',
          \ 'line': winrow + 1,
          \ 'col': wincol + 1,
          \ 'minwidth': winwidth,
          \ 'minheight': winheight,
          \ 'wrap': 0,
          \ })
  endif

  return winid
endfunction
function! s:error(msg) abort
  let msg = dein#util#_convert2list(a:msg)
  if empty(msg)
    return
  endif

  call s:echo(msg, 'error')

  call s:updates_log(msg)
endfunction
function! s:notify(msg) abort
  let msg = dein#util#_convert2list(a:msg)
  let context = s:global_context
  if empty(msg) || empty(context)
    return
  endif

  if context.message_type ==# 'echo'
    call dein#util#_notify(a:msg)
  endif

  call s:updates_log(msg)
  let s:progress = join(msg, "\n")
endfunction
function! s:updates_log(msg) abort
  let msg = dein#util#_convert2list(a:msg)

  let s:updates_log += msg
  call s:log(msg)
endfunction
function! s:log(msg) abort
  let msg = dein#util#_convert2list(a:msg)
  let s:log += msg
  call s:append_log_file(msg)
endfunction
function! s:append_log_file(msg) abort
  let logfile = dein#util#_expand(g:dein#install_log_filename)
  if logfile ==# ''
    return
  endif

  let msg = a:msg
  " Appends to log file.
  if filereadable(logfile)
    let msg = readfile(logfile) + msg
  endif

  call dein#util#_safe_writefile(msg, logfile)
endfunction


function! s:echo(expr, mode) abort
  let msg = map(filter(dein#util#_convert2list(a:expr),
        \ { _, val -> val !=# '' }), { _, val -> '[dein] ' .  val })
  if empty(msg)
    return
  endif

  let more_save = &more
  let showcmd_save = &showcmd
  let ruler_save = &ruler
  try
    set nomore
    set noshowcmd
    set noruler

    let height = max([1, &cmdheight])
    echo ''
    for i in range(0, len(msg)-1, height)
      redraw

      let m = join(msg[i : i+height-1], "\n")
      call s:echo_mode(m, a:mode)
      if has('vim_starting')
        echo ''
      endif
    endfor
  finally
    let &more = more_save
    let &showcmd = showcmd_save
    let &ruler = ruler_save
  endtry
endfunction
function! s:echo_mode(m, mode) abort
  for m in split(a:m, '\r\?\n', 1)
    if !has('vim_starting') && a:mode !=# 'error'
      let m = s:truncate_skipping(m, &columns - 1, &columns/3, '...')
    endif

    if a:mode ==# 'error'
      echohl WarningMsg | echomsg m | echohl None
    elseif a:mode ==# 'echomsg'
      echomsg m
    else
      echo m
    endif
  endfor
endfunction

function! s:truncate_skipping(str, max, footer_width, separator) abort
  let width = strwidth(a:str)
  if width <= a:max
    let ret = a:str
  else
    let header_width = a:max - strwidth(a:separator) - a:footer_width
    let ret = s:strwidthpart(a:str, header_width) . a:separator
          \ . s:strwidthpart_reverse(a:str, a:footer_width)
  endif

  return ret
endfunction
function! s:strwidthpart(str, width) abort
  if a:width <= 0
    return ''
  endif
  let ret = a:str
  let width = strwidth(a:str)
  while width > a:width
    let char = matchstr(ret, '.$')
    let ret = ret[: -1 - len(char)]
    let width -= strwidth(char)
  endwhile

  return ret
endfunction
function! s:strwidthpart_reverse(str, width) abort
  if a:width <= 0
    return ''
  endif
  let ret = a:str
  let width = strwidth(a:str)
  while width > a:width
    let char = matchstr(ret, '^.')
    let ret = ret[len(char) :]
    let width -= strwidth(char)
  endwhile

  return ret
endfunction
