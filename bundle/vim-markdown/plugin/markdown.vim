""
" @section Introduction, intro
" This is Markdown plugin for SpaceVim, It is based on SpaceVim API.
" This plugin include syntax file for Markdown.

if !exists('g:markdown_default_mappings')
    ""
    " Enable/Disable default mappings when edit markdown file, by default it is
    " enabled.
    let g:markdown_default_mappings = 1
endif

if !exists('g:vim_markdown_auto_insert_bullets')
    ""
    " Enable/Disable auto insert bullets, by default it is enabled.
    let g:vim_markdown_auto_insert_bullets = 1
endif

if !exists('g:markdown_hi_error')
    ""
    " Enable/Disable highlight for markdown error.
    let g:markdown_hi_error = 1
endif

