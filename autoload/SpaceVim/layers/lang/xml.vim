"=============================================================================
" xml.vim --- SpaceVim lang#xml layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section lang#xml, layer-lang-xml
" @parentsection layers
" When editing an xml file, the omni func is xmlcomplete#CompleteTags. You can
" read the documentation in autoload/xmlcomplete.vim in the vim or neovim
" runtime directory.


function! SpaceVim#layers#lang#xml#plugins() abort
  let plugins = []
  call add(plugins,['Valloric/MatchTagAlways',                { 'on_ft' : ['html' , 'xhtml' , 'xml' , 'jinja']}])
  call add(plugins,['sukima/xmledit',                { 'on_ft' : ['html' , 'xhtml' , 'xml' , 'jinja']}])
  return plugins
endfunction

function! SpaceVim#layers#lang#xml#config() abort
  function! s:xml_file_init() abort
    set omnifunc=xmlcomplete#CompleteTags
    if filereadable('AndroidManifest.xml')
      set dict+=~/.vim/bundle/vim-dict/dict/android_xml.dic
    endif
  endfunction
  augroup spacevim_lang_xml
    autocmd!
    autocmd FileType xml call <SID>xml_file_init()
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  augroup END
endfunction

