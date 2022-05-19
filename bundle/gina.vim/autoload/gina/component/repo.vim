scriptencoding utf-8

let s:Git = vital#gina#import('Git')
let s:Path = vital#gina#import('System.Filepath')
let s:Store = vital#gina#import('System.Store')


function! gina#component#repo#name() abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  return fnamemodify(git.worktree, ':t')
endfunction

function! gina#component#repo#branch() abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of([
        \ s:Git.resolve(git, 'HEAD'),
        \ s:Git.resolve(git, 'config'),
        \])
  let branch = store.get(slug, '')
  if !empty(branch)
    return branch
  endif
  let content = get(readfile(s:Git.resolve(git, 'HEAD')), 0, '')
  if content =~# '^ref:\s\+refs/heads'
    let branch = matchstr(content, '^ref:\s\+refs/heads/\zs.\+')
  elseif content =~# '^ref:'
    let branch = matchstr(content, '^ref:\s\+refs/\zs.\+')
  elseif g:gina#component#repo#commit_length > 0
    let branch = content[:(g:gina#component#repo#commit_length - 1)]
  else
    let branch = content
  endif
  call store.set(slug, branch)
  return branch
endfunction

function! gina#component#repo#track() abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of([
        \ s:Git.resolve(git, 'HEAD'),
        \ s:Git.resolve(git, 'config'),
        \])
  let branch = store.get(slug, '')
  if !empty(branch)
    return branch
  endif
  if !exists('s:track_job')
    let pipe = gina#process#pipe#store()
    let pipe.__on_exit = pipe.on_exit
    let pipe.on_exit = funcref('s:track_on_exit', [store, slug])
    let s:track_job = gina#process#open(git, [
          \ 'rev-parse',
          \ '--abbrev-ref',
          \ '--symbolic-full-name',
          \ '@{upstream}',
          \], pipe)
  endif
  return ''
endfunction

function! gina#component#repo#preset(...) abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  let kind = get(a:000, 0, 'ascii')
  return call('s:preset_' . kind, [])
endfunction


" Private --------------------------------------------------------------------
function! s:track_on_exit(store, slug, exitval) abort dict
  call self.__on_exit(a:exitval)
  silent! unlet! s:track_job
  if a:exitval
    return
  endif
  call a:store.set(a:slug, get(self.stdout, 0))
endfunction

function! s:preset_ascii() abort
  let name = gina#component#repo#name()
  let branch = gina#component#repo#branch()
  let track = gina#component#repo#track()
  if empty(track)
    return printf('%s [%s]', name, branch)
  endif
  return printf('%s [%s -> %s]', name, branch, track)
endfunction

function! s:preset_fancy() abort
  let name = gina#component#repo#name()
  let branch = gina#component#repo#branch()
  let track = gina#component#repo#track()
  if empty(track)
    return printf('%s [%s]', name, branch)
  endif
  return printf('%s [%s → %s]', name, branch, track)
endfunction


call gina#config(expand('<sfile>'), {
      \ 'commit_length': 0,
      \})
