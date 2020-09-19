" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! s:_vital_depends() abort
  return [
  \ 'Web.URI',
  \ 'Vim.Message',
  \ 'Data.Optional',
  \ 'Data.String',
  \ 'Web.HTTP',
  \ 'Vim.Buffer',
  \
  \ 'OpenBrowser.Opener',
  \]
endfunction

function! s:_vital_loaded(V) abort
  let s:URI = a:V.import('Web.URI')
  let s:Msg = a:V.import('Vim.Message')
  let s:O = a:V.import('Data.Optional')

  let s:_truncate_skipping = a:V.import('Data.String').truncate_skipping
  let s:_encodeURIComponent = a:V.import('Web.HTTP').encodeURIComponent
  let s:_get_last_selected = a:V.import('Vim.Buffer').get_last_selected

  let s:is_cygwin = has('win32unix')
  let s:is_mswin = has('win16') || has('win32') || has('win64')
  let s:use_wslpath = has('unix') && filereadable('/proc/version_signature')
  \ && get(readfile('/proc/version_signature', 'b', 1), 0, '') =~# '^Microsoft'
  \ && executable('wslpath')

  let s:Opener = a:V.import('OpenBrowser.Opener')
  let s:URIExtractor = a:V.import('OpenBrowser.URIExtractor')

  let s:vimproc_is_installed = globpath(&rtp, 'autoload/vimproc.vim') isnot# ''
endfunction

let s:NONE = []
lockvar s:NONE

function! s:new(config) abort
  return {
  \ 'config': a:config,
  \
  \ 'open': function('s:_OpenBrowser_open'),
  \ 'search': function('s:_OpenBrowser_search'),
  \ 'smart_search': function('s:_OpenBrowser_smart_search'),
  \ 'cmd_open': function('s:_OpenBrowser_cmd_open'),
  \ 'cmd_search': function('s:_OpenBrowser_cmd_search'),
  \ 'cmd_smart_search': function('s:_OpenBrowser_cmd_smart_search'),
  \ 'cmd_search_complete': function('s:_OpenBrowser_cmd_search_complete'),
  \ 'keymap_open': function('s:_OpenBrowser_keymap_open'),
  \ 'keymap_search': function('s:_OpenBrowser_keymap_search'),
  \ 'keymap_smart_search': function('s:_OpenBrowser_keymap_smart_search'),
  \}
endfunction

" @param uri URI object or String
function! s:_OpenBrowser_open(uri, ...) abort dict
  let uri = a:uri
  let options = a:0 && type(a:1) ==# type([]) ? a:1 : []
  if type(uri) isnot# type('')
    call s:_throw('s:OpenBrowser.open() received non-String argument: uri = ' . string(uri))
  endif

  " TODO: After deprecating Vim 7.x, refactoring by:
  " * Using s:O.map(), ...
  "   https://github.com/vim-jp/vital.vim/issues/576
  " * Using partial, lambda, ...

  let builder = s:_get_opener_builder(a:uri, self.config)
  let failed = 0
  if s:O.empty(builder)
    let failed = 1
  else
    " Open URI in a browser / Open a file in Vim
    let b = s:O.get(builder)

    " Show message
    if b.type is# 'shellcmd'
      redraw!
      let format_message = self.config.get('format_message')
      if self.config.get('message_verbosity') >= 2 && format_message.msg isnot# ''
        let msg = s:_expand_format_message(format_message,
        \   {
        \      'uri' : uri,
        \      'done' : 0,
        \      'command' : '',
        \   })
        echo msg
      endif
    endif

    if type(b.cmd.args) == v:t_string
      "String (Windows)
      let b.cmd.args = join([b.cmd.args] + map(copy(options), 'shellescape(v:val)'), ' ')
    else
      "Array (Other platforms)
      let b.cmd.args += options
    endif

    let opener = b.build()
    let failed = !opener.open()

    if !failed && b.type is# 'shellcmd'
      " Show message
      if self.config.get('message_verbosity') >= 2 && format_message.msg isnot# ''
        redraw
        let msg = s:_expand_format_message(format_message,
        \   {
        \      'uri' : uri,
        \      'done' : 1,
        \      'command' : b.cmd.name,
        \   })
        echo msg
      endif

      " XXX: Vim looses a focus after opening URI...
      " Is this same as non-Windows platform?
      if g:openbrowser_force_foreground_after_open && s:is_mswin
        augroup openbrowser-focuslost
          autocmd!
          autocmd FocusLost * call foreground() | autocmd! openbrowser FocusLost
        augroup END
      endif
    endif
  endif

  if failed
    if self.config.get('message_verbosity') >= 1
      call s:Msg.warn("open-browser doesn't know how to open '" . uri . "'.")
    endif
  endif
