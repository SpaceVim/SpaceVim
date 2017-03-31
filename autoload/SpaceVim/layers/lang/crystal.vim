""
" @section lang#crystal, layer-lang-crystal
" @parentsection layers
" @subsection Intro
" The lang#crystal layer provides crystal filetype detection and syntax highlight,
" crystal tool and crystal spec integration.

function! SpaceVim#layers#lang#crystal#plugins() abort
    let plugins = []
    call add(plugins, ['rhysd/vim-crystal', {'on_ft' : 'crystal'}])
    return plugins
endfunction
