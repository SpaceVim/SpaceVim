" ============================================================================
" File:        autoload/gitstatus/doctor.vim
" Description: what does the doctor say?
" Maintainer:  Xuyuan Pang <xuyuanp at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================

let s:types = {
            \ 'NUMBER': type(0),
            \ 'STRING': type(''),
            \ 'FUNCREF': type(function('tr')),
            \ 'LIST': type([]),
            \ 'DICT': type({}),
            \ 'FLOAT': type(0.0),
            \ 'BOOL': type(v:true),
            \ 'NULL': type(v:null)
            \ }

let s:type_formatters = {}
let s:type_formatters[s:types.NUMBER]  = { nbr -> string(nbr) }
let s:type_formatters[s:types.STRING]  = { str -> printf("'%s'", str) }
let s:type_formatters[s:types.FUNCREF] = { fn  -> string(fn) }
let s:type_formatters[s:types.LIST]    = { lst -> s:prettifyList(lst, '  \ ', 0, '  ') }
let s:type_formatters[s:types.DICT]    = { dct -> s:prettifyDict(dct, '  \ ', 0, '  ') }
let s:type_formatters[s:types.FLOAT]   = { flt -> string(flt) }
let s:type_formatters[s:types.BOOL]    = { bol -> bol ? 'v:true' : 'v:false' }
let s:type_formatters[s:types.NULL]    = { nul -> string(nul) }

function! s:get_git_version() abort
    return split(system('git version'), "\n")[0]
endfunction

function! s:get_git_status_output(workdir) abort
    return system(join(gitstatus#util#BuildGitStatusCommand(a:workdir, g:), ' '))
endfunction

function! s:prettifyDict(obj, prefix, level, indent) abort
    let l:prefix = a:prefix . repeat(a:indent, a:level)
    if empty(a:obj)
        return '{}'
    endif
    let l:res = "{\n"
    for [l:key, l:val] in items(a:obj)
        let l:type = type(l:val)
        if l:type is# s:types.DICT
            let l:val = s:prettifyDict(l:val, a:prefix, a:level + 1, a:indent)
        elseif l:type is# s:types.LIST
            let l:val = s:prettifyList(l:val, a:prefix , a:level + 1, a:indent)
        else
            let l:val = s:prettify(l:val)
        endif
        let l:res .= l:prefix . a:indent . "'" . l:key . "': " . l:val . ",\n"
    endfor
    let l:res .= l:prefix . '}'
    return l:res
endfunction

function! s:prettifyList(obj, prefix, level, indent) abort
    let l:prefix = a:prefix . repeat(a:indent, a:level)
    if empty(a:obj)
        return '[]'
    endif
    let l:res = "[\n"
    for l:val in a:obj
        let l:type = type(l:val)
        if l:type is# s:types.LIST
            let l:val = s:prettifyList(l:val, a:prefix, a:level + 1, a:indent)
        elseif l:type is# s:types.DICT
            let l:val = s:prettifyDict(l:val, a:prefix, a:level + 1, a:indent)
        else
            let l:val = s:prettify(l:val)
        endif
        let l:res .= l:prefix . a:indent . l:val . ",\n"
    endfor
    let l:res .= l:prefix . ']'
    return l:res
endfunction

function! s:prettify(obj) abort
    let l:type = type(a:obj)
    return call(s:type_formatters[l:type], [a:obj])
endfunction

function! s:loaded_vim_devicons() abort
    return get(g:, 'loaded_webdevicons', 0) && get(g:, 'webdevicons_enable', 0) && get(g:, 'webdevicons_enable_nerdtree', 0)
endfunction

function! s:loaded_vim_nerdtree_syntax_highlight() abort
    return exists('g:NERDTreeSyntaxEnabledExtensions')
endfunction

function! s:loaded_vim_nerdtree_tabs() abort
    return exists('g:nerdtree_tabs_open_on_gui_startup')
endfunction

function! gitstatus#doctor#Say() abort
    call g:NERDTree.MustBeOpen()
    call g:NERDTree.CursorToTreeWin()

    let l:line = repeat('=', 80)

    echo has('nvim') ? 'Neovim:' : 'Vim:'
    echo execute('version')
    echo l:line

    echo 'NERDTree:'
    echo 'version: ' . nerdtree#version()
    echo 'root: ' . b:NERDTree.root.path.str()

    echo l:line

    echo 'Git:'
    echo 'version: ' . s:get_git_version()
    let l:git_workdir = get(g:, 'NTGitWorkdir', '')
    echo 'workdir: ' . l:git_workdir
    if !empty(l:git_workdir)
        echo 'status output:'
        echo s:get_git_status_output(l:git_workdir)
    endif

    echo l:line

    echo 'Options:'
    for [l:key, l:val] in items(g:)
        if l:key =~# 'NERDTreeGitStatus*'
            echo '' . l:key . ' = ' . s:prettify(l:val)
        endif
    endfor

    echo l:line

    echo 'Others:'
    echo 'vim-devicons: ' . (s:loaded_vim_devicons() ? 'yes' : 'no')
    if s:loaded_vim_devicons()
        for [l:key, l:val] in items(g:)
            if l:key =~# 'WebDevIconsNerdTree*'
                echo '' . l:key . ' = ' . s:prettify(l:val)
            endif
        endfor
    endif

    echo repeat('-', 40)
    echo 'vim-nerdtree-syntax-highlight: ' . (s:loaded_vim_nerdtree_syntax_highlight() ? 'yes': 'no')
    if s:loaded_vim_nerdtree_syntax_highlight()
        for [l:key, l:val] in items(g:)
            if l:key =~# 'NERDTreeSyntax*'
                echo '' . l:key . ' = ' . s:prettify(l:val)
            endif
        endfor
    endif

    echo repeat('-', 40)
    echo 'vim-nerdtree-tabs: ' . (s:loaded_vim_nerdtree_tabs() ? 'yes': 'no')
    if s:loaded_vim_nerdtree_tabs()
        for [l:key, l:val] in items(g:)
            if l:key =~# 'nerdtree_tabs_*'
                echo '' . l:key . ' = ' . s:prettify(l:val)
            endif
        endfor
    endif

    echo l:line
endfunction
