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

scriptencoding utf-8
let s:messletters = SpaceVim#api#import('messletters')
let s:file = SpaceVim#api#import('file')
let s:BUFFER = SpaceVim#api#import('vim#buffer')

let g:_spacevim_tabline_loaded = 1
let s:buffers = s:BUFFER.listed_buffers()

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
    let nr = tabpagenr('$')
    let t = ''
    if nr > 1
        let ct = tabpagenr()
        if ct == 1
            let t = '%#SpaceVim_tabline_a#  '
        else
            let t = '%#SpaceVim_tabline_b#  '
        endif
        for i in range(1, nr)
            if i == ct
                let t .= '%#SpaceVim_tabline_a#'
            endif
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let name = fnamemodify(bufname(buflist[winnr - 1]), ':t')
            let id = s:messletters.bubble_num(i, g:spacevim_buffer_index_type)
            let icon = s:file.fticon(name)
            if !empty(icon)
                let name = icon . ' ' . name
            endif
            let t .= id . ' ' . name
            if i == ct - 1
                let t .= ' %#SpaceVim_tabline_b_a# '
            elseif i == ct
                let t .= ' %#SpaceVim_tabline_a_b# '
            else
                let t .= '  '
            endif
        endfor
        let t .= '%=%#SpaceVim_tabline_a_b#'
        let t .= '%#SpaceVim_tabline_a# Tabs'
    else
        let s:buffers = s:BUFFER.listed_buffers()
        if len(s:buffers) == 0
            return ''
        endif
        let ct = bufnr('%')
        let pt = index(s:buffers, ct) > 0 ? s:buffers[index(s:buffers, ct) - 1] : -1
        if ct == get(s:buffers, 0, -1)
            let t = '%#SpaceVim_tabline_a#  '
        else
            let t = '%#SpaceVim_tabline_b#  '
        endif
        for i in s:buffers
            if i == ct
                let t .= '%#SpaceVim_tabline_a#'
            endif
            let name = fnamemodify(bufname(i), ':t')
            let id = s:messletters.bubble_num(index(s:buffers, i) + 1, g:spacevim_buffer_index_type)
            let icon = s:file.fticon(name)
            if !empty(icon)
                let name = icon . ' ' . name
            endif
            let t .= id . ' ' . name
            if i == ct
                let t .= ' %#SpaceVim_tabline_a_b# '
            elseif i == pt
                let t .= ' %#SpaceVim_tabline_b_a# '
            else
                let t .= '  '
            endif
        endfor
        let t .= '%=%#SpaceVim_tabline_a_b#'
        let t .= '%#SpaceVim_tabline_a# Buffers'
    endif
    return t
endfunction
function! SpaceVim#layers#core#tabline#config() abort
    set tabline=%!SpaceVim#layers#core#tabline#get()
    for i in range(1, 9)
        exe "call SpaceVim#mapping#space#def('nnoremap', [" . i . "], 'call SpaceVim#layers#core#tabline#jump(" . i . ")', 'window " . i . "', 1)"
    endfor
    call SpaceVim#mapping#space#def('nmap', ['-'], 'bprevious', 'window previous', 1)
    call SpaceVim#mapping#space#def('nmap', ['+'], 'bnext', 'window next', 1)
endfunction

function! SpaceVim#layers#core#tabline#jump(id) abort
    if len(s:buffers) >= a:id
        let bid = s:buffers[a:id - 1]
        exe 'b' . bid
    endif
endfunction

function! SpaceVim#layers#core#tabline#def_colors() abort
    hi! SpaceVim_tabline_a ctermbg=003 ctermfg=Black guibg=#a89984 guifg=#282828
    hi! SpaceVim_tabline_b ctermbg=003 ctermfg=Black guibg=#504945 guifg=#a89984
    hi! SpaceVim_tabline_a_b ctermbg=003 ctermfg=Black guibg=#504945 guifg=#a89984
    hi! SpaceVim_tabline_b_a ctermbg=003 ctermfg=Black guibg=#a89984 guifg=#504945
endfunction
