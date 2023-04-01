" ============================================================================
" File:        tagbar.vim
" Description: List the current file's tags in a sidebar, ordered by class etc
" Author:      Jan Larres <jan@majutsushi.net>
" Licence:     Vim licence
" Website:     https://preservim.github.io/tagbar
" Version:     3.1.1
" Note:        This plugin was heavily inspired by the 'Taglist' plugin by
"              Yegappan Lakshmanan and uses a small amount of code from it.
"
" Original taglist copyright notice:
"              Permission is hereby granted to use and distribute this code,
"              with or without modifications, provided that this copyright
"              notice is copied with it. Like anything else that's free,
"              taglist.vim is provided *as is* and comes with no warranty of
"              any kind, either expressed or implied. In no event will the
"              copyright holder be liable for any damamges resulting from the
"              use of this software.
" ============================================================================

scriptencoding utf-8

if &compatible || exists('g:loaded_tagbar')
    finish
endif

" Basic init {{{1

if v:version < 700
    echohl WarningMsg
    echomsg 'Tagbar: Vim version is too old, Tagbar requires at least 7.0'
    echohl None
    finish
endif

if v:version == 700 && !has('patch167')
    echohl WarningMsg
    echomsg 'Tagbar: Vim versions lower than 7.0.167 have a bug'
          \ 'that prevents this version of Tagbar from working.'
          \ 'Please use the alternate version posted on the website.'
    echohl None
    finish
endif

function! s:init_var(var, value) abort
    if !exists('g:tagbar_' . a:var)
        execute 'let g:tagbar_' . a:var . ' = ' . string(a:value)
    endif
endfunction

function! s:setup_options() abort
    if exists('g:tagbar_position')
        " Map older deprecated values to correct values
        if g:tagbar_position ==# 'top'
            let g:tagbar_position = 'leftabove'
        elseif g:tagbar_position ==# 'bottom'
            let g:tagbar_position = 'rightbelow'
        elseif g:tagbar_position ==# 'left'
            let g:tagbar_position = 'topleft vertical'
        elseif g:tagbar_position ==# 'right'
            let g:tagbar_position = 'botright vertical'
        endif
        if g:tagbar_position !~# 'vertical'
            let previewwin_pos = 'rightbelow vertical'
        else
            let previewwin_pos = 'topleft'
        endif
        let default_pos = g:tagbar_position
    else
        if exists('g:tagbar_vertical') && g:tagbar_vertical > 0
            let previewwin_pos = 'rightbelow vertical'
            if exists('g:tagbar_left') && g:tagbar_left
                let default_pos = 'leftabove'
            else
                let default_pos = 'rightbelow'
            endif
            let g:tagbar_height = g:tagbar_vertical
        elseif exists('g:tagbar_left') && g:tagbar_left
            let previewwin_pos = 'topleft'
            let default_pos = 'topleft vertical'
        else
            let previewwin_pos = 'topleft'
            let default_pos = 'botright vertical'
        endif
    endif
    let options = [
        \ ['autoclose', 0],
        \ ['autoclose_netrw', 0],
        \ ['autofocus', 0],
        \ ['autopreview', 0],
        \ ['autoshowtag', 0],
        \ ['case_insensitive', 0],
        \ ['compact', 0],
        \ ['expand', 0],
        \ ['file_size_limit', 0],
        \ ['foldlevel', 99],
        \ ['hide_nonpublic', 0],
        \ ['height', 10],
        \ ['indent', 2],
        \ ['jump_offset', 0],
        \ ['jump_lazy_scroll', 0],
        \ ['left', 0],
        \ ['help_visibility', 0],
        \ ['highlight_follow_insert', 0],
        \ ['highlight_method', 'nearest-stl'],
        \ ['ignore_anonymous', 0],
        \ ['no_autocmds', 0],
        \ ['position', default_pos],
        \ ['previewwin_pos', previewwin_pos],
        \ ['scopestrs', {}],
        \ ['scrolloff', 0],
        \ ['show_balloon', 1],
        \ ['show_data_type', 0],
        \ ['show_visibility', 1],
        \ ['show_linenumbers', 0],
        \ ['show_tag_count', 0],
        \ ['show_tag_linenumbers', 0],
        \ ['singleclick', 0],
        \ ['sort', 1],
        \ ['systemenc', &encoding],
        \ ['vertical', 0],
        \ ['width', 40],
        \ ['zoomwidth', 1],
        \ ['silent', 0],
        \ ['use_cache', 1],
        \ ['wrap', 0],
    \ ]

    for [opt, val] in options
        call s:init_var(opt, val)
        unlet val
    endfor
