scriptencoding utf-8

let s:Git = vital#gina#import('Git')
let s:Path = vital#gina#import('System.Filepath')
let s:Store = vital#gina#import('System.Store')

let s:SLUG = eval(s:Store.get_slug_expr())


function! gina#component#status#staged() abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  let c = get(s:status_count(git), 'staged', 0)
  return c == 0 ? '' : (c . '')
endfunction

function! gina#component#status#unstaged() abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  let c = get(s:status_count(git), 'unstaged', 0)
  return c == 0 ? '' : (c . '')
endfunction

function! gina#component#status#conflicted() abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  let c = get(s:status_count(git), 'conflicted', 0)
  return c == 0 ? '' : (c . '')
endfunction

function! gina#component#status#preset(...) abort
  let git = gina#core#get()
  if empty(git)
    return ''
  endif
  let kind = get(a:000, 0, 'ascii')
  return call('s:preset_' . kind, [])
endfunction


" Private --------------------------------------------------------------------
function! s:get_store(git) abort
  let ref = get(s:Git.ref(a:git, 'HEAD'), 'path', 'HEAD')
  let store = s:Store.of([
        \ s:Git.resolve(a:git, 'index'),
        \ s:Git.resolve(a:git, ref),
        \])
  return store
endfunction

function! s:status_count(git) abort
  let store = s:get_store(a:git)
  let status_count = store.get(s:SLUG, {})
  if !empty(status_count)
    return status_count
  endif
  if !exists('s:status_job')
    let pipe = gina#process#pipe#store()
    let pipe.__on_exit = pipe.on_exit
    let pipe.on_exit = funcref('s:status_on_exit', [store])
    let s:status_job = gina#process#open(a:git, [
          \ 'status',
          \ '--porcelain',
          \ '--ignore-submodules',
          \], pipe)
  endif
  return {
        \ 'staged': 0,
        \ 'unstaged': 0,
        \ 'conflicted': 0,
        \}
endfunction

function! s:status_on_exit(store, exitval) abort dict
  call self.__on_exit(a:exitval)
  silent! unlet! s:status_job
  if a:exitval
    return
  endif
  let status_count = {
        \ 'staged': 0,
        \ 'unstaged': 0,
        \ 'conflicted': 0,
        \}
  for record in self.stdout
    let sign = record[:1]
    if sign =~# '^\%(DD\|AU\|UD\|UA\|DU\|AA\|UU\)$'
      let status_count.conflicted += 1
    elseif sign ==# '??' || sign ==# '!!'
      continue
    else
      if sign =~# '^\S.$'
        let status_count.staged += 1
      endif
      if sign =~# '^.\S$'
        let status_count.unstaged += 1
      endif
    endif
  endfor
  call a:store.set(s:SLUG, status_count)
endfunction

function! s:preset_ascii() abort
  let staged = gina#component#status#staged()
  let unstaged = gina#component#status#unstaged()
  let conflicted = gina#component#status#conflicted()
  let staged = empty(staged) ? '' : ('<' . staged)
  let unstaged = empty(unstaged) ? '' : ('>' . unstaged)
  let conflicted = empty(conflicted) ? '' : ('x' . conflicted)
  return join(filter([staged, unstaged, conflicted], '!empty(v:val)'))
endfunction

function! s:preset_fancy() abort
  let staged = gina#component#status#staged()
  let unstaged = gina#component#status#unstaged()
  let conflicted = gina#component#status#conflicted()
  let staged = empty(staged) ? '' : ('«' . staged)
  let unstaged = empty(unstaged) ? '' : ('»' . unstaged)
  let conflicted = empty(conflicted) ? '' : ('×' . conflicted)
  return join(filter([staged, unstaged, conflicted], '!empty(v:val)'))
endfunction

" NOTE:
" Tracked files might be changed (unstaged) so remove cache when 'modified'
" event has called.
function! s:on_modified(...) abort
  let git = gina#core#get()
  if empty(git)
    return
  endif
  let store = s:get_store(git)
  call store.remove(s:SLUG)
endfunction

if !exists('s:subscribed')
  let s:subscribed = 1
  call gina#core#emitter#subscribe(
        \ 'modified',
        \ function('s:on_modified')
        \)
endif
