function! airline#extensions#tabline#formatters#spacevim#format(bufnr, buffers)
    let id = SpaceVim#api#messletters#get().bubble_num(a:bufnr, 0)
    return fnamemodify(bufname(a:bufnr), id . ':t')
endfunction
