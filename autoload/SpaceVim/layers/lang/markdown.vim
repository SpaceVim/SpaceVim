function! SpaceVim#layers#lang#markdown#plugins() abort
    let plugins = []
    call add(plugins, ['plasticboy/vim-markdown',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['iamcco/mathjax-support-for-mkdp',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['iamcco/markdown-preview.vim',{ 'on_ft' : 'markdown'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#markdown#config() abort
    let g:vim_markdown_fenced_languages = [ 'c++=cpp' , 'viml=vim', 'bash=sh', 'ini=dosini']
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_toml_frontmatter = 1
endfunction
