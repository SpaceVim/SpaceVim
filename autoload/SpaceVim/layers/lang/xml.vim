""
" @section lang#xml, layer-lang-xml
" @parentsection layers
" when edite an xml file, the omni func is `xmlcomplete#CompleteTags`, you can
" read the document in `autoload/xmlcomplete.vim` in vim or neovim
" runtime directory.


function! SpaceVim#layers#lang#xml#plugins() abort
    return [['Valloric/MatchTagAlways',                { 'on_ft' : ['html' , 'xhtml' , 'xml' , 'jinja']}]]
endfunction

function! SpaceVim#layers#lang#xml#config() abort
    
endfunction
