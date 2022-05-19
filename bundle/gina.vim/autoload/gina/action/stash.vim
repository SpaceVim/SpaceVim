function! gina#action#stash#define(binder) abort
  let params = {
        \ 'description': 'Show changes in a stash',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['stash'],
        \}
  call a:binder.define('stash:show', function('s:on_show'), extend({
        \ 'options': {},
        \}, params))
  call a:binder.define('stash:show:split', function('s:on_show'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'new'},
        \}, params))
  call a:binder.define('stash:show:vsplit', function('s:on_show'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'vnew'},
        \}, params))
  call a:binder.define('stash:show:tab', function('s:on_show'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'tabedit'},
        \}, params))
  call a:binder.define('stash:show:preview', function('s:on_show'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'pedit'},
        \}, params))
  call a:binder.define('stash:drop', function('s:on_drop'), {
        \ 'description': 'Remove a stashed state',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['stash'],
        \ 'options': {},
        \})
  call a:binder.define('stash:drop:force', function('s:on_drop'), {
        \ 'hidden': 1,
        \ 'description': 'Remove a stashed state',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['stash'],
        \ 'options': {'force': 1},
        \})
  call a:binder.define('stash:pop', function('s:on_pop'), {
        \ 'description': 'Remove a stashed state and apply to a working tree',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['stash'],
        \ 'options': {},
        \})
  call a:binder.define('stash:pop:index', function('s:on_pop'), {
        \ 'hidden': 1,
        \ 'description': 'Remove a stashed state and apply to a working tree',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['stash'],
        \ 'options': {'index': 1},
        \})
  call a:binder.define('stash:apply', function('s:on_apply'), {
        \ 'description': 'Apply a stashed state to a working tree',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['stash'],
        \ 'options': {},
        \})
  call a:binder.define('stash:apply:index', function('s:on_apply'), {
        \ 'hidden': 1,
        \ 'description': 'Apply a stashed state to a working tree',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['stash'],
        \ 'options': {'index': 1},
        \})
  call a:binder.define('stash:branch', function('s:on_branch'), {
        \ 'description': 'Create a new branch with a stashed state',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['stash'],
        \ 'options': {},
        \})
  call a:binder.define('stash:clear', function('s:on_clear'), {
        \ 'description': 'Remove all stashed states',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {},
        \})
  call a:binder.define('stash:clear:force', function('s:on_clear'), {
        \ 'hidden': 1,
        \ 'description': 'Remove all stashed states',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {'force': 1},
        \})
  " Alias
  call a:binder.alias('stash:show:above', 'leftabove stash:show:split')
  call a:binder.alias('stash:show:below', 'belowright stash:show:split')
  call a:binder.alias('stash:show:left', 'leftabove stash:show:vsplit')
  call a:binder.alias('stash:show:right', 'belowright stash:show:vsplit')
  call a:binder.alias('stash:show:top', 'topleft stash:show:split')
  call a:binder.alias('stash:show:bottom', 'botright stash:show:split')
  call a:binder.alias('stash:show:leftest', 'topleft stash:show:vsplit')
  call a:binder.alias('stash:show:rightest', 'botright stash:show:vsplit')
endfunction


" Private --------------------------------------------------------------------
function! s:on_show(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'opener': '',
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina stash show %s %s %s %s',
          \ options.mods,
          \ gina#util#shellescape(options.opener, '--opener='),
          \ gina#util#shellescape(get(candidate, 'line'), '--line='),
          \ gina#util#shellescape(get(candidate, 'col'), '--col='),
          \ gina#util#shellescape(candidate.stash),
          \)
  endfor
endfunction

function! s:on_drop(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'force': 0,
        \}, a:options)
  if !options.force
    call gina#core#console#warn(join([
          \ 'A stash:drop action will drop selected stashes ',
          \ 'and the operation is irreversible, mean that you have no ',
          \ 'chance to revert the operation with safety mechanisms.',
          \], "\n"))
      call gina#core#console#info(
            \ 'This operation will be performed to the following candidates:'
            \)
      for candidate in a:candidates
        call gina#core#console#echo('- ' . candidate.stash)
      endfor
    if !gina#core#console#confirm('Are you sure to drop stashes?', 'n')
      return
    endif
  endif
  for candidate in a:candidates
    execute printf(
          \ '%s Gina stash drop --quiet %s',
          \ options.mods,
          \ gina#util#shellescape(candidate.stash),
          \)
  endfor
endfunction

function! s:on_pop(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'index': 0,
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina stash pop --quiet %s %s',
          \ options.mods,
          \ options.index ? '--index' : '',
          \ gina#util#shellescape(candidate.stash),
          \)
  endfor
endfunction

function! s:on_apply(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'index': 0,
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina stash apply --quiet %s %s',
          \ options.mods,
          \ options.index ? '--index' : '',
          \ gina#util#shellescape(candidate.stash),
          \)
  endfor
endfunction

function! s:on_branch(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({}, a:options)
  for candidate in a:candidates
    let name = gina#core#console#ask_or_cancel(
          \ 'Name: ', '',
          \)
    execute printf(
          \ '%s Gina stash branch %s %s',
          \ options.mods,
          \ name,
          \ gina#util#shellescape(candidate.stash),
          \)
  endfor
endfunction

function! s:on_clear(candidates, options) abort
  let options = extend({
        \ 'force': 0,
        \}, a:options)
  if !options.force
    call gina#core#console#warn(join([
          \ 'A stash:clear action will clear all stashes ',
          \ 'and the operation is irreversible, mean that you have no ',
          \ 'chance to revert the operation with safety mechanisms.',
          \], "\n"))
    if !gina#core#console#confirm('Are you sure to clear stashes?', 'n')
      return
    endif
  endif
  execute printf(
        \ '%s Gina stash clear',
        \ options.mods,
        \)
endfunction
