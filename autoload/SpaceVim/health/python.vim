"=============================================================================
" python.vim --- SpaceVim python checker
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:SYSTEM = SpaceVim#api#import('system')

function! SpaceVim#health#python#check() abort
  let result = ['SpaceVim python support check report:']
  if has('nvim')
    call add(result, 'Checking +python3:')
    if has('python3')
      call add(result, '      SUCCEED!')
    else
      call add(result, '      Failed : to support +python3, you need run `pip3 install neovim`')
    endif
    call add(result, 'Checking +python:')
    if has('python')
      call add(result, '      SUCCEED!')
    else
      call add(result, '      Failed : to support +python, you need run `pip2 install neovim`')
    endif
  else
    call add(result, 'Checking +python3:')
    if has('python3')
      call add(result, '      SUCCEED!')
    else
      if !s:SYSTEM.isWindows
        call add(result, '      Failed : to support +python3, Please install vim-gtk, or build from sources.')
      else
        call add(result, '      Failed : to support +python3, install vim from https://github.com/vim/vim-win32-installer/releases')
        call add(result, '                                    install python3, make sure you have `python` in your path.')
      endif
    endif
    call add(result, 'Checking +python:')
    if has('python')
      call add(result, '      SUCCEED!')
    else
      if !s:SYSTEM.isWindows
        call add(result, '      Failed : to support +python, Please install vim-gtk, or build from sources.')
      else
        call add(result, '      Failed : to support +python3, install vim from https://github.com/vim/vim-win32-installer/releases')
        call add(result, '                                    install python3, make sure you have `python` in your path.')
      endif
    endif
  endif
  return result
endfunction

" vim:set et sw=2:
