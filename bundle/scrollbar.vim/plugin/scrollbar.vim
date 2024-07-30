"=============================================================================
" scrollbar.vim --- scrollbar plugin for vim and neovim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! s:clear_previous_scrollbar() abort
  let bufnr = bufnr('#')
  call SpaceVim#plugins#scrollbar#clear(bufnr)
endfunction
augroup spacevim_scrollbar
  autocmd!
  let events = join(filter( ['BufEnter','WinEnter', 'QuitPre', 'CursorMoved', 'VimResized', 'FocusGained', 'WinScrolled' ], 'exists("##" . v:val)'), ',')
  if SpaceVim#plugins#scrollbar#usable()
    exe printf('autocmd %s * call SpaceVim#plugins#scrollbar#show()',
          \ events)
    autocmd WinLeave,BufLeave,BufWinLeave,FocusLost
          \ * call SpaceVim#plugins#scrollbar#clear()
    " why this autocmd is needed?
    "
    " because the startify use noautocmd enew
    autocmd User Startified call s:clear_previous_scrollbar()
  endif
augroup end
