function! s:find_path_and_lnum(git, src_prefix, dst_prefix) abort
  if getline('.') =~# '^-'
    return s:find_path_and_lnum_lhs(a:git, a:src_prefix)
  elseif getline('.') =~# '^[ +]'
    return s:find_path_and_lnum_rhs(a:git, a:dst_prefix)
  else
    return v:null
  endif
endfunction

function! s:find_path_and_lnum_lhs(git, prefix) abort
  let lnum = search('^@@', 'bnW')
  let m = matchlist(
        \ getline(lnum),
        \ '^@@ -\(\d\+\)\%(,\(\d\+\)\)\? +\(\d\+\),\(\d\+\) @@\(.*\)$'
        \)
  if empty(m)
    return v:null
  endif
  let path = matchstr(
        \ getline(search('^--- ', 'bnW')),
        \ printf('^--- %s\zs.*$', a:prefix),
        \)
  if empty(path)
    return v:null
  endif
  let n = len(filter(
        \ map(range(lnum, line('.')), { _, v -> getline(v) }),
        \ { _, v -> v !~# '^+' }
        \))
  return {'path': path, 'lnum': m[1] + n - 2, 'side': 0}
endfunction

function! s:find_path_and_lnum_rhs(git, prefix) abort
  if getline('.') !~# '^[ -+]'
    return v:null
  endif
  let lnum = search('^@@', 'bnW')
  let m = matchlist(
        \ getline(lnum),
        \ '^@@ -\(\d\+\)\%(,\(\d\+\)\)\? +\(\d\+\),\(\d\+\) @@\(.*\)$'
        \)
  if empty(m)
    return v:null
  endif
  let path = matchstr(
        \ getline(search('^+++ ', 'bnW')),
        \ printf('^+++ %s\zs.*$', a:prefix)
        \)
  if empty(path)
    return v:null
  endif
  let n = len(filter(
        \ map(range(lnum, line('.')), { _, v -> getline(v) }),
        \ { _, v -> v !~# '^-' }
        \))
  return {'path': path, 'lnum': m[3] + n - 2, 'side': 1}
endfunction

function! s:jump(opener) abort
  let git = gina#core#get_or_fail()
  let args = gina#core#meta#get_or_fail('args')
  let config = gina#core#repo#config(git)

  if get(config, 'diff.noprefix', '') =~? 'true' || args.get('--no-prefix')
    let src_prefix = ''
    let dst_prefix = ''
  else
    let src_prefix = args.get('--src-prefix', '[aic]/')
    let dst_prefix = args.get('--dst-prefix', '[bwi]/')
  endif

  let pathinfo = s:find_path_and_lnum(git, src_prefix, dst_prefix)
  if pathinfo is v:null
    return 1
  endif

  let rev = pathinfo.side ? args.params.rev2 : args.params.rev1
  if gina#core#args#is_worktree(rev) && pathinfo.side == 1
    call gina#core#console#debug(printf(
          \ 'Gina edit --line=%d --opener=%s %s',
          \ pathinfo.lnum,
          \ a:opener,
          \ pathinfo.path,
          \))
    execute printf(
          \ 'Gina edit --line=%d --opener=%s %s',
          \ pathinfo.lnum,
          \ a:opener,
          \ pathinfo.path,
          \)
  else
    call gina#core#console#debug(printf(
          \ 'Gina show --line=%d --opener=%s %s:%s',
          \ pathinfo.lnum,
          \ a:opener,
          \ rev,
          \ pathinfo.path,
          \))
    execute printf(
          \ 'Gina show --line=%d --opener=%s %s:%s',
          \ pathinfo.lnum,
          \ a:opener,
          \ rev,
          \ pathinfo.path,
          \)
  endif
endfunction

function! gina#core#diffjump#jump(...) abort
  let opener = a:0 ? a:1 : ''
  let opener = empty(opener) ? 'edit' : opener
  return gina#core#revelator#call(
        \ function('s:jump'),
        \ [opener],
        \)
endfunction
