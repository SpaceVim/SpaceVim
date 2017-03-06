" @vimlint(EVL103, 1, a:buffers)
function! airline#extensions#tabline#formatters#spacevim#format(bufnr, buffers) abort
  let id = SpaceVim#api#messletters#get().bubble_num(a:bufnr, g:spacevim_buffer_index_type) . ' '
  let fn = fnamemodify(bufname(a:bufnr), ':t')
  if g:spacevim_enable_tabline_filetype_icon
    let icon = SpaceVim#api#import('file').fticon(fn)
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
