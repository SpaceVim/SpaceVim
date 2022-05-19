function! gina#action#tag#define(binder) abort
  call a:binder.define('tag:new:lightweight', function('s:on_new'), {
        \ 'description': 'Create a lightweight tag',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {},
        \})
  call a:binder.define('tag:new:annotate', function('s:on_new'), {
        \ 'description': 'Create an unsigned, annotated tag',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {'annotate': 1},
        \})
  call a:binder.define('tag:new:sign', function('s:on_new'), {
        \ 'description': 'Create a GPG-signed tag',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {'sign': 1},
        \})
  call a:binder.define('tag:new:lightweight:force', function('s:on_new'), {
        \ 'hidden': 1,
        \ 'description': 'Create a lightweight tag',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {'force': 1},
        \})
  call a:binder.define('tag:new:annotate:force', function('s:on_new'), {
        \ 'hidden': 1,
        \ 'description': 'Create an unsigned, annotated tag',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {'annotate': 1, 'force': 1},
        \})
  call a:binder.define('tag:new:sign:force', function('s:on_new'), {
        \ 'hidden': 1,
        \ 'description': 'Create a GPG-signed tag',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {'sign': 1, 'force': 1},
        \})
  call a:binder.define('tag:delete', function('s:on_delete'), {
        \ 'description': 'Delete a tag',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['tag'],
        \ 'options': {},
        \})
  call a:binder.define('tag:verify', function('s:on_verify'), {
        \ 'description': 'Verify a tag',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['tag'],
        \ 'options': {},
        \})
  " Alias
  call a:binder.alias('tag:new', 'tag:new:annotate')
endfunction


" Private --------------------------------------------------------------------
function! s:on_new(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'annotate': 0,
        \ 'sign': 0,
        \ 'force': 0,
        \}, a:options)
  for candidate in a:candidates
    let name = gina#core#console#ask_or_cancel(
          \ 'Name: ', '',
          \)
    let from = gina#core#console#ask_or_cancel(
          \ 'From: ', 'HEAD',
          \ function('gina#complete#commit#branch')
          \)
    execute printf(
          \ '%s Gina tag %s %s %s %s %s',
          \ options.mods,
          \ options.annotate ? '--annotate' : '',
          \ options.sign ? '--sign' : '',
          \ options.force ? '--force' : '',
          \ gina#util#shellescape(name),
          \ gina#util#shellescape(from),
          \)
  endfor
endfunction

function! s:on_delete(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina tag --delete %s',
          \ options.mods,
          \ gina#util#shellescape(candidate.tag),
          \)
  endfor
endfunction

function! s:on_verify(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina tag --verify %s',
          \ options.mods,
          \ gina#util#shellescape(candidate.tag),
          \)
  endfor
endfunction
