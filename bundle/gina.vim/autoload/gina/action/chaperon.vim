function! gina#action#chaperon#define(binder) abort
  let params = {
        \ 'description': 'Open three buffers to solve conflict',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path', 'sign'],
        \}
  call a:binder.define('chaperon', function('s:on_chaperon'), extend({
        \ 'options': {},
        \}, params))
  call a:binder.define('chaperon:split', function('s:on_chaperon'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'new'},
        \}, params))
  call a:binder.define('chaperon:vsplit', function('s:on_chaperon'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'vnew'},
        \}, params))
  call a:binder.define('chaperon:tab', function('s:on_chaperon'), extend({
        \ 'hidden': 1,
        \ 'options': {'opener': 'tabedit'},
        \}, params))
  " Alias
  call a:binder.alias('chaperon:above', 'leftabove chaperon:split')
  call a:binder.alias('chaperon:below', 'belowright chaperon:split')
  call a:binder.alias('chaperon:left', 'leftabove chaperon:vsplit')
  call a:binder.alias('chaperon:right', 'belowright chaperon:vsplit')
  call a:binder.alias('chaperon:top', 'topleft chaperon:split')
  call a:binder.alias('chaperon:bottom', 'botright chaperon:split')
  call a:binder.alias('chaperon:leftest', 'topleft chaperon:vsplit')
  call a:binder.alias('chaperon:rightest', 'botright chaperon:vsplit')
endfunction


" Private --------------------------------------------------------------------
function! s:on_chaperon(candidates, options) abort
  let candidates = filter(copy(a:candidates), 'v:val.sign ==# ''UU''')
  if empty(candidates)
    return
  endif
  let options = extend({
        \ 'opener': '',
        \}, a:options)
  for candidate in candidates
    execute printf(
          \ '%s Gina chaperon %s %s %s %s',
          \ options.mods,
          \ gina#util#shellescape(options.opener, '--opener='),
          \ gina#util#shellescape(get(candidate, 'line'), '--line='),
          \ gina#util#shellescape(get(candidate, 'col'), '--col='),
          \ gina#util#shellescape(candidate.path),
          \)
  endfor
endfunction
