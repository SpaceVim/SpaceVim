
function! neomake#makers#ft#erlang#EnabledMakers() abort
    return ['erlc']
endfunction

function! neomake#makers#ft#erlang#erlc() abort
    let maker = {
        \ 'errorformat':
            \ '%W%f:%l: Warning: %m,' .
            \ '%E%f:%l: %m'
        \ }
    function! maker.InitForJob(_jobinfo) abort
        let self.args = neomake#makers#ft#erlang#GlobPaths()
    endfunction
    return maker
endfunction

if !exists('g:neomake_erlang_erlc_target_dir')
    let g:neomake_erlang_erlc_target_dir = tempname()
endif

function! neomake#makers#ft#erlang#GlobPaths() abort
    " Find project root directory.
    let rebar_config = neomake#utils#FindGlobFile('rebar.config')
    if !empty(rebar_config)
        let root = fnamemodify(rebar_config, ':h')
    else
        " At least try with CWD
        let root = getcwd()
    endif
    let root = fnamemodify(root, ':p')
    let build_dir = root . '_build'
    let ebins = []
    if isdirectory(build_dir)
        " Pick the rebar3 profile to use
        let default_profile = expand('%') =~# '_SUITE.erl$' ?  'test' : 'default'
        let profile = get(b:, 'neomake_erlang_erlc_rebar3_profile', default_profile)
        let ebins += neomake#compat#glob_list(build_dir . '/' . profile . '/lib/*/ebin')
        let target_dir = build_dir . '/neomake'
    else
        let target_dir = get(b:, 'neomake_erlang_erlc_target_dir',
                       \ get(g:, 'neomake_erlang_erlc_target_dir'))
    endif
    " If <root>/_build doesn't exist it might be a rebar2/erlang.mk project
    if isdirectory(root . 'deps')
        let ebins += neomake#compat#glob_list(root . 'deps/*/ebin')
    endif
    " Set g:neomake_erlang_erlc_extra_deps in a project-local .vimrc, e.g.:
    "   let g:neomake_erlang_erlc_extra_deps = ['deps.local']
    " Or just b:neomake_erlang_erlc_extra_deps in a specific buffer.
    let extra_deps_dirs = get(b:, 'neomake_erlang_erlc_extra_deps',
                        \ get(g:, 'neomake_erlang_erlc_extra_deps'))
    if !empty(extra_deps_dirs)
        for extra_deps in extra_deps_dirs
            if extra_deps[-1] !=# '/'
                let extra_deps .= '/'
            endif
            let ebins += neomake#compat#glob_list(extra_deps . '*/ebin')
        endfor
    endif
    let args = ['-pa', 'ebin', '-I', 'include', '-I', 'src']
    for ebin in ebins
        let args += [ '-pa', ebin,
                    \ '-I', substitute(ebin, 'ebin$', 'include', '') ]
    endfor
    if !isdirectory(target_dir)
        call mkdir(target_dir, 'p')
    endif
    let args += ['-o', target_dir]
    return args
endfunction
" vim: ts=4 sw=4 et
