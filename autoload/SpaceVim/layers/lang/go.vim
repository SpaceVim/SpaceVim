"=============================================================================
" go.vim --- SpaceVim lang#go layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
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
"   normal          SPC l a         go alternate
"   normal          SPC l b         go build
"   normal          SPC l c         go coverage
"   normal          SPC l d         go doc
"   normal          SPC l D         go doc vertical
"   normal          SPC l e         go rename
"   normal          SPC l g         go definition
"   normal          SPC l G         go generate
"   normal          SPC l h         go info
"   normal          SPC l i         go implements
"   normal          SPC l I         implement stubs
"   normal          SPC l k         add tags
"   normal          SPC l K         remove tags
"   normal          SPC l l         list declarations in file
"   normal          SPC l L         list declarations in dir
"   normal          SPC l m         format improts
"   normal          SPC l M         add import
"   normal          SPC l x         go referrers
"   normal          SPC l s         fill struct
"   normal          SPC l t         go test
"   normal          SPC l v         freevars
"   normal          SPC l r         go run
" <


function! SpaceVim#layers#lang#go#plugins() abort
  let plugins = [['fatih/vim-go', { 'on_ft' : 'go', 'loadconf_before' : 1}]]
  if has('nvim') && g:spacevim_autocomplete_method ==# 'deoplete'
    call add(plugins, ['zchee/deoplete-go', {'on_ft' : 'go', 'build': 'make'}])
  endif
  return plugins
endfunction


function! SpaceVim#layers#lang#go#config() abort
  let g:go_highlight_functions = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
  let g:go_fmt_command = 'goimports'
  let g:syntastic_go_checkers = ['golint', 'govet']
  let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
  let g:neomake_go_gometalinter_args = ['--disable-all']
  let g:go_snippet_engine = 'neosnippet'
  let g:go_rename_command = 'gopls'

  if SpaceVim#layers#lsp#check_filetype('go')
    call SpaceVim#mapping#gd#add('go',
          \ function('SpaceVim#lsp#go_to_def'))
  else
    call SpaceVim#mapping#gd#add('go', function('s:go_to_def'))
  endif
  call SpaceVim#mapping#space#regesit_lang_mappings('go', function('s:language_specified_mappings'))
  call SpaceVim#plugins#runner#reg_runner('go', 'go run %s')
endfunction

function! s:go_to_def() abort
  call go#def#Jump('', 0)
endfunction

function! s:language_specified_mappings() abort

  call SpaceVim#mapping#space#langSPC('nmap', ['l','a'],
        \ ':GoAlternate',
        \ 'go alternate', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','b'],
        \ '<Plug>(go-build)',
        \ 'go build', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c'],
        \ 'GoCoverageToggle',
        \ 'go coverage toggle', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d'],
        \ '<Plug>(go-doc)',
        \ 'go doc', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','D'],
        \ '<Plug>(go-doc-vertical)',
        \ 'go doc (vertical)', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','e'],
        \ '<Plug>(go-rename)',
        \ 'go rename', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','g'],
        \ '<Plug>(go-def)',
        \ 'go def', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','G'],
        \ ':GoGenerate',
        \ 'go generate', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','h'],
        \ '<Plug>(go-info)',
        \ 'go info', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','i'],
        \ '<Plug>(go-implements)',
        \ 'go implements', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','I'],
        \ ':GoImpl',
        \ 'impl stubs', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','k'],
        \ ':GoAddTags',
        \ 'add tags', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','K'],
        \ ':GoRemoveTags',
        \ 'remove tags', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','l'],
        \ ':GoDecls',
        \ 'decl file', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','L'],
        \ ':GoDeclsDir',
        \ 'decl dir', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','m'],
        \ ':GoImports',
        \ 'format imports', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','M'],
        \ ':GoImport ',
        \ 'add import', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x'],
        \ ':GoReferrers',
        \ 'go referrers', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s'],
        \ ':GoFillStruct',
        \ 'fill struct', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','t'],
        \ 'GoTest',
        \ 'go test', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','T'],
        \ 'GoTestFunc',
        \ 'go test function', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','v'],
        \ ':GoFreevars',
        \ 'freevars', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
