"=============================================================================
" povray.vim --- povray ftplugin
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if !exists("g:povray_command")
    let g:povray_command = "povray"
endif

if !empty(glob("~/.vim/*/vim-do"))
    let g:execute_command = "DoQuietly"
else
    let g:execute_command = "silent !"
endif

let s:compilation_failed = 0

function! povray#cleanPreviousImage()
    let l:remove = system("rm " . expand("%:r") . ".png")
    redraw!
endfunction

function! povray#CompileSilent()
    call povray#cleanPreviousImage()
    execute 'w!'
    let g:compile_output = system(g:povray_command . " "
                \ . expand("%"))
    if empty(glob(expand("%:r") . ".png"))
        let s:compilation_failed = 1
        call povray#showCompilationOutput()
    else
        let s:compilation_failed = 0
    endif
endfunction

function! povray#showCompilationOutput()
    execute 'silent pedit [POVRAY]' . expand("%:r") . ".png"
    wincmd P
    setlocal filetype=povray_output
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal bufhidden=wipe
    setlocal modifiable
    call append(0, split(g:compile_output, '\v\n'))
    setlocal nomodifiable
    nnoremap <silent> <buffer> q :silent bd!<CR>
endfunction

" Compile asynchronously if vim-do is installed
function! povray#CompileAsync()
    call povraycleanPreviousImage()
    execute 'w!'
    execute g:execute_command . " "
                \ . g:povray_command . " "
                \ . expand("%")
    redraw!
endfunction

function! povray#showImage() abort
    if exists("g:image_viewer")
        execute "silent ! " . g:image_viewer . " "
                    \ . expand("%:r") . ".png" . "&"
        redraw!
    else
        echom "Define an image viewer - let g:image_viewer = <viewer>"
    endif
endfunction

function! povray#CompileAndShow()
    call povray#CompileSilent()
    if !s:compilation_failed
        call povray#showImage()
    endif
endfunction
