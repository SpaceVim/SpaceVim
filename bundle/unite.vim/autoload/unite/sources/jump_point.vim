"=============================================================================
" FILE: jump_point.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#jump_point#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'jump_point',
      \ 'description' : 'candidates from cursor point',
      \ 'hooks' : {},
      \ 'default_kind' : 'jump_list',
      \}
function! s:source.hooks.on_init(args, context) abort "{{{
  let line = substitute(getline('.'), '^!!!\|!!!$', '', 'g')
  let a:context.source__line =
        \ (line =~ '^\f\+:') ?  line : ''
endfunction"}}}

function! s:source.gather_candidates(args, context) abort "{{{
  if a:context.source__line == ''
    return []
  endif

  let [word, list] = [a:context.source__line,
        \ split(a:context.source__line[2:], ':')]

  let candidate = {
        \   'word': word,
        \ }
  if len(word) == 1 && unite#util#is_windows()
    let candidate.word = word . list[0]
    let list = list[1:]
  endif

  let candidate.action__path = unite#util#substitute_path_separator(
        \ fnamemodify(word[:1].list[0], ':p'))
  if !filereadable(candidate.action__path)
    " Skip.
    return []
  endif

  " Drop filename field.
  let list = list[1:]

  " Check line:col.
  if len(list) >= 0 && list[0] =~ '^\d\+$'
    let candidate.action__line = list[0]
    if len(list) >= 1 && list[1] =~ '^\d\+$'
      let candidate.action__col = list[1]
    endif
  else
    let candidate.action__text = join(list, ':')
    let candidate.action__pattern =
          \ unite#util#escape_match(candidate.action__text)
  endif

  return [candidate]
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
