"=============================================================================
" FILE: util.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:is_windows = has('win32') || has('win64')
let s:is_mac = !s:is_windows && !has('win32unix')
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!isdirectory('/proc') && executable('sw_vers')))

function! defx#util#print_error(string) abort
  echohl Error | echomsg '[defx] '
        \ . defx#util#string(a:string) | echohl None
endfunction
function! defx#util#print_warning(string) abort
  echohl WarningMsg | echomsg '[defx] '
        \ . defx#util#string(a:string) | echohl None
endfunction
function! defx#util#print_debug(string) abort
  echomsg '[defx] ' . defx#util#string(a:string)
endfunction
function! defx#util#print_message(string) abort
  echo '[defx] ' . defx#util#string(a:string)
endfunction
function! defx#util#is_windows() abort
  return s:is_windows
endfunction

function! defx#util#convert2list(expr) abort
  return type(a:expr) ==# type([]) ? a:expr : [a:expr]
endfunction
function! defx#util#string(expr) abort
  return type(a:expr) ==# type('') ? a:expr : string(a:expr)
endfunction
function! defx#util#split(string) abort
  return split(a:string, '\s*,\s*')
endfunction

function! defx#util#has_yarp() abort
  return !has('nvim') || get(g:, 'defx#enable_yarp', 0)
endfunction

function! defx#util#execute_path(command, path) abort
  try
    execute a:command fnameescape(s:expand(a:path))
  catch /^Vim\%((\a\+)\)\=:E325\|^Vim:Interrupt/
    " Ignore swap file error
  catch
    call defx#util#print_error(v:throwpoint)
    call defx#util#print_error(v:exception)
  endtry
