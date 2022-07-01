function! dein#autoload#_source(...) abort
  let plugins = empty(a:000) ? values(g:dein#_plugins) :
        \ dein#util#_convert2list(a:1)
  if empty(plugins)
    return []
  endif

  if type(plugins[0]) != v:t_dict
    let plugins = map(dein#util#_convert2list(a:1),
        \       { _, val -> get(g:dein#_plugins, val, {}) })
  endif

  let rtps = dein#util#_split_rtp(&runtimepath)
  let index = index(rtps, dein#util#_get_runtime_path())
  if index < 0
    return []
  endif

  let sourced = []
  for plugin in filter(plugins,
        \ { _, val -> !empty(val) && !val.sourced && val.rtp !=# ''
        \             && (!has_key(v:val, 'if') || eval(v:val.if)) })
    call s:source_plugin(rtps, index, plugin, sourced)
  endfor

  let filetype_before = dein#util#_redir('autocmd FileType')
  let &runtimepath = dein#util#_join_rtp(rtps, &runtimepath, '')

  call dein#call_hook('source', sourced)

  " Reload script files.
  for plugin in sourced
    for directory in map(filter(
          \ ['ftdetect', 'after/ftdetect', 'plugin', 'after/plugin'],
          \ { _, val -> isdirectory(plugin.rtp . '/' . val) }),
          \ { _, val -> plugin.rtp . '/' . val })
      if directory =~# 'ftdetect'
        if !get(plugin, 'merge_ftdetect')
          execute 'augroup filetypedetect'
        endif
      endif
      let files = glob(directory . '/**/*.vim', v:true, v:true)
      if has('nvim')
        let files += glob(directory . '/**/*.lua', v:true, v:true)
      endif
      for file in files
        execute 'source' fnameescape(file)
      endfor
      if directory =~# 'ftdetect'
        execute 'augroup END'
      endif
    endfor

    if !has('vim_starting')
      let augroup = get(plugin, 'augroup', plugin.normalized_name)
      let events = ['VimEnter', 'BufRead', 'BufEnter',
            \ 'BufWinEnter', 'WinEnter']
      if has('gui_running') && &term ==# 'builtin_gui'
        call add(events, 'GUIEnter')
      endif
      for event in events
        if exists('#'.augroup.'#'.event)
          silent execute 'doautocmd' augroup event
        endif
      endfor

      " Register for lazy loaded denops plugin
      if isdirectory(plugin.rtp . '/denops')
        for name in filter(map(globpath(plugin.rtp,
              \ 'denops/*/main.ts', v:true, v:true),
              \ { _, val -> fnamemodify(val, ':h:t')}),
              \ { _, val -> !denops#plugin#is_loaded(val) })

          if denops#server#status() ==# 'running'
            " Note: denops#plugin#register() may be failed
            silent! call denops#plugin#register(name, { 'mode': 'skip' })
          endif
          call denops#plugin#wait(name)
          redraw
        endfor
      endif
    endif
  endfor

  let filetype_after = dein#util#_redir('autocmd FileType')

  let is_reset = s:is_reset_ftplugin(sourced)
  if is_reset
    call s:reset_ftplugin()
  endif

  if (is_reset || filetype_before !=# filetype_after) && &l:filetype !=# ''
    " Recall FileType autocmd
    let &l:filetype = &l:filetype
  endif

  if !has('vim_starting')
    call dein#call_hook('post_source', sourced)
  endif

  return sourced
endfunction

function! dein#autoload#_on_default_event(event) abort
  let lazy_plugins = dein#util#_get_lazy_plugins()
  let plugins = []

  let path = expand('<afile>')
  " For ":edit ~".
  if fnamemodify(path, ':t') ==# '~'
    let path = '~'
  endif
  let path = dein#util#_expand(path)

  for filetype in split(&l:filetype, '\.')
    let plugins += filter(copy(lazy_plugins),
          \ { _, val -> index(get(val, 'on_ft', []), filetype) >= 0 })
  endfor

  let plugins += filter(copy(lazy_plugins),
        \ { _, val -> !empty(filter(copy(get(val, 'on_path', [])),
        \                { _, val -> path =~? val })) })
  let plugins += filter(copy(lazy_plugins),
        \ { _, val -> !has_key(val, 'on_event') && has_key(val, 'on_if')
        \             && eval(val.on_if) })

  call s:source_events(a:event, plugins)
endfunction
function! dein#autoload#_on_event(event, plugins) abort
  let lazy_plugins = filter(dein#util#_get_plugins(a:plugins),
        \ { _, val -> !val.sourced })
  if empty(lazy_plugins)
    execute 'autocmd! dein-events' a:event
    return
  endif

  let plugins = filter(copy(lazy_plugins),
        \ { _, val -> !has_key(val, 'on_if') || eval(val.on_if) })
  call s:source_events(a:event, plugins)
endfunction
function! s:source_events(event, plugins) abort
  if empty(a:plugins)
    return
  endif

  let prev_autocmd = execute('autocmd ' . a:event)

  call dein#autoload#_source(a:plugins)

  let new_autocmd = execute('autocmd ' . a:event)

  if a:event ==# 'InsertCharPre'
    " Queue this key again
    call feedkeys(v:char)
    let v:char = ''
  else
    if exists('#BufReadCmd') && a:event ==# 'BufNew'
      " For BufReadCmd plugins
      silent doautocmd <nomodeline> BufReadCmd
    endif
    if exists('#' . a:event) && prev_autocmd !=# new_autocmd
      execute 'doautocmd <nomodeline>' a:event
    elseif exists('#User#' . a:event)
      execute 'doautocmd <nomodeline> User' a:event
    endif
  endif
endfunction

function! dein#autoload#_on_func(name) abort
  let function_prefix = substitute(a:name, '[^#]*$', '', '')
  if function_prefix =~# '^dein#'
        \ || function_prefix =~# '^vital#'
    return
  endif

  call dein#autoload#_source(filter(dein#util#_get_lazy_plugins(),
        \  { _, val -> stridx(function_prefix, val.normalized_name.'#') == 0
        \   || (index(get(val, 'on_func', []), a:name) >= 0) }))
endfunction

function! dein#autoload#_on_lua(name) abort
  if has_key(g:dein#_called_lua, a:name)
    return
  endif

  " Only use the root of module name.
  let mod_root = matchstr(a:name, '^[^./]\+')

  " Prevent infinite loop
  let g:dein#_called_lua[a:name] = v:true

  call dein#autoload#_source(filter(dein#util#_get_lazy_plugins(),
        \  { _, val -> index(get(val, 'on_lua', []), mod_root) >= 0 }))
endfunction

function! dein#autoload#_on_pre_cmd(name) abort
  call dein#autoload#_source(
        \ filter(dein#util#_get_lazy_plugins(),
        \ { _, val -> index(map(copy(get(val, 'on_cmd', [])),
        \            { _, val2 -> tolower(val2) }), a:name) >= 0
        \  || stridx(tolower(a:name),
        \            substitute(tolower(val.normalized_name),
        \                       '[_-]', '', 'g')) == 0 }))
endfunction

function! dein#autoload#_on_cmd(command, name, args, bang, line1, line2) abort
  call dein#source(a:name)

  if exists(':' . a:command) != 2
    call dein#util#_error(printf('command %s is not found.', a:command))
    return
  endif

  let range = (a:line1 == a:line2) ? '' :
        \ (a:line1 == line("'<") && a:line2 == line("'>")) ?
        \ "'<,'>" : a:line1.','.a:line2

  try
    execute range.a:command.a:bang a:args
  catch /^Vim\%((\a\+)\)\=:E481/
    " E481: No range allowed
    execute a:command.a:bang a:args
  endtry
endfunction

function! dein#autoload#_on_map(mapping, name, mode) abort
  let cnt = v:count > 0 ? v:count : ''

  let input = s:get_input()

  let sourced = dein#source(a:name)
  if empty(sourced)
    " Prevent infinite loop
    silent! execute a:mode.'unmap' a:mapping
  endif

  if a:mode ==# 'v' || a:mode ==# 'x'
    call feedkeys('gv', 'n')
  elseif a:mode ==# 'o' && v:operator !=# 'c'
    " TODO: omap
    " v:prevcount?
    " Cancel waiting operator mode.
    call feedkeys(v:operator, 'm')
  endif

  call feedkeys(cnt, 'n')

  if a:mode ==# 'o' && v:operator ==# 'c'
    " Note: This is the dirty hack.
    execute matchstr(s:mapargrec(a:mapping . input, a:mode),
          \ ':<C-u>\zs.*\ze<CR>')
  else
    let mapping = a:mapping
    while mapping =~# '<[[:alnum:]_-]\+>'
      let mapping = substitute(mapping, '\c<Leader>',
            \ get(g:, 'mapleader', '\'), 'g')
      let mapping = substitute(mapping, '\c<LocalLeader>',
            \ get(g:, 'maplocalleader', '\'), 'g')
      let ctrl = matchstr(mapping, '<\zs[[:alnum:]_-]\+\ze>')
      execute 'let mapping = substitute(
            \ mapping, "<' . ctrl . '>", "\<' . ctrl . '>", "")'
    endwhile
    call feedkeys(mapping . input, 'm')
  endif

  return ''
endfunction

function! dein#autoload#_dummy_complete(arglead, cmdline, cursorpos) abort
  let command = matchstr(a:cmdline, '\h\w*')
  if exists(':'.command) == 2
    " Remove the dummy command.
    silent! execute 'delcommand' command
  endif

  " Load plugins
  call dein#autoload#_on_pre_cmd(tolower(command))

  return [a:arglead]
endfunction

function! s:source_plugin(rtps, index, plugin, sourced) abort
  if a:plugin.sourced || index(a:sourced, a:plugin) >= 0
    \ || (has_key(a:plugin, 'if') && !eval(a:plugin.if))
    return
  endif

  call insert(a:sourced, a:plugin)

  let index = a:index

  " Note: on_source must sourced after depends
  for on_source in filter(dein#util#_get_lazy_plugins(),
        \ { _, val -> index(get(val, 'on_source', []), a:plugin.name) >= 0 })
    if s:source_plugin(a:rtps, index, on_source, a:sourced)
      let index += 1
    endif
  endfor

  " Load dependencies
  for name in get(a:plugin, 'depends', [])
    if !has_key(g:dein#_plugins, name)
      call dein#util#_error(printf(
            \ 'Plugin name "%s" is not found.', name))
      continue
    endif

    if !a:plugin.lazy && g:dein#_plugins[name].lazy
      call dein#util#_error(printf(
            \ 'Not lazy plugin "%s" depends lazy "%s" plugin.',
            \ a:plugin.name, name))
      continue
    endif

    if s:source_plugin(a:rtps, index, g:dein#_plugins[name], a:sourced)
      let index += 1
    endif
  endfor

  let a:plugin.sourced = 1

  if has_key(a:plugin, 'dummy_commands')
    for command in a:plugin.dummy_commands
      silent! execute 'delcommand' command[0]
    endfor
    let a:plugin.dummy_commands = []
  endif

  if has_key(a:plugin, 'dummy_mappings')
    for map in a:plugin.dummy_mappings
      silent! execute map[0].'unmap' map[1]
    endfor
    let a:plugin.dummy_mappings = []
  endif

  if !a:plugin.merged || get(a:plugin, 'local', 0)
    call insert(a:rtps, a:plugin.rtp, index)
    if isdirectory(a:plugin.rtp.'/after')
      call dein#util#_add_after(a:rtps, a:plugin.rtp.'/after')
    endif
  endif

  if get(g:, 'dein#lazy_rplugins', v:false) && !g:dein#_loaded_rplugins
        \ && isdirectory(a:plugin.rtp.'/rplugin')
    " Enable remote plugin
    unlet! g:loaded_remote_plugins

    runtime! plugin/rplugin.vim

    let g:dein#_loaded_rplugins = v:true
  endif
endfunction
function! s:reset_ftplugin() abort
  let filetype_state = dein#util#_redir('filetype')

  if exists('b:did_indent') || exists('b:did_ftplugin')
    filetype plugin indent off
  endif

  if filetype_state =~# 'plugin:ON'
    silent! filetype plugin on
  endif

  if filetype_state =~# 'indent:ON'
    silent! filetype indent on
  endif
endfunction
function! s:get_input() abort
  let input = ''
  let termstr = '<M-_>'

  call feedkeys(termstr, 'n')

  while 1
    let char = getchar()
    let input .= (type(char) == v:t_number) ? nr2char(char) : char

    let idx = stridx(input, termstr)
    if idx >= 1
      let input = input[: idx - 1]
      break
    elseif idx == 0
      let input = ''
      break
    endif
  endwhile

  return input
endfunction

function! s:is_reset_ftplugin(plugins) abort
  if &l:filetype ==# ''
    return 0
  endif

  for plugin in a:plugins
    let ftplugin = plugin.rtp . '/ftplugin/' . &l:filetype
    let after = plugin.rtp . '/after/ftplugin/' . &l:filetype
    let check_ftplugin = !empty(filter(['ftplugin', 'indent',
        \ 'after/ftplugin', 'after/indent',],
        \ { _, val -> filereadable(printf('%s/%s/%s.vim',
        \                          plugin.rtp, val, &l:filetype))
        \          || filereadable(printf('%s/%s/%s.lua',
        \                          plugin.rtp, val, &l:filetype))}))
    if check_ftplugin
          \ || isdirectory(ftplugin) || isdirectory(after)
          \ || glob(ftplugin. '_*.vim', v:true) !=# ''
          \ || glob(after . '_*.vim', v:true) !=# ''
          \ || glob(ftplugin. '_*.lua', v:true) !=# ''
          \ || glob(after . '_*.lua', v:true) !=# ''
      return 1
    endif
  endfor
  return 0
endfunction
function! s:mapargrec(map, mode) abort
  let arg = maparg(a:map, a:mode)
  while maparg(arg, a:mode) !=# ''
    let arg = maparg(arg, a:mode)
  endwhile
  return arg
endfunction
