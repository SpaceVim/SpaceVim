let s:Buffer = vital#gina#import('Vim.Buffer')
let s:String = vital#gina#import('Data.String')
let s:Guard = vital#gina#import('Vim.Guard')
let s:Opener = vital#gina#import('Vim.Buffer.Opener')
let s:Path = vital#gina#import('System.Filepath')
let s:Window = vital#gina#import('Vim.Window')

let s:NOAUTOCMD_SUFFIX = ':$'
let s:DEFAULT_PARAMS_ATTRIBUTES = {
      \ 'repo': '',
      \ 'scheme': '',
      \ 'params': [],
      \ 'rev': '',
      \ 'path': '',
      \ 'treeish': '',
      \}


function! gina#core#buffer#bufname(git, scheme, ...) abort
  let options = get(a:000, 0, {})
  let params = filter(gina#util#get(options, 'params', []), '!empty(v:val)')
  let treeish = gina#util#get(options, 'treeish', printf('%s:%s',
        \ gina#util#get(options, 'rev'),
        \ gina#util#get(options, 'path'),
        \))
  return s:normalize_bufname(printf(
        \ 'gina://%s:%s%s/%s%s',
        \ a:git.refname,
        \ a:scheme,
        \ empty(params) ? '' : ':' . join(params, ':'),
        \ s:Path.unixpath(substitute(treeish, '^:0', '', '')),
        \ gina#util#get(options, 'noautocmd', 0) ? s:NOAUTOCMD_SUFFIX : '',
        \))
endfunction

function! gina#core#buffer#parse(expr) abort
  let path = expand(a:expr)
  let m = matchlist(path, printf(
        \ '\v^gina://([^:]+):([^:\/]+)([^\/]*)[\/]?(%%(:[0-3]|[^:]*)%%(:[^:]*)?)%%(\m%s\v)?$',
        \ s:String.escape_pattern(s:NOAUTOCMD_SUFFIX),
        \))
  if empty(m)
    return {}
  endif
  let treeish = m[4]
  let [rev, path] = gina#core#treeish#parse(treeish)
  let params = {
        \ 'repo': m[1],
        \ 'scheme': m[2],
        \ 'params': filter(split(m[3], ':'), '!empty(v:val)'),
        \ 'rev': rev,
        \ 'treeish': treeish,
        \}
  if path isnot# v:null
    let params.path = substitute(
          \ path,
          \ s:String.escape_pattern(s:NOAUTOCMD_SUFFIX) . '$',
          \ '',
          \ '',
          \)
  endif
  return params
endfunction

function! gina#core#buffer#param(expr, attr, ...) abort
  if !has_key(s:DEFAULT_PARAMS_ATTRIBUTES, a:attr)
    throw gina#core#revelator#critical(printf(
          \ 'Unknown attribute "%s" has specified',
          \ a:attr,
          \))
  endif
  let default = get(a:000, 0, s:DEFAULT_PARAMS_ATTRIBUTES[a:attr])
  let params = gina#core#buffer#parse(a:expr)
  return gina#util#get(params, a:attr, default)
endfunction

function! gina#core#buffer#open(bufname, ...) abort
  let options = extend({
        \ 'mods': '',
        \ 'group': '',
        \ 'opener': '',
        \ 'origin': v:true,
        \ 'range': 'tabpage',
        \ 'cmdarg': '',
        \ 'width': v:null,
        \ 'height': v:null,
        \ 'line': v:null,
        \ 'col': v:null,
        \ 'callback': v:null,
        \}, get(a:000, 0, {}),
        \)
  let bufname = s:normalize_bufname(a:bufname)
  " Move focus to an origin window if necessary
  if options.origin isnot# v:null && s:is_locator_available(options.opener)
    let origin = options.origin is# v:true ? winnr() : options.origin
    call gina#core#locator#focus(origin)
  endif
  " Open a buffer
  if options.callback is# v:null
    let context = s:open_without_callback(bufname, options)
  else
    let context = s:open_with_callback(bufname, options)
  endif
  " Resize width/height if necessary
  if options.width && options.width != winwidth(0)
    execute printf('vertical resize %d', options.width)
  endif
  if options.height && options.height != winheight(0)
    execute printf('resize %d', options.height)
  endif
  " Move cursor if necessary
  call setpos('.', [
        \ 0,
        \ options.line is# v:null ? line('.') : options.line,
        \ options.col is# v:null ? col('.') : options.col,
        \ 0,
        \])
  normal! zvzz
  " Finalize
  call context.end()
  return context
