"=============================================================================
" spacevim.vim --- buffer name formatter for airline
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" @vimlint(EVL103, 1, a:buffers)
function! airline#extensions#tabline#formatters#spacevim#format(bufnr, buffers) abort
  let g:_spacevim_list_buffers = a:buffers
  " unique_tail_improved
  let id = SpaceVim#api#messletters#get().bubble_num(a:bufnr, g:spacevim_buffer_index_type) . ' '
  let fn = airline#extensions#tabline#formatters#unique_tail_improved#format(a:bufnr, a:buffers)
  if g:spacevim_enable_tabline_ft_icon || get(g:, 'spacevim_enable_tabline_filetype_icon', 0)
    let icon = SpaceVim#api#import('file').fticon(bufname(a:bufnr))
    if !empty(icon)
      let fn = icon . ' ' . fn
    endif
  endif
  if empty(fn)
    return 'No Name'
  elseif !g:airline#extensions#tabline#buffer_idx_mode
    return id . fn
  else
    return fn
  endif
endfunction
" @vimlint(EVL103, 0, a:buffers)


" vim:set et sw=2:
