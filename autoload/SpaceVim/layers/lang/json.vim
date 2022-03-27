"=============================================================================
" json.vim --- lang#json layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#json, layers-lang-json
" @parentsection layers
" This layer provides syntax highlighting for json file. To enable this layer:
" >
"   [layers]
"     name = "lang#json"
" <
"
" @subsection Options
"
" 1. conceal: Set the valuable for |g:vim_json_syntax_conceal|
"
" 2. concealcursor: Set the valuable for |g:vim_json_syntax_concealcursor|
"
" >
"   [layers]
"     name = 'lang#json'
"     conceal = false
"     concealcursor = ''
" <

if exists('s:conceal')
  " @bug s:conceal always return 0
  "
  " because this script will be loaded twice. This is the feature of vim,
  " when call an autoload func, vim will try to load the script again
  finish
else
  let s:conceal = 0
  let s:concealcursor = ''
endif


function! SpaceVim#layers#lang#json#plugins() abort
  let plugins = []
  call add(plugins, ['elzr/vim-json',                          { 'on_ft' : ['javascript','json']}])   
  return plugins
endfunction


function! SpaceVim#layers#lang#json#config() abort
  let g:vim_json_syntax_conceal = s:conceal
  let g:vim_json_syntax_concealcursor = s:concealcursor
endfunction

function! SpaceVim#layers#lang#json#set_variable(var) abort
  let s:conceal = get(a:var, 'conceal', 0)
  let s:concealcursor = get(a:var, 'concealcursor', 0)
endfunction


function! SpaceVim#layers#lang#json#health() abort
  call SpaceVim#layers#lang#json#plugins()
  call SpaceVim#layers#lang#json#config()
  return 1
endfunction
