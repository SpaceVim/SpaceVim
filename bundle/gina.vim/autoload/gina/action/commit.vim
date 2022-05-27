function! gina#action#commit#define(binder) abort
  " checkout
  call a:binder.define('commit:checkout', function('s:on_checkout'), {
        \ 'description': 'Checkout a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {},
        \})
  call a:binder.define('commit:checkout:track', function('s:on_checkout_track'), {
        \ 'description': 'Checkout a commit with a tracking branch',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {},
        \})
  " reset
  call a:binder.define('commit:reset', function('s:on_reset'), {
        \ 'description': 'Reset a HEAD to a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {},
        \})
  call a:binder.define('commit:reset:soft', function('s:on_reset'), {
        \ 'hidden': 1,
        \ 'description': 'Reset a HEAD to a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {'mode': 'soft'},
        \})
  call a:binder.define('commit:reset:hard', function('s:on_reset'), {
        \ 'hidden': 1,
        \ 'description': 'Reset a HEAD to a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {'mode': 'hard'},
        \})
  call a:binder.define('commit:reset:merge', function('s:on_reset'), {
        \ 'hidden': 1,
        \ 'description': 'Reset a HEAD to a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {'mode': 'merge'},
        \})
  call a:binder.define('commit:reset:keep', function('s:on_reset'), {
        \ 'hidden': 1,
        \ 'description': 'Reset a current HEAD to a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {'mode': 'keep'},
        \})
  " merge
  call a:binder.define('commit:merge', function('s:on_merge'), {
        \ 'description': 'Merge a commit into a HEAD',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {},
        \})
  call a:binder.define('commit:merge:ff-only', function('s:on_merge'), {
        \ 'hidden': 1,
        \ 'description': 'Merge a commit into a HEAD',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': { 'ff-only': 1 },
        \})
  call a:binder.define('commit:merge:no-ff', function('s:on_merge'), {
        \ 'hidden': 1,
        \ 'description': 'Merge a commit into a HEAD',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': { 'no-ff': 1 },
        \})
  call a:binder.define('commit:merge:squash', function('s:on_merge'), {
        \ 'hidden': 1,
        \ 'description': 'Merge a commit into a HEAD',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': { 'squash': 1 },
        \})
  " rebase
  call a:binder.define('commit:rebase', function('s:on_rebase'), {
        \ 'description': 'Rebase a HEAD from a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {},
        \})
  call a:binder.define('commit:rebase:merge', function('s:on_rebase'), {
        \ 'hidden': 1,
        \ 'description': 'Rebase a HEAD by merging a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': { 'merge': 1 },
        \})
  " revert
  call a:binder.define('commit:revert', function('s:on_revert'), {
        \ 'description': 'Revert a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {},
        \})
  call a:binder.define('commit:revert:1', function('s:on_revert'), {
        \ 'hidden': 1,
        \ 'description': 'Revert a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': { 'mainline': '1' },
        \})
  call a:binder.define('commit:revert:2', function('s:on_revert'), {
        \ 'hidden': 1,
        \ 'description': 'Revert a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': { 'mainline': '2' },
        \})
  " cherry-pick
  call a:binder.define('commit:cherry-pick', function('s:on_cherry_pick'), {
        \ 'description': 'Apply changes of a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {},
        \})
  call a:binder.define('commit:cherry-pick:1', function('s:on_cherry_pick'), {
        \ 'hidden': 1,
        \ 'description': 'Apply changes of a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': { 'mainline': '1' },
        \})
  call a:binder.define('commit:cherry-pick:2', function('s:on_cherry_pick'), {
        \ 'hidden': 1,
        \ 'description': 'Apply changes of a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': { 'mainline': '2' },
        \})
  call a:binder.define('commit:tag:lightweight', function('s:on_tag'), {
        \ 'description': 'Create a lightweight tag',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {},
        \})
  call a:binder.define('commit:tag:annotate', function('s:on_tag'), {
        \ 'description': 'Create an unsigned, annotated tag',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {'annotate': 1},
        \})
  call a:binder.define('commit:tag:sign', function('s:on_tag'), {
        \ 'description': 'Create a GPG-signed tag',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {'sign': 1},
        \})
  call a:binder.define('commit:tag:lightweight:force', function('s:on_tag'), {
        \ 'hidden': 1,
        \ 'description': 'Create a lightweight tag',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {'force': 1},
        \})
  call a:binder.define('commit:tag:annotate:force', function('s:on_tag'), {
        \ 'hidden': 1,
        \ 'description': 'Create an unsigned, annotated tag',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {'annotate': 1, 'force': 1},
        \})
  call a:binder.define('commit:tag:sign:force', function('s:on_tag'), {
        \ 'hidden': 1,
        \ 'description': 'Create a GPG-signed tag',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \ 'options': {'sign': 1, 'force': 1},
        \})
  " Alias
  call a:binder.alias('commit:tag', 'commit:tag:annotate')
endfunction


" Private --------------------------------------------------------------------
function! s:on_checkout(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina checkout %s',
          \ options.mods,
          \ gina#util#shellescape(candidate.rev),
          \)
  endfor
endfunction

function! s:on_checkout_track(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  for candidate in a:candidates
    if !has_key(candidate, 'branch')
      let branch = gina#core#console#ask_or_cancel(
            \ 'A tracking branch name: ',
            \ printf('%s-tracking', candidate.rev),
            \)
    else
      let branch = candidate.branch
    endif
    execute printf(
          \ '%s Gina checkout -b %s %s',
          \ options.mods,
          \ gina#util#shellescape(branch),
          \ gina#util#shellescape(candidate.rev),
          \)
  endfor
endfunction

function! s:on_reset(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'mode': '',
        \}, a:options)
  let mode = empty(options.mode)
        \ ? ''
        \ : '--' . options.mode
  for candidate in a:candidates
    execute printf(
          \ '%s Gina reset %s %s',
          \ options.mods,
          \ mode,
          \ gina#util#shellescape(candidate.rev),
          \)
  endfor
endfunction

function! s:on_merge(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'no-ff': 0,
        \ 'ff-only': 0,
        \ 'squash': 0,
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina merge --no-edit %s %s %s -- %s',
          \ options.mods,
          \ options['no-ff'] ? '--no-ff' : '',
          \ options['ff-only'] ? '--ff-only' : '',
          \ options.squash ? '--squash' : '',
          \ gina#util#shellescape(candidate.rev),
          \)
  endfor
endfunction

function! s:on_rebase(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'merge': 0,
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina rebase %s -- %s',
          \ options.mods,
          \ options.merge ? '--merge' : '',
          \ gina#util#shellescape(candidate.rev),
          \)
  endfor
endfunction

function! s:on_revert(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'mainline': '',
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina revert %s %s',
          \ options.mods,
          \ empty(options.mainline) ? '' : printf('--mainline %s', options.mainline),
          \ gina#util#shellescape(candidate.rev),
          \)
  endfor
endfunction

function! s:on_cherry_pick(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'mainline': '',
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina cherry-pick %s %s',
          \ options.mods,
          \ empty(options.mainline) ? '' : printf('--mainline %s', options.mainline),
          \ gina#util#shellescape(candidate.rev),
          \)
  endfor
endfunction

function! s:on_tag(candidates, options) abort
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
    execute printf(
          \ '%s Gina tag %s %s %s %s %s',
          \ options.mods,
          \ options.annotate ? '--annotate' : '',
          \ options.sign ? '--sign' : '',
          \ options.force ? '--force' : '',
          \ gina#util#shellescape(name),
          \ gina#util#shellescape(candidate.rev),
          \)
  endfor
endfunction
