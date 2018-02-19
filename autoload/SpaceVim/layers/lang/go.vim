"=============================================================================
" go.vim --- SpaceVim lang#go layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#go, layer-lang-go
" @parentsection layers
" This layer includes code completion and syntax checking for Go development.
"
" @subsection Mappings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l i         go implements
"   normal          SPC l f         go info
"   normal          SPC l e         go rename
"   normal          SPC l r         go run
"   normal          SPC l b         go build
"   normal          SPC l t         go test
"   normal          SPC l d         go doc
"   normal          SPC l v         go doc vertical
"   normal          SPC l c         go coverage
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

    call SpaceVim#mapping#space#regesit_lang_mappings('go', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort

  call SpaceVim#mapping#space#langSPC('nmap', ['l','i'],
        \ '<Plug>(go-implements)',
        \ 'go implements', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','f'],
        \ '<Plug>(go-info)',
        \ 'go info', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','e'],
        \ '<Plug>(go-rename)',
        \ 'go rename', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ '<Plug>(go-run)',
        \ 'go run', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','b'],
        \ '<Plug>(go-build)',
        \ 'go build', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','t'],
        \ '<Plug>(go-test)',
        \ 'go test', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d'],
        \ '<Plug>(go-doc)',
        \ 'go doc', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','v'],
        \ '<Plug>(go-doc-vertical)',
        \ 'go doc (vertical)', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c'],
        \ '<Plug>(go-coverage)',
        \ 'go coverage', 0)
endfunction
