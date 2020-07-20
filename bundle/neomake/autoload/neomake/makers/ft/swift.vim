" vim: ts=4 sw=4 et

function! neomake#makers#ft#swift#EnabledMakers() abort
    if !empty(s:get_swiftpm_config())
        return ['swiftpm']
    endif
    return ['swiftc']
endfunction

function! s:get_swiftpm_config() abort
    return neomake#utils#FindGlobFile('Package.swift')
endfunction

function! s:get_swiftpm_base_maker() abort
    let maker = {
        \ 'exe': 'swift',
        \ 'append_file': 0,
        \ 'errorformat':
            \ '%E%f:%l:%c: error: %m,' .
            \ '%E%f:%l: error: %m,' .
            \ '%W%f:%l:%c: warning: %m,' .
            \ '%Z%\s%#^~%#,' .
            \ '%-G%.%#',
        \ }
    let config = s:get_swiftpm_config()
    if !empty(config)
        let maker.cwd = fnamemodify(config, ':h')
    endif
    return maker
endfunction

function! neomake#makers#ft#swift#swiftpm() abort
    let maker = s:get_swiftpm_base_maker()
    let maker.args = ['build', '--build-tests']
    return maker
endfunction

function! neomake#makers#ft#swift#swiftpmtest() abort
    let maker = s:get_swiftpm_base_maker()
    let maker.args = ['test']
    return maker
endfunction

function! neomake#makers#ft#swift#swiftc() abort
    " `export SDKROOT="$(xcodebuild -version -sdk macosx Path)"`
    return {
        \ 'args': ['-parse'],
        \ 'errorformat':
            \ '%E%f:%l:%c: error: %m,' .
            \ '%W%f:%l:%c: warning: %m,' .
            \ '%Z%\s%#^~%#,' .
            \ '%-G%.%#',
        \ }
endfunction
