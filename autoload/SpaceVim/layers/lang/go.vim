"=============================================================================
" go.vim --- SpaceVim lang#go layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#go, layers-lang-go
" @parentsection layers
" The `lang#go` layer includes code completion and syntax checking for
" Go development. This layer is not enabled by default, to enable it:
" >
"   [[layers]]
"     name = 'go'
" <
" @subsection layer options
" 1. `enabled_linters`: set a list of enabled lint for golang. by default this
" option is `['golint']`. The available linters includes: `go`,
" `gometalinter`
" 2. go_file_head: the default file head for golang source code.
" >
"   [layers]
"     name = "lang#go"
"     go_file_head = [      
"       '#!/usr/bin/python3',
"       '# -*- coding : utf-8 -*-'
"       ''
"     ]
" <
" 3. `go_interpreter`: Set the interpreter of go.
" >
"   [[layers]]
"     name = 'lang#go'
"     go_interpreter = '~/download/bin/go'
" <
" 4. format_on_save: enable/disable code formation when save go file. This
" options is disabled by default, to enable it:
" >
"   [[layers]]
"     name = 'lang#go'
"     format_on_save = true
" <
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
" If the lsp layer is enabled for go, the following key bindings can
" be used:
" >
"   key binding     Description
"   g D             jump to type definition
"   SPC l e         rename symbol
"   SPC l x         show references
"   SPC l s         show line diagnostics
"   SPC l d         show document
"   K               show document
"   SPC l w l       list workspace folder
"   SPC l w a       add workspace folder
"   SPC l w r       remove workspace folder
" <

if exists('s:enabled_linters')
  finish
endif

let s:enabled_linters = ['golint']
let s:format_on_save = 0
let s:go_file_head = [
      \ '// @Title',
      \ '// @Description',
      \ '// @Author',
      \ '// @Update',
      \ ]
let s:go_interpreter = 'python3'

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
  let g:go_fmt_command = 'gopls'
  let g:syntastic_go_checkers = ['golint', 'govet']
  let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
  " neomake config:
  let g:neomake_go_gometalinter_remove_invalid_entries = 1
  let g:neomake_go_go_remove_invalid_entries = 1
  let g:neomake_go_gometalinter_args = ['--disable-all']
  let g:neomake_go_enabled_makers = s:enabled_linters
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
  if s:format_on_save
    call SpaceVim#layers#format#add_filetype({
          \ 'filetype' : 'go',
          \ 'enable' : 1,
          \ })
  endif
  call SpaceVim#layers#edit#add_ft_head_tamplate('go', s:go_file_head)
endfunction

function! s:go_to_def() abort
  if SpaceVim#layers#lsp#check_filetype('go')
        \ || SpaceVim#layers#lsp#check_server('gopls')
    call SpaceVim#lsp#go_to_def()
  else
    call go#def#Jump('', 0)
  endif
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
  if SpaceVim#layers#lsp#check_filetype('go')
        \ || SpaceVim#layers#lsp#check_server('gopls')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    nnoremap <silent><buffer> gD :<C-u>call SpaceVim#lsp#go_to_typedef()<Cr>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show-document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call SpaceVim#lsp#references()', 'show-references', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename-symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 's'],
          \ 'call SpaceVim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)
    let g:_spacevim_mappings_space.l.w = {'name' : '+Workspace'}
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'l'],
          \ 'call SpaceVim#lsp#list_workspace_folder()', 'list-workspace-folder', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'a'],
          \ 'call SpaceVim#lsp#add_workspace_folder()', 'add-workspace-folder', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'r'],
          \ 'call SpaceVim#lsp#remove_workspace_folder()', 'remove-workspace-folder', 1)
  endif
endfunction
function! SpaceVim#layers#lang#go#set_variable(var) abort
  let s:format_on_save = get(a:var,
        \ 'format_on_save',
        \ get(a:var,
        \ 'format-on-save',
        \ s:format_on_save))
  let s:go_file_head = get(a:var,
        \ 'go_file_head',
        \ s:go_file_head)
  let s:enabled_linters = get(a:var,
        \ 'enabled_linters',
        \ s:enabled_linters
        \ )
  let s:go_interpreter = get(a:var,
        \ 'go_interpreter',
        \ s:go_interpreter
        \ )
endfunction

function! SpaceVim#layers#lang#go#health() abort
  call SpaceVim#layers#lang#go#plugins()
  call SpaceVim#layers#lang#go#config()
  return 1
endfunction
