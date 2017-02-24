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
