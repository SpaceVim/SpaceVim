function! SpaceVim#layers#lang#markdown#plugins() abort
    let plugins = []
    call add(plugins, ['tpope/vim-markdown',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['joker1007/vim-markdown-quote-syntax',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['mzlogin/vim-markdown-toc',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['iamcco/mathjax-support-for-mkdp',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['iamcco/markdown-preview.vim',{ 'on_ft' : 'markdown'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#markdown#config() abort
    let g:markdown_minlines = 100
    let g:markdown_syntax_conceal = 0
    let g:markdown_enable_mappings = 0
    let g:markdown_enable_insert_mode_leader_mappings = 0
    let g:markdown_enable_spell_checking = 0
    let g:markdown_quote_syntax_filetypes = {
                \ "vim" : {
                \   "start" : "\\%(vim\\|viml\\)",
                \},
                \}
    augroup SpaceVim_lang_markdown
        au!
        autocmd BufEnter *.md call s:mappings()
    augroup END
    if executable('firefox')
        let g:mkdp_path_to_chrome= get(g:, 'mkdp_path_to_chrome', 'firefox')
    endif
endfunction

function! s:mappings() abort
    if !exists('g:_spacevim_mappings_space')
        let g:_spacevim_mappings_space = {}
    endif
    let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','ft'], "Tabularize /|", 'Format table under cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','p'], "MarkdownPreview", 'Real-time markdown preview', 1)
endfunction
