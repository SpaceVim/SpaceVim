function! gina#action#browse#define(binder) abort
  call a:binder.define('browse', function('s:on_browse'), {
        \ 'description': 'Open a remote url in a system browser',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {},
        \ 'use_marks': 0,
        \ 'clear_marks': 0,
        \})
  call a:binder.define('browse:exact', function('s:on_browse'), {
        \ 'hidden': 1,
        \ 'description': 'Open a remote url in a system browser',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': { 'exact': 1 },
        \ 'use_marks': 0,
        \ 'clear_marks': 0,
        \})
  call a:binder.define('browse:yank', function('s:on_browse'), {
        \ 'description': 'Copy a remote url',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': { 'yank': 1 },
        \ 'use_marks': 0,
        \ 'clear_marks': 0,
        \})
  call a:binder.define('browse:yank:exact', function('s:on_browse'), {
        \ 'hidden': 1,
        \ 'description': 'Copy a remote url',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': { 'yank': 1, 'exact': 1 },
        \ 'use_marks': 0,
        \ 'clear_marks': 0,
        \})
endfunction


" Private --------------------------------------------------------------------
function! s:on_browse(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'exact': 0,
        \ 'yank': 0,
        \}, a:options)
  let candidate = a:candidates[0]
  let treeish = gina#core#treeish#build(
        \ gina#util#get(candidate, 'rev'),
        \ gina#util#get(candidate, 'path', v:null),
        \)
  execute printf(
        \ '%s Gina browse %s %s %s',
        \ options.mods,
        \ options.exact ? '--exact' : '',
        \ options.yank ? '--yank' : '',
        \ gina#util#shellescape(treeish),
        \)
endfunction
