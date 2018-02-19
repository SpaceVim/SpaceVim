"=============================================================================
" core.vim --- SpaceVim core layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#core#plugins() abort
  return [
        \ ['Shougo/vimproc.vim', {'build' : ['make']}],
        \ ['benizi/vim-automkdir'],
        \ ]
endfunction

let s:filename = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#core#config() abort
  let g:vimproc#download_windows_dll = 1
  call SpaceVim#mapping#space#def('nnoremap', ['p', 't'], 'call SpaceVim#plugins#projectmanager#current_root()', 'find-project-root', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'k'], 'call SpaceVim#plugins#projectmanager#kill_project()', 'kill all project buffers', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'p'], 'call SpaceVim#plugins#projectmanager#list()', 'List all projects', 1)
  let lnum = expand('<slnum>') + s:lnum - 1
  if has('python3')
    let cmd =  'Denite file_rec'
  elseif has('python')
    let cmd =  "LeaderfFile"
  else
    let cmd =  "CtrlP"
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['p', 'f'],
        \ cmd,
        \ ['find files in current project',
        \ [
        \ '[SPC p f] is to find files in the root of the current project',
        \ 'vim with +python3 support will use denite',
        \ 'vim with +python support will use leaderf',
        \ 'otherwise will use ctrlp',
        \ '',
        \ 'Definition: ' . s:filename . ':' . lnum,
        \ ]
        \ ]
        \ , 1)
  call SpaceVim#mapping#space#def('nnoremap', ['p', '/'], 'Grepper', 'fuzzy search for text in current project', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['q', 'q'], 'qa', 'prompt-kill-vim', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['q', 'Q'], 'qa!', 'kill-vim', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['q', 'R'], '', 'restart-vim(TODO)', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['q', 'r'], '', 'restart-vim-resume-layouts(TODO)', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['q', 't'], 'tabclose!', 'kill current tab', 1)
  call SpaceVim#mapping#gd#add('HelpDescribe', function('s:gotodef'))
  
endfunction

function! s:gotodef() abort
  let fname = get(b:, 'defind_file_name', '')
  if !empty(fname)
    close
    exe 'edit ' . fname[0]
    exe fname[1]
  endif
endfunction
