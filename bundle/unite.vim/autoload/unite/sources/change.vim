"=============================================================================
" FILE: changes.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
"}}}

function! unite#sources#change#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'change',
      \ 'description' : 'candidates from changes',
      \ 'hooks' : {},
      \ }

let s:cached_result = []
function! s:source.hooks.on_init(args, context) abort "{{{
  let result = []
  for change in split(unite#util#redir('changes'), '\n')[1:]
    let list = split(change)
    if len(list) < 4
      continue
    endif

    let [linenr, col, text] = [list[1], list[2]+1, join(list[3:])]

    call add(result, {
          \ 'word' : printf('%4d-%-3d  %s', linenr, col, text),
          \ 'kind' : 'jump_list',
          \ 'action__path' : unite#util#substitute_path_separator(
          \         fnamemodify(expand('%'), ':p')),
          \ 'action__buffer_nr' : bufnr('%'),
          \ 'action__line' : linenr,
          \ 'action__col' : col,
          \ })
  endfor

  let a:context.source__result = reverse(result)
endfunction"}}}
function! s:source.gather_candidates(args, context) abort "{{{
  return a:context.source__result
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
