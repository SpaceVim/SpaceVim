function! SpaceVim#layers#lang#go#plugins() abort
    let plugins = [['fatih/vim-go', { 'on_ft' : 'go', 'loadconf_before' : 1}]]
    if has('nvim')
        call add(plugins, ['zchee/deoplete-go', {'on_ft' : 'go', 'build': 'make'}])
    endif
    return plugins
endfunction


function! SpaceVim#layers#lang#go#config() abort
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
    let g:go_fmt_command = 'goimports'
    let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
    let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
    let g:go_snippet_engine = "neosnippet"

    augroup SpaceVim_go
        au!
        au FileType go nmap <Buffer><Leader>s <Plug>(go-implements)
        au FileType go nmap <Buffer><Leader>i <Plug>(go-info)
        au FileType go nmap <Buffer><Leader>e <Plug>(go-rename)
        au FileType go nmap <Buffer><Leader>r <Plug>(go-run)
        au FileType go nmap <Buffer><Leader>b <Plug>(go-build)
        au FileType go nmap <Buffer><Leader>t <Plug>(go-test)
        au FileType go nmap <Buffer><Leader>gd <Plug>(go-doc)
        au FileType go nmap <Buffer><Leader>gv <Plug>(go-doc-vertical)
        au FileType go nmap <Buffer><Leader>co <Plug>(go-coverage)
    augroup END
endfunction