endfunction
function! s:expand(path) abort
  return s:substitute_path_separator(
        \ (a:path =~# '^\~') ? fnamemodify(a:path, ':p') :
        \ a:path)
endfunction
function! s:expand_complete(path) abort
  return s:substitute_path_separator(
        \ (a:path =~# '^\~') ? fnamemodify(a:path, ':p') :
        \ (a:path =~# '^\$\h\w*') ? substitute(a:path,
        \             '^\$\h\w*', '\=eval(submatch(0))', '') :
        \ a:path)
endfunction
function! s:substitute_path_separator(path) abort
  return s:is_windows ? substitute(a:path, '\\', '/', 'g') : a:path
endfunction

function! defx#util#call_defx(command, args) abort
  let [paths, context] = defx#util#_parse_options_args(a:args)
  call defx#start(paths, context)
endfunction

function! defx#util#input(prompt, ...) abort
  let text = get(a:000, 0, '')
  let completion = get(a:000, 1, '')
  try
    if completion !=# ''
      return input(a:prompt, text, completion)
    else
      return input(a:prompt, text)
    endif
  catch
    " ignore the errors
    return ''
  endtry
endfunction
function! defx#util#confirm(msg, choices, default) abort
  try
    return confirm(a:msg, a:choices, a:default)
  catch
    " ignore the errors
  endtry

  return a:default
endfunction

function! defx#util#_parse_options_args(cmdline) abort
  return s:parse_options(a:cmdline)
endfunction
function! s:re_unquoted_match(match) abort
  " Don't match a:match if it is located in-between unescaped single or double
  " quotes
  return a:match . '\v\ze([^"' . "'" . '\\]*(\\.|"([^"\\]*\\.)*[^"\\]*"|'
        \ . "'" . '([^' . "'" . '\\]*\\.)*[^' . "'" . '\\]*' . "'" . '))*[^"'
        \ . "'" . ']*$'
endfunction
function! s:remove_quote_pairs(s) abort
  " remove leading/ending quote pairs
  let s = a:s
  if s[0] ==# '"' && s[len(s) - 1] ==# '"'
    let s = s[1: len(s) - 2]
  elseif s[0] ==# "'" && s[len(s) - 1] ==# "'"
    let s = s[1: len(s) - 2]
  else
    let s = substitute(a:s, '\\\(.\)', "\\1", 'g')
  endif
  return s
endfunction
function! s:parse_options(cmdline) abort
  let args = []
  let options = {}

  " Eval
  let cmdline = (a:cmdline =~# '\\\@<!`.*\\\@<!`') ?
        \ s:eval_cmdline(a:cmdline) : a:cmdline

  for s in split(cmdline, s:re_unquoted_match('\%(\\\@<!\s\)\+'))
    let arg = substitute(s, '\\\( \)', '\1', 'g')
    let arg_key = substitute(arg, '=\zs.*$', '', '')

    let name = substitute(tr(arg_key, '-', '_'), '=$', '', '')[1:]
    if name =~# '^no_'
      let name = name[3:]
      let value = v:false
    else
      let value = (arg_key =~# '=$') ?
            \ s:remove_quote_pairs(arg[len(arg_key) :]) : v:true
    endif

    if index(keys(defx#init#_user_options()), name) >= 0
      let options[name] = value
    else
      call add(args, arg)
    endif
  endfor

  return [args, options]
endfunction
function! s:eval_cmdline(cmdline) abort
  let cmdline = ''
  let prev_match = 0
  let eval_pos = match(a:cmdline, '\\\@<!`.\{-}\\\@<!`')
  while eval_pos >= 0
    if eval_pos - prev_match > 0
      let cmdline .= a:cmdline[prev_match : eval_pos - 1]
    endif
    let prev_match = matchend(a:cmdline,
          \ '\\\@<!`.\{-}\\\@<!`', eval_pos)
    let cmdline .= escape(eval(a:cmdline[eval_pos+1 : prev_match - 2]), '\ ')

    let eval_pos = match(a:cmdline, '\\\@<!`.\{-}\\\@<!`', prev_match)
  endwhile
  if prev_match >= 0
    let cmdline .= a:cmdline[prev_match :]
  endif

  return cmdline
endfunction

function! defx#util#complete(arglead, cmdline, cursorpos) abort
  let _ = []

  if a:arglead =~# '^-'
    " Option names completion.
    let bool_options = keys(filter(copy(defx#init#_user_options()),
          \ 'type(v:val) == type(v:true) || type(v:val) == type(v:false)'))
    let _ += map(copy(bool_options), "'-' . tr(v:val, '_', '-')")
    let string_options = keys(filter(copy(defx#init#_user_options()),
          \ 'type(v:val) != type(v:true) && type(v:val) != type(v:false)'))
    let _ += map(copy(string_options), "'-' . tr(v:val, '_', '-') . '='")

    " Add "-no-" option names completion.
    let _ += map(copy(bool_options), "'-no-' . tr(v:val, '_', '-')")
  else
    let arglead = s:expand_complete(a:arglead)
    " Path names completion.
    let files = filter(map(glob(a:arglead . '*', v:true, v:true),
          \                's:substitute_path_separator(v:val)'),
          \            'stridx(tolower(v:val), tolower(arglead)) == 0')
    let files = map(filter(files, 'isdirectory(v:val)'),
          \ 's:expand_complete(v:val)')
    if a:arglead =~# '^\~'
      let home_pattern = '^'. s:expand_complete('~')
      call map(files, "substitute(v:val, home_pattern, '~/', '')")
    endif
    call map(files, "escape(v:val.'/', ' \\')")
    let _ += files
  endif

  return uniq(sort(filter(_, 'stridx(v:val, a:arglead) == 0')))
endfunction

function! defx#util#has_yarp() abort
  return !has('nvim')
endfunction
function! defx#util#rpcrequest(method, args, is_async) abort
  if !defx#init#_check_channel()
    return -1
  endif

  if defx#util#has_yarp()
    if g:defx#_yarp.job_is_dead
      return -1
    endif
    if a:is_async
      return g:defx#_yarp.notify(a:method, a:args)
    else
      return g:defx#_yarp.request(a:method, a:args)
    endif
  else
    if a:is_async
      return rpcnotify(g:defx#_channel_id, a:method, a:args)
    else
      return rpcrequest(g:defx#_channel_id, a:method, a:args)
    endif
  endif
endfunction

" Open a file.
function! defx#util#open(filename) abort
  let filename = fnamemodify(a:filename, ':p')

  " Detect desktop environment.
  if s:is_windows
    " For URI only.
    " Note:
    "   # and % required to be escaped (:help cmdline-special)
    silent execute printf(
          \ '!start rundll32 url.dll,FileProtocolHandler %s',
          \ escape(filename, '#%'),
          \)
  elseif has('win32unix')
    " Cygwin.
    call system(printf('%s %s', 'cygstart',
          \ shellescape(filename)))
  elseif executable('xdg-open')
    " Linux.
    call system(printf('%s %s &', 'xdg-open',
          \ shellescape(filename)))
  elseif exists('$KDE_FULL_SESSION') && $KDE_FULL_SESSION ==# 'true'
    " KDE.
    call system(printf('%s %s &', 'kioclient exec',
          \ shellescape(filename)))
  elseif exists('$GNOME_DESKTOP_SESSION_ID')
    " GNOME.
    call system(printf('%s %s &', 'gnome-open',
          \ shellescape(filename)))
  elseif executable('exo-open')
    " Xfce.
    call system(printf('%s %s &', 'exo-open',
          \ shellescape(filename)))
  elseif s:is_mac && executable('open')
    " Mac OS.
    call system(printf('%s %s &', 'open',
          \ shellescape(filename)))
  else
    " Give up.
    call defx#util#print_error('Not supported.')
  endif
endfunction

function! defx#util#cd(path) abort
  if exists('*chdir')
    call chdir(a:path)
  else
    silent execute (haslocaldir() ? 'lcd' : 'cd') fnameescape(a:path)
  endif
endfunction

function! defx#util#truncate_skipping(str, max, footer_width, separator) abort
  let width = strwidth(a:str)
  if width <= a:max
    let ret = a:str
  else
    let header_width = a:max - strwidth(a:separator) - a:footer_width
    let ret = s:strwidthpart(a:str, header_width) . a:separator
         \ . s:strwidthpart_reverse(a:str, a:footer_width)
  endif
  return s:truncate(ret, a:max)
endfunction
function! s:truncate(str, width) abort
  " Original function is from mattn.
  " http://github.com/mattn/googlereader-vim/tree/master

  if a:str =~# '^[\x00-\x7f]*$'
    return len(a:str) < a:width
          \ ? printf('%-' . a:width . 's', a:str)
          \ : strpart(a:str, 0, a:width)
  endif

  let ret = a:str
  let width = strwidth(a:str)
  if width > a:width
    let ret = s:strwidthpart(ret, a:width)
    let width = strwidth(ret)
  endif

  if width < a:width
    let ret .= repeat(' ', a:width - width)
  endif

  return ret
endfunction
function! s:strwidthpart(str, width) abort
  let str = tr(a:str, "\t", ' ')
  let vcol = a:width + 2
  return matchstr(str, '.*\%<' . (vcol < 0 ? 0 : vcol) . 'v')
endfunction
function! s:strwidthpart_reverse(str, width) abort
  let str = tr(a:str, "\t", ' ')
  let vcol = strwidth(str) - a:width
  return matchstr(str, '\%>' . (vcol < 0 ? 0 : vcol) . 'v.*')
endfunction
