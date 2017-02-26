function! airline#extensions#tabline#formatters#spacevim#format(bufnr, buffers) abort
    let id = SpaceVim#api#messletters#get().bubble_num(a:bufnr, g:spacevim_buffer_index_type) . ' '
    let fn = fnamemodify(bufname(a:bufnr), ':t')
    if empty(fn)
        return 'No Name'
    elseif !g:airline#extensions#tabline#buffer_idx_mode
        return id . fn
    else
        return fn
    endif
endfunction
