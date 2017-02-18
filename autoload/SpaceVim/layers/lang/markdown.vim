function! SpaceVim#layers#lang#markdown#plugins() abort
    let plugins = []
    call add(plugins, ['plasticboy/vim-markdown',{ 'on_ft' : 'markdown'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#markdown#config() abort
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_folding_disabled = 1
    let g:markdown_fenced_languages = ['vim', 'java', 'bash=sh', 'sh', 'html', 'python']
endfunction
