""
" @section lang#go, layer-lang-go
" @parentsection layers
" This layer includes code completion and syntax checking for Go development.
"
" @subsection Mappings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          <leader>gi      go implements
"   normal          <leader>gf      go info
"   normal          <leader>ge      go rename
"   normal          <leader>gr      go run
"   normal          <leader>gb      go build
"   normal          <leader>gt      go test
"   normal          <leader>gd      go doc
"   normal          <leader>gv      go doc vertical
"   normal          <leader>gco     go coverage
" <


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
    let g:go_snippet_engine = 'neosnippet'

    augroup SpaceVim_go
        au!
        au FileType go nmap <Buffer><silent><Leader>s <Plug>(go-implements)
        au FileType go nmap <Buffer><silent><Leader>i <Plug>(go-info)
        au FileType go nmap <Buffer><silent><Leader>e <Plug>(go-rename)
        au FileType go nmap <Buffer><silent><Leader>r <Plug>(go-run)
        au FileType go nmap <Buffer><silent><Leader>b <Plug>(go-build)
        au FileType go nmap <Buffer><silent><Leader>t <Plug>(go-test)
        au FileType go nmap <Buffer><silent><Leader>gd <Plug>(go-doc)
        au FileType go nmap <Buffer><silent><Leader>gv <Plug>(go-doc-vertical)
        au FileType go nmap <Buffer><silent><Leader>co <Plug>(go-coverage)
    augroup END
endfunction
