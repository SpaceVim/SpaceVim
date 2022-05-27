function! gina#action#yank#define(binder) abort
  call a:binder.define('yank:rev', function('s:on_yank_rev'), {
        \ 'description': 'Yank the revision of a candidate under the cursor',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'use_marks': 0,
        \ 'clear_marks': 0,
        \})
  call a:binder.define('yank:path', function('s:on_yank_path'), {
        \ 'description': 'Yank the path of a candidate under the cursor',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'use_marks': 0,
        \ 'clear_marks': 0,
        \})
  call a:binder.define('yank:treeish', function('s:on_yank_treeish'), {
        \ 'description': 'Yank the treeish (revision and path) of a candidate under the cursor',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev', 'path'],
        \ 'use_marks': 0,
        \ 'clear_marks': 0,
        \})
endfunction


" Private --------------------------------------------------------------------
function! s:on_yank_rev(candidates, options) abort dict
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  let candidates = map(
        \ copy(a:candidates),
        \ 's:get_rev(v:val)'
        \)
  call gina#util#yank(join(candidates, "\n"))
endfunction

function! s:on_yank_path(candidates, options) abort dict
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  let candidates = map(
        \ copy(a:candidates),
        \ 's:get_path(v:val)'
        \)
  call gina#util#yank(join(candidates, "\n"))
endfunction

function! s:on_yank_treeish(candidates, options) abort dict
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  let candidates = map(
        \ copy(a:candidates),
        \ 's:get_treeish(v:val)'
        \)
  call gina#util#yank(join(candidates, "\n"))
endfunction

function! s:get_rev(candidate) abort
  let rev = gina#util#get(a:candidate, 'rev', v:null)
  return rev is v:null
        \ ? gina#core#buffer#param(bufname('%'), 'rev')
        \ : rev
endfunction

function! s:get_path(candidate) abort
  let path = gina#util#get(a:candidate, 'path', v:null)
  return path is v:null
        \ ? gina#core#buffer#param(bufname('%'), 'path')
        \ : path
endfunction

function! s:get_treeish(candidate) abort
  let rev = s:get_rev(a:candidate)
  let path = s:get_path(a:candidate)
  return gina#core#treeish#build(rev, path)
endfunction
