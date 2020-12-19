function! neomake#makers#ft#julia#EnabledMakers() abort
    return ['lint']
endfunction

function! neomake#makers#ft#julia#lint() abort
    return {
\       'errorformat': '%f:%l %t%*[^ ] %m',
\       'exe': 'julia',
\       'args': ['-e', '
\           try
\               using Lint
\           catch
\               println("$(basename(ARGS[1])):1 E999 Install Lint.jl: Pkg.add(""Lint"")");
\               exit(1)
\           end;
\           r = lintfile(ARGS[1]);
\           if !isempty(r)
\               display(r);
\               exit(1)
\           end
\       ']
\   }
endfunction
" vim: ts=4 sw=4 et
