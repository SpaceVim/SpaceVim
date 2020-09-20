function! neoformat#utils#log(msg) abort
    if neoformat#utils#should_be_verbose()
        return s:better_echo(a:msg)
    endif
endfunction

function! neoformat#utils#log_file_content(path) abort
    if neoformat#utils#should_be_verbose()
        return s:better_echo(readfile(a:path))
    endif
endfunction

function! neoformat#utils#warn(msg) abort
    echohl WarningMsg | call s:better_echo(a:msg) | echohl NONE
endfunction

function! neoformat#utils#msg(msg) abort
    if exists('g:neoformat_only_msg_on_error') && g:neoformat_only_msg_on_error
        return
    endif
    return s:better_echo(a:msg)
endfunction

function! neoformat#utils#should_be_verbose() abort
    if !exists('g:neoformat_verbose')
        let g:neoformat_verbose = 0
    endif
    return &verbose || g:neoformat_verbose
endfunction

function! s:better_echo(msg) abort
    if type(a:msg) != type('')
        echom 'Neoformat: ' . string(a:msg)
    else
        echom 'Neoformat: ' . a:msg
    endif
endfunction

function! neoformat#utils#var(name) abort
    return neoformat#utils#var_default(a:name, 0)
endfunction

function! neoformat#utils#var_default(name, default) abort
    if exists('b:' . a:name)
        return get(b:, a:name)
    endif

    return get(g:, a:name, a:default)
endfunction
