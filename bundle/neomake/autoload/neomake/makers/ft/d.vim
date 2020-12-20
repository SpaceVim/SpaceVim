" vim: ts=4 sw=4 et

function! neomake#makers#ft#d#EnabledMakers() abort
    " dmd, ldmd, and gdmd all share a common CLI.
    " Ordered in efficiency of compiler
    for m in ['dmd', 'ldmd', 'gdmd']
        if executable(m)
            return [m]
        endif
    endfor
    return []
endfunction

function! s:findDubRoot() abort
    "Look upwards for a dub.json or dub.sdl to find the root
    "I did it like this because it's the only cross platform way I know of
    let tmp_file = findfile('dub.json', '.;')
    if empty(tmp_file)
        let tmp_file = findfile('dub.sdl', '.;')
    endif
    return tmp_file
endfunction

function! s:UpdateDub() abort
    "Add dub directories
    let s:dubImports = []
    let tmp_file = s:findDubRoot()
    if executable('dub') && !empty(tmp_file)
        let tmp_dir = fnamemodify(tmp_file,':p:h')
        let dubCmd = 'dub describe --data=import-paths --annotate '
                    \ .'--skip-registry=all --vquiet --data-list --root='
        let output = system(dubCmd . tmp_dir)
        if(v:shell_error == 0 && !empty(output))
            " Is \n portable?
            let s:dubImports = split(output, '\n')
            call map(s:dubImports, "'-I' . v:val")
        endif
    endif
endfunction

"GDMD does not adhere to dmd's flags or output, but to GCC's.
"This is for LDMD and dmd only.
function! s:DmdStyleMaker(args) abort
    "Updating dub paths each make might be slow?
    call s:UpdateDub()
    let args = ['-w', '-wi', '-c', '-o-', '-vcolumns'] + a:args + s:dubImports
    return {
        \ 'args': args,
        \ 'errorformat':
        \     '%f(%l\,%c): %trror: %m,' .
        \     '%f(%l): %trror: %m,' .
        \     '%f(%l\,%c): %tarning: %m,' .
        \     '%f(%l): %tarning: %m,' .
        \     '%f(%l\,%c): Deprecation: %m,' .
        \     '%f(%l): Deprecation: %m,',
        \ }
endfunction

function! neomake#makers#ft#d#dmd() abort
    let args = []
    if exists('g:neomake_d_dmd_args_conf')
        call add(args, '-conf=' . expand(g:neomake_d_dmd_args_conf))
    endif
    return s:DmdStyleMaker(args)
endfunction

function! neomake#makers#ft#d#ldmd() abort
    let args = []
    if exists('g:neomake_d_ldmd_args_conf')
        call add(args, '-conf=' . expand(g:neomake_d_ldmd_args_conf))
    endif
    return s:DmdStyleMaker(args)
endfunction

function! neomake#makers#ft#d#gdmd() abort
    let args = ['-c', '-o-', '-fsyntax-only', s:UpdateDub()]
    return {
        \ 'args': args,
        \ 'errorformat':
            \ '%-G%f:%s:,' .
            \ '%-G%f:%l: %#error: %#(Each undeclared identifier is reported only%.%#,' .
            \ '%-G%f:%l: %#error: %#for each function it appears%.%#,' .
            \ '%-GIn file included%.%#,' .
            \ '%-G %#from %f:%l\,,' .
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%f:%l:%c: %m,' .
            \ '%f:%l: %trror: %m,' .
            \ '%f:%l: %tarning: %m,'.
            \ '%f:%l: %m',
        \ }
endfunction
