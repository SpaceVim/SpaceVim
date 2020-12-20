let s:suite = themis#suite('custom')
let s:assert = themis#helper('assert')

function! s:suite.custom_source() abort
  call deoplete#custom#_init()

  call deoplete#custom#source('_',
        \ 'matchers', ['matcher_head'])

  call deoplete#custom#source('_', 'converters',
        \ ['converter_auto_delimiter', 'remove_overlap'])

  call s:assert.equals(
        \ deoplete#custom#_get().source,
        \ {'_' : {
        \  'matchers': ['matcher_head'],
        \  'converters': ['converter_auto_delimiter', 'remove_overlap']}})

  call deoplete#custom#_init()

  call deoplete#custom#source('buffer',
        \ 'min_pattern_length', 9999)
  call deoplete#custom#source('buffer', 'rank', 9999)
  call deoplete#custom#source('buffer', {'filetypes': []})
  call s:assert.equals(
        \ deoplete#custom#_get_source('buffer').filetypes, [])
  call s:assert.equals(
        \ deoplete#custom#_get_source('buffer').rank, 9999)

  call deoplete#custom#var('file', 'force_completion_length', 2)
  call deoplete#custom#var('file', {'foo': -1, 'bar': 1})
  call deoplete#custom#_update_cache()
  call s:assert.equals(
        \ deoplete#custom#_get_source_vars('file'),
        \ {'force_completion_length' : 2, 'foo': -1, 'bar': 1})
  call deoplete#custom#buffer_var('file', 'force_completion_length', 0)
  call deoplete#custom#_update_cache()
  call s:assert.equals(
        \ deoplete#custom#_get_source_vars('file'),
        \ {'force_completion_length' : 0, 'foo': -1, 'bar': 1})
endfunction

function! s:suite.custom_option() abort
  " Simple option test
  call deoplete#custom#_init()
  call deoplete#custom#_init_buffer()
  call deoplete#custom#option('auto_complete', v:true)
  call deoplete#custom#_update_cache()
  call s:assert.equals(
        \ deoplete#custom#_get_option('auto_complete'), v:true)

  " Buffer option test
  call deoplete#custom#buffer_option('auto_complete', v:false)
  call deoplete#custom#_update_cache()
  call s:assert.equals(
        \ deoplete#custom#_get_option('auto_complete'), v:false)

  " Compatibility test
  call deoplete#custom#_init()
  call deoplete#custom#_init_buffer()
  let g:deoplete#disable_auto_complete = 1
  call deoplete#init#_custom_variables()
  call deoplete#custom#_update_cache()
  call s:assert.equals(
        \ deoplete#custom#_get_option('auto_complete'), v:false)

  " Filetype option test
  call deoplete#custom#_init()
  call deoplete#custom#_init_buffer()
  let s:java_pattern = '[^. *\t]\.\w*'
  call deoplete#custom#option('omni_patterns', {
        \ 'java': s:java_pattern,
        \})
  call deoplete#custom#_update_cache()
  call s:assert.equals(
        \ deoplete#custom#_get_filetype_option(
        \   'omni_patterns', 'java', ''), s:java_pattern)
  call s:assert.equals(
        \ deoplete#custom#_get_filetype_option(
        \   'omni_patterns', 'foobar', ''), '')

  " Compatibility test
  call deoplete#custom#_init()
  call deoplete#custom#_init_buffer()
  let s:tex_pattern = '[^\w|\s][a-zA-Z_]\w*'
  let g:deoplete#keyword_patterns = {}
  let g:deoplete#keyword_patterns.tex = '[^\w|\s][a-zA-Z_]\w*'
  call deoplete#init#_custom_variables()
  call deoplete#custom#_update_cache()
  call s:assert.equals(
        \ deoplete#custom#_get_filetype_option(
        \   'keyword_patterns', 'tex', ''), s:tex_pattern)

  " Dict type format
  call deoplete#custom#_init()
  call deoplete#custom#_init_buffer()
  call deoplete#custom#option({
        \ 'auto_complete': v:true, 'camel_case': v:true
        \ })
  call deoplete#custom#_update_cache()
  call s:assert.equals(
        \ deoplete#custom#_get_option('auto_complete'), v:true)
  call s:assert.equals(
        \ deoplete#custom#_get_option('camel_case'), v:true)
endfunction

function! s:suite.custom_filter() abort
  call deoplete#custom#_init()
  call deoplete#custom#filter('converter_auto_delimiter', {
        \ 'delimiters': ['foo', 'bar'],
        \ })
  call deoplete#custom#_update_cache()
  call s:assert.equals(
        \ deoplete#custom#_get_filter('converter_auto_delimiter'),
        \ {'delimiters': ['foo', 'bar']})
  call deoplete#custom#buffer_filter('converter_auto_delimiter', {
        \ 'delimiters': ['foo'],
        \ })
  call deoplete#custom#_update_cache()
  call s:assert.equals(
        \ deoplete#custom#_get_filter('converter_auto_delimiter'),
        \ {'delimiters': ['foo']})
endfunction
