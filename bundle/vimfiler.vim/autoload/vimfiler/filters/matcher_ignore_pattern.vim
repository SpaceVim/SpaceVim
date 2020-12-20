"=============================================================================
" FILE: matcher_ignore_pattern.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! vimfiler#filters#matcher_ignore_pattern#define() abort
  return s:filter
endfunction

let s:filter = {
      \ 'name' : 'matcher_ignore_pattern',
      \ 'description' : 'ignore g:vimfiler_ignore_pattern matched files',
      \ }

function! s:filter.filter(files, context) abort
  for pattern in filter(vimfiler#util#convert2list(
        \ g:vimfiler_ignore_pattern), "v:val != ''")
    call filter(a:files,
          \  "v:val.vimfiler__filename !~? pattern")
  endfor
  return a:files
endfunction
