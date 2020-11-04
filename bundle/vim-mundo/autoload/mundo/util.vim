" ============================================================================
" File:        util.vim
" Description: Defines utility functions and default option values for Mundo.
" Maintainer:  Hyeon Kim <simnalamburt@gmail.com>
" License:     GPLv2+
" ============================================================================

let s:save_cpo = &cpo
set cpo&vim

if exists('g:Mundo_PluginLoaded')
    let &cpo = s:save_cpo
    finish
endif

" Utility functions{{{

" Moves to the first window in the current tab corresponding to expr. Accepts
" an integer buffer number or a string file-pattern; for a detailed description
" see :h bufname. Returns 1 if successful, 0 otherwise.
function! mundo#util#GoToBuffer(expr)"{{{
    let l:winnr = bufwinnr(bufnr(a:expr))

    if l:winnr == -1
        return 0
    elseif l:winnr != winnr()
        exe l:winnr . "wincmd w"
    endif

    return 1
endfunction"}}}

" Similar to MundoGoToBuffer, but considers windows in all tabs.
" Prioritises matches in the current tab.
function! mundo#util#GoToBufferGlobal(expr)"{{{
    if mundo#util#GoToBuffer(a:expr)
        return 1
    endif

    let l:bufWinIDs = win_findbuf(bufnr(a:expr))

    if len(l:bufWinIDs) <= 0
        return 0
    endif

    call win_gotoid(l:bufWinIDs[0])
    return 1
endfunction"}}}

" Prints a highlighted string.
function! mundo#util#Echo(higroup, text)"{{{
    execute 'echohl ' . a:higroup
    execute 'unsilent echomsg ' . '"' . escape(a:text, '"') . '"'
    echohl None
endfunction"}}}

" Set var to val only if var has not been set by the user. Optionally takes a
" deprecated option name and shows a warning if a variable with this name exists.
function! mundo#util#set_default(var, val, ...)"{{{
    if !exists(a:var)
        let {a:var} = a:val
        return 1
    endif

    let old_var = get(a:000, 0, '')

    if exists(old_var)
        call mundo#util#Echo(
                    \ 'WarningMsg',
                    \ "{".old_var."}is deprecated! "
                    \ ."Please change your setting to {"
                    \ .split(old_var,':')[0]
                    \ .':'
                    \ .substitute(split(old_var,':')[1],'gundo_','mundo_','g')
                    \ .'}'
        )
    endif

    return 0
endfunction
"}}}

"}}}

" Placeholder functions for deprecated Gundo commands{{{

function! mundo#util#Toggle()
    return mundo#util#Echo('WarningMsg', 'GundoToggle commands are '
                \ . 'deprecated. Please change to their corresponding '
                \ . 'MundoToggle command.')
endf

function! mundo#util#Show()
    return mundo#util#Echo('WarningMsg', 'GundoToggle commands are '
                \ . 'deprecated. Please change to their corresponding '
                \ . 'MundoShow command.')
endf

function! mundo#util#Hide()
    return mundo#util#Echo('WarningMsg', 'GundoToggle commands are '
                \ . 'deprecated. Please change to their corresponding '
                \ . 'MundoHide command.')
endf

function! mundo#util#RenderGraph()
    return mundo#util#Echo('WarningMsg', 'GundoToggle commands are '
                \ . 'deprecated. Please change to their corresponding '
                \ . 'MundoRenderGraph command.')
endf

"}}}

let g:Mundo_PluginLoaded = 1

let &cpo = s:save_cpo
unlet s:save_cpo
