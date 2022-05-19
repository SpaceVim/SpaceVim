function! gina#action#branch#define(binder) abort
  call a:binder.define('branch:refresh', function('s:on_refresh'), {
        \ 'description': 'Refresh remote branches',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {},
        \ 'use_marks': 0,
        \ 'clear_marks': 0,
        \})
  call a:binder.define('branch:new', function('s:on_new'), {
        \ 'description': 'Create a new branch',
        \ 'mapping_mode': 'n',
        \ 'requirements': ['branch', 'remote'],
        \ 'options': {},
        \})
  call a:binder.define('branch:move', function('s:on_move'), {
        \ 'description': 'Rename a branch',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['branch', 'remote'],
        \ 'options': {},
        \})
  call a:binder.define('branch:move:force', function('s:on_move'), {
        \ 'hidden': 1,
        \ 'description': 'Rename a branch',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['branch', 'remote'],
        \ 'options': { 'force': 1 },
        \})
  call a:binder.define('branch:delete', function('s:on_delete'), {
        \ 'description': 'Delete a branch',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['branch', 'remote'],
        \ 'options': {},
        \})
  call a:binder.define('branch:delete:force', function('s:on_delete'), {
        \ 'hidden': 1,
        \ 'description': 'Delete a branch',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['branch', 'remote'],
        \ 'options': { 'force': 1 },
        \})
  call a:binder.define('branch:set-upstream-to', function('s:on_set_upstream_to'), {
        \ 'description': 'Set an upstream of a branch',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['branch', 'remote'],
        \ 'options': {},
        \})
  call a:binder.define('branch:unset-upstream', function('s:on_unset_upstream'), {
        \ 'description': 'Unset an upstream of a branch',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['branch', 'remote'],
        \ 'options': {},
        \})
endfunction


" Private --------------------------------------------------------------------
function! s:on_refresh(candidates, options) abort
  let options = extend({}, a:options)
  execute printf(
        \ '%s Gina remote update --prune',
        \ options.mods,
        \)
endfunction

function! s:on_new(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  for candidate in a:candidates
    let name = gina#core#console#ask_or_cancel(
          \ 'Name: ', '',
          \)
    let from = gina#core#console#ask_or_cancel(
          \ 'From: ', candidate.rev,
          \ function('gina#complete#commit#branch')
          \)
    execute printf(
          \ '%s Gina checkout -b %s %s',
          \ options.mods,
          \ gina#util#shellescape(name),
          \ gina#util#shellescape(from),
          \)
  endfor
endfunction

function! s:on_move(candidates, options) abort
  let candidates = filter(copy(a:candidates), 'empty(v:val.remote)')
  if empty(candidates)
    return
  endif
  let options = extend({
        \ 'force': 0,
        \}, a:options)
  for candidate in candidates
    let name = gina#core#console#ask_or_cancel(
          \ 'Rename: ',
          \ candidate.branch,
          \)
    execute printf(
          \ '%s Gina branch --move %s %s %s',
          \ options.mods,
          \ options.force ? '--force' : '',
          \ gina#util#shellescape(candidate.branch),
          \ gina#util#shellescape(name),
          \)
  endfor
endfunction

function! s:on_delete(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'force': 0,
        \}, a:options)
  for candidate in a:candidates
    let is_remote = !empty(candidate.remote)
    if is_remote
      execute printf(
            \ '%s Gina push --delete %s %s %s',
            \ options.mods,
            \ options.force ? '--force' : '',
            \ gina#util#shellescape(candidate.remote),
            \ gina#util#shellescape(candidate.branch),
            \)
    else
      execute printf(
            \ '%s Gina branch --delete %s %s',
            \ options.mods,
            \ options.force ? '--force' : '',
            \ gina#util#shellescape(candidate.branch),
            \)
    endif
  endfor
endfunction

function! s:on_set_upstream_to(candidates, options) abort
  let candidates = filter(copy(a:candidates), 'empty(v:val.remote)')
  if empty(candidates)
    return
  endif
  let options = extend({}, a:options)
  for candidate in candidates
    let upstream = gina#core#console#ask_or_cancel(
          \ 'Upstream: ', candidate.branch,
          \ function('gina#complete#commit#remote_branch'),
          \)
    let upstream = substitute(
          \ upstream, printf('^%s/', candidate.remote), '', ''
          \)
    execute printf(
          \ '%s Gina branch --set-upstream-to=%s %s',
          \ options.mods,
          \ gina#util#shellescape(upstream),
          \ gina#util#shellescape(candidate.branch),
          \)
  endfor
endfunction

function! s:on_unset_upstream(candidates, options) abort
  let candidates = filter(copy(a:candidates), 'empty(v:val.remote)')
  if empty(candidates)
    return
  endif
  let options = extend({}, a:options)
  for candidate in candidates
    execute printf(
          \ '%s Gina branch --unset-upstream %s',
          \ options.mods,
          \ gina#util#shellescape(candidate.branch),
          \)
  endfor
endfunction
