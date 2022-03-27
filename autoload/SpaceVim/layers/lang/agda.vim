"=============================================================================
" agda.vim --- lang#agda layer for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#agda, layers-lang-agda
" @parentsection layers
" This layer provides syntax highlighting for agda. To enable this
" layer:
" >
"   [layers]
"     name = "lang#agda"
" <
"
" @subsection key bindings
"
" The following key bindings will be added when this layer is loaded. All key
" bindings start with `SPC l`.
"
" >
"   Key binding Description
"   SPC l r     execute current file
"   SPC l l     reload
"   SPC l t     infer
"   SPC l f     refine false
"   SPC l F     refine true
"   SPC l g     give
"   SPC l c     make case
"   SPC l a     auto
"   SPC l e     context
"   SPC l n     Normalize IgnoreAbstract
"   SPC l N     Normalize DefaultCompute
"   SPC l M     Show module
"   SPC l y     why in scope
"   SPC l h     helper function
"   SPC l m     metas
" <

function! SpaceVim#layers#lang#agda#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-agda', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#agda#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('agda', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
  " let g:_spacevim_mappings_space.l.g = {'name' : '+Generate'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','l'],
        \ 'Reload',
        \ 'reload', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','t'],
        \ 'call Infer()',
        \ 'infer', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','f'],
        \ 'call Refine("False")',
        \ 'refine false', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','F'],
        \ 'call Refine("True")',
        \ 'refine true', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','g'],
        \ 'call Give()',
        \ 'give', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c'],
        \ 'call MakeCase()',
        \ 'MakeCase', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','a'],
        \ 'call Auto()',
        \ 'Auto', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','e'],
        \ 'call Context()',
        \ 'Context', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','n'],
        \ 'call Normalize("IgnoreAbstract")',
        \ 'Normalize IgnoreAbstract', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','N'],
        \ 'call Normalize("DefaultCompute")',
        \ 'Normalize DefaultCompute', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','M'],
        \ 'call ShowModule("")',
        \ 'Show module', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','y'],
        \ 'call WhyInScope("")',
        \ 'Why in scope', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','h'],
        \ 'call HelperFunction()',
        \ 'HelperFunction', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','m'],
        \ 'Metas',
        \ 'Metas', 1)
endfunction

function! SpaceVim#layers#lang#agda#health() abort
  call SpaceVim#layers#lang#agda#plugins()
  call SpaceVim#layers#lang#agda#config()
  return 1
endfunction
