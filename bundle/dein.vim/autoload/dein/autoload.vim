"=============================================================================
" FILE: autoload.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! dein#autoload#_source(...) abort
  let plugins = empty(a:000) ? values(g:dein#_plugins) :
        \ dein#util#_convert2list(a:1)
  if empty(plugins)
    return
  endif

  if type(plugins[0]) != v:t_dict
    let plugins = map(dein#util#_convert2list(a:1),
        \       'get(g:dein#_plugins, v:val, {})')
  endif

  let rtps = dein#util#_split_rtp(&runtimepath)
  let index = index(rtps, dein#util#_get_runtime_path())
  if index < 0
    return 1
  endif

  let sourced = []
  for plugin in filter(plugins,
        \ "!empty(v:val) && !v:val.sourced && v:val.rtp !=# ''")
    call s:source_plugin(rtps, index, plugin, sourced)
  endfor

  let filetype_before = dein#util#_redir('autocmd FileType')
  let &runtimepath = dein#util#_join_rtp(rtps, &runtimepath, '')

  call dein#call_hook('source', sourced)

  " Reload script files.
  for plugin in sourced
    for directory in filter(['plugin', 'after/plugin'],
          \ "isdirectory(plugin.rtp.'/'.v:val)")
      for file in dein#util#_globlist(plugin.rtp.'/'.directory.'/**/*.vim')
        execute 'source' fnameescape(file)
      endfor
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
    endif
  endfor

  let filetype_after = dein#util#_redir('autocmd FileType')

  let is_reset = s:is_reset_ftplugin(sourced)
  if is_reset
    call s:reset_ftplugin()
  endif

  if (is_reset || filetype_before !=# filetype_after) && &filetype !=# ''
    " Recall FileType autocmd
    let &filetype = &filetype
  endif

  if !has('vim_starting')
    call dein#call_hook('post_source', sourced)
  endif
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
          \ "index(get(v:val, 'on_ft', []), filetype) >= 0")
  endfor

  let plugins += filter(copy(lazy_plugins),
        \ "!empty(filter(copy(get(v:val, 'on_path', [])),
        \                'path =~? v:val'))")
  let plugins += filter(copy(lazy_plugins),
        \ "!has_key(v:val, 'on_event')
        \  && has_key(v:val, 'on_if') && eval(v:val.on_if)")

  call s:source_events(a:event, plugins)
endfunction
function! dein#autoload#_on_event(event, plugins) abort
  let lazy_plugins = filter(dein#util#_get_plugins(a:plugins),
        \ '!v:val.sourced')
  if empty(lazy_plugins)
    execute 'autocmd! dein-events' a:event
    return
  endif

  let plugins = filter(copy(lazy_plugins),
        \ "!has_key(v:val, 'on_if') || eval(v:val.on_if)")
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
        \ || has('vim_starting')
    return
  endif

  call dein#autoload#_source(filter(dein#util#_get_lazy_plugins(),
        \  "stridx(function_prefix, v:val.normalized_name.'#') == 0
        \   || (index(get(v:val, 'on_func', []), a:name) >= 0)"))
endfunction

function! dein#autoload#_on_pre_cmd(name) abort
  call dein#autoload#_source(
        \ filter(dein#util#_get_lazy_plugins(),
        \ "index(map(copy(get(v:val, 'on_cmd', [])),
        \            'tolower(v:val)'), a:name) >= 0
        \  || stridx(tolower(a:name),
        \            substitute(tolower(v:val.normalized_name),
        \                       '[_-]', '', 'g')) == 0"))
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

  call dein#source(a:name)

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
          \ ':<C-U>\zs.*\ze<CR>')
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

  if exists(':'.command) == 2
    " Print the candidates
    call feedkeys("\<C-d>", 'n')
  endif

  return [a:arglead]
endfunction

function! s:source_plugin(rtps, index, plugin, sourced) abort
  if a:plugin.sourced || index(a:sourced, a:plugin) >= 0
    return
  endif

  call add(a:sourced, a:plugin)

  let index = a:index

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

  for on_source in filter(dein#util#_get_lazy_plugins(),
        \ "index(get(v:val, 'on_source', []), a:plugin.name) >= 0")
    if s:source_plugin(a:rtps, index, on_source, a:sourced)
      let index += 1
    endif
  endfor

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
  if &filetype ==# ''
    return 0
  endif

  for plugin in a:plugins
    let ftplugin = plugin.rtp . '/ftplugin/' . &filetype
    let after = plugin.rtp . '/after/ftplugin/' . &filetype
    if !empty(filter(['ftplugin', 'indent',
        \ 'after/ftplugin', 'after/indent',],
        \ "filereadable(printf('%s/%s/%s.vim',
        \    plugin.rtp, v:val, &filetype))"))
        \ || isdirectory(ftplugin) || isdirectory(after)
        \ || glob(ftplugin. '_*.vim') !=# '' || glob(after . '_*.vim') !=# ''
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