endfunction

" Returns s:O.some(builder) or s:O.none().
" Builder is either Ex command opener or shell command opener.
" Ex command opener builds an opener which opens a given file in Vim.
" Shell command builder builds an opener which opens a given URI in a browser.
function! s:_get_opener_builder(uristr, config) abort
  let [uristr, config] = [a:uristr, a:config]
  let uriobj = s:URI.new_from_uri_like_string(uristr, s:NONE)
  if s:_seems_path(uristr)    " Existed file path or 'file://'
    " Convert to full path.
    if stridx(uristr, 'file://') is# 0    " file://
      let fullpath = substitute(uristr, '^file://', '', '')
    elseif uristr[0] is# '/'    " full path
      let fullpath = uristr
    else    " relative path
      let fullpath = s:_convert_to_fullpath(uristr)
    endif
    if config.get('open_filepath_in_vim')
      let fullpath = tr(fullpath, '\', '/')
      let command = config.get('open_vim_command')
      let builder = s:_new_excmd_opener_builder(join([command, fullpath]))
      return s:O.some(builder)
    else
      let fullpath = tr(fullpath, '\', '/')
      " Windows Subsystem for Linux: Convert Unix path to Windows UNC path
      if s:use_wslpath
        let fullpath = substitute(
        \ system('wslpath -am ' . shellescape(fullpath)), '\n', '', '')
      endif
      " Convert to file:// string.
      " NOTE: cygwin cannot treat file:// URI,
      " pass a string as fullpath.
      if !s:is_cygwin
        let fullpath = 'file://' . fullpath
      endif
      return s:_get_shellcmd_opener_builder(fullpath, config)
    endif
  elseif s:_valid_uri(uriobj)    " other URI
    " Fix scheme, host, path.
    " e.g.: "ttp" => "http"
    for where in ['scheme', 'host', 'path']
      let fix = config.get('fix_'.where.'s')
      let value = uriobj[where]()
      if has_key(fix, value)
        call call(uriobj[where], [fix[value]], uriobj)
      endif
    endfor
    let uristr = uriobj.to_string()
    return s:_get_shellcmd_opener_builder(uristr, config)
  endif
  return s:O.none()
endfunction

" Returns builder which builds Ex command opener.
" `builder.build().open()` will open a file in Vim.
function! s:_new_excmd_opener_builder(excmd) abort
  let builder = {
  \ 'type': 'excmd',
  \ 'excmd': a:excmd,
  \}
  function! builder.build() abort
    return s:Opener.new_from_excmd(self.excmd)
  endfunction
  return builder
endfunction

" Returns builder which builds shell command opener.
" `builder.build().open()` will open the URI in a browser.
function! s:_new_shellcmd_opener_builder(cmd, execmd, uri, use_vimproc) abort
  let builder = {
  \ 'type': 'shellcmd',
  \ 'cmd': a:cmd,
  \ 'execmd': a:execmd,
  \ 'uri': a:uri,
  \ 'use_vimproc': a:use_vimproc,
  \}
  function! builder.build() abort
    " If args is not List, need to escape by open-browser
    let args = deepcopy(self.cmd.args)
    let need_escape = type(args) isnot type([])
    let quote = need_escape ? "'" : ''
    let expand_param = {
    \  'browser'      : quote . self.execmd . quote,
    \  'browser_noesc': self.execmd,
    \  'uri'          : quote . self.uri . quote,
    \  'uri_noesc'    : self.uri,
    \  'use_vimproc'  : self.use_vimproc,
    \}
    if type(args) is# type([])
      let system_args = map(
      \ copy(args), 's:_expand_keywords(v:val, expand_param)'
      \)
    else
      let system_args = s:_expand_keywords(args, expand_param)
    endif
    return s:Opener.new_from_shellcmd(
    \ system_args, get(self.cmd, 'background'), self.use_vimproc
    \)
  endfunction
  return builder
endfunction

" If applicable browser is found, this returns s:O.some(builder) which
" builds shell command opener from given URI. Otherwise this returns
" s:O.none().
function! s:_get_shellcmd_opener_builder(uri, config) abort
  let [uri, config] = [a:uri, a:config]
  let use_vimproc = config.get('use_vimproc') && s:vimproc_is_installed
  for cmd in config.get('browser_commands')
    let execmd = get(cmd, 'cmd', cmd.name)
    if executable(execmd)
      let builder = s:_new_shellcmd_opener_builder(cmd, execmd, uri, use_vimproc)
      return s:O.some(builder)
    endif
  endfor
  return s:O.none()
endfunction

" :OpenBrowserSearch
function! s:_OpenBrowser_search(query, ...) abort dict
  if a:query =~# '^\s*$'
    return
  endif

  let default_search = self.config.get('default_search')
  let engine = get(a:000, 0, default_search)
  let engine = engine is# '' ? default_search : engine

  let search_engines = self.config.get('search_engines')
  if !has_key(search_engines, engine)
    call s:Msg.error("Unknown search engine '" . engine . "'.")
    return
  endif

  let query = s:_encodeURIComponent(a:query)
  let uri = s:_expand_keywords(search_engines[engine], {'query': query})
  call self.open(uri)
endfunction

" :OpenBrowserSmartSearch
function! s:_OpenBrowser_smart_search(query, ...) abort dict
  let default_search = self.config.get('default_search')
  let engine = get(a:000, 0, default_search)
  let engine = engine is# '' ? default_search : engine

  if s:_seems_path(a:query) || s:_valid_uri(s:URI.new(a:query, {}))
    return self.open(a:query)
  else
    return self.search(a:query, engine)
  endif
endfunction


function! s:_parse_spaces(cmdline) abort
  return substitute(a:cmdline, '^\s\+', '', '')
endfunction

" Parse engine if specified
function! s:_parse_engine(cmdline) abort
  let c = s:_parse_spaces(a:cmdline)
  let engine = s:O.none()
  let m = matchlist(c, '^-\(\S\+\)\s\+\(.*\)')
  if !empty(m)
    let engine = s:O.some(m[1])
    let c = m[2]
  endif
  return [engine, c]
endfunction

" :OpenBrowser
function! s:_OpenBrowser_cmd_open(cmdline) abort dict
  let uri = s:_parse_spaces(a:cmdline)
  if uri is# ''
    call s:Msg.error(':OpenBrowser {uri}')
    return
  endif
  call self.open(uri)
endfunction

" :OpenBrowserSearch
function! s:_OpenBrowser_cmd_search(cmdline) abort dict
  let [engine, c] = s:_parse_search_args(a:cmdline)
  let c = s:_parse_spaces(c)
  if c is# ''
    call s:Msg.error(':OpenBrowserSearch [-{search-engine}] {query}')
    return
  endif
  return self.search(c, s:O.get_or(engine, { -> '' }))
endfunction

" Parse command-line arguments of:
" * :OpenBrowserSearch
" * :OpenBrowserSmartSearch
function! s:_parse_search_args(cmdline) abort
  let c = s:_parse_spaces(a:cmdline)
  let engine = s:O.none()
  while 1
    if c =~# '^-'
      let [engine, c] = s:_parse_engine(c)
      if s:O.empty(engine)
        break
      endif
    else
      break
    endif
  endwhile
  return [engine, c]
endfunction

" @vimlint(EVL103, 1, a:arglead)
" @vimlint(EVL103, 1, a:cursorpos)
function! s:_OpenBrowser_cmd_search_complete(arglead, cmdline, cursorpos) abort dict
  let excmd = '^\s*OpenBrowser\w\+\s\+'
  if a:cmdline !~# excmd
    return
  endif
  let cmdline = substitute(a:cmdline, excmd, '', '')

  let engine_opts = map(
  \   sort(keys(self.config.get('search_engines'))),
  \   '''-'' . v:val'
  \)
  let reg_opts = ['++clip', '++reg=']
  let all_opts = engine_opts + reg_opts

  if cmdline is# ''
    return all_opts
  endif
  return filter(all_opts, 'stridx(v:val, cmdline) is# 0')
endfunction
" @vimlint(EVL103, 0, a:arglead)
" @vimlint(EVL103, 0, a:cursorpos)

" :OpenBrowserSmartSearch
function! s:_OpenBrowser_cmd_smart_search(cmdline) abort dict
  let [engine, c] = s:_parse_search_args(a:cmdline)
  let c = s:_parse_spaces(c)
  if c is# ''
    call s:Msg.error(':OpenBrowserSmartSearch [-{search-engine}] {query}')
    return
  endif
  return self.smart_search(c, s:O.get_or(engine, { -> '' }))
endfunction

" <Plug>(openbrowser-open)
function! s:_OpenBrowser_keymap_open(mode, ...) abort dict
  let silent = get(a:000, 0, self.config.get('message_verbosity') is# 0)
  let options = get(a:000, 1, [])
  if a:mode is# 'n'
    " URL
    let url = s:_get_url_on_cursor(self.config)
    if !empty(url)
      call self.open(url, options)
      return 1
    endif
    " FilePath
    let filepath = s:_get_filepath_on_cursor()
    if !empty(filepath)
      call self.open(filepath)
      return 1
    endif
    " Fail!
    if !silent
      call s:Msg.error('URL or file path is not found under cursor!')
    endif
    return 0
  else
    let text = s:_get_selected_text()
    let extracted = s:_extract_urls(text, self.config)
    for e in extracted
      call self.open(e.url.to_string())
    endfor
    return !empty(extracted)
  endif
endfunction

" <Plug>(openbrowser-search)
function! s:_OpenBrowser_keymap_search(mode) abort dict
  if a:mode is# 'n'
    return self.search(expand('<cword>'))
  else
    return self.search(s:_get_selected_text())
  endif
endfunction

" <Plug>(openbrowser-smart-search)
function! s:_OpenBrowser_keymap_smart_search(mode) abort dict
  if self.keymap_open(a:mode, 1)
    " Suceeded to open!
    return
  endif
  " If neither URL nor FilePath is found...
  if a:mode is# 'n'
    " Search <cword>.
    call self.search(
    \   expand('<cword>'),
    \   self.config.get('default_search'))
  else
    " Search selected text.
    call self.search(
    \   s:_get_selected_text(),
    \   self.config.get('default_search'))
  endif
endfunction

function! s:_get_selected_text() abort
  let selected_text = s:_get_last_selected()
  let text = substitute(selected_text, '[\n\r]\+', ' ', 'g')
  return substitute(text, '^\s*\|\s*$', '', 'g')
endfunction


" Define more tolerant URI parsing.
" TODO: Make this configurable.

let s:LoosePatternSet = {}

function! s:_get_loose_pattern_set() abort
  if !empty(s:LoosePatternSet)
    return s:LoosePatternSet
  endif
  let s:LoosePatternSet = s:URI.new_default_pattern_set()

  " Remove "'", "(", ")" from default sub_delims().
  function! s:LoosePatternSet.sub_delims() abort
    return '[!$&*+,;=]'
  endfunction

  return s:LoosePatternSet
endfunction


function! s:_extract_urls(text, config) abort
  let pattern_set = s:_get_loose_pattern_set()
  let schemes = keys(a:config.get('fix_schemes'))
  let head_pattern = s:_get_url_head_pattern(schemes, pattern_set)
  return s:URIExtractor.extract_from_text(a:text, {
  \ 'uri_pattern_set': pattern_set,
  \ 'head_pattern': head_pattern,
  \})
endfunction

" This pattern matches:
" * "https", "http", "file", and the keys of Dictionary returned by
"   config.get('fix_schemes')
"   * Above 3 schemes are used because most frequently used, and URI scheme
"     regex is too tolerant
" * URI hostname (for no scheme URI)
function! s:_get_url_head_pattern(schemes, pattern_set) abort
  let schemes = ['https', 'http', 'file'] + a:schemes
  let scheme_pattern = join(sort(copy(a:schemes), 's:_by_length'), '\|')
  let head_pattern = scheme_pattern . '\|' . a:pattern_set.host()
  return head_pattern
endfunction

function! s:_by_length(s1, s2) abort
  let [l1, l2] = [strlen(a:s1), strlen(a:s2)]
  return l1 ># l2 ? -1 : l1 <# l2 ? 1 : 0
endfunction

function! s:_seems_path(uri) abort
  " - Has no invalid filename character (seeing &isfname)
  " and, either
  " - file:// prefixed string and existed file path
  " - Existed file path
  if stridx(a:uri, 'file://') is# 0
    let path = substitute(a:uri, '^file://', '', '')
  else
    let path = a:uri
  endif
  return getftype(path) isnot# ''
endfunction

function! s:_valid_uri(uriobj) abort
  return !empty(a:uriobj)
  \   && a:uriobj.scheme() isnot# ''
endfunction

" @vimlint(EVL104, 1, l:save_shellslash)
function! s:_convert_to_fullpath(path) abort
  if exists('+shellslash')
    let save_shellslash = &l:shellslash
    let &l:shellslash = 1
  endif
  try
    return fnamemodify(a:path, ':p')
  finally
    if exists('+shellslash')
      let &l:shellslash = save_shellslash
    endif
  endtry
endfunction
" @vimlint(EVL104, 0, l:save_shellslash)

function! s:_expand_format_message(format_message, keywords) abort
  let maxlen = s:Msg.get_hit_enter_max_length()
  let expanded_msg = s:_expand_keywords(a:format_message.msg, a:keywords)
  if a:format_message.truncate && strlen(expanded_msg) > maxlen
    " Avoid |hit-enter-prompt|.
    let non_uri_len = strlen(expanded_msg) - strlen(a:keywords.uri)
    " First Try: Remove "https" or "http" scheme in URI.
    let scheme = '\C^https\?://'
    let matched_len = strlen(matchstr(a:keywords.uri, scheme))
    if matched_len > 0
      let a:keywords.uri = a:keywords.uri[matched_len :]
    endif
    if non_uri_len + strlen(a:keywords.uri) <= maxlen
      let expanded_msg = s:_expand_keywords(a:format_message.msg, a:keywords)
    else
      " Second Try: Even if expanded_msg is longer than command-line
      " after "First Try", truncate URI as possible.
      let min_uri_len = a:format_message.min_uri_len
      if non_uri_len + min_uri_len <= maxlen
        " Truncate only URI.
        let a:keywords.uri = s:_truncate_skipping(
        \           a:keywords.uri, maxlen - 4 - non_uri_len, 0, '...')
        let expanded_msg = s:_expand_keywords(a:format_message.msg, a:keywords)
      else
        " Third, Fallback: Even if expanded_msg is longer than command-line
        " after "Second Try", truncate whole string.
        let a:keywords.uri = s:_truncate_skipping(
        \                   a:keywords.uri, min_uri_len, 0, '...')
        let expanded_msg = s:_expand_keywords(a:format_message.msg, a:keywords)
        let expanded_msg = s:_truncate_skipping(
        \                   expanded_msg, maxlen - 4, 0, '...')
      endif
    endif
  endif
  return expanded_msg
endfunction

" @return Dictionary: the URL on cursor, or the first URL after cursor
"   Empty Dictionary means no URLs found.
" :help openbrowser-url-detection
function! s:_get_url_on_cursor(config) abort
  let url = s:_get_thing_on_cursor('s:_detect_url_cb', [a:config])
  return s:O.get_or(url, { -> '' })
endfunction

function! s:_detect_url_cb(config) abort
  let extracted = s:_extract_urls(expand('<cWORD>'), a:config)
  if !empty(extracted)
    return s:O.some(extracted[0].url.to_string())
  endif
  return s:O.none()
endfunction

" @return the filepath on cursor, or the first filepath after cursor
" :help openbrowser-filepath-detection
function! s:_get_filepath_on_cursor() abort
  let filepath = s:_get_thing_on_cursor('s:_detect_filepath_cb', [])
  return s:O.get_or(filepath, { -> '' })
endfunction

function! s:_detect_filepath_cb() abort
  let path = expand('<cWORD>')
  return s:_seems_path(path) ? s:O.some(path) : s:O.none()
endfunction

function! s:_get_thing_on_cursor(func, args) abort
  let line = s:_getconcealedline('.')
  let col = s:_getconcealedcol('.')
  if line[col-1] =~# '\s'
    let pos = getpos('.')
    try
      " Search left WORD.
      if search('\S', 'bnW')[0] ># 0
        normal! B
        let r = call(a:func, a:args)
        if s:O.exists(r)
          return r
        endif
      endif
      " Search right WORD.
      if search('\S', 'nW')[0] ># 0
        normal! W
        let r = call(a:func, a:args)
        if s:O.exists(r)
          return r
        endif
      endif
      " Not found.
      return s:O.none()
    finally
      call setpos('.', pos)
    endtry
  endif
  return call(a:func, a:args)
endfunction

" This function is from quickrun.vim (http://github.com/thinca/vim-quickrun)
" Original function is `s:Runner.expand()`.
"
" NOTE: Original version recognize more keywords.
" This function is speciallized for open-browser.vim
" - @register @{register}
" - &option &{option}
" - $ENV_NAME ${ENV_NAME}
"
" Expand the keywords.
" - {expr}
"
" Escape by \ if you does not want to expand.
" - "\{keyword}" => "{keyword}", not expression `keyword`.
"   it does not expand vim variable `keyword`.
function! s:_expand_keywords(str, options) abort
  if type(a:str) isnot# type('') || type(a:options) isnot# type({})
    call s:_throw('s:_expand_keywords(): invalid arguments. (a:str = '.string(a:str).', a:options = '.string(a:options).')')
  endif
  let rest = a:str
  let result = ''

  " Assign these variables for eval().
  for [name, val] in items(a:options)
    " unlockvar l:
    " let l:[name] = val
    execute 'let' name '=' string(val)
  endfor

  while 1
    let f = match(rest, '\\\?[{]')

    " No more special characters. end parsing.
    if f < 0
      let result .= rest
      break
    endif

    " Skip ordinary string.
    if f isnot# 0
      let result .= rest[: f - 1]
      let rest = rest[f :]
    endif

    " Process special string.
    if rest[0] is# '\'
      let result .= rest[1]
      let rest = rest[2 :]
    elseif rest[0] is# '{'
      " NOTE: braindex + 1 is# 1, it skips first bracket (rest[0])
      let braindex = 0
      let braindex_stack = [braindex]
      while !empty(braindex_stack)
        let braindex = match(rest, '\\\@<![{}]', braindex + 1)
        if braindex is# -1
          call s:_throw('expression is invalid: curly bracket is not closed.')
        elseif rest[braindex] is# '{'
          call add(braindex_stack, braindex)
        else    " '}'
          let brastart = remove(braindex_stack, -1)
          " expr does not contain brackets.
          " Assert: rest[brastart is# '{' && rest[braindex] is# '}'
          let left = brastart is# 0 ? '' : rest[: brastart-1]
          let expr = rest[brastart+1 : braindex-1]
          let right = rest[braindex+1 :]
          " Remove(unescape) backslashes.
          let expr = substitute(expr, '\\\([{}]\)', '\1', 'g')
          let value = eval(expr) . ''
          let rest = left . value . right
          let braindex -= len(expr) - len(value)
        endif
      endwhile
      let result .= rest[: braindex]
      let rest = rest[braindex+1 :]
    else
      call s:_throw('parse error: rest = ' . rest . ', result = ' . result)
    endif
  endwhile
  return result
endfunction

function! s:_throw(msg) abort
  throw 'openbrowser: ' . a:msg
endfunction

" From https://github.com/chikatoike/concealedyank.vim
function! s:_getconcealedline(lnum, ...) abort
  if !has('conceal')
    return getline(a:lnum)
  endif

  let line = getline(a:lnum)
  let index = get(a:000, 0, 0)
  let endidx = get(a:000, 1, -1)
  let endidx = endidx >= 0 ? min([endidx, strlen(line)]) : strlen(line)

  let region = -1
  let ret = ''

  while index <= endidx
    let concealed = synconcealed(a:lnum, index + 1)
    if concealed[0] isnot# 0
      if region isnot# concealed[2]
        let region = concealed[2]
        let ret .= concealed[1]
      endif
    else
      let ret .= line[index]
    endif

    " get next char index.
    let index += 1
  endwhile

  return ret
endfunction

function! s:_getconcealedcol(expr) abort
  if !has('conceal')
    return col(a:expr)
  endif

  let index = 0
  let endidx = col(a:expr)

  let ret = 0
  let isconceal = 0

  while index < endidx
    let concealed = synconcealed('.', index + 1)
    if concealed[0] is# 0
      let ret += 1
    endif
    let isconceal = concealed[0]

    " get next char index.
    let index += 1
  endwhile

  if ret is# 0
    let ret = 1
  elseif isconceal
    let ret += 1
  endif

  return ret
endfunction


let &cpo = s:save_cpo
