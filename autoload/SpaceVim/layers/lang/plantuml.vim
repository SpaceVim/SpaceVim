"=============================================================================
" plantuml.vim --- lang#plantuml layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#plantuml#plugins() abort
  let plugins = []
  call add(plugins, ['aklt/plantuml-syntax', {'on_ft' : 'plantuml'}])
  call add(plugins, ['wsdjeg/vim-slumlord', {'on_ft' : 'plantuml'}])
  call add(plugins, ['weirongxu/plantuml-previewer.vim', {'depends': 'open-browser.vim'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#plantuml#config() abort
  let g:plantuml_previewer#plantuml_jar_path = s:plantuml_jar_path

  call SpaceVim#mapping#space#regesit_lang_mappings('plantuml',
        \ function('s:language_specified_mappings'))

endfunction


let s:plantuml_jar_path = ''
function! SpaceVim#layers#lang#plantuml#set_variable(var) abort

  let s:plantuml_jar_path = get(a:var, 'plantuml_jar_path', s:plantuml_jar_path)

endfunction


function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','p'],
        \ 'PlantumlOpen',
        \ 'preview uml file in browser', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','c'],
        \ 'PlantumlStop',
        \ 'close uml preview', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','s'],
        \ 'PlantumlSave',
        \ 'save uml file', 1)
endfunction
