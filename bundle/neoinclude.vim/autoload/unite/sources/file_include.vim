"=============================================================================
" FILE: file_include.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
"          manga_osyo (Original)
" License: MIT license
"=============================================================================

function! unite#sources#file_include#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name' : 'file_include',
      \ 'description' : 'candidates from include files',
      \ 'hooks' : {},
      \}
function! s:source.hooks.on_init(args, context) abort
  let a:context.source__include_files =
        \ neoinclude#include#get_include_files(bufnr('%'))
  let a:context.source__path = &path
endfunction

function! s:source.gather_candidates(args, context) abort
  let files = map(copy(a:context.source__include_files), '{
        \ "word" : neoinclude#util#substitute_path_separator(v:val),
        \ "abbr" : neoinclude#util#substitute_path_separator(v:val),
        \ "source" : "file_include",
        \ "kind" : "file",
        \ "action__path" : v:val
        \ }')

  for word in files
    " Path search.
    for path in map(split(a:context.source__path, ','),
          \ 'neoinclude#util#substitute_path_separator(v:val)')
      if path != '' && neoinclude#util#head_match(word.word, path . '/')
        let word.abbr = word.abbr[len(path)+1 : ]
        break
      endif
    endfor
  endfor

  return files
endfunction
