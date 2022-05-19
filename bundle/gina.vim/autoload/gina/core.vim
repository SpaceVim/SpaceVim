let s:Cache = vital#gina#import('System.Cache.Memory')
let s:Git = vital#gina#import('Git')

let s:registry = s:Cache.new()
let s:reference = s:Cache.new()

let s:CACHE_NEVER = 'never'   " No cache. Search .git always.
let s:CACHE_TRUTH = 'truth'   " Use a cache when a git repository is found.
let s:CACHE_ALWAYS = 'always' " Use a cache always.


function! gina#core#get_or_fail(...) abort
  let options = extend({
        \ 'expr': '%',
        \ 'cache': s:CACHE_TRUTH,
        \}, get(a:000, 0, {})
        \)
  let git = gina#core#get(options)
  if !empty(git)
    return git
  endif
  throw gina#core#revelator#warning(printf(
        \ 'No git repository for a buffer "%s" is found.',
        \ expand(options.expr)
        \))
endfunction

function! gina#core#get(...) abort
  let options = extend({
        \ 'expr': '%',
        \ 'cache': s:CACHE_ALWAYS,
        \}, get(a:000, 0, {})
        \)
  if options.cache !=# s:CACHE_NEVER
    let cached = s:get_cached_instance(options.expr)
    if !empty(cached)
      call gina#core#console#debug(printf(
            \ 'A cached git instanse "%s" is used for "%s"',
            \ get(cached, 'refname', ''),
            \ expand(options.expr),
            \))
      return cached
    elseif options.cache ==# s:CACHE_TRUTH && cached isnot# v:null
      call gina#core#console#debug(printf(
            \ 'An empty cached git instanse is used for "%s"',
            \ expand(options.expr),
            \))
      return cached
    endif
  endif

  let params = gina#core#buffer#parse(options.expr)
  if empty(params)
    let git = {}
    let params.path = expand(options.expr)
  else
    let git = s:get_from_cache(params.repo)
  endif
  if empty(git)
    if s:is_file_buffer(options.expr)
      let git = s:get_from_bufname(params.path)
    else
      let git = s:get_from_cwd(bufnr(options.expr))
    endif
  endif
  call s:set_cached_instance(options.expr, git)
  return git
endfunction

function! gina#core#git_version() abort
  if exists('s:git_version')
    return s:git_version
  endif
  let r = gina#process#call(gina#core#get(), ['--version'])
  let s:git_version = matchstr(join(r.stdout, "\n"), '\%(\d\+\.\)\+\d')
  return s:git_version
endfunction


" Private --------------------------------------------------------------------
function! s:is_file_buffer(expr) abort
  return getbufvar(a:expr, '&buftype', '') =~# '^\%(\|nowrite\|acwrite\)$'
endfunction

function! s:get_cached_instance(expr) abort
  let refinfo = getbufvar(a:expr, 'gina', {})
  if empty(refinfo)
    return v:null
  endif
  " Check if the refinfo is fresh enough
  if refinfo.bufname !=# simplify(bufname(a:expr))
    return v:null
  elseif refinfo.buftype !=# getbufvar(a:expr, '&buftype', '')
    return v:null
  elseif refinfo.cwd !=# simplify(getcwd())
    return v:null
  endif
  " refinfo is fresh enough, use a cached git instance
  return s:get_from_cache(refinfo.refname)
endfunction

function! s:set_cached_instance(expr, git) abort
  if bufexists(bufnr(a:expr))
    call setbufvar(a:expr, 'gina', {
          \ 'refname': get(a:git, 'refname', ''),
          \ 'bufname': simplify(bufname(a:expr)),
          \ 'buftype': getbufvar(a:expr, '&buftype', ''),
          \ 'cwd': simplify(getcwd()),
          \})
  endif
endfunction

function! s:get_available_refname(refname, git) abort
  let refname = a:refname
  let ref = s:reference.get(refname, '')
  let index = 1
  while !empty(ref) && ref !=# a:git.worktree
    let refname = a:refname . '~' . index
    let ref = s:reference.get(refname, '')
    let index += 1
  endwhile
  return refname
endfunction

function! s:get_from_cache(reference) abort
  if s:registry.has(a:reference)
    return s:registry.get(a:reference)
  elseif s:reference.has(a:reference)
    return s:registry.get(s:reference.get(a:reference), {})
  endif
  return {}
endfunction

function! s:get_from_path(path) abort
  let path = simplify(fnamemodify(a:path, ':p'))
  let git = s:Git.new(path)
  if empty(git)
    return {}
  endif
  let git.refname = s:get_available_refname(
        \ fnamemodify(git.worktree, ':t'),
        \ git,
        \)
  call s:registry.set(git.worktree, git)
  call s:reference.set(path, git.worktree)
  call s:reference.set(git.refname, git.worktree)
  return git
endfunction

function! s:get_from_bufname(path) abort
  let git = s:get_from_path(a:path)
  if !empty(git)
    return git
  endif

  " Resolve symbol link
  let sympath = simplify(resolve(a:path))
  if sympath !=# a:path
    let git = s:get_from_path(sympath)
    if !empty(git)
      return git
    endif
  endif

  " Not found
  return {}
endfunction

function! s:get_from_cwd(bufnr) abort
  let winnr = bufwinnr(a:bufnr)
  let cwdpath = winnr == -1
        \ ? simplify(getcwd())
        \ : simplify(getcwd(winnr))
  return s:get_from_path(cwdpath)
endfunction
