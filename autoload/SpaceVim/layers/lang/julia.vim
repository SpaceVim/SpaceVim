"=============================================================================
" julia.vim --- SpaceVim lang#julia layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#julia, layers-lang-julia
" @parentsection layers
" This layer is for julia development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#julia'
" <
"
" @subsection Key bindings
"
" This layer brings following key bindings to julia file:
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
" This layer also provides REPL support for julia, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
" To format julia code, you need to install `JuliaFormatter`, and the key
" binding is `SPC b f`
"
" If the lsp layer is enabled for julia, the following key bindings can
" be used:
" >
"   key binding     Description
"   g D             jump to type definition
"   g d             jump to definition
"   SPC l e         rename symbol
"   SPC l x         show references
"   SPC l h         show line diagnostics
"   SPC l d         show document
"   K               show document
"   SPC l w l       list workspace folder
"   SPC l w a       add workspace folder
"   SPC l w r       remove workspace folder
" <

function! SpaceVim#layers#lang#julia#plugins() abort
  let plugins = []
  call add(plugins, ['JuliaEditorSupport/julia-vim' , {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#julia#config() abort
  " registe code runner commmand for julia
  call SpaceVim#plugins#runner#reg_runner('julia', 'julia %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('julia', function('s:language_specified_mappings'))
  " registe REPL command and key bindings for julia
  call SpaceVim#plugins#repl#reg('julia', 'julia')

  let g:latex_to_unicode_auto = 1
  let g:latex_to_unicode_tab = 1
  " runtime macros/matchit.vim

  " julia
  let g:default_julia_version = '0.7'
  " format code
  " if you want to use mirror:
  " let $JULIA_PKG_SERVER = 'https://mirrors.tuna.tsinghua.edu.cn/julia'
  let g:neoformat_enabled_julia = ['juliafmt']
  let g:neoformat_julia_juliafmt = {
        \ 'exe': 'julia',
        \ 'args': ['-e', '"using JuliaFormatter; print(format_text(read(stdin, String)))"'],
        \ 'stdin': 1,
        \ }
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("julia")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 't'],
        \ 'call LaTeXtoUnicode#Toggle()', 'toggle latex to unicode', 1)
  if SpaceVim#layers#lsp#check_filetype('julia')
        \ || SpaceVim#layers#lsp#check_server('julials')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    nnoremap <silent><buffer> gD :<C-u>call SpaceVim#lsp#go_to_typedef()<Cr>
    nnoremap <silent><buffer> gd :<C-u>call SpaceVim#lsp#go_to_def()<Cr>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show-document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call SpaceVim#lsp#references()', 'show-references', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename-symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'h'],
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

function! SpaceVim#layers#lang#julia#health() abort
  call SpaceVim#layers#lang#julia#plugins()
  call SpaceVim#layers#lang#julia#config()
  return 1
endfunction
