"=============================================================================
" reason.vim --- Reason programming language layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


if exists('s:JSON')
  finish
endif

let s:JSON = SpaceVim#api#import('data#json')

function! SpaceVim#layers#lang#reason#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-reason', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#reason#config() abort
  call SpaceVim#plugins#tasks#reg_provider(funcref('s:reasonml_tasks'))
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
