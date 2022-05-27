function! gina#action#edit#define(binder) abort
  let params = {
        \ 'description': 'Edit a content in a working tree',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \}
  call a:binder.define('edit', function('s:on_edit'), extend({
        \ 'options': {},
        \}, params))
  call a:binder.define('edit:split', function('s:on_edit'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'new'},
        \}, params))
  call a:binder.define('edit:vsplit', function('s:on_edit'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'vnew'},
        \}, params))
  call a:binder.define('edit:tab', function('s:on_edit'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'tabedit'},
        \}, params))
  call a:binder.define('edit:preview', function('s:on_edit'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'pedit'},
        \}, params))
  " Alias
  call a:binder.alias('edit:above', 'leftabove edit:split')
  call a:binder.alias('edit:below', 'belowright edit:split')
  call a:binder.alias('edit:left', 'leftabove edit:vsplit')
  call a:binder.alias('edit:right', 'belowright edit:vsplit')
  call a:binder.alias('edit:top', 'topleft edit:split')
  call a:binder.alias('edit:bottom', 'botright edit:split')
  call a:binder.alias('edit:leftest', 'topleft edit:vsplit')
  call a:binder.alias('edit:rightest', 'botright edit:vsplit')
  call a:binder.alias('edit:preview:top', 'topleft edit:preview')
  call a:binder.alias('edit:preview:bottom', 'botright edit:preview')
endfunction


" Private --------------------------------------------------------------------
function! s:on_edit(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'opener': '',
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina edit %s %s %s %s',
          \ options.mods,
          \ gina#util#shellescape(options.opener, '--opener='),
          \ gina#util#shellescape(get(candidate, 'line'), '--line='),
          \ gina#util#shellescape(get(candidate, 'col'), '--col='),
          \ gina#util#shellescape(candidate.path),
          \)
  endfor
endfunction
