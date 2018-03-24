"=============================================================================
" init.vim --- Language && encoding in SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8
" Enable nocompatible
if has('vim_starting')
  if &compatible
    set nocompatible
  endif
endif

let s:SYSTEM = SpaceVim#api#import('system')

" Fsep && Psep
if has('win16') || has('win32') || has('win64')
  let s:Psep = ';'
  let s:Fsep = '\'
else
  let s:Psep = ':'
  let s:Fsep = '/'
endif
"Use English for anything in vim
try
  if s:SYSTEM.isWindows
    silent exec 'lan mes en_US.UTF-8'
  elseif s:SYSTEM.isOSX
    silent exec 'language en_US'
  else
    let s:uname = system('uname -s')
    if s:uname ==# "Darwin\n"
      " in mac-terminal
      silent exec 'language en_US'
    elseif s:uname ==# "SunOS\n"
      " in Sun-OS terminal
      silent exec 'lan en_US.UTF-8'
    elseif s:uname ==# "FreeBSD\n"
      " in FreeBSD terminal
      silent exec 'lan en_US.UTF-8'
    else
      " in linux-terminal
      silent exec 'lan en_US.utf8'
    endif
  endif
catch /^Vim\%((\a\+)\)\=:E197/
  call SpaceVim#logger#error('Can not set language to en_US.utf8')
endtry

" try to set encoding to utf-8
if s:SYSTEM.isWindows
  " Be nice and check for multi_byte even if the config requires
  " multi_byte support most of the time
  if has('multi_byte')
    " Windows cmd.exe still uses cp850. If Windows ever moved to
    " Powershell as the primary terminal, this would be utf-8
    set termencoding=cp850
    " Let Vim use utf-8 internally, because many scripts require this
    set encoding=utf-8
    setglobal fileencoding=utf-8
    " Windows has traditionally used cp1252, so it's probably wise to
    " fallback into cp1252 instead of eg. iso-8859-15.
    " Newer Windows files might contain utf-8 or utf-16 LE so we might
    " want to try them first.
    set fileencodings=ucs-bom,utf-8,gbk,utf-16le,cp1252,iso-8859-15
  endif

else
  " set default encoding to utf-8
  set termencoding=utf-8
  set fileencoding=utf-8
  set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
endif
