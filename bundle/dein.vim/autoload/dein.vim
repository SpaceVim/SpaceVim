"=============================================================================
" FILE: dein.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! dein#_init() abort
  let g:dein#_cache_version = 150
  let g:dein#_merged_format =
        \ "{'repo': v:val.repo, 'rev': get(v:val, 'rev', '')}"
  let g:dein#_merged_length = 3
  let g:dein#name = ''
  let g:dein#plugin = {}
  let g:dein#_plugins = {}
  let g:dein#_base_path = ''
  let g:dein#_cache_path = ''
  let g:dein#_runtime_path = ''
  let g:dein#_hook_add = ''
  let g:dein#_ftplugin = {}
  let g:dein#_off1 = ''
  let g:dein#_off2 = ''
  let g:dein#_vimrcs = []
  let g:dein#_block_level = 0
  let g:dein#_event_plugins = {}
  let g:dein#_is_sudo = $SUDO_USER !=# '' && $USER !=# $SUDO_USER
        \ && $HOME !=# expand('~'.$USER)
        \ && $HOME ==# expand('~'.$SUDO_USER)
  let g:dein#_progname = fnamemodify(v:progname, ':r')
  let g:dein#_init_runtimepath = &runtimepath

  augroup dein
    autocmd!
    autocmd FuncUndefined * call dein#autoload#_on_func(expand('<afile>'))
    autocmd BufRead *? call dein#autoload#_on_default_event('BufRead')
    autocmd BufNew,BufNewFile *? call dein#autoload#_on_default_event('BufNew')
    autocmd VimEnter *? call dein#autoload#_on_default_event('VimEnter')
    autocmd FileType *? call dein#autoload#_on_default_event('FileType')
    autocmd BufWritePost *.vim,*.toml,vimrc,.vimrc
          \ call dein#util#_check_vimrcs()
  augroup END
  augroup dein-events | augroup END

  if !exists('##CmdUndefined') | return | endif
  autocmd dein CmdUndefined *
        \ call dein#autoload#_on_pre_cmd(expand('<afile>'))
endfunction
function! dein#load_cache_raw(vimrcs) abort
  let g:dein#_vimrcs = a:vimrcs
  let cache = get(g:, 'dein#cache_directory', g:dein#_base_path)
        \ .'/cache_' . g:dein#_progname
  let time = getftime(cache)
  if !empty(filter(map(copy(g:dein#_vimrcs),
        \ 'getftime(expand(v:val))'), 'time < v:val'))
    return [{}, {}]
  endif
  let list = readfile(cache)
  if len(list) != 3 || string(g:dein#_vimrcs) !=# list[0]
    return [{}, {}]
  endif
  return [json_decode(list[1]), json_decode(list[2])]
endfunction
function! dein#load_state(path, ...) abort
  if !exists('#dein')
    call dein#_init()
  endif
  let sourced = a:0 > 0 ? a:1 : has('vim_starting') &&
        \  (!exists('&loadplugins') || &loadplugins)
  if (g:dein#_is_sudo || !sourced) | return 1 | endif
  let g:dein#_base_path = expand(a:path)

  let state = get(g:, 'dein#cache_directory', g:dein#_base_path)
        \ . '/state_' . g:dein#_progname . '.vim'
  if !filereadable(state) | return 1 | endif
  try
    execute 'source' fnameescape(state)
  catch
    if v:exception !=# 'Cache loading error'
      call dein#util#_error('Loading state error: ' . v:exception)
    endif
    call dein#clear_state()
    return 1
  endtry
endfunction

function! dein#tap(name) abort
  if !has_key(g:dein#_plugins, a:name)
        \ || !isdirectory(g:dein#_plugins[a:name].path) | return 0 | endif
  let g:dein#name = a:name
  let g:dein#plugin = g:dein#_plugins[a:name]
  return 1
endfunction
function! dein#is_sourced(name) abort
  return has_key(g:dein#_plugins, a:name)
        \ && isdirectory(g:dein#_plugins[a:name].path)
        \ && g:dein#_plugins[a:name].sourced
endfunction
function! dein#begin(path, ...) abort
  return dein#util#_begin(a:path, (empty(a:000) ? [] : a:1))
endfunction
function! dein#end() abort
  return dein#util#_end()
endfunction
function! dein#add(repo, ...) abort
  return dein#parse#_add(a:repo, get(a:000, 0, {}))
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
  return dein#install#_update(get(a:000, 0, []),
        \ 'check_update', dein#install#_is_async())
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
        \ map(copy(a:arg), 'dein#util#_config(v:val, a:1)')
endfunction
function! dein#set_hook(plugins, hook_name, hook) abort
  return dein#util#_set_hook(a:plugins, a:hook_name, a:hook)
endfunction
function! dein#save_state() abort
  return dein#util#_save_state(has('vim_starting'))
endfunction
function! dein#clear_state() abort
  return dein#util#_clear_state()
endfunction
