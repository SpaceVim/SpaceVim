"=============================================================================
" tabline.vim --- core#tabline Layer file for SpaceVim
" Copyright (c) 2012-2016 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

""
" @section core#tabline, layer-core-tabline
" @parentsection layers
" This layer provides default tabline for SpaceVim

let s:messletters = SpaceVim#api#import('messletters')
let s:file = SpaceVim#api#import('file')


function! s:tabname(id) abort
    let id = s:messletters.bubble_num(a:id, g:spacevim_buffer_index_type) . ' '
    let fn = fnamemodify(bufname(a:id), ':t')
    if g:spacevim_enable_tabline_filetype_icon
        let icon = s:file.fticon(fn)
        if !empty(icon)
            let fn = icon . ' ' . fn
        endif
    endif
    if empty(fn)
        return 'No Name'
    else
        return id . fn
    endif
endfunction

function! SpaceVim#layers#core#tabline#get() abort
    let t = '  '
    let nr = tabpagenr()
    " if nr > 1
    for i in range(1, nr)
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let name = fnamemodify(bufname(buflist[winnr - 1]), ':t')
        let id = s:messletters.bubble_num(i, g:spacevim_buffer_index_type)
        let icon = s:file.fticon(name)
        if !empty(icon)
            let name = icon . ' ' . name
        endif
        let t .= id . ' ' . name
        if i == nr
            let t .= '%#TabLineSel#'
        else
            let t .= '%#TabLine# | '
        endif
    endfor
    let t .= '%#TabLineFill#%T'
    return t
endfunction
function! SpaceVim#layers#core#tabline#config() abort
    set tabline=%!SpaceVim#layers#core#tabline#get()
endfunction
