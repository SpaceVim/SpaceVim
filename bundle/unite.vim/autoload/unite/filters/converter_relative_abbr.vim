"=============================================================================
" FILE: converter_relative_abbr.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_relative_abbr#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_relative_abbr',
      \ 'description' : 'relative path abbr converter',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  try
    let directory = unite#util#substitute_path_separator(getcwd())
    let old_dir = directory

    if has_key(a:context, 'source__directory')
      let directory = substitute(
            \ a:context.source__directory, '*', '', 'g')

      if directory !=# old_dir && isdirectory(directory)
            \ && a:context.input == ''
        call unite#util#lcd(directory)
      endif
    endif

    for candidate in a:candidates
      let candidate.abbr = unite#util#substitute_path_separator(
            \ fnamemodify(get(candidate, 'action__path',
            \     candidate.word), ':~:.'))
      if candidate.abbr == ''
        let candidate.abbr = get(candidate, 'action__path',
              \     candidate.word)
      endif
      if isdirectory(candidate.abbr)
        let candidate.abbr .= '/'
      endif
    endfor
  finally
    if has_key(a:context, 'source__directory')
          \ && directory !=# old_dir
      call unite#util#lcd(old_dir)
    endif
  endtry

  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
