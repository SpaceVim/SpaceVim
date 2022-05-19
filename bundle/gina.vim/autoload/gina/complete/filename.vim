let s:Git = vital#gina#import('Git')
let s:Path = vital#gina#import('System.Filepath')
let s:Store = vital#gina#import('System.Store')
let s:String = vital#gina#import('Data.String')


function! gina#complete#filename#directory(arglead, cmdline, cursorpos) abort
  let separator = s:Path.separator()
  return filter(
        \ gina#complete#filename#any(a:arglead, a:cmdline, a:cursorpos),
        \ 'v:val =~# separator . ''$'''
        \)
endfunction

function! gina#complete#filename#any(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let candidates = s:get_available_filenames(git, [
        \ '--cached', '--others', '--', a:arglead . '*',
        \])
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#filename#tracked(arglead, cmdline, cursorpos, ...) abort
  let rev = a:0 ? a:1 : ''
  let git = gina#core#get_or_fail()
  let slug = eval(s:Store.get_slug_expr()) . rev
  let store = s:Store.of([
        \ s:Git.resolve(git, 'HEAD'),
        \ s:Git.resolve(git, 'index'),
        \])
  let candidates = store.get(slug, [])
  if empty(candidates)
    let candidates = s:get_available_filenames(git, [], rev)
    call store.set(slug, candidates)
  endif
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#filename#cached(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of([
        \ s:Git.resolve(git, 'HEAD'),
        \ s:Git.resolve(git, 'index'),
        \])
  let candidates = store.get(slug, [])
  if empty(candidates)
    let candidates = s:get_available_filenames(git, ['--cached'])
    call store.set(slug, candidates)
  endif
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#filename#deleted(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of([
        \ s:Git.resolve(git, 'HEAD'),
        \ s:Git.resolve(git, 'index'),
        \])
  let candidates = store.get(slug, [])
  if empty(candidates)
    let candidates = s:get_available_filenames(git, ['--deleted'])
    call store.set(slug, candidates)
  endif
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#filename#modified(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of([
        \ s:Git.resolve(git, 'HEAD'),
        \ s:Git.resolve(git, 'index'),
        \])
  let candidates = store.get(slug, [])
  if empty(candidates)
    let candidates = s:get_available_filenames(git, ['--modified'])
    call store.set(slug, candidates)
  endif
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#filename#others(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let candidates = s:get_available_filenames(git, [
        \ '--others', '--', a:arglead . '*',
        \])
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#filename#unstaged(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let candidates = s:get_available_filenames(git, [
        \ '--others',
        \ '--modified',
        \ '--',
        \ a:arglead . '*',
        \])
  return s:filter(a:arglead, candidates)
endfunction

function! gina#complete#filename#conflicted(arglead, cmdline, cursorpos) abort
  let git = gina#core#get_or_fail()
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of([
        \ s:Git.resolve(git, 'HEAD'),
        \ s:Git.resolve(git, 'index'),
        \])
  let candidates = store.get(slug, [])
  if empty(candidates)
    let result = gina#process#call(git, [
          \ 'status',
          \ '--porcelain',
          \ '--ignore-submodules',
          \])
    if result.status
      return []
    endif
    call filter(
          \ candidates,
          \ 'v:val[:1] =~# ''^\%(DD\|AU\|UD\|UA\|DU\|AA\|UU\)'''
          \)
    call map(candidates, 'matchstr(v:val, ''.. \zs.*'')')
    call store.set(slug, candidates)
  endif
  return s:filter(a:arglead, candidates)
endfunction

" Private --------------------------------------------------------------------
function! s:filter(arglead, candidates) abort
  let pattern = s:String.escape_pattern(a:arglead)
  let separator = s:Path.separator()
  let candidates = gina#util#filter(a:arglead, a:candidates, '^\.')
  call map(
        \ candidates,
        \ printf(
        \   'matchstr(v:val, ''^%s[^%s]*%s\?\ze'')',
        \   pattern, separator, separator
        \ ),
        \)
  return uniq(candidates)
endfunction

function! s:get_available_filenames(git, args, ...) abort
  let rev = a:0 ? a:1 : ''
  if empty(rev)
    let args = ['ls-files', '--full-name']
  else
    let args = [
          \ 'ls-tree',
          \ '--full-name',
          \ '--full-tree',
          \ '--name-only',
          \ '-r',
          \ rev,
          \]
  endif
  let result = gina#process#call(a:git, args + a:args)
  if result.status
    return []
  endif
  return map(result.stdout, 'gina#core#repo#relpath(a:git, v:val)')
endfunction
