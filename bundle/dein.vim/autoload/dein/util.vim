"=============================================================================
" FILE: util.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:is_windows = has('win32') || has('win64')

function! dein#util#_init() abort
endfunction

function! dein#util#_set_default(var, val, ...) abort
  if !exists(a:var) || type({a:var}) != type(a:val)
    let alternate_var = get(a:000, 0, '')

    let {a:var} = exists(alternate_var) ?
          \ {alternate_var} : a:val
  endif
endfunction

function! dein#util#_is_windows() abort
  return s:is_windows
endfunction
function! dein#util#_is_mac() abort
  return !s:is_windows && !has('win32unix')
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!isdirectory('/proc') && executable('sw_vers')))
endfunction

function! dein#util#_get_base_path() abort
  return g:dein#_base_path
endfunction
function! dein#util#_get_runtime_path() abort
  if g:dein#_runtime_path !=# ''
    return g:dein#_runtime_path
  endif

  let g:dein#_runtime_path = dein#util#_get_cache_path() . '/.dein'
  if !isdirectory(g:dein#_runtime_path)
    call mkdir(g:dein#_runtime_path, 'p')
  endif
  return g:dein#_runtime_path
endfunction
function! dein#util#_get_cache_path() abort
  if g:dein#_cache_path !=# ''
    return g:dein#_cache_path
  endif

  let g:dein#_cache_path = get(g:,
        \ 'dein#cache_directory', g:dein#_base_path)
        \ . '/.cache/' . fnamemodify(dein#util#_get_myvimrc(), ':t')
  if !isdirectory(g:dein#_cache_path)
    call mkdir(g:dein#_cache_path, 'p')
  endif
  return g:dein#_cache_path
endfunction
function! dein#util#_get_vimrcs(vimrcs) abort
  return !empty(a:vimrcs) ?
        \ map(dein#util#_convert2list(a:vimrcs), 'expand(v:val)') :
        \ [dein#util#_get_myvimrc()]
endfunction
function! dein#util#_get_myvimrc() abort
  let vimrc = $MYVIMRC !=# '' ? $MYVIMRC :
        \ matchstr(split(dein#util#_redir('scriptnames'), '\n')[0],
        \  '^\s*\d\+:\s\zs.*')
  return dein#util#_substitute_path(vimrc)
endfunction

function! dein#util#_error(msg) abort
  for mes in s:msg2list(a:msg)
    echohl WarningMsg | echomsg '[dein] ' . mes | echohl None
  endfor
endfunction
function! dein#util#_notify(msg) abort
  call dein#util#_set_default(
        \ 'g:dein#enable_notification', 0)
  call dein#util#_set_default(
        \ 'g:dein#notification_icon', '')
  call dein#util#_set_default(
        \ 'g:dein#notification_time', 2)

  if !g:dein#enable_notification || a:msg ==# '' || has('vim_starting')
    call dein#util#_error(a:msg)
    return
  endif

  let icon = dein#util#_expand(g:dein#notification_icon)

  let title = '[dein]'
  let cmd = ''
  if executable('notify-send')
    let cmd = printf('notify-send --expire-time=%d',
          \ g:dein#notification_time * 1000)
    if icon !=# ''
      let cmd .= ' --icon=' . string(icon)
    endif
    let cmd .= ' ' . string(title) . ' ' . string(a:msg)
  elseif dein#util#_is_windows() && executable('Snarl_CMD')
    let cmd = printf('Snarl_CMD snShowMessage %d "%s" "%s"',
          \ g:dein#notification_time, title, a:msg)
    if icon !=# ''
      let cmd .= ' "' . icon . '"'
    endif
  elseif dein#util#_is_mac()
    let cmd = ''
    if executable('terminal-notifier')
      let cmd .= 'terminal-notifier -title '
            \ . string(title) . ' -message ' . string(a:msg)
      if icon !=# ''
        let cmd .= ' -appIcon ' . string(icon)
      endif
    else
      let cmd .= printf("osascript -e 'display notification "
            \        ."\"%s\" with title \"%s\"'", a:msg, title)
    endif
  endif

  if cmd !=# ''
    call dein#install#_system(cmd)
  endif
endfunction

function! dein#util#_chomp(str) abort
  return a:str !=# '' && a:str[-1:] ==# '/' ? a:str[: -2] : a:str
endfunction

function! dein#util#_uniq(list) abort
  let list = copy(a:list)
  let i = 0
  let seen = {}
  while i < len(list)
    let key = list[i]
    if key !=# '' && has_key(seen, key)
      call remove(list, i)
    else
      if key !=# ''
        let seen[key] = 1
      endif
      let i += 1
    endif
  endwhile
  return list
endfunction

function! dein#util#_is_fish() abort
  return dein#install#_is_async() && fnamemodify(&shell, ':t:r') ==# 'fish'
endfunction
function! dein#util#_is_powershell() abort
  return dein#install#_is_async() && fnamemodify(&shell, ':t:r') =~? 'powershell\|pwsh'
endfunction
function! dein#util#_has_job() abort
  return (has('nvim') && exists('v:t_list'))
        \ || (has('patch-8.0.0027') && has('job'))
endfunction

function! dein#util#_check_lazy_plugins() abort
  return map(filter(dein#util#_get_lazy_plugins(),
        \   "isdirectory(v:val.rtp)
        \    && !get(v:val, 'local', 0)
        \    && get(v:val, 'hook_source', '') ==# ''
        \    && get(v:val, 'hook_add', '') ==# ''
        \    && !isdirectory(v:val.rtp . '/plugin')
        \    && !isdirectory(v:val.rtp . '/after/plugin')"),
        \   'v:val.name')
endfunction
function! dein#util#_check_clean() abort
  let plugins_directories = map(values(dein#get()), 'v:val.path')
  let path = dein#util#_substitute_path(
        \ globpath(dein#util#_get_base_path(), 'repos/*/*/*'))
  return filter(split(path, "\n"),
        \ "isdirectory(v:val) && fnamemodify(v:val, ':t') !=# 'dein.vim'
        \  && index(plugins_directories, v:val) < 0")
endfunction

function! dein#util#_writefile(path, list) abort
  if g:dein#_is_sudo || !filewritable(dein#util#_get_cache_path())
    return 1
  endif

  let path = dein#util#_get_cache_path() . '/' . a:path
  let dir = fnamemodify(path, ':h')
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif

  return writefile(a:list, path)
endfunction

function! dein#util#_get_type(name) abort
  return get(dein#parse#_get_types(), a:name, {})
endfunction

function! dein#util#_save_cache(vimrcs, is_state, is_starting) abort
  if dein#util#_get_cache_path() ==# '' || !a:is_starting
    " Ignore
    return 1
  endif

  let plugins = deepcopy(dein#get())

  for plugin in values(plugins)
    if !a:is_state
      let plugin.sourced = 0
    endif
    if has_key(plugin, 'orig_opts')
      call remove(plugin, 'orig_opts')
    endif

    " Hooks
    for hook in filter([
          \ 'hook_add', 'hook_source',
          \ 'hook_post_source', 'hook_post_update',
          \ ], 'has_key(plugin, v:val)
          \     && type(plugin[v:val]) == v:t_func')
      call remove(plugin, hook)
    endfor
  endfor

  if !isdirectory(g:dein#_base_path)
    call mkdir(g:dein#_base_path, 'p')
  endif

  call writefile([string(a:vimrcs),
        \         json_encode(plugins), json_encode(g:dein#_ftplugin)],
        \ get(g:, 'dein#cache_directory', g:dein#_base_path)
        \ .'/cache_' . g:dein#_progname)
endfunction
function! dein#util#_check_vimrcs() abort
  let time = getftime(dein#util#_get_runtime_path())
  let ret = !empty(filter(map(copy(g:dein#_vimrcs), 'getftime(expand(v:val))'),
        \ 'time < v:val'))
  if !ret
    return 0
  endif

  call dein#clear_state()

  if get(g:, 'dein#auto_recache', 0)
    silent execute 'source' dein#util#_get_myvimrc()

    if dein#util#_get_merged_plugins() !=# dein#util#_load_merged_plugins()
      call dein#util#_notify('auto recached')
      call dein#recache_runtimepath()
    endif
  endif

  return ret
endfunction
function! dein#util#_load_merged_plugins() abort
  let path = dein#util#_get_cache_path() . '/merged'
  if !filereadable(path)
    return []
  endif
  let merged = readfile(path)
  if len(merged) != g:dein#_merged_length
    return []
  endif
  sandbox return merged[: g:dein#_merged_length - 2] + eval(merged[-1])
endfunction
function! dein#util#_save_merged_plugins() abort
  let merged = dein#util#_get_merged_plugins()
  call writefile(merged[: g:dein#_merged_length - 2] +
        \ [string(merged[g:dein#_merged_length - 1 :])],
        \ dein#util#_get_cache_path() . '/merged')
endfunction
function! dein#util#_get_merged_plugins() abort
  let ftplugin_len = 0
  for ftplugin in values(g:dein#_ftplugin)
    let ftplugin_len += len(ftplugin)
  endfor
  return [g:dein#_merged_format, string(ftplugin_len)] +
         \ sort(map(values(g:dein#_plugins), g:dein#_merged_format))
endfunction

function! dein#util#_save_state(is_starting) abort
  if g:dein#_block_level != 0
    call dein#util#_error('Invalid dein#save_state() usage.')
    return 1
  endif

  if dein#util#_get_cache_path() ==# '' || !a:is_starting
    " Ignore
    return 1
  endif

  let g:dein#_vimrcs = dein#util#_uniq(g:dein#_vimrcs)
  let &runtimepath = dein#util#_join_rtp(dein#util#_uniq(
        \ dein#util#_split_rtp(&runtimepath)), &runtimepath, '')

  call dein#util#_save_cache(g:dein#_vimrcs, 1, a:is_starting)

  " Version check

  let lines = [
        \ 'if g:dein#_cache_version !=# ' . g:dein#_cache_version . ' || ' .
        \ 'g:dein#_init_runtimepath !=# ' . string(g:dein#_init_runtimepath) .
        \      ' | throw ''Cache loading error'' | endif',
        \ 'let [plugins, ftplugin] = dein#load_cache_raw('.
        \      string(g:dein#_vimrcs) .')',
        \ "if empty(plugins) | throw 'Cache loading error' | endif",
        \ 'let g:dein#_plugins = plugins',
        \ 'let g:dein#_ftplugin = ftplugin',
        \ 'let g:dein#_base_path = ' . string(g:dein#_base_path),
        \ 'let g:dein#_runtime_path = ' . string(g:dein#_runtime_path),
        \ 'let g:dein#_cache_path = ' . string(g:dein#_cache_path),
        \ 'let &runtimepath = ' . string(&runtimepath),
        \ ]

  if g:dein#_off1 !=# ''
    call add(lines, g:dein#_off1)
  endif
  if g:dein#_off2 !=# ''
    call add(lines, g:dein#_off2)
  endif

  " Add dummy mappings/commands
  for plugin in dein#util#_get_lazy_plugins()
    for command in get(plugin, 'dummy_commands', [])
      call add(lines, 'silent! ' . command[1])
    endfor
    for mapping in get(plugin, 'dummy_mappings', [])
      call add(lines, 'silent! ' . mapping[2])
    endfor
  endfor

  " Add hooks
  if !empty(g:dein#_hook_add)
    let lines += s:skipempty(g:dein#_hook_add)
  endif
  for plugin in dein#util#_tsort(values(dein#get()))
    if has_key(plugin, 'hook_add') && type(plugin.hook_add) == v:t_string
      let lines += s:skipempty(plugin.hook_add)
    endif
  endfor

  " Add events
  for [event, plugins] in filter(items(g:dein#_event_plugins),
        \ "exists('##' . v:val[0])")
    call add(lines, printf('autocmd dein-events %s call '
          \. 'dein#autoload#_on_event("%s", %s)',
          \ (exists('##' . event) ? event . ' *' : 'User ' . event),
          \ event, string(plugins)))
  endfor

  call writefile(lines, get(g:, 'dein#cache_directory', g:dein#_base_path)
        \ .'/state_' . g:dein#_progname . '.vim')
endfunction
function! dein#util#_clear_state() abort
  let base = get(g:, 'dein#cache_directory', g:dein#_base_path)
  for cache in dein#util#_globlist(base.'/state_*.vim')
        \ + dein#util#_globlist(base.'/cache_*')
    call delete(cache)
  endfor
endfunction

function! dein#util#_begin(path, vimrcs) abort
  if !exists('#dein')
    call dein#_init()
  endif

  " Reset variables
  if has('vim_starting')
    let g:dein#_plugins = {}
    let g:dein#_event_plugins = {}
  endif
  let g:dein#_ftplugin = {}
  let g:dein#_hook_add = ''

  if !dein#util#_has_job()
    call dein#util#_error('Does not work in the Vim (' . v:version . ').')
    return 1
  endif

  if a:path ==# '' || g:dein#_block_level != 0
    call dein#util#_error('Invalid begin/end block usage.')
    return 1
  endif

  let g:dein#_block_level += 1
  let g:dein#_base_path = dein#util#_expand(a:path)
  if g:dein#_base_path[-1:] ==# '/'
    let g:dein#_base_path = g:dein#_base_path[: -2]
  endif
  call dein#util#_get_runtime_path()
  call dein#util#_get_cache_path()
  let g:dein#_vimrcs = dein#util#_get_vimrcs(a:vimrcs)
  let g:dein#_hook_add = ''

  if has('vim_starting')
    " Filetype off
    if exists('g:did_load_filetypes') || has('nvim')
      let g:dein#_off1 = 'filetype off'
      execute g:dein#_off1
    endif
    if exists('b:did_indent') || exists('b:did_ftplugin')
      let g:dein#_off2 = 'filetype plugin indent off'
      execute g:dein#_off2
    endif
  else
    execute 'set rtp-='.fnameescape(g:dein#_runtime_path)
    execute 'set rtp-='.fnameescape(g:dein#_runtime_path.'/after')
  endif

  " Insert dein runtimepath to the head in 'runtimepath'.
  let rtps = dein#util#_split_rtp(&runtimepath)
  let idx = index(rtps, $VIMRUNTIME)
  if idx < 0
    call dein#util#_error('Invalid runtimepath.')
    return 1
  endif
  if fnamemodify(a:path, ':t') ==# 'plugin'
        \ && index(rtps, fnamemodify(a:path, ':h')) >= 0
    call dein#util#_error('You must not set the installation directory'
          \ .' under "&runtimepath/plugin"')
    return 1
  endif
  call insert(rtps, g:dein#_runtime_path, idx)
  call dein#util#_add_after(rtps, g:dein#_runtime_path.'/after')
  let &runtimepath = dein#util#_join_rtp(rtps,
        \ &runtimepath, g:dein#_runtime_path)
endfunction
function! dein#util#_end() abort
  if g:dein#_block_level != 1
    call dein#util#_error('Invalid begin/end block usage.')
    return 1
  endif

  let g:dein#_block_level -= 1

  if !has('vim_starting')
    call dein#source(filter(values(g:dein#_plugins),
       \ "!v:val.lazy && !v:val.sourced && v:val.rtp !=# ''"))
  endif

  " Add runtimepath
  let rtps = dein#util#_split_rtp(&runtimepath)
  let index = index(rtps, g:dein#_runtime_path)
  if index < 0
    call dein#util#_error('Invalid runtimepath.')
    return 1
  endif

  let depends = []
  let sourced = has('vim_starting') &&
        \ (!exists('&loadplugins') || &loadplugins)
  for plugin in filter(values(g:dein#_plugins),
        \ "!v:val.lazy && !v:val.sourced && v:val.rtp !=# ''")
    " Load dependencies
    if has_key(plugin, 'depends')
      let depends += plugin.depends
    endif

    if !plugin.merged
      call insert(rtps, plugin.rtp, index)
      if isdirectory(plugin.rtp.'/after')
        call dein#util#_add_after(rtps, plugin.rtp.'/after')
      endif
    endif

    let plugin.sourced = sourced
  endfor
  let &runtimepath = dein#util#_join_rtp(rtps, &runtimepath, '')

  if !empty(depends)
    call dein#source(depends)
  endif

  if g:dein#_hook_add !=# ''
    call dein#util#_execute_hook({}, g:dein#_hook_add)
  endif

  for [event, plugins] in filter(items(g:dein#_event_plugins),
        \ "exists('##' . v:val[0])")
    execute printf('autocmd dein-events %s call '
          \. 'dein#autoload#_on_event("%s", %s)',
          \ (exists('##' . event) ? event . ' *' : 'User ' . event),
          \ event, string(plugins))
  endfor

  if !has('vim_starting')
    call dein#call_hook('add')
    call dein#call_hook('source')
    call dein#call_hook('post_source')
  endif
endfunction
function! dein#util#_config(arg, dict) abort
  let name = type(a:arg) == v:t_dict ?
        \   g:dein#name : a:arg
  let dict = type(a:arg) == v:t_dict ?
        \   a:arg : a:dict
  if !has_key(g:dein#_plugins, name)
        \ || g:dein#_plugins[name].sourced
    return {}
  endif

  let plugin = g:dein#_plugins[name]
  let options = extend({'repo': plugin.repo}, dict)
  if has_key(plugin, 'orig_opts')
    call extend(options, copy(plugin.orig_opts), 'keep')
  endif
  return dein#parse#_add(options.repo, options)
endfunction

function! dein#util#_call_hook(hook_name, ...) abort
  let hook = 'hook_' . a:hook_name
  let plugins = filter(dein#util#_get_plugins((a:0 ? a:1 : [])),
        \ "((a:hook_name !=# 'source'
        \    && a:hook_name !=# 'post_source') || v:val.sourced)
        \   && has_key(v:val, hook) && isdirectory(v:val.path)")

  for plugin in filter(dein#util#_tsort(plugins),
        \ 'has_key(v:val, hook)')
    call dein#util#_execute_hook(plugin, plugin[hook])
  endfor
endfunction
function! dein#util#_execute_hook(plugin, hook) abort
  try
    let g:dein#plugin = a:plugin

    if type(a:hook) == v:t_string
      call s:execute(a:hook)
    else
      call call(a:hook, [])
    endif
  catch
    call dein#util#_error(
          \ 'Error occurred while executing hook: ' .
          \ get(a:plugin, 'name', ''))
    call dein#util#_error(v:exception)
  endtry
endfunction
function! dein#util#_set_hook(plugins, hook_name, hook) abort
  let names = empty(a:plugins) ? keys(dein#get()) :
        \ dein#util#_convert2list(a:plugins)
  for name in names
    if !has_key(g:dein#_plugins, name)
      call dein#util#_error(name . ' is not found.')
      return 1
    endif
    let plugin = g:dein#_plugins[name]
    let plugin[a:hook_name] =
          \ type(a:hook) != v:t_string ? a:hook :
          \   substitute(a:hook, '\n\s*\\\|\%(^\|\n\)\s*"[^\n]*', '', 'g')
    if a:hook_name ==# 'hook_add'
      call dein#util#_execute_hook(plugin, plugin[a:hook_name])
    endif
  endfor
endfunction

function! dein#util#_sort_by(list, expr) abort
  let pairs = map(a:list, printf('[v:val, %s]', a:expr))
  return map(s:sort(pairs,
  \      'a:a[1] ==# a:b[1] ? 0 : a:a[1] ># a:b[1] ? 1 : -1'), 'v:val[0]')
endfunction
function! dein#util#_tsort(plugins) abort
  let sorted = []
  let mark = {}
  for target in a:plugins
    call s:tsort_impl(target, mark, sorted)
  endfor

  return sorted
endfunction

function! dein#util#_split_rtp(runtimepath) abort
  if stridx(a:runtimepath, '\,') < 0
    return split(a:runtimepath, ',')
  endif

  let split = split(a:runtimepath, '\\\@<!\%(\\\\\)*\zs,')
  return map(split,'substitute(v:val, ''\\\([\\,]\)'', ''\1'', ''g'')')
endfunction
function! dein#util#_join_rtp(list, runtimepath, rtp) abort
  return (stridx(a:runtimepath, '\,') < 0 && stridx(a:rtp, ',') < 0) ?
        \ join(a:list, ',') : join(map(copy(a:list), 's:escape(v:val)'), ',')
endfunction

function! dein#util#_add_after(rtps, path) abort
  let idx = index(a:rtps, $VIMRUNTIME)
  call insert(a:rtps, a:path, (idx <= 0 ? -1 : idx + 1))
endfunction

function! dein#util#_expand(path) abort
  let path = (a:path =~# '^\~') ? fnamemodify(a:path, ':p') :
        \ (a:path =~# '^\$\h\w*') ? substitute(a:path,
        \               '^\$\h\w*', '\=eval(submatch(0))', '') :
        \ a:path
  return (s:is_windows && path =~# '\\') ?
        \ dein#util#_substitute_path(path) : path
endfunction
function! dein#util#_substitute_path(path) abort
  return ((s:is_windows || has('win32unix')) && a:path =~# '\\') ?
        \ tr(a:path, '\', '/') : a:path
endfunction
function! dein#util#_globlist(path) abort
  return split(glob(a:path), '\n')
endfunction

function! dein#util#_convert2list(expr) abort
  return type(a:expr) ==# v:t_list ? copy(a:expr) :
        \ type(a:expr) ==# v:t_string ?
        \   (a:expr ==# '' ? [] : split(a:expr, '\r\?\n', 1))
        \ : [a:expr]
endfunction
function! dein#util#_split(expr) abort
  return type(a:expr) ==# v:t_list ? copy(a:expr) :
        \ split(a:expr, '\r\?\n')
endfunction

function! dein#util#_redir(cmd) abort
  if exists('*execute')
    return execute(a:cmd)
  else
    let [save_verbose, save_verbosefile] = [&verbose, &verbosefile]
    set verbose=0 verbosefile=
    redir => res
    silent! execute a:cmd
    redir END
    let [&verbose, &verbosefile] = [save_verbose, save_verbosefile]
    return res
  endif
endfunction

function! dein#util#_get_lazy_plugins() abort
  return filter(values(g:dein#_plugins),
        \ "!v:val.sourced && v:val.rtp !=# ''")
endfunction

function! dein#util#_get_plugins(plugins) abort
  return empty(a:plugins) ?
        \ values(dein#get()) :
        \ filter(map(dein#util#_convert2list(a:plugins),
        \   'type(v:val) == v:t_dict ? v:val : dein#get(v:val)'),
        \   '!empty(v:val)')
endfunction

function! dein#util#_disable(names) abort
  for plugin in map(filter(dein#util#_convert2list(a:names),
        \ 'has_key(g:dein#_plugins, v:val)
        \  && !g:dein#_plugins[v:val].sourced'), 'g:dein#_plugins[v:val]')
    if has_key(plugin, 'dummy_commands')
      for command in plugin.dummy_commands
        silent! execute 'delcommand' command[0]
      endfor
      let plugin.dummy_commands = []
    endif

    if has_key(plugin, 'dummy_mappings')
      for map in plugin.dummy_mappings
        silent! execute map[0].'unmap' map[1]
      endfor
      let plugin.dummy_mappings = []
    endif

    call remove(g:dein#_plugins, plugin.name)
  endfor
endfunction

function! dein#util#_download(uri, outpath) abort
  if !exists('g:dein#download_command')
    let g:dein#download_command =
          \ executable('curl') ?
          \   'curl --silent --location --output' :
          \ executable('wget') ?
          \   'wget -q -O' : ''
  endif
  if g:dein#download_command !=# ''
    return printf('%s "%s" "%s"',
          \ g:dein#download_command, a:outpath, a:uri)
  elseif dein#util#_is_windows()
    " Use powershell
    " Todo: Proxy support
    let pscmd = printf("(New-Object Net.WebClient).DownloadFile('%s', '%s')",
          \ a:uri, a:outpath)
    return printf('powershell -Command "%s"', pscmd)
  else
    return 'E: curl or wget command is not available!'
  endif
endfunction

function! s:tsort_impl(target, mark, sorted) abort
  if empty(a:target) || has_key(a:mark, a:target.name)
    return
  endif

  let a:mark[a:target.name] = 1
  if has_key(a:target, 'depends')
    for depend in a:target.depends
      call s:tsort_impl(dein#get(depend), a:mark, a:sorted)
    endfor
  endif

  call add(a:sorted, a:target)
endfunction

function! dein#util#_check_install(plugins) abort
  if !empty(a:plugins)
    let invalids = filter(dein#util#_convert2list(a:plugins),
          \ 'empty(dein#get(v:val))')
    if !empty(invalids)
      call dein#util#_error('Invalid plugins: ' .
            \ string(map(invalids, 'v:val')))
      return -1
    endif
  endif
  let plugins = empty(a:plugins) ? values(dein#get()) :
        \ map(dein#util#_convert2list(a:plugins), 'dein#get(v:val)')
  let plugins = filter(plugins, '!isdirectory(v:val.path)')
  if empty(plugins) | return 0 | endif
  call dein#util#_notify('Not installed plugins: ' .
        \ string(map(plugins, 'v:val.name')))
  return 1
endfunction

function! s:msg2list(expr) abort
  return type(a:expr) ==# v:t_list ? a:expr : split(a:expr, '\n')
endfunction
function! s:skipempty(string) abort
  return filter(split(a:string, '\n'), "v:val !=# ''")
endfunction

function! s:escape(path) abort
  " Escape a path for runtimepath.
  return substitute(a:path, ',\|\\,\@=', '\\\0', 'g')
endfunction

function! s:sort(list, expr) abort
  if type(a:expr) == v:t_func
    return sort(a:list, a:expr)
  endif
  let s:expr = a:expr
  return sort(a:list, 's:_compare')
endfunction
function! s:_compare(a, b) abort
  return eval(s:expr)
endfunction

function! s:execute(expr) abort
  if exists('*execute')
    return execute(split(a:expr, '\n'), '')
  endif

  let dummy = '_dein_dummy_' .
        \ substitute(reltimestr(reltime()), '\W', '_', 'g')
  execute 'function! '.dummy."() abort\n"
        \ . a:expr . "\nendfunction"
  call {dummy}()
  execute 'delfunction' dummy
endfunction

function! s:neovim_version() abort
  return str2float(matchstr(execute('version'), 'NVIM v\zs\d\.\d\.\d'))
endfunction
