"=============================================================================
" vala.vim --- vala language support in SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#vala, layers-lang-vala
" @parentsection layers
" This layer is for vala development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#vala'
" <
" @subsection Enable language server
"
" To enable lsp layer for vala language. you need to install
" vala-language-server, for example, use AUR in Arch Linux.
" >
"   yay -S vala-language-server
" <
" If you are using `nvim(>=0.5.0)`. You need to use `enabled_clients`
" to specific the language servers. For example:
" >
"   [[layers]]
"     name = 'lsp'
"     enabled_clients = ['vala_ls']
" <
" If you are using `nvim(<0.5.0)` or `vim`, you need to use `override_cmd`
" option. For example:
" >
"   [[layers]]
"     name = "lsp"
"     filetypes = [
"         "vala",
"         "genie",
"     ]
"     [layers.override_cmd]
"         vala = ["vala-language-server"]
"         genie = ["vala-language-server"]
" <

function! SpaceVim#layers#lang#vala#plugins() abort
  let plugins = []
  call add(plugins, ['arrufat/vala.vim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#vala#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('vala', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
endfunction

function! SpaceVim#layers#lang#vala#health() abort
  call SpaceVim#layers#lang#vala#plugins()
  call SpaceVim#layers#lang#vala#config()
  return 1
endfunction

