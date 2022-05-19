function! gina#action#patch#define(binder) abort
  let params = {
        \ 'description': 'Open three buffers to patch changes to an index',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \}
  call a:binder.define('patch', function('s:on_patch'), extend({
        \ 'options': {},
        \}, params))
  call a:binder.define('patch:split', function('s:on_patch'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'new'},
        \}, params))
  call a:binder.define('patch:vsplit', function('s:on_patch'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'vnew'},
        \}, params))
  call a:binder.define('patch:tab', function('s:on_patch'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'tabedit'},
        \}, params))
  call a:binder.define('patch:oneside', function('s:on_patch'), extend({
        \ 'options': {'oneside': 1},
        \}, params))
  call a:binder.define('patch:oneside:split', function('s:on_patch'), extend({
        \ 'hidden': 1,
        \ 'options': {'oneside': 1, 'opener': 'new'},
        \}, params))
  call a:binder.define('patch:oneside:vsplit', function('s:on_patch'), extend({
        \ 'hidden': 1,
        \ 'options': {'oneside': 1, 'opener': 'vnew'},
        \}, params))
  call a:binder.define('patch:oneside:tab', function('s:on_patch'), extend({
        \ 'hidden': 1,
        \ 'options': {'oneside': 1, 'opener': 'tabedit'},
        \}, params))
  " Alias
  call a:binder.alias('patch:above', 'leftabove patch:split')
  call a:binder.alias('patch:below', 'belowright patch:split')
  call a:binder.alias('patch:left', 'leftabove patch:vsplit')
  call a:binder.alias('patch:right', 'belowright patch:vsplit')
  call a:binder.alias('patch:top', 'topleft patch:split')
  call a:binder.alias('patch:bottom', 'botright patch:split')
  call a:binder.alias('patch:leftest', 'topleft patch:vsplit')
  call a:binder.alias('patch:rightest', 'botright patch:vsplit')
  call a:binder.alias('patch:oneside:above', 'leftabove patch:oneside:split')
  call a:binder.alias('patch:oneside:below', 'belowright patch:oneside:split')
  call a:binder.alias('patch:oneside:left', 'leftabove patch:oneside:vsplit')
  call a:binder.alias('patch:oneside:right', 'belowright patch:oneside:vsplit')
  call a:binder.alias('patch:oneside:top', 'topleft patch:oneside:split')
  call a:binder.alias('patch:oneside:bottom', 'botright patch:oneside:split')
  call a:binder.alias('patch:oneside:leftest', 'topleft patch:oneside:vsplit')
  call a:binder.alias('patch:oneside:rightest', 'botright patch:oneside:vsplit')
endfunction


" Private --------------------------------------------------------------------
function! s:on_patch(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'opener': '',
        \ 'oneside': 0,
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina patch %s %s %s %s %s',
          \ options.mods,
          \ options.oneside ? '--oneside' : '',
          \ gina#util#shellescape(options.opener, '--opener='),
          \ gina#util#shellescape(get(candidate, 'line'), '--line='),
          \ gina#util#shellescape(get(candidate, 'col'), '--col='),
          \ gina#util#shellescape(candidate.path),
          \)
  endfor
endfunction
