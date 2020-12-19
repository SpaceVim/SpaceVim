"=============================================================================
" FILE: matcher_hide_hidden_files.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_hide_hidden_files#define() abort "{{{
  return s:matcher
endfunction"}}}

let s:matcher = {
      \ 'name' : 'matcher_hide_hidden_files',
      \ 'description' : 'hide hidden files matcher',
      \}

function! s:matcher.filter(candidates, context) abort "{{{
  if stridx(a:context.input, '.') >= 0
    return a:candidates
  endif

  return unite#util#has_lua() ?
        \ unite#filters#lua_filter_patterns(a:candidates,
        \   ['^%.[^/]*/?$', '/%.[^/]*/?$'], []) :
        \ filter(a:candidates, "
        \   has_key(v:val, 'action__path')
        \    && v:val.action__path !~ '\\%(^\\|/\\)\\.[^/]*/\\?$'")
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
