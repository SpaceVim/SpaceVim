"=============================================================================
" FILE: parse.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" Global options definition."
let g:dein#enable_name_conversion =
      \ get(g:, 'dein#enable_name_conversion', 0)


let s:git = dein#types#git#define()

function! dein#parse#_add(repo, options) abort
  let plugin = dein#parse#_dict(dein#parse#_init(a:repo, a:options))
  if (has_key(g:dein#_plugins, plugin.name)
        \ && g:dein#_plugins[plugin.name].sourced)
        \ || !get(plugin, 'if', 1)
    " Skip already loaded or not enabled plugin.
    return {}
  endif

  if plugin.lazy && plugin.rtp !=# ''
    call s:parse_lazy(plugin)
  endif

  if has_key(g:dein#_plugins, plugin.name)
        \ && g:dein#_plugins[plugin.name].sourced
    let plugin.sourced = 1
  endif
  let g:dein#_plugins[plugin.name] = plugin
  if has_key(plugin, 'hook_add')
    call dein#util#_execute_hook(plugin, plugin.hook_add)
  endif
  if has_key(plugin, 'ftplugin')
    call s:merge_ftplugin(plugin.ftplugin)
  endif
  return plugin
endfunction
function! dein#parse#_init(repo, options) abort
  let repo = dein#util#_expand(a:repo)
  let plugin = has_key(a:options, 'type') ?
        \ dein#util#_get_type(a:options.type).init(repo, a:options) :
        \ s:git.init(repo, a:options)
  if empty(plugin)
    let plugin = s:check_type(repo, a:options)
  endif
  call extend(plugin, a:options)
  let plugin.repo = repo
  if !empty(a:options)
    let plugin.orig_opts = deepcopy(a:options)
  endif
  return plugin
endfunction
function! dein#parse#_dict(plugin) abort
  let plugin = {
        \ 'rtp': '',
        \ 'sourced': 0,
        \ }
  call extend(plugin, a:plugin)

  if !has_key(plugin, 'name')
    let plugin.name = dein#parse#_name_conversion(plugin.repo)
  endif

  if !has_key(plugin, 'normalized_name')
    let plugin.normalized_name = substitute(
          \ fnamemodify(plugin.name, ':r'),
          \ '\c^n\?vim[_-]\|[_-]n\?vim$', '', 'g')
  endif

  if !has_key(a:plugin, 'name') && g:dein#enable_name_conversion
    " Use normalized name.
    let plugin.name = plugin.normalized_name
  endif

  if !has_key(plugin, 'path')
    let plugin.path = (plugin.repo =~# '^/\|^\a:[/\\]') ?
          \ plugin.repo : dein#util#_get_base_path().'/repos/'.plugin.name
  endif

  let plugin.path = dein#util#_chomp(dein#util#_expand(plugin.path))
  if get(plugin, 'rev', '') !=# ''
    " Add revision path
    let plugin.path .= '_' . substitute(
          \ plugin.rev, '[^[:alnum:].-]', '_', 'g')
  endif

  " Check relative path
  if (!has_key(a:plugin, 'rtp') || a:plugin.rtp !=# '')
        \ && plugin.rtp !~# '^\%([~/]\|\a\+:\)'
    let plugin.rtp = plugin.path.'/'.plugin.rtp
  endif
  if plugin.rtp[0:] ==# '~'
    let plugin.rtp = dein#util#_expand(plugin.rtp)
  endif
  let plugin.rtp = dein#util#_chomp(plugin.rtp)
  if g:dein#_is_sudo && !get(plugin, 'trusted', 0)
    let plugin.rtp = ''
  endif

  if has_key(plugin, 'script_type')
    " Add script_type.
    let plugin.path .= '/' . plugin.script_type
  endif

  if has_key(plugin, 'depends') && type(plugin.depends) != v:t_list
    let plugin.depends = [plugin.depends]
  endif

  " Deprecated check.
  for key in filter(['directory', 'base'], 'has_key(plugin, v:val)')
    call dein#util#_error('plugin name = ' . plugin.name)
    call dein#util#_error(string(key) . ' is deprecated.')
  endfor

  if !has_key(plugin, 'lazy')
    let plugin.lazy =
          \    has_key(plugin, 'on_i')
          \ || has_key(plugin, 'on_idle')
          \ || has_key(plugin, 'on_ft')
          \ || has_key(plugin, 'on_cmd')
          \ || has_key(plugin, 'on_func')
          \ || has_key(plugin, 'on_map')
          \ || has_key(plugin, 'on_path')
          \ || has_key(plugin, 'on_if')
          \ || has_key(plugin, 'on_event')
          \ || has_key(plugin, 'on_source')
  endif

  if !has_key(a:plugin, 'merged')
    let plugin.merged = !plugin.lazy
          \ && plugin.normalized_name !=# 'dein'
          \ && !has_key(plugin, 'local')
          \ && !has_key(plugin, 'build')
          \ && !has_key(plugin, 'if')
          \ && stridx(plugin.rtp, dein#util#_get_base_path()) == 0
  endif

  if has_key(plugin, 'if') && type(plugin.if) == v:t_string
    let plugin.if = eval(a:plugin.if)
  endif

  " Hooks
  for hook in filter([
        \ 'hook_add', 'hook_source',
        \ 'hook_post_source', 'hook_post_update',
        \ ], 'has_key(plugin, v:val) && type(plugin[v:val]) == v:t_string')
    let plugin[hook] = substitute(plugin[hook],
          \ '\n\s*\\\|\%(^\|\n\)\s*"[^\n]*', '', 'g')
  endfor

  return plugin
endfunction
function! dein#parse#_load_toml(filename, default) abort
  try
    let toml = dein#toml#parse_file(dein#util#_expand(a:filename))
  catch /Text.TOML:/
    call dein#util#_error('Invalid toml format: ' . a:filename)
    call dein#util#_error(v:exception)
    return 1
  endtry
  if type(toml) != v:t_dict
    call dein#util#_error('Invalid toml file: ' . a:filename)
    return 1
  endif

  " Parse.
  if has_key(toml, 'hook_add')
    let pattern = '\n\s*\\\|\%(^\|\n\)\s*"[^\n]*'
    let g:dein#_hook_add .= "\n" . substitute(
          \ toml.hook_add, pattern, '', 'g')
  endif
  if has_key(toml, 'ftplugin')
    call s:merge_ftplugin(toml.ftplugin)
  endif

  if has_key(toml, 'plugins')
    for plugin in toml.plugins
      if !has_key(plugin, 'repo')
        call dein#util#_error('No repository plugin data: ' . a:filename)
        return 1
      endif

      let options = extend(plugin, a:default, 'keep')
      call dein#add(plugin.repo, options)
    endfor
  endif

  " Add to g:dein#_vimrcs
  call add(g:dein#_vimrcs, dein#util#_expand(a:filename))
endfunction
function! dein#parse#_plugins2toml(plugins) abort
  let toml = []

  let default = dein#parse#_dict(dein#parse#_init('', {}))
  let default.if = ''
  let default.frozen = 0
  let default.local = 0
  let default.depends = []
  let default.on_i = 0
  let default.on_idle = 0
  let default.on_ft = []
  let default.on_cmd = []
  let default.on_func = []
  let default.on_map = []
  let default.on_path = []
  let default.on_source = []
  let default.build = ''
  let default.hook_add = ''
  let default.hook_source = ''
  let default.hook_post_source = ''
  let default.hook_post_update = ''

  let skip_default = {
        \ 'type': 1,
        \ 'path': 1,
        \ 'rtp': 1,
        \ 'sourced': 1,
        \ 'orig_opts': 1,
        \ 'repo': 1,
        \ }

  for plugin in dein#util#_sort_by(a:plugins, 'v:val.repo')
    let toml += ['[[plugins]]',
          \ 'repo = ' . string(plugin.repo)]

    for key in filter(sort(keys(default)),
          \ '!has_key(skip_default, v:val) && has_key(plugin, v:val)
          \  && (type(plugin[v:val]) !=# type(default[v:val])
          \      || plugin[v:val] !=# default[v:val])')
      let val = plugin[key]
      if key =~# '^hook_'
        call add(toml, key . " = '''")
        let toml += split(val, '\n')
        call add(toml, "'''")
      else
        call add(toml, key . ' = ' . string(
              \ (type(val) == v:t_list && len(val) == 1) ? val[0] : val))
      endif
      unlet! val
    endfor

    call add(toml, '')
  endfor

  return toml
endfunction
function! dein#parse#_load_dict(dict, default) abort
  for [repo, options] in items(a:dict)
    call dein#add(repo, extend(copy(options), a:default, 'keep'))
  endfor
endfunction
function! dein#parse#_local(localdir, options, includes) abort
  let base = fnamemodify(dein#util#_expand(a:localdir), ':p')
  let directories = []
  for glob in a:includes
    let directories += map(filter(dein#util#_globlist(base . glob),
          \ 'isdirectory(v:val)'), "
          \ substitute(dein#util#_substitute_path(
          \   fnamemodify(v:val, ':p')), '/$', '', '')")
  endfor

  for dir in dein#util#_uniq(directories)
    let options = extend({
          \ 'repo': dir, 'local': 1, 'path': dir,
          \ 'name': fnamemodify(dir, ':t')
          \ }, a:options)

    if has_key(g:dein#_plugins, options.name)
      call dein#config(options.name, options)
    else
      call dein#add(dir, options)
    endif
  endfor
endfunction
function! s:parse_lazy(plugin) abort
  " Auto convert2list.
  for key in filter([
        \ 'on_ft', 'on_path', 'on_cmd', 'on_func', 'on_map',
        \ 'on_source', 'on_event',
        \ ], 'has_key(a:plugin, v:val)
        \     && type(a:plugin[v:val]) != v:t_list
        \     && type(a:plugin[v:val]) != v:t_dict
        \')
    let a:plugin[key] = [a:plugin[key]]
  endfor

  if get(a:plugin, 'on_i', 0)
    let a:plugin.on_event = ['InsertEnter']
  endif
  if get(a:plugin, 'on_idle', 0)
    let a:plugin.on_event = ['FocusLost', 'CursorHold']
  endif
  if has_key(a:plugin, 'on_event')
    for event in a:plugin.on_event
      if !has_key(g:dein#_event_plugins, event)
        let g:dein#_event_plugins[event] = [a:plugin.name]
      else
        call add(g:dein#_event_plugins[event], a:plugin.name)
        let g:dein#_event_plugins[event] = dein#util#_uniq(
              \ g:dein#_event_plugins[event])
      endif
    endfor
  endif

  if has_key(a:plugin, 'on_cmd')
    call s:generate_dummy_commands(a:plugin)
  endif
  if has_key(a:plugin, 'on_map')
    call s:generate_dummy_mappings(a:plugin)
  endif
endfunction
function! s:generate_dummy_commands(plugin) abort
  let a:plugin.dummy_commands = []
  for name in a:plugin.on_cmd
    " Define dummy commands.
    let raw_cmd = 'command '
          \ . '-complete=customlist,dein#autoload#_dummy_complete'
          \ . ' -bang -bar -range -nargs=* '. name
          \ . printf(" call dein#autoload#_on_cmd(%s, %s, <q-args>,
          \  expand('<bang>'), expand('<line1>'), expand('<line2>'))",
          \   string(name), string(a:plugin.name))

    call add(a:plugin.dummy_commands, [name, raw_cmd])
    silent! execute raw_cmd
  endfor
endfunction
function! s:generate_dummy_mappings(plugin) abort
  let a:plugin.dummy_mappings = []
  let items = type(a:plugin.on_map) == v:t_dict ?
        \ map(items(a:plugin.on_map),
        \   "[split(v:val[0], '\\zs'), dein#util#_convert2list(v:val[1])]") :
        \ map(copy(a:plugin.on_map),
        \  "type(v:val) == v:t_list ?
        \     [split(v:val[0], '\\zs'), v:val[1:]] :
        \     [['n', 'x'], [v:val]]")
  for [modes, mappings] in items
    if mappings ==# ['<Plug>']
      " Use plugin name.
      let mappings = ['<Plug>(' . a:plugin.normalized_name]
      if stridx(a:plugin.normalized_name, '-') >= 0
        " The plugin mappings may use "_" instead of "-".
        call add(mappings, '<Plug>(' .
              \ substitute(a:plugin.normalized_name, '-', '_', 'g'))
      endif
    endif

    for mapping in mappings
      " Define dummy mappings.
      let prefix = printf('dein#autoload#_on_map(%s, %s,',
            \ string(substitute(mapping, '<', '<lt>', 'g')),
            \ string(a:plugin.name))
      for mode in modes
        let raw_map = mode.'noremap <unique><silent> '.mapping
            \ . (mode ==# 'c' ? " \<C-r>=" :
            \    mode ==# 'i' ? " \<C-o>:call " : " :\<C-u>call ") . prefix
            \ . string(mode) . ')<CR>'
        call add(a:plugin.dummy_mappings, [mode, mapping, raw_map])
        silent! execute raw_map
      endfor
    endfor
  endfor
endfunction
function! s:merge_ftplugin(ftplugin) abort
  let pattern = '\n\s*\\\|\%(^\|\n\)\s*"[^\n]*'
  for [ft, val] in items(a:ftplugin)
    if !has_key(g:dein#_ftplugin, ft)
      let g:dein#_ftplugin[ft] = val
    else
      let g:dein#_ftplugin[ft] .= "\n" . val
    endif
  endfor
  call map(g:dein#_ftplugin, "substitute(v:val, pattern, '', 'g')")
endfunction

function! dein#parse#_get_types() abort
  if !exists('s:types')
    " Load types.
    let s:types = {}
    for type in filter(map(split(globpath(&runtimepath,
          \ 'autoload/dein/types/*.vim', 1), '\n'),
          \ "dein#types#{fnamemodify(v:val, ':t:r')}#define()"),
          \ '!empty(v:val)')
      let s:types[type.name] = type
    endfor
  endif
  return s:types
endfunction
function! s:check_type(repo, options) abort
  let plugin = {}
  for type in values(dein#parse#_get_types())
    let plugin = type.init(a:repo, a:options)
    if !empty(plugin)
      break
    endif
  endfor

  if empty(plugin)
    let plugin.type = 'none'
    let plugin.local = 1
    let plugin.path = isdirectory(a:repo) ? a:repo : ''
  endif

  return plugin
endfunction

function! dein#parse#_name_conversion(path) abort
  return fnamemodify(get(split(a:path, ':'), -1, ''),
        \ ':s?/$??:t:s?\c\.git\s*$??')
endfunction
