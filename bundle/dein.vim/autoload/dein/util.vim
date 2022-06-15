let s:is_windows = has('win32') || has('win64')
let s:merged_length = 3

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
  call dein#util#_safe_mkdir(g:dein#_runtime_path)
  return g:dein#_runtime_path
endfunction
function! dein#util#_get_cache_path() abort
  if g:dein#_cache_path !=# ''
    return g:dein#_cache_path
  endif

  let g:dein#_cache_path = dein#util#_substitute_path(
        \ get(g:, 'dein#cache_directory', g:dein#_base_path)
        \ . '/.cache/' . fnamemodify(dein#util#_get_myvimrc(), ':t'))
  call dein#util#_safe_mkdir(g:dein#_cache_path)
  return g:dein#_cache_path
endfunction
function! dein#util#_get_vimrcs(vimrcs) abort
  return !empty(a:vimrcs) ?
        \ map(dein#util#_convert2list(a:vimrcs),
        \     { _, val -> dein#util#_substitute_path(expand(val)) }) :
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
        \ 'g:dein#enable_notification', v:false)
  call dein#util#_set_default(
        \ 'g:dein#notification_icon', '')
  call dein#util#_set_default(
        \ 'g:dein#notification_time', 2000)

  if !g:dein#enable_notification || a:msg ==# ''
    call dein#util#_error(a:msg)
    return
  endif

  let title = '[dein]'

  if has('nvim')
    if dein#util#_luacheck('notify')
      " Use nvim-notify plugin
      call luaeval('require("notify")(_A.msg, "info", {'.
            \ 'timeout=vim.g["dein#notification_time"],'.
            \ 'title=_A.title })',
            \ { 'msg': a:msg, 'title': title })
    else
      call nvim_notify(a:msg, 1, {})
    endif
  else
    if dein#is_available('vim-notification') ||
        \ exists('g:loaded_notification')
      " Use vim-notification plugin
      call notification#show({
            \ 'text': a:msg,
            \ 'title': title,
            \ 'wait': g:dein#notification_time,
            \ })
    else
      call popup_notification(a:msg, {
            \ 'title': title,
            \ 'time': g:dein#notification_time,
            \ })
    endif
  endif
endfunction
function! dein#util#_luacheck(module) abort
  return luaeval('pcall(require, _A.module)', { 'module': a:module })
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

function! dein#util#_check_lazy_plugins() abort
  return map(filter(dein#util#_get_lazy_plugins(), { _, val ->
        \    isdirectory(val.rtp)
        \    && !get(val, 'local', 0)
        \    && get(val, 'hook_source', '') ==# ''
        \    && get(val, 'hook_add', '') ==# ''
        \    && !isdirectory(val.rtp . '/plugin')
        \    && !isdirectory(val.rtp . '/after/plugin')
        \ }), { _, val -> val.name })
