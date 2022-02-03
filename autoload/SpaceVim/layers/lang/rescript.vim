"=============================================================================
" rescript.vim --- ReScript programming language layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


if exists('s:JSON')
  finish
endif

let s:JSON = SpaceVim#api#import('data#json')

function! SpaceVim#layers#lang#rescript#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-rescript', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#rescript#config() abort
  call SpaceVim#plugins#tasks#reg_provider(function('s:rescript_tasks'))
  if index(g:spacevim_project_rooter_patterns, 'package.json') ==# -1
    call add(g:spacevim_project_rooter_patterns, 'package.json')
  endif
endfunction

function! s:rescript_tasks() abort
  let detect_task = {}
  let conf = {}
  if filereadable('package.json')
    let conf = s:JSON.json_decode(join(readfile('package.json', ''), ''))
  endif
  if has_key(conf, 'scripts')
    for task_name in keys(conf.scripts)
      call extend(detect_task, {
            \ task_name : {'command' : conf.scripts[task_name], 'isDetected' : 1, 'detectedName' : 'bsb:'}
            \ })
    endfor
  endif
  return detect_task
endfunction


function! SpaceVim#layers#lang#rescript#health() abort
  call SpaceVim#layers#lang#rescript#plugins()
  call SpaceVim#layers#lang#rescript#config()
  return 1
endfunction
