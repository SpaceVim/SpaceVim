"=============================================================================
" FILE: neomru.vim
" AUTHOR:  Zhao Cai <caizhaoff@gmail.com>
"          Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" Source
call neomru#init()
function! unite#sources#neomru#define() abort
  return [s:file_mru_source, s:dir_mru_source]
endfunction
let s:file_mru_source = {
      \ 'name' : 'neomru/file',
      \ 'description' : 'candidates from file MRU list',
      \ 'hooks' : {},
      \ 'action_table' : {},
      \ 'syntax' : 'uniteSource__FileMru',
      \ 'default_kind' : 'file',
      \ 'ignore_pattern' : g:neomru#file_mru_ignore_pattern,
      \ 'max_candidates' : 200,
      \}

let s:dir_mru_source = {
      \ 'name' : 'neomru/directory',
      \ 'description' : 'candidates from directory MRU list',
      \ 'hooks' : {},
      \ 'action_table' : {},
      \ 'syntax' : 'uniteSource__DirectoryMru',
      \ 'default_kind' : 'directory',
      \ 'ignore_pattern' :
      \    g:neomru#directory_mru_ignore_pattern,
      \ 'alias_table' : { 'unite__new_candidate' : 'vimfiler__mkdir' },
      \ 'max_candidates' : 200,
      \}

function! s:file_mru_source.hooks.on_syntax(args, context) abort
  syntax match uniteSource__FileMru_Time
        \ /([^)]*)\s\+/
        \ contained containedin=uniteSource__FileMru
  highlight default link uniteSource__FileMru_Time Statement
endfunction
function! s:dir_mru_source.hooks.on_syntax(args, context) abort
  syntax match uniteSource__DirectoryMru_Time
        \ /([^)]*)\s\+/
        \ contained containedin=uniteSource__DirectoryMru
  highlight default link uniteSource__DirectoryMru_Time Statement
endfunction
function! s:file_mru_source.hooks.on_post_filter(args, context) abort
  return s:on_post_filter(a:args, a:context)
endfunction
function! s:dir_mru_source.hooks.on_post_filter(args, context) abort
  for candidate in a:context.candidates
    if !has_key(candidate, 'abbr')
      let candidate.abbr = candidate.word
    endif
    if candidate.abbr !~ '/$'
      let candidate.abbr .= '/'
    endif
  endfor
  return s:on_post_filter(a:args, a:context)
endfunction
function! s:file_mru_source.gather_candidates(args, context) abort
  let mru = neomru#_get_mrus().file
  let candidates = mru.gather_candidates(a:args, a:context)
  return exists('*unite#helper#paths2candidates') ?
        \ unite#helper#paths2candidates(candidates) :
        \ map(copy(candidates), "{
        \ 'word' : v:val,
        \ 'action__path' : v:val,
        \}")
endfunction
function! s:dir_mru_source.gather_candidates(args, context) abort
  let mru = neomru#_get_mrus().directory
  let candidates = mru.gather_candidates(a:args, a:context)
  return exists('*unite#helper#paths2candidates') ?
        \ unite#helper#paths2candidates(candidates) :
        \ map(copy(candidates), "{
        \ 'word' : v:val,
        \ 'action__path' : v:val,
        \}")
endfunction

" Actions
let s:file_mru_source.action_table.delete = {
      \ 'description' : 'delete from file_mru list',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ 'is_selectable' : 1,
      \ }
function! s:file_mru_source.action_table.delete.func(candidates) abort
  call neomru#_get_mrus().file.delete(a:candidates)
endfunction

let s:dir_mru_source.action_table.delete = {
      \ 'description' : 'delete from directory_mru list',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ 'is_selectable' : 1,
      \ }
function! s:dir_mru_source.action_table.delete.func(candidates) abort
  call neomru#_get_mrus().directory.delete(a:candidates)
endfunction


" Filters
function! s:converter(candidates, context) abort
  if g:neomru#filename_format == '' && g:neomru#time_format == ''
    return a:candidates
  endif

  for candidate in filter(copy(a:candidates),
        \ "!has_key(v:val, 'abbr')")
    let path = (g:neomru#filename_format == '') ?  candidate.action__path :
          \ unite#util#substitute_path_separator(
          \   fnamemodify(candidate.action__path, g:neomru#filename_format))
    if path == ''
      let path = candidate.action__path
    endif

    " Set default abbr.
    let candidate.abbr = neomru#_abbr(path, getftime(candidate.action__path))
  endfor

  return a:candidates
endfunction
function! s:file_mru_source.source__converter(candidates, context) abort
  return s:converter(a:candidates, a:context)
endfunction
let s:file_mru_source.converters = [ s:file_mru_source.source__converter ]
function! s:dir_mru_source.source__converter(candidates, context) abort
  return s:converter(a:candidates, a:context)
endfunction
let s:dir_mru_source.converters = [ s:dir_mru_source.source__converter ]

" Misc
function! s:on_post_filter(args, context) abort
  for candidate in a:context.candidates
    let candidate.action__directory =
          \ unite#util#path2directory(candidate.action__path)
  endfor
endfunction
