let s:Git = vital#gina#import('Git')
let s:Path = vital#gina#import('System.Filepath')
let s:String = vital#gina#import('Data.String')
let s:is_windows = has('win32') || has('win64')


if s:is_windows
  function! gina#core#path#expand(expr) abort
    return s:Path.unixpath(s:expand(s:realpath(a:expr)))
  endfunction

  function! gina#core#path#abspath(path, ...) abort
    let path = s:realpath(a:path)
    return s:Path.unixpath(call('s:abspath', [path] + a:000))
  endfunction

  function! gina#core#path#relpath(path, ...) abort
    let path = s:realpath(a:path)
    return s:Path.unixpath(call('s:relpath', [path] + a:000))
  endfunction

  function! s:realpath(path) abort
    if a:path =~# '^\w\+://'
      return s:Path.unixpath(a:path)
    endif
    return s:Path.realpath(a:path)
  endfunction
else
  function! gina#core#path#expand(expr) abort
    return s:expand(a:expr)
  endfunction

  function! gina#core#path#abspath(path, ...) abort
    return call('s:abspath', [a:path] + a:000)
  endfunction

  function! gina#core#path#relpath(path, ...) abort
    return call('s:relpath', [a:path] + a:000)
  endfunction
endif


function! s:expand(expr) abort
  if empty(a:expr) || a:expr[0] ==# ':'
    return a:expr
  elseif a:expr[:6] ==# 'gina://'
    let git = gina#core#get_or_fail({'expr': a:expr})
    let path = gina#core#buffer#param(a:expr, 'path')
    return empty(path) ? '' : s:Path.join(git.worktree, path)
  elseif a:expr[0] =~# '[%#<]'
    let m = matchlist(a:expr, '^\([%#]\|<\w\+>\)\(.*\)')
    let expr = expand(m[1])
    let modifiers = m[2]
    return fnamemodify(s:expand(expr), modifiers)
  endif
  return a:expr
endfunction

function! s:abspath(path, ...) abort
  if s:Path.is_absolute(a:path) || a:path[0] ==# ':'
    return a:path
  endif
  let root = s:Path.remove_last_separator(a:0 == 0 ? getcwd() : a:1)
  return s:Path.join(root, a:path)
endfunction

function! s:relpath(path, ...) abort
  if s:Path.is_relative(a:path) || a:path[0] ==# ':'
    return a:path
  endif
  let root = s:Path.remove_last_separator(a:0 == 0 ? getcwd() : a:1)
  let pattern = s:String.escape_pattern(root . s:Path.separator())
  return a:path =~# '^' . pattern
        \ ? matchstr(a:path, '^' . pattern . '\zs.*')
        \ : a:path
endfunction
