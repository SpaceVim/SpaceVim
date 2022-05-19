if exists('g:loaded_gina') || v:version < 800
  finish
endif
let g:loaded_gina = 1

command! -nargs=+ -range=% -bang
      \ -complete=customlist,gina#command#complete
      \ Gina
      \ call gina#command#call(<q-bang>, [<line1>, <line2>], <q-args>, <q-mods>)
