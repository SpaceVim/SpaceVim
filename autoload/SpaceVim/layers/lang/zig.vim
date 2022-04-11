"=============================================================================
" zig.vim --- zig language support
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

""
" @section lang#zig, layers-lang-zig
" @parentsection layers
" This layer is for zig language development, disabled by default,
" to enable this layer, add following snippet to your SpaceVim
" configuration file.
" >
"   [[layers]]
"     name = 'lang#zig'
" <
"
" @subsection layer option
"
" 1. `ztagsbin`: set the path of ztags, by default this option is `ztags`
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for zig, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

if exists('s:ztagsbin')
  finish
endif

let s:ztagsbin = 'ztags'

function! SpaceVim#layers#lang#zig#plugins() abort
  let plugins = []
  call add(plugins, ['ziglang/zig.vim', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#zig#config() abort
  call SpaceVim#plugins#runner#reg_runner('zig', 'zig run %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('zig', function('s:language_specified_mappings'))
  if executable(s:ztagsbin) && !exists('g:tagbar_type_zig')
    let g:tagbar_type_zig = {
          \ 'ctagstype' : 'zig',
          \ 'kinds'     : [
          \ 's:structs',
          \ 'u:unions',
          \ 'e:enums',
          \ 'v:variables',
          \ 'm:members',
          \ 'f:functions',
          \ 'r:errors'
          \ ],
          \ 'sro' : '.',
          \ 'kind2scope' : {
          \ 'e' : 'enum',
          \ 'u' : 'union',
          \ 's' : 'struct',
          \ 'r' : 'error'
          \ },
          \ 'scope2kind' : {
          \ 'enum' : 'e',
          \ 'union' : 'u',
          \ 'struct' : 's',
          \ 'error' : 'r'
          \ },
          \ 'ctagsbin'  : s:ztagsbin,
          \ 'ctagsargs' : ''
          \ }
  endif
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','t'], 'call SpaceVim#plugins#runner#open("zig test %s")', 'test current file', 1)
endfunction

function! SpaceVim#layers#lang#zig#set_variable(opt) abort
  let s:ztagsbin = get(a:opt, 'ztagsbin', s:ztagsbin) 
endfunction

function! SpaceVim#layers#lang#zig#health() abort
  call SpaceVim#layers#lang#zig#plugins()
  call SpaceVim#layers#lang#zig#config()
  return 1
endfunction
