"=============================================================================
" xmake.vim --- xmake support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" Original Author: luzhlon
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
" This file is based on:
" https://github.com/luzhlon/xmake.vim/tree/5b20e97f5d0b063a97be23451c730d0278eef927

if exists('s:xmake_loaded')
  finish
endif

let s:xmake_loaded = 1

" Arguments of 'xmake'
let s:xmake_args = [ 'run',
                   \ 'config', 'global',
                   \ 'create', 'package',
                   \ 'install', 'uninstall',
                   \ 'build', 'clean',
                   \ 'project',
                   \ 'doxygen',
                   \ 'app2ipa']
" Arguments of 'xmake create'
let s:create_args = [
            \ '--name=', '-n',
            \ '--language=', '-l',
            \ '--template=', '-t']
" Arguments of 'xmake config'
let s:config_args = [
            \ '--verbose=', '-v',
            \ '--plat=', '-p',
            \ '--arch=', '-a',
            \ '--mode=', '-m',
            \ '--kind=', '-k',
            \ '--buildir=', '-o']
let s:plat_args = ['android', 'iphoneos', 'linux', 'macos', 'mingw', 'watchos', 'windows']
let s:language_args = ['c', 'c++', 'dlang', 'objc', 'objc++', 'rust', 'swift']
let s:arch_args = ['x86', 'x64', 'x86_64', 'i386', 'armv7', 'armv7s', 'arm64', 'armv7-a', 'armv7k', 'armv5te', 'armv6', 'armv8-a', 'arm64-v8a']
" Get the last operation
fun! s:lastarg(args)
    let i = -1
    try | while 1
        let a = a:args[i]
        if a =~ '^-' | return a | endif
        let i -= 1
    endw | endt
    return ''
endf
" Function to complete the xmake args
fun! s:xmake_complete(a, c, p)
    let args = split(strpart(a:c, 0, a:p), '\s\+')
    let op = len(args) > 1 ? args[1] : ''
    let larg = args[-1][0] == '-' ? args[-1] : len(args) > 1 ? args[-2] : ''
    let rets = []
    if op == 'run' || op == 'build'
        let rets = keys(g:xmproj['targets'])
    elseif op == 'create'
        if larg == '--language=' || larg == '-l'
            let rets = s:language_args
        else
            let rets = s:create_args
        endif
    elseif op == 'config'
        if larg == '--plat=' || larg == '-p'
            let rets = s:plat_args
        elseif larg == '--kind=' || larg == '-k'
            let rets = ['static', 'shared', 'binary']
        elseif larg == '--mode=' || larg == '-m'
            let rets = ['debug', 'release']
        elseif larg == '--arch' || larg == '-a'
            let rets = s:arch_args
        else
            let rets = s:config_args
        endif
    elseif op == 'project'
        if larg == '-k'
            let rets = ['vs2013', 'vs2015', 'vs2017', 'makefile']
        elseif larg == '--mode=' || larg == '-m'
            let rets = ['debug', 'release']
        else
            let rets = ['-k', '-m']
        endif
    else
        let rets = s:xmake_args
    endif
    return s:wildfilter(rets, a:a)
endf

let s:patten = ''
function! s:compare(a, b) abort
  return match(a:a, s:patten) - match(a:b, s:patten)
endfunction

function! s:wildfilter(rets, patten) abort
    let ret = filter(copy(a:rets), 'v:val =~ a:patten')
    let s:patten = a:patten
    call sort(ret, function('s:compare'))
    return ret
endfunction

""
" Run `xmake` command based on provided arguments.
command! -complete=customlist,<SID>xmake_complete
            \ -nargs=* XMake call xmake#xmake(<f-args>)

let s:path = expand('<sfile>:p:h')

fun! s:xmgen()
    exe 'py3file' s:path . '/xmgen.py'
endf

com! XMakeLoad call xmake#load()
com! XMakeGen  call <SID>xmgen()

let arg = argv(0)
if fnamemodify(arg, ':t') == 'xmake.lua'
    " exe 'bw' arg
    if filereadable(arg)
        au VimEnter * XMakeLoad
    endif
endif

fun! s:on_read()
    if !exists('b:deoplete_sources')
        if exists('g:deoplete#sources')
            let b:deoplete_sources = 
                    \ get(g:deoplete#sources, '_', []) +
                    \ get(g:deoplete#sources, 'lua', [])
        else
            let b:deoplete_sources = []
        endif
    endif
    call add(b:deoplete_sources, 'xmake')
endf

au BufWritePost xmake.lua XMakeLoad
au BufRead,BufNew xmake.lua call <sid>on_read()

call SpaceVim#plugins#projectmanager#reg_callback(function('xmake#on_project_changed'))
