" OCaml autocompletion provided by merlin
" https://github.com/ocaml/merlin/tree/master/vim/merlin
"
" Make sure `opam` and `merlin` are installed on your system.

function! SpaceVim#layers#lang#ocaml#plugins() abort
    let plugins = []
    let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
    call add(plugins, [g:opamshare . "/merlin/vim", {'on_ft' : 'ocaml'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#ocaml#config() abort
    let g:syntastic_ocaml_checkers = ['merlin']
    augroup SpaceVim_Ocaml
        autocmd FileType ocaml execute "helptags " . g:opamshare . "/merlin/vim/doc"
    augroup END
endfunction
