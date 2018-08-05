"=============================================================================
" agda.vim --- lang#agda layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


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
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call Refine("False")',
        \ 'refine false', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','R'],
        \ 'call Refine("True")',
        \ 'refine true', 1)
  nnoremap <buffer> <LocalLeader>g :call Give()<CR>
  nnoremap <buffer> <LocalLeader>c :call MakeCase()<CR>
  nnoremap <buffer> <LocalLeader>a :call Auto()<CR>
  nnoremap <buffer> <LocalLeader>e :call Context()<CR>
  nnoremap <buffer> <LocalLeader>n :call Normalize("IgnoreAbstract")<CR>
  nnoremap <buffer> <LocalLeader>N :call Normalize("DefaultCompute")<CR>
  nnoremap <buffer> <LocalLeader>M :call ShowModule('')<CR>
  nnoremap <buffer> <LocalLeader>y :call WhyInScope('')<CR>
  nnoremap <buffer> <LocalLeader>h :call HelperFunction()<CR>
  nnoremap <buffer> <LocalLeader>m :Metas<CR>
endfunction
