""
" @section lang#xml, layer-lang-xml
" @parentsection layers
" when edite an xml file, the omni func is `xmlcomplete#CompleteTags`, you can
" read the document in `autoload/xmlcomplete.vim` in vim or neovim
" runtime directory.


function! SpaceVim#layers#lang#xml#plugins() abort
    let plugins = []
    call add(plugins,['Valloric/MatchTagAlways',                { 'on_ft' : ['html' , 'xhtml' , 'xml' , 'jinja']}])
    call add(plugins,['sukima/xmledit',                { 'on_ft' : ['html' , 'xhtml' , 'xml' , 'jinja']}])
    call add(plugins,['alvan/vim-closetag',                { 'on_ft' : ['html' , 'xhtml' , 'xml' , 'jinja']}])
    return plugins
endfunction

function! SpaceVim#layers#lang#xml#config() abort
    
endfunction
