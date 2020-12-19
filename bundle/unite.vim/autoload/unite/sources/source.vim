"=============================================================================
" FILE: source.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#source#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'source',
      \ 'description' : 'candidates from sources list',
      \ 'default_action' : 'start',
      \ 'default_kind' : 'source',
      \ 'hooks' : {},
      \ 'syntax' : 'uniteSource__Source',
      \}

function! s:source.hooks.on_syntax(args, context) abort "{{{
  syntax match uniteSource__SourceDescriptionLine / -- .*$/
        \ contained containedin=uniteSource__Source
  syntax match uniteSource__SourceDescription /.*$/
        \ contained containedin=uniteSource__SourceDescriptionLine
  syntax match uniteSource__SourceMarker / -- /
        \ contained containedin=uniteSource__SourceDescriptionLine
  highlight default link uniteSource__SourceMarker Special
  highlight default link uniteSource__SourceDescription Comment
endfunction"}}}

function! s:source.gather_candidates(args, context) abort "{{{
  let sources = filter(values(unite#get_all_sources()),
        \        'v:val.is_listed && (empty(a:args) ||
        \            index(a:args, v:val.name) >= 0)')
  return map(copy(unite#util#sort_by(sources, 'v:val.name')), "{
        \ 'word' : v:val.name,
        \ 'abbr' : unite#util#truncate(v:val.name, 25) .
        \         (v:val.description != '' ? ' -- ' . v:val.description : ''),
        \ 'action__source_name' : v:val.name,
        \ 'action__source_args' : [],
        \}")
endfunction"}}}

function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return keys(filter(unite#init#_sources([], a:arglead),
            \ 'v:val.is_listed'))
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
