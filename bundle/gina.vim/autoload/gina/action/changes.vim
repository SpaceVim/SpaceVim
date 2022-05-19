function! gina#action#changes#define(binder) abort
  " changes:of
  let params = {
        \ 'description': 'Show changes of a commit',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \}
  call a:binder.define('changes:of', function('s:on_changes'), extend({
        \ 'options': {},
        \}, params))
  call a:binder.define('changes:of:split', function('s:on_changes'), extend({
        \ 'options': {'opener': 'new'},
        \}, params))
  call a:binder.define('changes:of:vsplit', function('s:on_changes'), extend({
        \ 'options': {'opener': 'vnew'},
        \}, params))
  call a:binder.define('changes:of:tab', function('s:on_changes'), extend({
        \ 'options': {'opener': 'tabedit'},
        \}, params))
  call a:binder.define('changes:of:preview', function('s:on_changes'), extend({
        \ 'options': {'opener': 'pedit'},
        \}, params))
  " changes:between
  let params = {
        \ 'description': 'Show changes between a commit and a HEAD',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \}
  call a:binder.define('changes:between', function('s:on_changes'), extend({
        \ 'options': { 'format': '%s..' },
        \}, params))
  call a:binder.define('changes:between:split', function('s:on_changes'), extend({
        \ 'options': { 'format': '%s..', 'opener': 'new' },
        \}, params))
  call a:binder.define('changes:between:vsplit', function('s:on_changes'), extend({
        \ 'options': { 'format': '%s..', 'opener': 'vnew' },
        \}, params))
  call a:binder.define('changes:between:tab', function('s:on_changes'), extend({
        \ 'options': { 'format': '%s..', 'opener': 'tabedit' },
        \}, params))
  call a:binder.define('changes:between:preview', function('s:on_changes'), extend({
        \ 'options': { 'format': '%s..', 'opener': 'pedit' },
        \}, params))
  " changes:from
  let params = {
        \ 'description': 'Show changes from a common ancestor of a commit and a HEAD',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['rev'],
        \}
  call a:binder.define('changes:from', function('s:on_changes'), extend({
        \ 'options': { 'format': '%s...' },
        \}, params))
  call a:binder.define('changes:from:split', function('s:on_changes'), extend({
        \ 'options': { 'format': '%s...', 'opener': 'new' },
        \}, params))
  call a:binder.define('changes:from:vsplit', function('s:on_changes'), extend({
        \ 'options': { 'format': '%s...', 'opener': 'vnew' },
        \}, params))
  call a:binder.define('changes:from:tab', function('s:on_changes'), extend({
        \ 'options': { 'format': '%s...', 'opener': 'tabedit' },
        \}, params))
  call a:binder.define('changes:from:preview', function('s:on_changes'), extend({
        \ 'options': { 'format': '%s...', 'opener': 'pedit' },
        \}, params))
  call a:binder.alias('changes:of:above', 'leftabove changes:of:split')
  call a:binder.alias('changes:of:below', 'belowright changes:of:split')
  call a:binder.alias('changes:of:left', 'leftabove changes:of:vsplit')
  call a:binder.alias('changes:of:right', 'belowright changes:of:vsplit')
  call a:binder.alias('changes:of:top', 'topleft changes:of:split')
  call a:binder.alias('changes:of:bottom', 'botright changes:of:split')
  call a:binder.alias('changes:of:leftest', 'topleft changes:of:vsplit')
  call a:binder.alias('changes:of:rightest', 'botright changes:of:vsplit')
  call a:binder.alias('changes:between:above', 'leftabove changes:between:split')
  call a:binder.alias('changes:between:below', 'belowright changes:between:split')
  call a:binder.alias('changes:between:left', 'leftabove changes:between:vsplit')
  call a:binder.alias('changes:between:right', 'belowright changes:between:vsplit')
  call a:binder.alias('changes:between:top', 'topleft changes:between:split')
  call a:binder.alias('changes:between:bottom', 'botright changes:between:split')
  call a:binder.alias('changes:between:leftest', 'topleft changes:between:vsplit')
  call a:binder.alias('changes:between:rightest', 'botright changes:between:vsplit')
  call a:binder.alias('changes:from:above', 'leftabove changes:from:split')
  call a:binder.alias('changes:from:below', 'belowright changes:from:split')
  call a:binder.alias('changes:from:left', 'leftabove changes:from:vsplit')
  call a:binder.alias('changes:from:right', 'belowright changes:from:vsplit')
  call a:binder.alias('changes:from:top', 'topleft changes:from:split')
  call a:binder.alias('changes:from:bottom', 'botright changes:from:split')
  call a:binder.alias('changes:from:leftest', 'topleft changes:from:vsplit')
  call a:binder.alias('changes:from:rightest', 'botright changes:from:vsplit')
endfunction


" Private --------------------------------------------------------------------
function! s:on_changes(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'opener': '',
        \ 'format': '%s',
        \}, a:options)
  for candidate in a:candidates
    execute printf(
          \ '%s Gina changes %s %s -- %s',
          \ options.mods,
          \ gina#util#shellescape(options.opener, '--opener='),
          \ gina#util#shellescape(printf(options.format, candidate.rev)),
          \ gina#util#shellescape(gina#util#get(candidate, 'residual')),
          \)
  endfor
endfunction
