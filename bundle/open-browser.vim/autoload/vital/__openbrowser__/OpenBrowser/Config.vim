" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_vital_loaded(V) abort
  let is_unix = has('unix')
  let is_mswin = has('win16') || has('win32') || has('win64')
  let is_cygwin = has('win32unix')
  let is_macunix = !is_mswin && !is_cygwin && (has('mac') || has('macunix') || has('gui_macvim') || (!executable('xdg-open') && system('uname') =~? '^darwin'))

  " FIXME: 'background' doesn't work now on neovim.
  " https://github.com/tyru/open-browser.vim/issues/102
  let s:background = has('nvim') ? 0 : 1

  if is_cygwin
    if executable('cygstart')
      " Cygwin
      function! s:_get_default_browser_commands()
        return [
        \   {'name': 'cygstart',
        \    'args': ['{browser}', '{uri}']}
        \]
      endfunction
    else
      " MSYS, MSYS2, ...
      function! s:_get_default_browser_commands()
        return [
        \   {'name': 'rundll32',
        \    'args': 'rundll32 url.dll,FileProtocolHandler {use_vimproc ? uri : uri_noesc}'}
        \]
      endfunction
    endif
  elseif is_macunix
    function! s:_get_default_browser_commands()
      return [
      \   {'name': 'open',
      \    'args': ['{browser}', '{uri}'],
      \    'background': s:background}
      \]
    endfunction
  elseif is_mswin
    function! s:_get_default_browser_commands()
      return [
      \   {'name': 'rundll32',
      \    'args': 'rundll32 url.dll,FileProtocolHandler {use_vimproc ? uri : uri_noesc}'}
      \]
    endfunction
  elseif is_unix
    function! s:_get_default_browser_commands()
      if filereadable('/proc/version_signature') &&
      \ get(readfile('/proc/version_signature', 'b', 1), 0, '') =~# '^Microsoft'
        " Windows Subsystem for Linux (recent version's directory name is 'WINDOWS')
        for rundll32 in [
        \ '/mnt/c/WINDOWS/System32/rundll32.exe',
        \ '/mnt/c/Windows/System32/rundll32.exe',
        \]
          if executable(rundll32)
            return [
            \   {'name': 'rundll32',
            \    'cmd': rundll32,
            \    'args': rundll32 . ' url.dll,FileProtocolHandler {use_vimproc ? uri : uri_noesc}'}
            \]
          endif
        endfor
      endif
      return [
      \   {'name': 'xdg-open',
      \    'args': ['{browser}', '{uri}'],
      \    'background': s:background},
      \   {'name': 'x-www-browser',
      \    'args': ['{browser}', '{uri}'],
      \    'background': s:background},
      \   {'name': 'firefox',
      \    'args': ['{browser}', '{uri}'],
      \    'background': s:background},
      \   {'name': 'w3m',
      \    'args': ['{browser}', '{uri}'],
      \    'background': s:background},
      \]
    endfunction
  else
    throw 'OpenBrowser.Config: not supported environment'
  endif
endfunction

function! s:new_user_var_source(prefix) abort
  if !exists('s:_initialized')
    call s:_init_global_vars(a:prefix)
    let s:_initialized = 1
  endif
  return {
  \ 'prefix': a:prefix,
  \ 'get': function('s:_UserVarConfig_get'),
  \}
endfunction

function! s:new_default_source() abort
  return {
  \ '_values': s:default_values(),
  \ 'get': function('s:_DefaultConfig_get'),
  \}
endfunction

function! s:_UserVarConfig_get(key) abort dict
  let name = self.prefix . a:key
  for ns in [b:, w:, t:, g:]
    if has_key(ns, name)
      return ns[name]
    endif
  endfor
  throw 'openbrowser: internal error: '
  \   . "s:get_var() couldn't find variable '" . name . "'."
endfunction

function! s:_DefaultConfig_get(key) abort dict
  return self._values[a:key]
endfunction