endfunction

function! gina#core#buffer#focus(expr) abort
  return s:Window.focus_buffer(a:expr)
endfunction

function! gina#core#buffer#assign_cmdarg(...) abort
  let guard = s:Guard.store(['&l:modifiable'])
  try
    setlocal modifiable
    let cmdarg = a:0 == 0 ? v:cmdarg : a:1
    let fileencoding = matchstr(cmdarg, '++enc=\zs\S\+')
    if !empty(fileencoding)
      let &l:fileencoding = fileencoding
    endif
    let fileformat = matchstr(cmdarg, '++ff=\zs\S\+')
    if !empty(fileformat)
      let &l:fileformat = fileformat
    endif
  finally
    call guard.restore()
  endtry
endfunction


" Private --------------------------------------------------------------------
function! s:normalize_bufname(bufname) abort
  " The {bufname}
  " 1. Could not be started/ended with whitespaces
  " 2. Could not ends with ':' in Windows
  " 3. Should not ends with '/' in Vim 8 (opening a buffer fail randomly)
  let oldname = ''
  let newname = a:bufname
  while oldname !=# newname
    let oldname = newname
    let newname = substitute(newname, '\%(^\s\+\|\s\+$\)', '', 'g')
    let newname = substitute(newname, '\:\+$', '', '')
    let newname = substitute(newname, '[\\/]$', '', '')
  endwhile
  return newname
endfunction

function! s:open_without_callback(bufname, options) abort
  let context = s:Opener.open(a:bufname, {
        \ 'mods': a:options.mods,
        \ 'cmdarg': a:options.cmdarg,
        \ 'group':  a:options.group,
        \ 'opener': a:options.opener,
        \ 'range': a:options.range,
        \})
  return context
endfunction

function! s:open_with_callback(bufname, options) abort
  " Open a buffer without BufReadCmd
  let guard = s:Guard.store(['&eventignore'])
  try
    set eventignore+=BufReadCmd
    let context = s:Opener.open(a:bufname, {
          \ 'mods': a:options.mods,
          \ 'group':  a:options.group,
          \ 'opener': a:options.opener,
          \ 'range': a:options.range,
          \})
  finally
    call guard.restore()
  endtry
  " NOTE:
  " The content of the buffer MUST NOT be modified by callback while 'edit'
  " command will be called to override the content later.
  let content = getline(1, '$')
  call call(
        \ a:options.callback.fn,
        \ get(a:options.callback, 'args', []),
        \ a:options.callback
        \)
  if content != getline(1, '$')
    throw gina#core#revelator#critical(
          \ 'A buffer content could not be modified by callback'
          \)
  endif
  " Update content
  if !&modified
    execute 'keepjumps edit' a:options.cmdarg
  endif
  return context
endfunction

function! s:is_locator_available(opener) abort
  if a:opener =~# '\<p\%[tag]!\?\>'
    return 0
  elseif a:opener =~# '\<ped\%[it]!\?\>'
    return 0
  elseif a:opener =~# '\<ps\%[earch]!\?\>'
    return 0
  elseif a:opener =~# '\<\%(tabe\%[dit]\|tabnew\)\>'
    return 0
  elseif a:opener =~# '\<tabf\%[ind]\>'
    return 0
  endif
  return 1
endfunction
