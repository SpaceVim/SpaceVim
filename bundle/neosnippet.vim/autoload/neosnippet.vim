"=============================================================================
" FILE: neosnippet.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" Global options definition.
call neosnippet#util#set_default(
      \ 'g:neosnippet#disable_runtime_snippets', {})
call neosnippet#util#set_default(
      \ 'g:neosnippet#scope_aliases', {})
call neosnippet#util#set_default(
      \ 'g:neosnippet#snippets_directory', '')
call neosnippet#util#set_default(
      \ 'g:neosnippet#disable_select_mode_mappings', 1)
call neosnippet#util#set_default(
      \ 'g:neosnippet#enable_snipmate_compatibility', 0)
call neosnippet#util#set_default(
      \ 'g:neosnippet#expand_word_boundary', 0)
call neosnippet#util#set_default(
      \ 'g:neosnippet#enable_conceal_markers', 1)
call neosnippet#util#set_default(
      \ 'g:neosnippet#enable_completed_snippet', 0,
      \ 'g:neosnippet#enable_complete_done')
call neosnippet#util#set_default(
      \ 'g:neosnippet#enable_optional_arguments', 1)
call neosnippet#util#set_default(
      \ 'g:neosnippet#enable_auto_clear_markers', 1)
call neosnippet#util#set_default(
      \ 'g:neosnippet#enable_complete_done', 0)
call neosnippet#util#set_default(
      \ 'g:neosnippet#conceal_char', '|')

function! neosnippet#expandable_or_jumpable() abort
  return neosnippet#mappings#expandable_or_jumpable()
endfunction
function! neosnippet#expandable() abort
  return neosnippet#mappings#expandable()
endfunction
function! neosnippet#jumpable() abort
  return neosnippet#mappings#jumpable()
endfunction
function! neosnippet#anonymous(snippet) abort
  return neosnippet#mappings#_anonymous(a:snippet)
endfunction
function! neosnippet#expand(trigger) abort
  return neosnippet#mappings#_expand(a:trigger)
endfunction
function! neosnippet#complete_done() abort
  return neosnippet#mappings#_complete_done(
        \ neosnippet#util#get_cur_text(), col('.'))
endfunction

function! neosnippet#get_snippets_directory() abort
  return neosnippet#helpers#get_snippets_directory()
endfunction
function! neosnippet#get_user_snippets_directory() abort
  return copy(neosnippet#variables#snippets_dir())
endfunction
function! neosnippet#get_runtime_snippets_directory() abort
  return copy(neosnippet#variables#runtime_dir())
endfunction

" Get marker patterns.
function! neosnippet#get_placeholder_target_marker_pattern() abort
  return '\%(\\\@<!\|\\\\\zs\)\${\d\+:\(#:\)\?\%(TARGET\|\${VISUAL\%(:.\{-}\)\?}\)\%(:.\{-}\)\?\\\@<!}'
endfunction
function! neosnippet#get_placeholder_marker_pattern() abort
  return '<`\d\+\%(:.\{-}\)\?\\\@<!`>'
endfunction
function! neosnippet#get_placeholder_marker_substitute_pattern() abort
  return '\%(\\\@<!\|\\\\\zs\)\${\(\d\+\%(:\%(\${VISUAL\%(:.\{-}\)\?}\)\?.\{-}\)\?\\\@<!\)}'
endfunction
function! neosnippet#get_placeholder_marker_substitute_zero_pattern() abort
  return '\%(\\\@<!\|\\\\\zs\)\$\(0\)'
endfunction
function! neosnippet#get_placeholder_marker_substitute_nonzero_pattern() abort
  return '\%(\\\@<!\|\\\\\zs\)\${\([1-9]\d*\%(:\%(\${VISUAL\%(:.\{-}\)\?}\)\?.\{-}\)\?\\\@<!\)}'
endfunction
function! neosnippet#get_placeholder_marker_default_pattern() abort
  return '<`\d\+:\zs.\{-}\ze\\\@<!`>'
endfunction
function! neosnippet#get_sync_placeholder_marker_pattern() abort
  return '<{\d\+\%(:.\{-}\)\?\\\@<!}>'
endfunction
function! neosnippet#get_sync_placeholder_marker_default_pattern() abort
  return '<{\d\+:\zs.\{-}\ze\\\@<!}>'
endfunction
function! neosnippet#get_mirror_placeholder_marker_pattern() abort
  return '<|\d\+|>'
endfunction
function! neosnippet#get_mirror_placeholder_marker_substitute_pattern() abort
  return '\\\@<!\$\(\d\+\)'
endfunction
