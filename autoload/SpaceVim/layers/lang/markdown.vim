function! SpaceVim#layers#lang#markdown#plugins() abort
    let plugins = []
    call add(plugins, ['gabrielelana/vim-markdown',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['joker1007/vim-markdown-quote-syntax',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['mzlogin/vim-markdown-toc',{ 'on_ft' : 'markdown'}])
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
    let g:markdown_quote_syntax_filetypes = {
                \ "vim" : {
                \   "start" : "\\%(vim\\|viml\\)",
                \},
                \}
    augroup SpaceVim_lang_markdown
        au!
        autocmd BufEnter *.md call s:mappings()
    augroup END
endfunction

function! s:mappings() abort
    let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','ft'], "Tabularize /|", 'Format table under cursor', 1)
endfunction