endfunction
call s:setup_options()

if !exists('g:tagbar_iconchars')
    if has('multi_byte') && has('unix') && &encoding ==# 'utf-8' &&
     \ (!exists('+termencoding') || empty(&termencoding) || &termencoding ==# 'utf-8')
        let g:tagbar_iconchars = ['▸', '▾']
    else
        let g:tagbar_iconchars = ['+', '-']
    endif
endif

function! s:setup_keymaps() abort
    let keymaps = [
        \ ['jump',          '<CR>'],
        \ ['preview',       'p'],
        \ ['previewwin',    'P'],
        \ ['nexttag',       '<C-N>'],
        \ ['prevtag',       '<C-P>'],
        \ ['showproto',     '<Space>'],
        \ ['hidenonpublic', 'v'],
        \
        \ ['openfold',      ['+', '<kPlus>', 'zo']],
        \ ['closefold',     ['-', '<kMinus>', 'zc']],
        \ ['togglefold',    ['o', 'za']],
        \ ['openallfolds',  ['*', '<kMultiply>', 'zR']],
        \ ['closeallfolds', ['=', 'zM']],
        \ ['incrementfolds',  ['zr']],
        \ ['decrementfolds',  ['zm']],
        \ ['nextfold',      'zj'],
        \ ['prevfold',      'zk'],
        \
        \ ['togglesort',            's'],
        \ ['togglecaseinsensitive', 'i'],
        \ ['toggleautoclose',       'c'],
        \ ['togglepause',           't'],
        \ ['zoomwin',               'x'],
        \ ['close',                 'q'],
        \ ['help',                  ['<F1>', '?']],
    \ ]

    for [map, key] in keymaps
        call s:init_var('map_' . map, key)
        unlet key
    endfor
endfunction
call s:setup_keymaps()

augroup TagbarSession
    autocmd!
    autocmd SessionLoadPost * nested call tagbar#RestoreSession()
augroup END

" Commands {{{1
command! -nargs=? Tagbar              call tagbar#ToggleWindow(<f-args>)
command! -nargs=? TagbarToggle        call tagbar#ToggleWindow(<f-args>)
command! -nargs=? TagbarOpen          call tagbar#OpenWindow(<f-args>)
command! -nargs=0 TagbarOpenAutoClose call tagbar#OpenWindow('fcj')
command! -nargs=0 TagbarClose         call tagbar#CloseWindow()
command! -nargs=1 -bang TagbarSetFoldlevel  call tagbar#SetFoldLevel(<args>, <bang>0)
command! -nargs=0 TagbarShowTag       call tagbar#highlighttag(1, 1)
command! -nargs=* TagbarCurrentTag    echo tagbar#currenttag('%s', 'No current tag', <f-args>)
command! -nargs=1 TagbarGetTypeConfig call tagbar#gettypeconfig(<f-args>)
command! -nargs=? TagbarDebug         call tagbar#debug#start_debug(<f-args>)
command! -nargs=0 TagbarDebugEnd      call tagbar#debug#stop_debug()
command! -nargs=0 TagbarTogglePause   call tagbar#toggle_pause()
command! -nargs=0 TagbarForceUpdate   call tagbar#ForceUpdate()
command! -nargs=0 TagbarJump   call tagbar#jump()
command! -nargs=0 TagbarJumpPrev      call tagbar#jumpToNearbyTag(-1)
command! -nargs=0 TagbarJumpNext      call tagbar#jumpToNearbyTag(1)


" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
