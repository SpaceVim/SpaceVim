"=============================================================================
" kotlin.vim --- SpaceVim lang#kotlin layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#kotlin, layer-lang-kotlin
" @parentsection layers
" This layer is for kotlin development. 

let s:SYS = SpaceVim#api#import('system')

function! SpaceVim#layers#lang#kotlin#plugins() abort
  let plugins = []
  call add(plugins, ['udalov/kotlin-vim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#kotlin#config() abort
  if g:spacevim_enable_neomake
    " neomake support:
    let g:neomake_kotlin_kotlinc_maker = {
          \ 'args': ['-cp', s:classpath(), '-d', s:outputdir()],
          \ 'errorformat':
          \ '%E%f:%l:%c: error: %m,' .
          \ '%W%f:%l:%c: warning: %m,' .
          \ '%Eerror: %m,' .
          \ '%Wwarning: %m,' .
          \ '%Iinfo: %m,'
          \ }
    let g:neomake_kotlin_enabled_makers = ['kotlinc']
  endif
  call SpaceVim#mapping#space#regesit_lang_mappings('kotlin', function('s:language_specified_mappings'))
  let runner = {
        \ 'exe' : 'kotlinc'. (s:SYS.isWindows ? '.BAT' : ''),
        \ 'targetopt' : '-o',
        \ 'opt' : [],
        \ 'usestdin' : 0,
        \ }
  call SpaceVim#plugins#runner#reg_runner('kotlin', [runner, '#TEMP#'])
endfunction

function! s:language_specified_mappings() abort
  if SpaceVim#layers#lsp#check_filetype('kotlin')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
func! s:classpath() abort

endf

func! s:outputdir() abort

endf

