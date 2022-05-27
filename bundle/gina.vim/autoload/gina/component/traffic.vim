scriptencoding utf-8

let s:Git = vital#gina#import('Git')
let s:Path = vital#gina#import('System.Filepath')
let s:Store = vital#gina#import('System.Store')


function! gina#component#traffic#ahead() abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  let slug = eval(s:Store.get_slug_expr())
  let ref = get(s:Git.ref(git, 'HEAD'), 'path', 'HEAD')
  let track = s:get_tracking_ref(git)
  let store = s:Store.of([
        \ s:Git.resolve(git, 'index'),
        \ s:Git.resolve(git, ref),
        \ s:Git.resolve(git, track),
        \])
  let ahead = store.get(slug, '')
  if !empty(ahead)
    return str2nr(ahead)
  endif
  if !exists('s:ahead_job')
    let pipe = gina#process#pipe#store()
    let pipe.__on_exit = pipe.on_exit
    let pipe.on_exit = funcref('s:ahead_on_exit', [store, slug])
    let s:ahead_job = gina#process#open(git, [
          \ 'log',
          \ '--oneline',
          \ '@{upstream}..',
          \], pipe)
  endif
  return ''
endfunction

function! gina#component#traffic#behind() abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  let slug = eval(s:Store.get_slug_expr())
  let ref = get(s:Git.ref(git, 'HEAD'), 'path', 'HEAD')
  let track = s:get_tracking_ref(git)
  let store = s:Store.of([
        \ s:Git.resolve(git, 'index'),
        \ s:Git.resolve(git, ref),
        \ s:Git.resolve(git, track),
        \])
  let behind = store.get(slug, '')
  if !empty(behind)
    return str2nr(behind)
  endif
  if !exists('s:behind_job')
    let pipe = gina#process#pipe#store()
    let pipe.__on_exit = pipe.on_exit
    let pipe.on_exit = funcref('s:behind_on_exit', [store, slug])
    let s:behind_job = gina#process#open(git, [
          \ 'log',
          \ '--oneline',
          \ '..@{upstream}',
          \], pipe)
  endif
  return ''
endfunction

function! gina#component#traffic#preset(...) abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  let kind = get(a:000, 0, 'ascii')
  return call('s:preset_' . kind, [])
endfunction

" Private --------------------------------------------------------------------
function! s:ahead_on_exit(store, slug, exitval) abort dict
  call self.__on_exit(a:exitval)
  silent! unlet! s:ahead_job
  if a:exitval
    return
  endif
  let ahead = len(filter(copy(self.stdout), '!empty(v:val)')) . ''
  call a:store.set(a:slug, ahead)
endfunction

function! s:behind_on_exit(store, slug, exitval) abort dict
  call self.__on_exit(a:exitval)
  silent! unlet! s:behind_job
  if a:exitval
    return
  endif
  let behind = len(filter(copy(self.stdout), '!empty(v:val)')) . ''
  call a:store.set(a:slug, behind)
endfunction

function! s:get_tracking_ref(git) abort
  let slug = eval(s:Store.get_slug_expr())
  let store = s:Store.of([
        \ s:Git.resolve(a:git, 'HEAD'),
        \ s:Git.resolve(a:git, 'config'),
        \])
  let ref = store.get(slug, '')
  if !empty(ref)
    return ref
  endif
  if !exists('s:tracking_ref_job')
    let pipe = gina#process#pipe#store()
    let pipe.__on_exit = pipe.on_exit
    let pipe.on_exit = funcref('s:tracking_ref_on_exit', [store, slug])
    let s:tracking_ref_job = gina#process#open(a:git, [
          \ 'rev-parse',
          \ '--symbolic-full-name',
          \ '@{upstream}',
          \], pipe)
  endif
  return ''
endfunction

function! s:tracking_ref_on_exit(store, slug, exitval) abort dict
  call self.__on_exit(a:exitval)
  silent! unlet! s:tracking_ref_job
  if a:exitval
    return
  endif
  call a:store.set(a:slug, get(self.stdout, 0))
endfunction

function! s:preset_ascii() abort
  let ahead = gina#component#traffic#ahead()
  let behind = gina#component#traffic#behind()
  let ahead = empty(ahead) ? '' : ('^' . ahead)
  let behind = empty(behind) ? '' : ('v' . behind)
  return join(filter([ahead, behind], '!empty(v:val)'))
endfunction

function! s:preset_fancy() abort
  let ahead = gina#component#traffic#ahead()
  let behind = gina#component#traffic#behind()
  let ahead = empty(ahead) ? '' : ('↑' . ahead)
  let behind = empty(behind) ? '' : ('↓' . behind)
  return join(filter([ahead, behind], '!empty(v:val)'))
endfunction
