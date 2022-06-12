"=============================================================================
" clipboard.vim --- clipboard for neovim and vim8
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" This script is based on kamilkrz (Kamil Krześ)'s idea about using clipboard.
function! s:set_command() abort
  let yank = ''
  let paste = ''

  " the logic is based on nvim's clipboard provider

  " in vim8, system() do not support list argv

  if has('mac')
    let yank = 'pbcopy'
    let paste = 'pbpaste'
  elseif !empty($WAYLAND_DISPLAY) && executable('wl-copy') && executable('wl-paste')
    let yank = 'wl-copy --foreground --type text/plain'
    let paste = 'wl-paste --no-newline'
  elseif !empty($DISPLAY) && executable('xclip')
    let yank = 'xclip -quiet -i -selection clipboard'
    let paste = 'xclip -o -selection clipboard'
  elseif !empty($DISPLAY) && executable('xsel')
    let yank = 'xsel --nodetach -i -b'
    let paste = 'xsel -o -b'
  elseif executable('lemonade')
    let yank = 'lemonade copy'
    let paste = 'lemonade paste'
  elseif executable('doitclient')
    let yank = 'doitclient wclip'
    let paste = 'doitclient wclip -r'
  elseif executable('win32yank.exe')
    if has('wsl') && getftype(exepath('win32yank.exe')) == 'link'
      let win32yank = resolve(exepath('win32yank.exe'))
    else
      let win32yank = 'win32yank.exe'
    endif
    let yank = shellescape(win32yank) . ' -i --crlf'
    let paste = shellescape(win32yank) .  ' -o --lf'
  elseif executable('termux-clipboard-set')
    let yank = 'termux-clipboard-set'
    let paste = 'termux-clipboard-get'
  elseif !empty($TMUX) && executable('tmux')
    let yank = 'tmux load-buffer -'
    let paste = 'tmux save-buffer -'
  endif
  return [yank, paste]
endfunction

" yank to system clipboard
function! clipboard#yank() abort
  if !empty(s:yank_cmd)
    call system(s:yank_cmd, s:get_selection_text())
  else
    if has('clipboard')
      let @+ = s:get_selection_text()
    else
    endif
  endif
endfunction


" The mode can be `p` or `P`

function! clipboard#paste(mode) abort
  if !empty(s:paste_cmd)
    let @" = system(s:paste_cmd)
  else
    if has('clipboard')
      let @" = @+
    else
    endif
  endif
  return a:mode
endfunction


function! s:get_selection_text()
  let [begin, end] = [getpos("'<"), getpos("'>")]
  let lastchar = matchstr(getline(end[1])[end[2]-1 :], '.')
  if begin[1] ==# end[1]
    let lines = [getline(begin[1])[begin[2]-1 : end[2]-2]]
  else
    let lines = [getline(begin[1])[begin[2]-1 :]]
          \         + (end[1] - begin[1] <# 2 ? [] : getline(begin[1]+1, end[1]-1))
          \         + [getline(end[1])[: end[2]-2]]
  endif
  return join(lines, "\n") . lastchar . (visualmode() ==# 'V' ? "\n" : '')
endfunction

let [s:yank_cmd, s:paste_cmd] = s:set_command()
