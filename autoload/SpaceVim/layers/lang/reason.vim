"=============================================================================
" reason.vim --- Reason programming language layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


if exists('s:JSON')
  finish
endif

""
" @section lang#reason, layers-lang-reason
" @parentsection layers
" This layer is for reason development, disabled by default, to enable this
" layer, add following snippet to your @section(options) file.
" >
"   [[layers]]
"     name = 'lang#reason'
" <

let s:JSON = SpaceVim#api#import('data#json')

function! SpaceVim#layers#lang#reason#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-reason', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#reason#config() abort
  call SpaceVim#plugins#tasks#reg_provider(function('s:reasonml_tasks'))
  call SpaceVim#mapping#space#regesit_lang_mappings('reason', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  if SpaceVim#layers#lsp#check_filetype('reason')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction
function! s:reasonml_tasks() abort
  let detect_task = {}
  let conf = {}
  if filereadable('package.json')
    let conf = s:JSON.json_decode(join(readfile('package.json', ''), ''))
  endif
  if has_key(conf, 'scripts')
    for task_name in keys(conf.scripts)
      call extend(detect_task, {
            \ task_name : {'command' : conf.scripts[task_name], 'isDetected' : 1, 'detectedName' : 'esy:'}
            \ })
    endfor
  endif
  return detect_task
endfunction

function! SpaceVim#layers#lang#reason#health() abort
  call SpaceVim#layers#lang#reason#plugins()
  call SpaceVim#layers#lang#reason#config()
  return 1
endfunction
