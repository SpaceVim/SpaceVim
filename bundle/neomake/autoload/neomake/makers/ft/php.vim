" vim: ts=4 sw=4 et

function! neomake#makers#ft#php#EnabledMakers() abort
    return ['php', 'phpmd', 'phpcs', 'phpstan']
endfunction

function! neomake#makers#ft#php#php() abort
    return {
        \ 'args': ['-l', '-d', 'display_errors=1', '-d', 'log_errors=0',
            \      '-d', 'xdebug.cli_color=0'],
        \ 'errorformat':
            \ '%-GNo syntax errors detected in%.%#,'.
            \ '%EParse error: %#syntax error\, %m in %f on line %l,'.
            \ '%EParse error: %m in %f on line %l,'.
            \ '%EFatal error: %m in %f on line %l,'.
            \ '%-G\s%#,'.
            \ '%-GErrors parsing %.%#',
        \ 'output_stream': 'stdout',
        \ }
endfunction

function! neomake#makers#ft#php#phpcs() abort
    let args = ['--report=csv', '-q']

    "Add standard argument if one is set.
    if exists('g:neomake_php_phpcs_args_standard')
        call add(args, '--standard=' . expand(g:neomake_php_phpcs_args_standard))
    endif

    return {
        \ 'args': args,
        \ 'errorformat':
            \ '%-GFile\,Line\,Column\,Type\,Message\,Source\,Severity%.%#,'.
            \ '"%f"\,%l\,%c\,%t%*[a-zA-Z]\,"%m"\,%*[a-zA-Z0-9_.-]\,%*[0-9]%.%#',
        \ }
endfunction

function! neomake#makers#ft#php#phpmd() abort
    return {
        \ 'args': ['%t', 'text', 'codesize,design,unusedcode,naming'],
        \ 'append_file': 0,
        \ 'errorformat': '%W%f:%l%\s%\s%#%m'
        \ }
endfunction

function! neomake#makers#ft#php#phpstan() abort
    " PHPStan normally considers 0 to be the default level, so that is used here as the default:
    let maker = {
        \ 'args': ['analyse', '--error-format', 'raw', '--no-progress', '--level', get(g:, 'neomake_phpstan_level', 0)],
        \ 'errorformat': '%E%f:%l:%m',
        \ }
    " Check for the existence of a default PHPStan project configuration file.
    " Technically PHPStan does not have a concept of a default filename for a
    " project configuration file, but phpstan.neon is the filename shown in the
    " example in the PHPStan documentation, so this is the default name expected
    " by Neomake.
    let phpStanConfigFilePath = neomake#utils#FindGlobFile('phpstan.neon')
    if !empty(phpStanConfigFilePath)
        call extend(maker.args, ['-c', phpStanConfigFilePath])
    endif
    return maker
endfunction

function! neomake#makers#ft#php#psalm() abort
    let maker = {
        \ 'args': [
            \ '--output-format=pylint'
        \ ],
        \ 'errorformat': '%A%f:%l:%\s[%t%n]%\s%m',
        \ }
    return maker
endfunction
