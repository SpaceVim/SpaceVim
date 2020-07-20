"=============================================================================
" FILE: matcher_ignore_wildignore.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! vimfiler#filters#matcher_ignore_wildignore#define() abort
  return s:filter
endfunction

let s:filter = {
      \ 'name' : 'matcher_ignore_wildignore',
      \ 'description' : 'ignore wildignore matched files',
      \ }

function! s:filter.filter(files, context) abort
  for pattern in unite#filters#globs2vim_patterns(split(&wildignore, ','))
    call filter(a:files,
          \  "v:val.action__path !~? pattern")
  endfor
  return a:files
endfunction
