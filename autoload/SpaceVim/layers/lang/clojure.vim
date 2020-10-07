"=============================================================================
" clojure.vim --- SpaceVim lang#clojure layer
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#clojure, layer-lang-clojure
" @parentsection layers
" This layer provides syntax highlighting for clojure. To enable this
" layer:
" >
"   [layers]
"     name = "lang#clojure"
" <

function! SpaceVim#layers#lang#clojure#plugins() abort
  let plugins = []
  " if has('nvim')
  " call add(plugins, ['clojure-vim/acid.nvim', {'merged' : 0}])
  " call add(plugins, ['clojure-vim/async-clj-highlight', {'merged' : 0}])
  call add(plugins, ['clojure-vim/async-clj-omni', {'merged' : 0}])
  " else
  " for vim, use guns's clojure plugin guide
  call add(plugins, ['guns/vim-clojure-static', {'merged' : 0}])
  call add(plugins, ['guns/vim-clojure-highlight', {'merged' : 0}])
  " endif
  if !g:spacevim_enable_neomake && !g:spacevim_enable_ale
    call add(plugins, ['venantius/vim-eastwood', {'merged' : 0}])
  endif
  call add(plugins, ['tpope/vim-fireplace', {'merged' : 0}])
  call add(plugins, ['venantius/vim-cljfmt', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#clojure#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('clojure', function('s:language_specified_mappings'))
  " in Window, if install clojure via scoop install clojure, the command is
  " cmd-clj
  let clojure = get(filter(['cmd-clj'], 'executable(v:val)'), 0, 'clojure')
  call SpaceVim#plugins#runner#reg_runner('clojure', clojure . ' -M %s')
  call SpaceVim#plugins#repl#reg('clojure', 'cmd-clj')
  call SpaceVim#plugins#tasks#reg_provider(funcref('s:lein_tasks'))
  call add(g:spacevim_project_rooter_patterns, 'project.clj')
endfunction

" Add language specific mappings
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("clojure")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
endfunction

function! s:lein_tasks() abort
  let detect_task = {}
  if filereadable('project.clj')
    for task_name in ['run', 'test']
      call extend(detect_task, {
            \ task_name : {'command' : 'lein', 'args' : [task_name], 'isDetected' : 1, 'detectedName' : 'lein:'}
            \ })
    endfor
  endif
  return detect_task
endfunction
