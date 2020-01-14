"=============================================================================
 " extra.vim --- lang#extra layer for SpaceVim
 " Copyright (c) 2016-2019 Wang Shidong & Contributors
 " Author: Wang Shidong < wsdjeg at 163.com >
 " URL: https://spacevim.org
 " License: GPLv3
 "=============================================================================


 function! SpaceVim#layers#lang#extra#plugins() abort
    let plugins = [
                \ ['digitaltoad/vim-pug',                    { 'on_ft' : ['pug', 'jade']}],
                \ ['juvenn/mustache.vim',                    { 'on_ft' : ['mustache']}],
                \ ['kchmck/vim-coffee-script',               { 'on_ft' : ['coffee']}],
                \ ['PotatoesMaster/i3-vim-syntax',           { 'on_ft' : 'i3'}],
                \ ['isundil/vim-irssi-syntax',               { 'on_ft' : 'irssi'}],
                \ ['vimperator/vimperator.vim',              { 'on_ft' : 'vimperator'}],
                \ ['peterhoeg/vim-qml',                      { 'on_ft' : 'qml'}],
                \ ['cespare/vim-toml',                      { 'on_ft' : 'toml'}],
                \ ] 
    return plugins
 endfunction
