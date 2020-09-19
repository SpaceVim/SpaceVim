"=============================================================================
" FILE: converter_file_directory.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu (at) gmail.com>
"          basyura <basyura (at) gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_file_directory#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_file_directory',
      \ 'description' : 'converter to separate file and directory',
      \}

function! s:converter.filter(candidates, context) abort
  let candidates = copy(a:candidates)

  let max = min([max(map(copy(candidates), "
        \ strwidth(s:convert_to_abbr(
        \  get(v:val, 'action__path', v:val.word)))"))+2,
        \ get(g:, 'unite_converter_file_directory_width', 45)])

  for candidate in candidates
    let path = get(candidate, 'action__path', candidate.word)

    let abbr = s:convert_to_abbr(path)
    let abbr = unite#util#truncate(abbr, max) . ' '
    let path = unite#util#substitute_path_separator(
          \ fnamemodify(path, ':~:.:h'))
    if path ==# '.'
      let path = ''
    endif
    let candidate.abbr = abbr . path
  endfor

  return candidates
endfunction

function! s:convert_to_abbr(path) abort
  return printf('%s (%s)', fnamemodify(a:path, ':p:t'),
        \ fnamemodify(a:path, ':p:h:t'))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
