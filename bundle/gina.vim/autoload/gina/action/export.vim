let s:Path = vital#gina#import('System.Filepath')
let s:String = vital#gina#import('Data.String')


function! gina#action#export#define(binder) abort
  call a:binder.define('export:quickfix', function('s:on_quickfix'), {
        \ 'description': 'Create a new quickfix list with selected candidates',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path', 'word'],
        \ 'options': {},
        \})
  call a:binder.define('export:quickfix:add', function('s:on_quickfix'), {
        \ 'hidden': 1,
        \ 'description': 'Add selected candidates to an existing quickfix list',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path', 'word'],
        \ 'options': { 'action': 'a' },
        \})
  call a:binder.define('export:quickfix:replace', function('s:on_quickfix'), {
        \ 'hidden': 1,
        \ 'description': 'Replace an existing quickfix list with selected candidates',
        \ 'mapping_mode': 'nv',
        \ 'requirements': ['path', 'word'],
        \ 'options': { 'action': 'r' },
        \})
endfunction


" Private --------------------------------------------------------------------
function! s:on_quickfix(candidates, options) abort dict
  let options = extend({
        \ 'action': ' ',
        \}, a:options)
  let git = gina#core#get_or_fail()
  call setqflist(
        \ map(copy(a:candidates), 's:to_quickfix(git, v:val)'),
        \ options.action,
        \)
endfunction

function! s:to_quickfix(git, candidate) abort
  let abspath = gina#core#repo#abspath(a:git, a:candidate.path)
  return {
        \ 'filename': s:Path.realpath(abspath),
        \ 'lnum': get(a:candidate, 'line', 1),
        \ 'col': get(a:candidate, 'col', 1),
        \ 'text': s:String.remove_ansi_sequences(a:candidate.word),
        \}
endfunction
