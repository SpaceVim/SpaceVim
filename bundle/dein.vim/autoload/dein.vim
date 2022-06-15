function! dein#load_cache_raw(vimrcs) abort
  return dein#min#_load_cache_raw(a:vimrcs)
endfunction
function! dein#load_state(path, ...) abort
  return call('dein#min#load_state', [a:path] + a:000)
endfunction

function! dein#tap(name) abort
  if !dein#is_available(a:name) | return 0 | endif
  let g:dein#name = a:name
  let g:dein#plugin = g:dein#_plugins[a:name]
  return 1
endfunction
function! dein#is_sourced(name) abort
  return has_key(g:dein#_plugins, a:name)
        \ && isdirectory(g:dein#_plugins[a:name].path)
        \ && g:dein#_plugins[a:name].sourced
endfunction
function! dein#is_available(names) abort
  for name in type(a:names) ==# v:t_list ? a:names : [a:names]
    if !has_key(g:dein#_plugins, name) | return 0 | endif
    let plugin = g:dein#_plugins[name]
    if !isdirectory(plugin.path)
          \ || (has_key(plugin, 'if') && !eval(plugin.if)) | return 0 | endif
  endfor
  return 1
endfunction
function! dein#begin(path, ...) abort
  return dein#util#_begin(a:path, (empty(a:000) ? [] : a:1))
endfunction
function! dein#end() abort
  return dein#util#_end()
endfunction
function! dein#add(repo, ...) abort
  return dein#parse#_add(a:repo, get(a:000, 0, {}), v:false)
endfunction
function! dein#local(dir, ...) abort
  return dein#parse#_local(a:dir, get(a:000, 0, {}), get(a:000, 1, ['*']))
endfunction
function! dein#get(...) abort
  return empty(a:000) ? copy(g:dein#_plugins) : get(g:dein#_plugins, a:1, {})
endfunction
function! dein#source(...) abort
  return call('dein#autoload#_source', a:000)
endfunction
function! dein#check_install(...) abort
  return dein#util#_check_install(get(a:000, 0, []))
endfunction
function! dein#check_clean() abort
  return dein#util#_check_clean()
endfunction
function! dein#install(...) abort
  return dein#install#_update(get(a:000, 0, []),
        \ 'install', dein#install#_is_async())
endfunction
function! dein#update(...) abort
  return dein#install#_update(get(a:000, 0, []),
        \ 'update', dein#install#_is_async())
endfunction
function! dein#check_update(...) abort
  return dein#install#_check_update(
        \ get(a:000, 1, []), get(a:000, 0, v:false),
        \ dein#install#_is_async())
endfunction
function! dein#direct_install(repo, ...) abort
  call dein#install#_direct_install(a:repo, (a:0 ? a:1 : {}))
endfunction
function! dein#get_direct_plugins_path() abort
  return get(g:, 'dein#cache_directory', g:dein#_base_path)
        \ .'/direct_install.vim'
endfunction
function! dein#reinstall(plugins) abort
  call dein#install#_reinstall(a:plugins)
endfunction
function! dein#rollback(date, ...) abort
  call dein#install#_rollback(a:date, (a:0 ? a:1 : []))
endfunction
function! dein#save_rollback(rollbackfile, ...) abort
  call dein#install#_save_rollback(a:rollbackfile, (a:0 ? a:1 : []))
endfunction
function! dein#load_rollback(rollbackfile, ...) abort
  call dein#install#_load_rollback(a:rollbackfile, (a:0 ? a:1 : []))
endfunction
function! dein#remote_plugins() abort
  return dein#install#_remote_plugins()
endfunction
function! dein#recache_runtimepath() abort
  call dein#install#_recache_runtimepath()
endfunction
function! dein#call_hook(hook_name, ...) abort
  return call('dein#util#_call_hook', [a:hook_name] + a:000)
endfunction
function! dein#check_lazy_plugins() abort
  return dein#util#_check_lazy_plugins()
endfunction
function! dein#load_toml(filename, ...) abort
  return dein#parse#_load_toml(a:filename, get(a:000, 0, {}))
endfunction
function! dein#load_dict(dict, ...) abort
  return dein#parse#_load_dict(a:dict, get(a:000, 0, {}))
endfunction
function! dein#get_log() abort
  return join(dein#install#_get_log(), "\n")
endfunction
function! dein#get_updates_log() abort
  return join(dein#install#_get_updates_log(), "\n")
endfunction
function! dein#get_progress() abort
  return dein#install#_get_progress()
endfunction
function! dein#get_failed_plugins() abort
  return dein#install#_get_failed_plugins()
endfunction
function! dein#each(command, ...) abort
  return dein#install#_each(a:command, (a:0 ? a:1 : []))
endfunction
function! dein#build(...) abort
  return dein#install#_build(a:0 ? a:1 : [])
endfunction
function! dein#plugins2toml(plugins) abort
  return dein#parse#_plugins2toml(a:plugins)
endfunction
function! dein#disable(names) abort
  return dein#util#_disable(a:names)
endfunction
function! dein#config(arg, ...) abort
  return type(a:arg) != v:t_list ?
        \ dein#util#_config(a:arg, get(a:000, 0, {})) :
        \ map(copy(a:arg), { _, val -> dein#util#_config(val, a:1) })
endfunction
function! dein#set_hook(plugins, hook_name, hook) abort
  return dein#util#_set_hook(a:plugins, a:hook_name, a:hook)
endfunction
function! dein#save_state() abort
  return dein#util#_save_state(has('vim_starting'))
endfunction
function! dein#clear_state() abort
  call dein#util#_clear_state()

  if !get(g:, 'dein#auto_recache', v:false) && !empty(g:dein#_ftplugin)
    call dein#util#_notify(
          \ 'call dein#recache_runtimepath() is needed for ftplugin feature')
  endif
endfunction
function! dein#deno_cache(...) abort
  call dein#install#_deno_cache(get(a:000, 0, []))
endfunction
function! dein#post_sync(plugins) abort
  call dein#install#_post_sync(a:plugins)
endfunction
function! dein#get_updated_plugins(...) abort
  return dein#install#_get_updated_plugins(
        \ get(a:000, 0, []), dein#install#_is_async())
endfunction
