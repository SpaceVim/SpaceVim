"=============================================================================
" verilog.vim --- Verilog/SystemVerilog support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#verilog, layers-lang-verilog
" @parentsection layers
" This layer is for verilog development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#verilog'
" <

function! SpaceVim#layers#lang#verilog#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/verilog', {'merged' : 0}])
  return plugins
endfunction

" ref：
" https://zhuanlan.zhihu.com/p/95081329

function! SpaceVim#layers#lang#verilog#config() abort
  call SpaceVim#plugins#runner#reg_runner('verilog', ['iverilog -o #TEMP# %s', '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('verilog', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort

  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
  if SpaceVim#layers#lsp#check_filetype('verilog')
        " \ || SpaceVim#layers#lsp#check_server('clangd')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call SpaceVim#lsp#references()', 'show-references', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'i'],
          \ 'call SpaceVim#lsp#go_to_impl()', 'implementation', 1)
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


function! SpaceVim#layers#lang#verilog#health() abort
  call SpaceVim#layers#lang#verilog#plugins()
  call SpaceVim#layers#lang#verilog#config()
  return 1
endfunction
