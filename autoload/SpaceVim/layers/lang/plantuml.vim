"=============================================================================
" plantuml.vim --- lang#plantuml layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#plantuml, layers-lang-plantuml
" @parentsection layers
" This layer is for plantuml development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#plantuml'
" <
"
" @subsection layer options
"
" 1. `java_command`: Set the path of java command, by default, it is `java`
" >
"   [[layers]]
"     name = 'lang#plantuml'
"     java_command = 'path/to/java'
" <
" 2. `plantuml_jar_path`: Set the path of `pluatuml.jar`.
" >
"   [[layers]]
"     name = 'lang#plantuml'
"     plantuml_jar_path = 'path/to/plantuml.jar'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l p         preview uml file
"   normal          SPC l c         stop preview
"   normal          SPC l s         save uml file
" <
"

function! SpaceVim#layers#lang#plantuml#plugins() abort
  let plugins = []
  call add(plugins, ['aklt/plantuml-syntax', {'on_ft' : 'plantuml'}])
  call add(plugins, ['wsdjeg/vim-slumlord', {'on_ft' : 'plantuml'}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/plantuml-previewer.vim', {'merged':0}])
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
  let g:plantuml_java_command = get(a:var, 'java_command', 'java')

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

function! SpaceVim#layers#lang#plantuml#health() abort
  call SpaceVim#layers#lang#plantuml#plugins()
  call SpaceVim#layers#lang#plantuml#config()
  return 1
endfunction
