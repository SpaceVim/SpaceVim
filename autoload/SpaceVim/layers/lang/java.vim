function! SpaceVim#layers#lang#java#plugins() abort
    let plugins = [
                \ ['wsdjeg/vim-dict',                        { 'on_ft' : 'java'}],
                \ ['wsdjeg/java_getset.vim',                 { 'on_ft' : 'java', 'loadconf' : 1}],
                \ ['wsdjeg/JavaUnit.vim',                    { 'on_ft' : 'java'}],
                \ ['vim-jp/vim-java',                        { 'on_ft' : 'java'}],
                \ ]
    if g:spacevim_enable_javacomplete2_py
        call add(plugins , ['wsdjeg/vim-javacomplete2',               { 'on_ft' : ['java','jsp'], 'loadconf' : 1}])
    else
        call add(plugins , ['artur-shaik/vim-javacomplete2',          { 'on_ft' : ['java','jsp'], 'loadconf' : 1}])
    endif
    return plugins
endfunction

function! SpaceVim#layers#lang#java#config() abort
    
endfunction
