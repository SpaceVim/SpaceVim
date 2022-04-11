"=============================================================================
" FILE: mru.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" For compatibility
function! unite#sources#mru#define() abort
  let [file_mru_source, dir_mru_source] =
        \ deepcopy(unite#sources#neomru#define())
  let file_mru_source.name = 'file_mru'
  let dir_mru_source.name = 'directory_mru'
  return [file_mru_source, dir_mru_source]
endfunction
