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
let s:HI = SpaceVim#api#import('vim#highlight')

let g:_spacevim_tabline_loaded = 1
let s:buffers = s:BUFFER.listed_buffers()

function! s:tabname(id) abort
    if g:spacevim_buffer_index_type == 3
        let id = s:messletters.index_num(a:id)
    elseif g:spacevim_buffer_index_type == 4
        let id = a:id
    else
        let id = s:messletters.bubble_num(a:id, g:spacevim_buffer_index_type) . ' '
    endif
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
            if empty(name)
                let name = 'No Name'
            endif
            if g:spacevim_buffer_index_type == 3
                let id = s:messletters.index_num(i)
            elseif g:spacevim_buffer_index_type == 4
                let id = i
            else
                let id = s:messletters.circled_num(i, g:spacevim_buffer_index_type)
            endif
            if g:spacevim_enable_tabline_filetype_icon
                let icon = s:file.fticon(name)
                if !empty(icon)
                    let name = icon . ' ' . name
                endif
            endif
            let t .= id . ' ' . name
            if i == ct - 1
                let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_a# '
            elseif i == ct
                let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b# '
            else
                let t .= '  '
            endif
        endfor
        let t .= '%=%#SpaceVim_tabline_a_SpaceVim_tabline_b#'
        let t .= '%#SpaceVim_tabline_a# Tabs'
    else
        let s:buffers = s:BUFFER.listed_buffers()
        let g:_spacevim_list_buffers = s:buffers
        if len(s:buffers) == 0
            return ''
        endif
        let ct = bufnr('%')
        let pt = index(s:buffers, ct) > 0 ? s:buffers[index(s:buffers, ct) - 1] : -1
        if ct == get(s:buffers, 0, -1)
            let t = '%#SpaceVim_tabline_a# '
        else
            let t = '%#SpaceVim_tabline_b# '
        endif
        for i in s:buffers
            if i == ct
                let t .= '%#SpaceVim_tabline_a#'
            endif
            let name = fnamemodify(bufname(i), ':t')
            if empty(name)
                let name = 'No Name'
            endif
            if g:spacevim_buffer_index_type == 3
                let id = s:messletters.index_num(index(s:buffers, i) + 1)
            elseif g:spacevim_buffer_index_type == 4
                let id = index(s:buffers, i) + 1
            else
                let id = s:messletters.circled_num(index(s:buffers, i) + 1, g:spacevim_buffer_index_type)
            endif
            if g:spacevim_enable_tabline_filetype_icon
                let icon = s:file.fticon(name)
                if !empty(icon)
                    let name = icon . ' ' . name
                endif
            endif
            let t .= id . ' ' . name
            if i == ct
                let t .= ' %#SpaceVim_tabline_a_SpaceVim_tabline_b# '
            elseif i == pt
                let t .= ' %#SpaceVim_tabline_b_SpaceVim_tabline_a# '
            else
                let t .= '  '
            endif
        endfor
        let t .= '%=%#SpaceVim_tabline_a_SpaceVim_tabline_b#'
        let t .= '%#SpaceVim_tabline_a# Buffers'
    endif
    return t
endfunction
function! SpaceVim#layers#core#tabline#config() abort
    set tabline=%!SpaceVim#layers#core#tabline#get()
    augroup SpaceVim_tabline
        autocmd!
        autocmd ColorScheme * call SpaceVim#layers#core#tabline#def_colors()
    augroup END
    for i in range(1, 9)
        exe "call SpaceVim#mapping#def('nmap <silent>', '<leader>" . i
                    \ . "', ':call SpaceVim#layers#core#tabline#jump("
                    \ . i . ")<cr>', 'Switch to airline tab " . i
                    \ . "', '', 'tabline index " . i . "')"
    endfor
    call SpaceVim#mapping#def('nmap', '<leader>-', ':bprevious<cr>', 'Switch to previous airline tag', '', 'window previous')
    call SpaceVim#mapping#def('nmap', '<leader>+', ':bnext<cr>', 'Switch to next airline tag', '', 'window next')
    "call SpaceVim#mapping#space#def('nmap', ['-'], 'bprevious', 'window previous', 1)
    "call SpaceVim#mapping#space#def('nmap', ['+'], 'bnext', 'window next', 1)
endfunction

function! SpaceVim#layers#core#tabline#jump(id) abort
    if len(s:buffers) >= a:id
        let bid = s:buffers[a:id - 1]
        exe 'b' . bid
    endif
endfunction

function! SpaceVim#layers#core#tabline#def_colors() abort
    let name = get(g:, 'colors_name', 'gruvbox')
    try
        let t = SpaceVim#mapping#guide#theme#{name}#palette()
    catch /^Vim\%((\a\+)\)\=:E117/
        let t = SpaceVim#mapping#guide#theme#gruvbox#palette()
    endtry
    exe 'hi! SpaceVim_tabline_a ctermbg=' . t[0][2] . ' ctermfg=' . t[0][3] . ' guibg=' . t[0][1] . ' guifg=' . t[0][0]
    exe 'hi! SpaceVim_tabline_b ctermbg=' . t[1][2] . ' ctermfg=' . t[1][3] . ' guibg=' . t[1][1] . ' guifg=' . t[1][0]
    call s:HI.hi_separator('SpaceVim_tabline_a', 'SpaceVim_tabline_b')
endfunction