function! s:_init_global_vars(prefix) abort
  let default = s:default_values()

  " Merge default values & user config values
  for [key, value] in items(default)
    let name = a:prefix . key
    if type(value) is# type({})
      let g:[name] = extend(get(g:, name, {}), value, 'keep')
    else
      let g:[name] = get(g:, name, value)
    endif
  endfor

  " ======= Some special treatments for backward compatibility =======

  function! s:_valid_commands_and_rules()
    let open_commands = g:openbrowser_open_commands
    let open_rules    = g:openbrowser_open_rules
    if type(open_commands) isnot type([])
      return 0
    endif
    if type(open_rules) isnot type({})
      return 0
    endif
    for cmd in open_commands
      if !has_key(open_rules, cmd)
        return 0
      endif
    endfor
    return 1
  endfunction

  if !exists('g:openbrowser_browser_commands')
    if exists('g:openbrowser_open_commands')
    \   && exists('g:openbrowser_open_rules')
    \   && s:_valid_commands_and_rules()
      function! s:_convert_commands_and_rules()
        let open_commands = g:openbrowser_open_commands
        let open_rules    = g:openbrowser_open_rules
        let browser_commands = []
        for cmd in open_commands
          call add(browser_commands,{
          \ 'name': cmd,
          \ 'args': open_rules[cmd]
          \})
        endfor
        return browser_commands
      endfunction
      let g:openbrowser_browser_commands = s:_convert_commands_and_rules()
    else
      let g:openbrowser_browser_commands = default.browser_commands
    endif
  endif

  if !exists('g:openbrowser_format_message')
    let g:openbrowser_format_message = default.format_message
  elseif type(g:openbrowser_format_message) is type('')
    let msg = g:openbrowser_format_message
    unlet g:openbrowser_format_message
    let g:openbrowser_format_message = extend(
    \   default.format_message, {'msg': msg}, 'force')
  else
    let g:openbrowser_format_message = extend(
    \   g:openbrowser_format_message, default.format_message, 'keep')
  endif
endfunction

function! s:default_values() abort
  return {
  \ 'browser_commands': s:_get_default_browser_commands(),
  \ 'fix_schemes': {
  \   'ttp': 'http',
  \   'ttps': 'https',
  \ },
  \ 'fix_hosts': {},
  \ 'fix_paths': {},
  \ 'default_search': 'google',
  \ 'search_engines': {
  \   'alc': 'https://eow.alc.co.jp/search?q={query}',
  \   'askubuntu': 'https://askubuntu.com/search?q={query}',
  \   'baidu': 'https://www.baidu.com/s?wd={query}&rsv_bp=0&rsv_spt=3&inputT=2478',
  \   'cpan': 'http://search.cpan.org/search?query={query}',
  \   'devdocs': 'https://devdocs.io/#q={query}',
  \   'duckduckgo': 'https://duckduckgo.com/?q={query}',
  \   'go': 'https://pkg.go.dev/search?q={query}',
  \   'fileformat': 'https://www.fileformat.info/info/unicode/char/{query}/',
  \   'github': 'https://github.com/search?q={query}',
  \   'google': 'https://google.com/search?q={query}',
  \   'php': 'https://php.net/{query}',
  \   'python': 'https://docs.python.org/dev/search.html?q={query}&check_keywords=yes&area=default',
  \   'twitter-search': 'https://twitter.com/search/{query}',
  \   'twitter-user': 'https://twitter.com/{query}',
  \   'vim': 'https://www.google.com/cse?cx=partner-pub-3005259998294962%3Abvyni59kjr1&ie=ISO-8859-1&q={query}&sa=Search&siteurl=www.vim.org%2F#gsc.tab=0&gsc.q={query}&gsc.page=1',
  \   'wikipedia': 'https://en.wikipedia.org/wiki/{query}',
  \   'wikipedia-ja': 'https://ja.wikipedia.org/wiki/{query}',
  \   'yahoo': 'https://search.yahoo.com/search?p={query}',
  \ },
  \ 'open_filepath_in_vim': 0,
  \ 'open_vim_command': 'vsplit',
  \ 'format_message': {
  \   'msg': "opening '{uri}' ... {done ? 'done! ({command})' : ''}",
  \   'truncate': 1,
  \   'min_uri_len': 15,
  \ },
  \ 'message_verbosity': 2,
  \ 'use_vimproc': 1,
  \ 'force_foreground_after_open': 0,
  \}
endfunction


let &cpo = s:save_cpo
