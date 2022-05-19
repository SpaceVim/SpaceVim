function! gina#action#diff#define(binder) abort
  let params = {
        \ 'description': 'Open an unified-diff',
        \ 'mapping_mode': 'nv',
        \ 'requirements': [],
        \}
  call a:binder.define('diff', function('s:on_diff'), extend({
        \ 'options': {},
        \}, params))
  call a:binder.define('diff:split', function('s:on_diff'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'new'},
        \}, params))
  call a:binder.define('diff:vsplit', function('s:on_diff'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'vnew'},
        \}, params))
  call a:binder.define('diff:tab', function('s:on_diff'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'tabedit'},
        \}, params))
  call a:binder.define('diff:preview', function('s:on_diff'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'pedit'},
        \}, params))
  " Alias
  call a:binder.alias('diff:above', 'leftabove diff:split')
  call a:binder.alias('diff:below', 'belowright diff:split')
  call a:binder.alias('diff:left', 'leftabove diff:vsplit')
  call a:binder.alias('diff:right', 'belowright diff:vsplit')
  call a:binder.alias('diff:top', 'topleft diff:split')
  call a:binder.alias('diff:bottom', 'botright diff:split')
  call a:binder.alias('diff:leftest', 'topleft diff:vsplit')
  call a:binder.alias('diff:rightest', 'botright diff:vsplit')
  call a:binder.alias('diff:preview:top', 'topleft diff:preview')
  call a:binder.alias('diff:preview:bottom', 'botright diff:preview')
endfunction


" Private --------------------------------------------------------------------
function! s:on_diff(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'opener': '',
        \}, a:options)
  for candidate in a:candidates
    let cached = get(candidate, 'sign', '!!') !~# '^\%(??\|!!\|.\w\)$'
    let treeish = gina#core#treeish#build(
          \ gina#util#get(candidate, 'rev'),
          \ gina#util#get(candidate, 'path', v:null),
          \)
    execute printf(
          \ '%s Gina diff %s %s %s -- %s',
          \ options.mods,
          \ cached ? '--cached' : '',
          \ gina#util#shellescape(options.opener, '--opener='),
          \ gina#util#shellescape(treeish),
          \ gina#util#shellescape(gina#util#get(candidate, 'residual')),
          \)
  endfor
endfunction
