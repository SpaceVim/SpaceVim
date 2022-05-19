let s:Path = vital#gina#import('System.Filepath')
let s:Git = vital#gina#import('Git')


function! gina#core#treeish#parse(treeish) abort
  " Ref: https://git-scm.com/docs/gitrevisions
  if a:treeish =~# '^:/' || a:treeish =~# '^[^:]*^{/' || a:treeish !~# ':'
    return [a:treeish, v:null]
  endif
  let m = matchlist(a:treeish, '^\(:[0-3]\|[^:]*\)\%(:\(.*\)\)\?$')
  return [m[1], m[2]]
endfunction

function! gina#core#treeish#build(rev, path) abort
  let rev = a:rev is# v:null ? ':0' : a:rev
  if a:path is# v:null
    return rev
  endif
  return printf('%s:%s', rev, s:Path.unixpath(a:path))
endfunction

function! gina#core#treeish#split(rev) abort
  if a:rev =~# '^.\{-}\.\.\..*$'
    let [lhs, rhs] = matchlist(a:rev, '^\(.\{-}\)\.\.\.\(.*\)$')[1 : 2]
    let lhs = empty(lhs) ? 'HEAD' : lhs
    let rhs = empty(rhs) ? 'HEAD' : rhs
    return [lhs . '...' . rhs, rhs]
  elseif a:rev =~# '^.\{-}\.\..*$'
    let [lhs, rhs] = matchlist(a:rev, '^\(.\{-}\)\.\.\(.*\)$')[1 : 2]
    let lhs = empty(lhs) ? 'HEAD' : lhs
    let rhs = empty(rhs) ? 'HEAD' : rhs
    return [lhs, rhs]
  else
    return [a:rev, '']
  endif
endfunction

function! gina#core#treeish#sha1(git, rev) abort
  let ref = s:Git.ref(a:git, a:rev)
  if !empty(ref)
    return ref.hash
  endif
  " Fallback to rev-parse (e.g. HEAD@{2.days.ago})
  let result = gina#process#call_or_fail(a:git, ['rev-parse', a:rev])
  return get(result.stdout, 0, '')
endfunction

function! gina#core#treeish#resolve(git, rev, ...) abort
  let aggressive = a:0 ? a:1 : 0
  if a:rev =~# '^.\{-}\.\.\..*$'
    let [lhs, rhs] = matchlist(a:rev, '^\(.\{-}\)\.\.\.\(.*\)$')[1 : 2]
    let lhs = empty(lhs) ? 'HEAD' : lhs
    let rhs = empty(rhs) ? 'HEAD' : rhs
    return s:find_common_ancestor(a:git, lhs, rhs)
  elseif a:rev =~# '^.\{-}\.\..*$'
    let [lhs, _] = matchlist(a:rev, '^\(.\{-}\)\.\.\(.*\)$')[1 : 2]
    let lhs = empty(lhs) ? 'HEAD' : lhs
    if aggressive
      let ref = s:Git.ref(a:git, lhs)
      return get(ref, 'name', lhs)
    else
      return lhs
    endif
  elseif aggressive
    let ref = s:Git.ref(a:git, a:rev)
    return get(ref, 'name', a:rev)
  else
    return a:rev
  endif
endfunction

function! gina#core#treeish#validate(git, rev, path, ...) abort
  let treeish = gina#core#treeish#build(a:rev, a:path)
  let result = gina#process#call(a:git, ['rev-parse', treeish])
  if result.status
    throw gina#core#revelator#warning(a:0 ? a:1 : join(result.stderr, "\n"))
  endif
endfunction


" Private --------------------------------------------------------------------
function! s:find_common_ancestor(git, rev1, rev2) abort
  let lhs = empty(a:rev1) ? 'HEAD' : a:rev1
  let rhs = empty(a:rev2) ? 'HEAD' : a:rev2
  let result = gina#process#call_or_fail(a:git, [
        \ 'merge-base', lhs, rhs
        \])
  return get(result.stdout, 0, '')
endfunction
