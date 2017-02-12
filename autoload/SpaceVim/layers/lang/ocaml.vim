""
" @section lang#ocaml, layer-lang-ocaml
" @parentsection layers
" OCaml autocompletion provided by merlin
"
" Make sure `opam` and `merlin` are installed on your system.
" requirement:
" >
"   opam
"   merlin
" <

function! SpaceVim#layers#lang#ocaml#plugins() abort
    let plugins = []
    call add(plugins, ['ocaml/merlin', {'on_ft' : 'ocaml', 'rtp' : 'vim/merlin'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#ocaml#config() abort
    let g:syntastic_ocaml_checkers = ['merlin']
endfunction
