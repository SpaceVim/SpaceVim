""
" @section lang#python, layer-lang-python
" @parentsection layers
" To make this layer work well, you should install jedi.
" @subsection mappings
" >
"   mode            key             function
" <

function! SpaceVim#layers#lang#python#plugins() abort
    let plugins = []
    " python
    if has('nvim')
        call add(plugins, ['zchee/deoplete-jedi',                    { 'on_ft' : 'python'}])
    else
        call add(plugins, ['davidhalter/jedi-vim',                   { 'on_ft' : 'python'}])
    endif
    call add(plugins, ['Vimjas/vim-python-pep8-indent',                   { 'on_ft' : 'python'}])
    return plugins
endfunction
