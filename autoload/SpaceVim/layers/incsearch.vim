function! SpaceVim#layers#incsearch#plugins() abort
    let plugins = []
    call add(plugins, ['haya14busa/incsearch.vim', {'merged' : 0}])
    call add(plugins, ['haya14busa/incsearch-fuzzy.vim', {'merged' : 0}])
    call add(plugins, ['haya14busa/vim-asterisk', {'merged' : 0}])
    return plugins
endfunction

function! SpaceVim#layers#incsearch#config() abort
    
endfunction
