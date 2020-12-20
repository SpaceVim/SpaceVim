"=============================================================================
" FILE: defx.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

if exists('g:loaded_defx')
  finish
endif
let g:loaded_defx = 1

command! -nargs=* -range -bar -complete=customlist,defx#util#complete
      \ Defx
      \ call defx#util#call_defx('Defx', <q-args>)
