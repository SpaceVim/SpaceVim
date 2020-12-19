scriptencoding utf-8
" fcitx.vim	remember fcitx's input state for each buffer
" Author:       lilydjwg
" Version:	1.2.6
" URL:		https://www.vim.org/scripts/script.php?script_id=3764
" ---------------------------------------------------------------------
" Load Once:
if &cp || exists("g:loaded_fcitx") || (
      \ (!exists('$DISPLAY') || exists('$SSH_TTY') || has('gui_macvim'))
      \ && !exists('$FCITX_SOCKET'))
  finish
endif
if executable('fcitx5-remote')
  " currently python version does not support fcitx5
  let g:fcitx_remote = 'fcitx5-remote'
  runtime so/fcitx.vim
  finish
else
  let g:fcitx_remote = 'fcitx-remote'
endif
if has("python3")
  let python3 = 1
elseif has("python")
  let python3 = 0
else
  runtime so/fcitx.vim
  finish
endif
let s:keepcpo = &cpo
set cpo&vim
" this is quicker than expand()
if exists('$FCITX_SOCKET')
  let s:fcitxsocketfile = $FCITX_SOCKET
else
  let s:fcitxsocketfile = '/tmp/fcitx-socket-' . $DISPLAY
  if !filewritable(s:fcitxsocketfile) "try again
    if strridx(s:fcitxsocketfile, '.') > 0
      let s:fcitxsocketfile = strpart(s:fcitxsocketfile, 0,
            \ strridx(s:fcitxsocketfile, '.'))
    else
      let s:fcitxsocketfile = s:fcitxsocketfile . '.0'
      if !filewritable(s:fcitxsocketfile)
        echohl WarningMsg
        echomsg "socket file of fcitx not found, fcitx.vim not loaded."
        echohl None
        finish
      endif
    endif
  endif
endif
let g:loaded_fcitx = 1
let pyfile = expand('<sfile>:r') . '.py'
if python3
  exe 'py3file' pyfile
  au InsertLeave * py3 fcitx2en()
  au InsertEnter * py3 fcitx2zh()
else
  exe 'pyfile' pyfile
  au InsertLeave * py fcitx2en()
  au InsertEnter * py fcitx2zh()
endif
" ---------------------------------------------------------------------
"  Restoration And Modelines:
unlet python3
unlet pyfile
let &cpo=s:keepcpo
unlet s:keepcpo