endfunction
function! dein#util#_check_clean() abort
  let plugins_directories = map(values(dein#get()), { _, val -> val.path })
  let path = dein#util#_substitute_path(
        \ globpath(dein#util#_get_base_path(), 'repos/*/*/*', v:true))
  return filter(split(path, "\n"),
        \ { _, val -> isdirectory(val)
        \  && fnamemodify(val, ':t') !=# 'dein.vim'
        \  && index(plugins_directories, val) < 0
        \ })
endfunction

function! dein#util#_cache_writefile(list, path) abort
  if !filewritable(dein#util#_get_cache_path())
    return 1
  endif

  let path = dein#util#_get_cache_path() . '/' . a:path
  return dein#util#_safe_writefile(a:list, path)
endfunction
function! dein#util#_safe_writefile(list, path, ...) abort
  if g:dein#_is_sudo
    return 1
  endif

  call dein#util#_safe_mkdir(fnamemodify(a:path, ':h'))
  return writefile(a:list, a:path, get(a:000, 0, ''))
endfunction
function! dein#util#_safe_mkdir(path) abort
  if g:dein#_is_sudo || isdirectory(a:path)
    return 1
  endif
  return mkdir(a:path, 'p')
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
    if has_key(plugin, 'called')
      call remove(plugin, 'called')
    endif

    " Hooks
    for hook in filter([
          \ 'hook_add', 'hook_source',
          \ 'hook_post_source', 'hook_post_update',
          \ ], { _, val -> has_key(plugin, val)
          \      && type(plugin[val]) == v:t_func })
      call remove(plugin, hook)
    endfor
  endfor

  call dein#util#_safe_mkdir(g:dein#_base_path)

  let src = [plugins, g:dein#_ftplugin]
  call dein#util#_safe_writefile(
        \ has('nvim') ? [json_encode(src)] : [js_encode(src)],
        \ get(g:, 'dein#cache_directory', g:dein#_base_path)
        \ .'/cache_' . g:dein#_progname)
endfunction
function! dein#util#_check_vimrcs() abort
  let time = getftime(dein#util#_get_runtime_path())
  let ret = !empty(filter(map(copy(g:dein#_vimrcs),
        \ { _, val -> getftime(expand(val)) }),
        \ { _, val -> time < val }))
  if !ret
    return 0
  endif

  call dein#clear_state()

  return ret
endfunction

function! dein#util#_save_state(is_starting) abort
  if g:dein#_block_level != 0
    call dein#util#_error('Invalid dein#save_state() usage.')
    return 1
  endif

  if dein#util#_get_cache_path() ==# '' || !a:is_starting || g:dein#_is_sudo
    " Ignore
    return 1
  endif

  if get(g:, 'dein#auto_recache', v:false)
    call dein#util#_notify('auto recached')
    call dein#recache_runtimepath()
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
        \ 'let [s:plugins, s:ftplugin] = dein#min#_load_cache_raw('.
        \      string(g:dein#_vimrcs) .')',
        \ "if empty(s:plugins) | throw 'Cache loading error' | endif",
        \ 'let g:dein#_plugins = s:plugins',
        \ 'let g:dein#_ftplugin = s:ftplugin',
        \ 'let g:dein#_base_path = ' . string(g:dein#_base_path),
        \ 'let g:dein#_runtime_path = ' . string(g:dein#_runtime_path),
        \ 'let g:dein#_cache_path = ' . string(g:dein#_cache_path),
        \ 'let g:dein#_on_lua_plugins = ' . string(g:dein#_on_lua_plugins),
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
  for plugin in filter(dein#util#_tsort(values(dein#get())),
        \ { _, val ->
        \   isdirectory(val.path) && (!has_key(val, 'if') || eval(val.if))
        \ })
    if has_key(plugin, 'hook_add') && type(plugin.hook_add) == v:t_string
      let lines += s:skipempty(plugin.hook_add)
    endif

    " Invalid hooks detection
    for key in keys(filter(copy(plugin),
          \ { key, val -> stridx(key, 'hook_') == 0
          \                && type(val) != v:t_string }))
        call dein#util#_error(
              \ printf('%s: "%s" must be string to save state',
              \        plugin.name, key))
    endfor
  endfor

  " Add events
  for [event, plugins] in filter(items(g:dein#_event_plugins),
        \ { _, val -> exists('##' . val[0]) })
    call add(lines, printf('autocmd dein-events %s call '
          \. 'dein#autoload#_on_event("%s", %s)',
          \ (exists('##' . event) ? event . ' *' : 'User ' . event),
          \ event, string(plugins)))
  endfor

  " Add inline vimrcs
  for vimrc in get(g:, 'dein#inline_vimrcs', [])
    let lines += filter(readfile(vimrc),
          \ { _, val -> val !=# '' && val !~# '^\s*"' })
  endfor

  let state = get(g:, 'dein#cache_directory', g:dein#_base_path)
        \ . '/state_' . g:dein#_progname . '.vim'
  call dein#util#_safe_writefile(lines, state)
endfunction
function! dein#util#_clear_state() abort
  let base = get(g:, 'dein#cache_directory', g:dein#_base_path)
  for cache in glob(base.'/state_*.vim', v:true, v:true)
        \ + glob(base.'/cache_*', v:true, v:true)
    call delete(cache)
  endfor
endfunction

function! dein#util#_begin(path, vimrcs) abort
  if !exists('#dein')
    call dein#min#_init()
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
  if exists('g:dein#inline_vimrcs')
    let g:dein#_vimrcs += g:dein#inline_vimrcs
  endif
  let g:dein#_hook_add = ''

  if has('vim_starting')
    " Filetype off
    if (!has('nvim') && get(g:, 'did_load_filetypes', v:false))
          \ || (has('nvim') && !get(g:, 'do_filetype_lua', v:false))
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
  let idx = index(rtps, dein#util#_substitute_path($VIMRUNTIME))
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
       \ { _, val -> !val.lazy && !val.sourced && val.rtp !=# '' }))
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
        \ { _, val -> !empty(val)
        \             && !val.lazy && !val.sourced && val.rtp !=# ''
        \             && (!has_key(v:val, 'if') || eval(v:val.if)) })

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

  for multi in filter(copy(g:dein#_multiple_plugins),
        \ { _, val -> dein#is_available(val.plugins) })
    if has_key(multi, 'hook_add')
      let g:dein#_hook_add .= "\n" . substitute(
            \ multi.hook_add, '\n\s*\\', '', 'g')
    endif
  endfor

  if g:dein#_hook_add !=# ''
    call dein#util#_execute_hook({}, g:dein#_hook_add)
  endif

  for [event, plugins] in filter(items(g:dein#_event_plugins),
        \ { _, val -> exists('##' . val[0]) })
    execute printf('autocmd dein-events %s call '
          \. 'dein#autoload#_on_event("%s", %s)',
          \ (exists('##' . event) ? event . ' *' : 'User ' . event),
          \ event, string(plugins))
  endfor

  for vimrc in get(g:, 'dein#inline_vimrcs', [])
    execute 'source' fnameescape(vimrc)
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
  return dein#parse#_add(options.repo, options, v:true)
endfunction

function! dein#util#_call_hook(hook_name, ...) abort
  let hook = 'hook_' . a:hook_name
  let plugins = filter(dein#util#_tsort(
        \ dein#util#_get_plugins((a:0 ? a:1 : []))),
        \ { _, val ->
        \    ((a:hook_name !=# 'source'
        \      && a:hook_name !=# 'post_source') || val.sourced)
        \    && has_key(val, hook) && isdirectory(val.path)
        \    && (!has_key(val, 'if') || eval(val.if))
        \ })
  for plugin in plugins
    call dein#util#_execute_hook(plugin, plugin[hook])
  endfor
endfunction
function! dein#util#_execute_hook(plugin, hook) abort
  " Skip twice call
  if !has_key(a:plugin, 'called')
    let a:plugin.called = {}
  endif
  if has_key(a:plugin.called, string(a:hook))
    return
  endif

  try
    let g:dein#plugin = a:plugin

    if type(a:hook) == v:t_string
      call s:execute(a:hook)
    else
      call call(a:hook, [])
    endif

    let a:plugin.called[string(a:hook)] = v:true
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
      call dein#util#_call_hook('add', plugin)
    endif
  endfor
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
    let rtps = split(a:runtimepath, ',')
  else
    let split = split(a:runtimepath, '\\\@<!\%(\\\\\)*\zs,')
    let rtps = map(split,
          \ { _, val -> substitute(val, '\\\([\\,]\)', '\1', 'g') })
  endif
  return map(rtps, { _, val -> dein#util#_substitute_path(val) })
endfunction
function! dein#util#_join_rtp(list, runtimepath, rtp) abort
  return (stridx(a:runtimepath, '\,') < 0 && stridx(a:rtp, ',') < 0) ?
        \ join(a:list, ',') : join(map(copy(a:list),
        \ { _, val -> s:escape(val) }), ',')
endfunction

function! dein#util#_add_after(rtps, path) abort
  let idx = index(a:rtps, dein#util#_substitute_path($VIMRUNTIME))
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
        \ { _, val -> !val.sourced && val.rtp !=# '' })
endfunction

function! dein#util#_get_plugins(plugins) abort
  return empty(a:plugins) ?
        \ values(dein#get()) :
        \ filter(map(dein#util#_convert2list(a:plugins),
        \   { _, val -> type(val) == v:t_dict ? val : dein#get(val) }),
        \   { _, val -> !empty(val) })
endfunction

function! dein#util#_disable(names) abort
  for plugin in map(filter(dein#util#_convert2list(a:names),
        \ { _, val ->
        \   has_key(g:dein#_plugins, val) && !g:dein#_plugins[val].sourced
        \ }), { _, val -> g:dein#_plugins[val]})
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
  if g:dein#_is_sudo
    return
  endif

  if !empty(a:plugins)
    let invalids = filter(dein#util#_convert2list(a:plugins),
          \ { _, val -> empty(dein#get(val)) })
    if !empty(invalids)
      call dein#util#_error('Invalid plugins: ' . string(invalids))
      return -1
    endif
  endif
  let plugins = empty(a:plugins) ? values(dein#get()) :
        \ map(dein#util#_convert2list(a:plugins),
        \     { _, val -> dein#get(val) })
  let plugins = filter(plugins, { _, val -> !isdirectory(val.path) })
  if empty(plugins) | return 0 | endif
  call dein#util#_notify('Not installed plugins: ' .
        \ string(map(plugins, { _, val -> val.name })))
  return 1
endfunction

function! s:msg2list(expr) abort
  return type(a:expr) ==# v:t_list ? a:expr : split(a:expr, '\n')
endfunction
function! s:skipempty(string) abort
  return filter(split(a:string, '\n'), { _, val -> val !=# '' })
endfunction

function! s:escape(path) abort
  " Escape a path for runtimepath.
  return substitute(a:path, ',\|\\,\@=', '\\\0', 'g')
endfunction
function! dein#util#escape_match(str) abort
  return escape(a:str, '~\.^$[]')
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
