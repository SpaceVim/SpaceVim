let g:spacevim_statusline_mode_format = {
            \ 'n' : 'NORMAL',
            \ 'i' : 'INSERT',
            \ 'v' : 'VISUAL', 
            \ }

"""""""""""""""""""""""""""""""""

function! s:mode() abort
    let mt = g:spacevim_statusline_mode_format
    let m = mode()
    return mt[m]
endfunction

function! s:filetype() abort
    return &filetype
endfunction

function! s:encoding() abort
    return &encoding
endfunction


function! s:tabname() abort
    return '1'
endfunction

function! SpaceVim#layers#core#statusline#get() abort
    return join([
                \ s:mode(),
                \ s:tabname(),
                \ s:encoding(),
                \ s:filetype()
                \ ], ' ')
endfunction

function! s:refresh() abort
endfunction
set statusline=%!SpaceVim#layers#core#statusline#get()

