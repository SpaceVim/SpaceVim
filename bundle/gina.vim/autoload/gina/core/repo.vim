let s:Git = vital#gina#import('Git')
let s:Path = vital#gina#import('System.Filepath')
let s:Store = vital#gina#import('System.Store')


function! gina#core#repo#abspath(git, expr) abort
  return gina#core#path#abspath(a:expr, a:git.worktree)
endfunction

function! gina#core#repo#relpath(git, expr) abort
  let path = gina#core#path#expand(a:expr)
  if s:Path.is_relative(s:Path.realpath(path))
    return path
  endif
  let path = gina#core#path#relpath(path, a:git.worktree)
  if path ==# path && path !=# resolve(path)
    return gina#core#path#relpath(resolve(path), a:git.worktree)
  endif
  return path
endfunction

function! gina#core#repo#config(git) abort
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of(s:Git.resolve(a:git, 'config'))
  let config = store.get(slug, {})
  if !empty(config)
    return config
  endif
  let result = gina#process#call(a:git, ['config', '--list'])
  if result.status
    throw gina#process#errormsg(result)
  endif
  let config = {}
  for record in filter(copy(result.stdout), '!empty(v:val)')
    call s:extend_config(config, record)
  endfor
  call store.set(slug, config)
  return config
endfunction


" Private --------------------------------------------------------------------
function! s:extend_config(config, record) abort
  let m = matchlist(a:record, '^\(.\+\)=\(.*\)$')
  if empty(m)
    return
  endif
  let a:config[tolower(m[1])] = m[2]
endfunction
