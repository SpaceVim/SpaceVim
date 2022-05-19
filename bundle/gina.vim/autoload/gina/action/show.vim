function! gina#action#show#define(binder) abort
  let params = {
        \ 'description': 'Show a commit or a content at a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': [],
        \}
  call a:binder.define('show', function('s:on_show'), extend({
        \ 'options': {},
        \}, params))
  call a:binder.define('show:split', function('s:on_show'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'new'},
        \}, params))
  call a:binder.define('show:vsplit', function('s:on_show'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'vnew'},
        \}, params))
  call a:binder.define('show:tab', function('s:on_show'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'tabedit'},
        \}, params))
  call a:binder.define('show:preview', function('s:on_show'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'pedit'},
        \}, params))

  let params = {
        \ 'description': 'Show a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': [],
        \}
  call a:binder.define('show:commit', function('s:on_commit'), extend({
        \ 'options': {},
        \}, params))
  call a:binder.define('show:commit:split', function('s:on_commit'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'new'},
        \}, params))
  call a:binder.define('show:commit:vsplit', function('s:on_commit'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'vnew'},
        \}, params))
  call a:binder.define('show:commit:tab', function('s:on_commit'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'tabedit'},
        \}, params))
  call a:binder.define('show:commit:preview', function('s:on_commit'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'pedit'},
        \}, params))
  " Alias
  call a:binder.alias('show:above', 'leftabove show:split')
  call a:binder.alias('show:below', 'belowright show:split')
  call a:binder.alias('show:left', 'leftabove show:vsplit')
  call a:binder.alias('show:right', 'belowright show:vsplit')
  call a:binder.alias('show:top', 'topleft show:split')
  call a:binder.alias('show:bottom', 'botright show:split')
  call a:binder.alias('show:leftest', 'topleft show:vsplit')
  call a:binder.alias('show:rightest', 'botright show:vsplit')
  call a:binder.alias('show:preview:top', 'topleft show:preview')
  call a:binder.alias('show:preview:bottom', 'botright show:preview')
  call a:binder.alias('show:commit:above', 'leftabove show:commit:split')
  call a:binder.alias('show:commit:below', 'belowright show:commit:split')
  call a:binder.alias('show:commit:left', 'leftabove show:commit:vsplit')
  call a:binder.alias('show:commit:right', 'belowright show:commit:vsplit')
  call a:binder.alias('show:commit:top', 'topleft show:commit:split')
  call a:binder.alias('show:commit:bottom', 'botright show:commit:split')
  call a:binder.alias('show:commit:leftest', 'topleft show:commit:vsplit')
  call a:binder.alias('show:commit:rightest', 'botright show:commit:vsplit')
  call a:binder.alias('show:commit:preview:top', 'topleft show:commit:preview')
  call a:binder.alias('show:commit:preview:bottom', 'botright show:commit:preview')
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
    let treeish = gina#core#treeish#build(
          \ gina#util#get(candidate, 'rev'),
          \ gina#util#get(candidate, 'path', v:null),
          \)
    execute printf(
          \ '%s Gina show %s %s %s %s -- %s',
          \ options.mods,
          \ gina#util#shellescape(options.opener, '--opener='),
          \ gina#util#shellescape(get(candidate, 'line'), '--line='),
          \ gina#util#shellescape(get(candidate, 'col'), '--col='),
          \ gina#util#shellescape(treeish),
          \ gina#util#shellescape(gina#util#get(candidate, 'residual')),
          \)
  endfor
endfunction

function! s:on_commit(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'opener': '',
        \}, a:options)
  for candidate in a:candidates
    let treeish = gina#core#treeish#build(
          \ gina#util#get(candidate, 'rev'),
          \ v:null
          \)
    execute printf(
          \ '%s Gina show %s %s -- %s',
          \ options.mods,
          \ gina#util#shellescape(options.opener, '--opener='),
          \ gina#util#shellescape(treeish),
          \ gina#util#shellescape(gina#util#get(candidate, 'residual')),
          \)
  endfor
endfunction
