""
" @section lang#scala, layer-lang-scala
" @parentsection layers
" @subsection mappings
" >
"   mode            key             function
" <

function! SpaceVim#layers#lang#scala#plugins() abort
    let plugins = []
    " scala
    call add(plugins, ['derekwyatt/vim-scala',                    { 'on_ft' : 'scala'}])
    return plugins
endfunction
