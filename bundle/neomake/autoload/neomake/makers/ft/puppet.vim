function! neomake#makers#ft#puppet#EnabledMakers() abort
    return ['puppet', 'puppetlint']
endfunction

function! neomake#makers#ft#puppet#puppetlint() abort
    return {
        \ 'exe': 'puppet-lint',
        \ 'args': ['--log-format', '%%{path}:%%{line}:%%{column}:%%{kind}:[%%{check}] %%{message}'],
        \ 'errorformat': '%f:%l:%c:%t%*[a-zA-Z]:%m',
        \ 'short_name': 'pupl',
        \ 'output_stream': 'stdout',
        \ }
endfunction

function! neomake#makers#ft#puppet#puppet() abort
    return {
        \ 'args': ['parser', 'validate', '--color=false'],
        \ 'errorformat':
          \ '%-Gerr: Try ''puppet help parser validate'' for usage,' .
          \ '%-GError: Try ''puppet help parser validate'' for usage,' .
          \ '%t%*[a-zA-Z]: %m at %f:%l:%c,' .
          \ '%t%*[a-zA-Z]: %m at %f:%l,'.
          \ '%t%*[a-zA-Z]: Could not parse for environment production: %m (file: %f\, line: %l\, column: %c),' .
          \ '%t%*[a-zA-Z]: Could not parse for environment production: %m (file: %f)',
        \ 'short_name': 'pupp',
        \ 'output_stream': 'stderr',
        \ }
endfunction
" vim: ts=4 sw=4 et
