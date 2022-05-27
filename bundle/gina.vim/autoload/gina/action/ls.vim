function! gina#action#ls#define(binder) abort
  let params = {
        \ 'description': 'List files/directories of the repository on a particular commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \}
  call a:binder.define('ls', function('s:on_ls'), extend({
        \ 'options': {},
        \}, params))
  call a:binder.define('ls:split', function('s:on_ls'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'new'},
        \}, params))
  call a:binder.define('ls:vsplit', function('s:on_ls'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'vnew'},
        \}, params))
  call a:binder.define('ls:tab', function('s:on_ls'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'tabedit'},
        \}, params))
  call a:binder.define('ls:preview', function('s:on_ls'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'pedit'},
        \}, params))
  " Alias
  call a:binder.alias('ls:above', 'leftabove ls:split')
  call a:binder.alias('ls:below', 'belowright ls:split')
  call a:binder.alias('ls:left', 'leftabove ls:vsplit')
  call a:binder.alias('ls:right', 'belowright ls:vsplit')
  call a:binder.alias('ls:top', 'topleft ls:split')
  call a:binder.alias('ls:bottom', 'botright ls:split')
  call a:binder.alias('ls:leftest', 'topleft ls:vsplit')
  call a:binder.alias('ls:rightest', 'botright ls:vsplit')
endfunction


" Private --------------------------------------------------------------------
function! s:on_ls(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'opener': '',
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina ls %s %s',
          \ options.mods,
          \ gina#util#shellescape(options.opener, '--opener='),
          \ gina#util#shellescape(candidate.rev),
          \)
  endfor
endfunction

