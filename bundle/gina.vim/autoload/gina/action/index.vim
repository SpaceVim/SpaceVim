let s:File = vital#gina#import('System.File')
let s:Path = vital#gina#import('System.Filepath')


function! gina#action#index#define(binder) abort
  call a:binder.define('index:add', function('s:on_add'), {
        \ 'hidden': 1,
        \ 'description': 'Add changes to an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': {},
        \})
  call a:binder.define('index:add:force', function('s:on_add'), {
        \ 'hidden': 1,
        \ 'description': 'Add changes to an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'force': 1 },
        \})
  call a:binder.define('index:add:intent-to-add', function('s:on_add'), {
        \ 'hidden': 1,
        \ 'description': 'Intent to add changes to an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'intent-to-add': 1 },
        \})
  call a:binder.define('index:rm', function('s:on_rm'), {
        \ 'hidden': 1,
        \ 'description': 'Remove files from a working tree and from an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': {},
        \})
  call a:binder.define('index:rm:force', function('s:on_rm'), {
        \ 'hidden': 1,
        \ 'description': 'Remove files from a working tree and from an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'force': 1 },
        \})
  call a:binder.define('index:rm:cached', function('s:on_rm'), {
        \ 'hidden': 1,
        \ 'description': 'Remove files from an index but a working tree',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'cached': 1 },
        \})
  call a:binder.define('index:reset', function('s:on_reset'), {
        \ 'hidden': 1,
        \ 'description': 'Reset changes on an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': {},
        \})
  call a:binder.define('index:stage', function('s:on_stage'), {
        \ 'description': 'Stage changes to an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path', 'sign'],
        \ 'options': {},
        \})
  call a:binder.define('index:stage:force', function('s:on_stage'), {
        \ 'hidden': 1,
        \ 'description': 'Stage changes to an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path', 'sign'],
        \ 'options': { 'force': 1 },
        \})
  call a:binder.define('index:unstage', function('s:on_unstage'), {
        \ 'description': 'Unstage changes from an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path', 'sign'],
        \ 'options': {},
        \})
  call a:binder.define('index:toggle', function('s:on_toggle'), {
        \ 'description': 'Toggle stage/unstage of changes in an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path', 'sign'],
        \ 'options': {},
        \})
  call a:binder.define('index:checkout', function('s:on_checkout'), {
        \ 'description': 'Checkout a content from an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': {},
        \})
  call a:binder.define('index:checkout:force', function('s:on_checkout'), {
        \ 'hidden': 1,
        \ 'description': 'Checkout a content from an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'force': 1 },
        \})
  call a:binder.define('index:checkout:HEAD', function('s:on_checkout'), {
        \ 'hidden': 1,
        \ 'description': 'Checkout a content from a HEAD',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'rev': 'HEAD' },
        \})
  call a:binder.define('index:checkout:HEAD:force', function('s:on_checkout'), {
        \ 'hidden': 1,
        \ 'description': 'Checkout a content from a HEAD',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'rev': 'HEAD', 'force': 1 },
        \})
  call a:binder.define('index:checkout:origin', function('s:on_checkout'), {
        \ 'hidden': 1,
        \ 'description': 'Checkout a content from an origin/HEAD',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'rev': 'origin/HEAD' },
        \})
  call a:binder.define('index:checkout:origin:force', function('s:on_checkout'), {
        \ 'hidden': 1,
        \ 'description': 'Checkout a content from an origin/HEAD',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'rev': 'origin/HEAD', 'force': 1 },
        \})
  call a:binder.define('index:checkout:ours', function('s:on_checkout'), {
        \ 'hidden': 1,
        \ 'description': 'Checkout a content from local (ours) during merge',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'ours': 1 },
        \})
  call a:binder.define('index:checkout:theirs', function('s:on_checkout'), {
        \ 'hidden': 1,
        \ 'description': 'Checkout a content from remote (theirs) during merge',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \ 'options': { 'theirs': 1 },
        \})
  call a:binder.define('index:discard', function('s:on_discard'), {
        \ 'description': 'Discard changes on a working tree',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path', 'sign'],
        \ 'options': {},
        \})
  call a:binder.define('index:discard:force', function('s:on_discard'), {
        \ 'hidden': 1,
        \ 'description': 'Discard changes on a working tree',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path', 'sign'],
        \ 'options': { 'force': 1 },
        \})
endfunction


function! s:on_add(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'force': 0,
        \ 'intent-to-add': 0,
        \}, a:options)
  let pathlist = map(copy(a:candidates), 'v:val.path')
  execute printf(
        \ '%s Gina add --ignore-errors %s %s -- %s',
        \ options.mods,
        \ options.force ? '--force' : '',
        \ options['intent-to-add'] ? '--intent-to-add' : '',
        \ gina#util#shellescape(pathlist),
        \)
endfunction

