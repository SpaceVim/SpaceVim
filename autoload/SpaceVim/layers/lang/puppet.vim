"=============================================================================
" puppet.vim --- SpaceVim lang#puppet layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#puppet, layer-lang-puppet
" @parentsection layers
" This layer is for Puppet development. It provides syntax highlighting and
" syntax checking.
"
" Requirements:
" >
"   Puppet
"   Puppet Lint
" <

function! SpaceVim#layers#lang#puppet#plugins() abort
    let plugins = []
    call add(plugins, ['rodjek/vim-puppet', { 'on_ft' : 'puppet', 'loadconf_before' : 1}])
    return plugins
endfunction


function! SpaceVim#layers#lang#puppet#config() abort
    let g:syntastic_puppet_checkers = ['puppetlint', 'puppet']
    let g:syntastic_puppet_puppetlint_args='--no-autoloader_layout-check --no-class_inherits_from_params_class-check'
    let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['puppet'] }
endfunction
