"=============================================================================
" environment.vim --- SpaceVim environment checker
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
function! SpaceVim#health#environment#check() abort
  let result = ['SpaceVim environment check report:']
  " FIXME: old vim does not provide v:progpath, we need a compatible function
  " for getting the progpath of current vim.
  call add(result, 'Current progpath: ' . v:progname . '(' . get(v:, 'progpath', '') . ')')
  call add(result, 'version: ' . v:version)
  call add(result, 'OS: ' . SpaceVim#api#import('system').name)
  call add(result, '[shell, shellcmdflag, shellslash]: ' . string([&shell, &shellcmdflag, &shellslash]))
  return result
endfunction

" vim:set et sw=2:
