if exists('b:did_ftplugin') | finish | endif

if get(g:, 'markdown_default_mappings', 1)
    inoremap <buffer> <C-b> ****<Left><Left>
endif

let b:did_ftplugin = 1
