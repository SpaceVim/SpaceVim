"=============================================================================
" clipboard.vim --- SpaceVim clipboard checker
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#health#clipboard#check() abort
  let result = ['SpaceVim clipboard support check report:']
  call add(result, 'Checking +clipboard:')
  if has('nvim')
    if has('clipboard')
      call add(result, '      SUCCEED!')
    else
      call add(result, '      Failed : to support +clipboard, you need has one of following clipboard tools in your $PATH:')
      call add(result, '               1. xclip')
      call add(result, '               2. xsel')
      call add(result, '               3. pbcopy/pbpaste (Mac OS X)')
      call add(result, '               4. lemonade (for SSH) https://github.com/pocke/lemonade')
      call add(result, '               5. doitclient (for SSH) http://www.chiark.greenend.org.uk/~sgtatham/doit/')
    endif
  else
    if has('clipboard')
      call add(result, '      SUCCEED!')
    else
      call add(result, '      Failed : to support +clipboard, you need recompile your vim with +clipboard support.')
    endif
  endif

  return result
endfunction

" vim:set et sw=2:
