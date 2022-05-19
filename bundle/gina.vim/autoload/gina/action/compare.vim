function! gina#action#compare#define(binder) abort
  let params = {
        \ 'description': 'Open two buffers to compare differences',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path'],
        \}
  call a:binder.define('compare', function('s:on_compare'), extend({
        \ 'options': {},
        \}, params))
  call a:binder.define('compare:split', function('s:on_compare'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'new'},
        \}, params))
  call a:binder.define('compare:vsplit', function('s:on_compare'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'vnew'},
        \}, params))
  call a:binder.define('compare:tab', function('s:on_compare'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'tabedit'},
        \}, params))
  " Alias
  call a:binder.alias('compare:above', 'leftabove compare:split')
  call a:binder.alias('compare:below', 'belowright compare:split')
  call a:binder.alias('compare:left', 'leftabove compare:vsplit')
  call a:binder.alias('compare:right', 'belowright compare:vsplit')
  call a:binder.alias('compare:top', 'topleft compare:split')
  call a:binder.alias('compare:bottom', 'botright compare:split')
  call a:binder.alias('compare:leftest', 'topleft compare:vsplit')
  call a:binder.alias('compare:rightest', 'botright compare:vsplit')
endfunction


" Private --------------------------------------------------------------------
function! s:on_compare(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'opener': '',
        \}, a:options)
  for candidate in a:candidates
    let cached = gina#util#get(candidate, 'sign', '!!') !~# '^\%(??\|!!\|.\w\)$'
    let treeish = gina#core#treeish#build(
          \ gina#util#get(candidate, 'rev'),
          \ candidate.path,
          \)
    execute printf(
          \ '%s Gina compare %s %s %s %s %s',
          \ options.mods,
          \ cached ? '--cached' : '',
          \ gina#util#shellescape(options.opener, '--opener='),
          \ gina#util#shellescape(get(candidate, 'line'), '--line='),
          \ gina#util#shellescape(get(candidate, 'col'), '--col='),
          \ gina#util#shellescape(treeish),
          \)
  endfor
endfunction
