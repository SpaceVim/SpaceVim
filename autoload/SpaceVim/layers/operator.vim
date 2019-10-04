"=============================================================================
" operator.vim --- SpaceVim operator layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section operator, layer-operator
" @parentsection layers
" With this layer, you can confirm that text is yanked correctly and see
" yanked text by highlighting.

function! SpaceVim#layers#operator#plugins() abort
    let plugins = []
    call add(plugins, ['kana/vim-operator-user', { 'merged' : 0 }])
    call add(plugins, ['haya14busa/vim-operator-flashy', { 'merged' : 0 }])
    return plugins
endfunction

function! SpaceVim#layers#operator#config() abort
    map y <Plug>(operator-flashy)
    nmap Y <Plug>(operator-flashy)$
endfunction