function! s:on_rm(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'cached': 0,
        \ 'force': 0,
        \}, a:options)
  let pathlist = map(copy(a:candidates), 'v:val.path')
  execute printf(
        \ '%s Gina rm --quiet --ignore-unmatch %s %s -- %s',
        \ options.mods,
        \ options.force ? '--force' : '',
        \ options.cached ? '--cached' : '',
        \ gina#util#shellescape(pathlist),
        \)
endfunction

function! s:on_reset(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  let pathlist = map(copy(a:candidates), 'v:val.path')
  execute printf(
        \ '%s Gina reset --quiet -- %s',
        \ options.mods,
        \ gina#util#shellescape(pathlist),
        \)
endfunction

function! s:on_stage(candidates, options) abort dict
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'force': 0,
        \}, a:options)
  let rm_candidates = []
  let add_candidates = []
  for candidate in a:candidates
    if candidate.sign =~# '^.D$'
      call add(rm_candidates, candidate)
    elseif candidate.sign !~# '^. $'
      call add(add_candidates, candidate)
    endif
  endfor
  if options.force
    call self.call(options.mods . 'index:add:force', add_candidates)
    if !empty(rm_candidates)
      call gina#process#wait()
    endif
    call self.call(options.mods . 'index:rm:force', rm_candidates)
  else
    call self.call(options.mods . 'index:add', add_candidates)
    if !empty(rm_candidates)
      call gina#process#wait()
    endif
    call self.call(options.mods . 'index:rm', rm_candidates)
  endif
endfunction

function! s:on_unstage(candidates, options) abort dict
  let options = extend({}, a:options)
  call self.call(options.mods . 'index:reset', a:candidates)
endfunction

function! s:on_toggle(candidates, options) abort dict
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  let stage_candidates = []
  let unstage_candidates = []
  for candidate in a:candidates
    if candidate.sign =~# '^\%(??\|!!\|.\w\)$'
      call add(stage_candidates, candidate)
    elseif candidate.sign =~# '^\w.$'
      call add(unstage_candidates, candidate)
    endif
  endfor
  call self.call(options.mods . 'index:stage', stage_candidates)
  if !empty(unstage_candidates)
    call gina#process#wait()
  endif
  call self.call(options.mods . 'index:unstage', unstage_candidates)
endfunction

function! s:on_checkout(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'force': 0,
        \ 'ours': 0,
        \ 'theirs': 0,
        \ 'rev': '',
        \}, a:options)
  let pathlist = map(copy(a:candidates), 'v:val.path')
  execute printf(
        \ '%s Gina! checkout --quiet %s %s %s %s -- %s',
        \ options.mods,
        \ options.force ? '--force' : '',
        \ options.ours ? '--ours' : '',
        \ options.theirs ? '--theirs' : '',
        \ gina#util#shellescape(options.rev),
        \ gina#util#shellescape(pathlist),
        \)
endfunction

function! s:on_discard(candidates, options) abort dict
  if empty(a:candidates)
    return
  endif
  let git = gina#core#get_or_fail()
  let options = extend({
        \ 'force': 0,
        \}, a:options)
  let delete_candidates = []
  let checkout_candidates = []
  for candidate in a:candidates
    if candidate.sign =~# '^\%(??\|!!\)$'
      call add(delete_candidates, candidate)
    else
      call add(checkout_candidates, candidate)
    endif
  endfor
  if !options.force
    call gina#core#console#warn(join([
          \ 'A discard action will discard all local changes on the working ',
          \ 'tree and the operation is irreversible, mean that you have no ',
          \ 'chance to revert the operation.',
          \], "\n"))
    call gina#core#console#info(
          \ 'This operation will be performed to the following candidates:'
          \)
    for candidate in extend(copy(delete_candidates), checkout_candidates)
      call gina#core#console#echo('- ' . s:Path.realpath(candidate.path))
    endfor
    if !gina#core#console#confirm('Are you sure to discard the changes?', 'n')
      return
    endif
  endif
  " delete untracked files
  for candidate in delete_candidates
    let abspath = s:Path.realpath(gina#core#repo#abspath(git, candidate.path))
    if isdirectory(abspath)
      if g:gina#action#index#discard_directories
        call s:File.rmdir(abspath, 'r')
      else
        call gina#core#console#info(printf(
              \ '"%s" is directory. While g:gina#action#index#discard_directories is not set, it is not removed.',
              \ candidate.path,
              \))
      endif
    elseif filewritable(abspath)
      call delete(abspath)
    endif
  endfor
  call self.call(options.mods . 'index:checkout:HEAD:force', checkout_candidates)
  if !empty(delete_candidates) && empty(checkout_candidates)
    call gina#core#emitter#emit('modified:delay')
  endif
endfunction


" Config ---------------------------------------------------------------------
call gina#config(expand('<sfile>'), {
      \ 'discard_directories': 0,
      \})
