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
"   normal          SPC l r         go referrers
"   normal          SPC l s         fill struct
"   normal          SPC l t         go test
"   normal          SPC l v         freevars
"   normal          SPC l x         go run
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
  let g:go_highlight_function_calls = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
  let g:go_fmt_command = 'goimports'
  let g:syntastic_go_checkers = ['golint', 'govet']
  let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
  let g:go_snippet_engine = 'neosnippet'

  if SpaceVim#layers#lsp#check_filetype('go')
    call SpaceVim#mapping#gd#add('go',
          \ function('SpaceVim#lsp#go_to_def'))
  else
    call SpaceVim#mapping#gd#add('go', function('s:go_to_def'))
  endif
  call SpaceVim#mapping#space#regesit_lang_mappings('go', function('s:language_specified_mappings'))
augroup spacevim_layer_lang_go
  autocmd!
  " Add indentation level to tab-indentated files. 
  " Note: there is a blank space at the end of the late backslash
  autocmd FileType go setl list lcs=tab:\┊\ 
  autocmd FileType go setl spell
augroup END
endfunction

function! s:go_to_def() abort
    call go#def#Jump('')
endfunction

function! s:language_specified_mappings() abort

  call SpaceVim#mapping#space#langSPC('nmap', ['l','a'],
        \ ':GoAlternate<CR>',
        \ 'go alternate', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','b'],
        \ '<Plug>(go-build)',
        \ 'go build', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c'],
        \ '<Plug>(go-coverage)',
        \ 'go coverage', 0)
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
        \ ':GoGenerate<CR>',
        \ 'go generate', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','h'],
        \ '<Plug>(go-info)',
        \ 'go info', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','i'],
        \ '<Plug>(go-implements)',
        \ 'go implements', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','I'],
        \ ':GoImpl<CR>',
        \ 'impl stubs', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','k'],
        \ ':GoAddTags<CR>',
        \ 'add tags', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','K'],
        \ ':GoRemoveTags<CR>',
        \ 'remove tags', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','l'],
        \ ':GoDecls<CR>',
        \ 'decl file', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','L'],
        \ ':GoDeclsDir<CR>',
        \ 'decl dir', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','m'],
        \ ':GoImports<CR>',
        \ 'format imports', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','M'],
        \ ':GoImport ',
        \ 'add import', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ ':GoReferrers<CR>',
        \ 'go referrers', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s'],
        \ ':GoFillStruct<CR>',
        \ 'fill struct', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','t'],
        \ '<Plug>(go-test)',
        \ 'go test', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','v'],
        \ ':GoFreevars<CR>',
        \ 'freevars', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x'],
        \ '<Plug>(go-run)',
        \ 'go run', 0)
endfunction
