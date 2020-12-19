unlet! s:makers
unlet! s:uses_cabal

function! neomake#makers#ft#haskell#EnabledMakers() abort
    if !exists('s:makers')
        " cache whether each maker is available, to avoid lots of (UI blocking)
        " system calls
        " TODO: figure out how to do all this configuration async instead of
        " caching it--that would allow the user to change directories from
        " within vim and recalculate maker availability without restarting vim
        let commands = ['ghc-mod', 'hdevtools', 'hlint', 'liquid']
        let s:makers = []
        let s:jobs = []
        for command in commands
            " stack may be able to find a maker binary that's not on the normal
            " path so check for that first
            if executable('stack')
                " run the maker command using stack to see whether stack can
                " find it use the help flag to run the maker command without
                " doing anything
                let stack_command = [
                      \   'stack'
                      \ , 'exec'
                      \ , '--'
                      \ , command
                      \ , '--help'
                      \ ]
                if has('nvim')
                    let job_id = jobstart(
                        \ stack_command,
                        \ { 'command': command
                        \ , 'on_exit': function('s:CheckStackMakerAsync')
                        \ })
                    if job_id > 0
                        call add(s:jobs, job_id)
                    endif
                else
                    call extend(stack_command, ['> /dev/null 2>&1;', 'echo $?'])
                    if system(join(stack_command, ' ')) == 0
                        call add(s:makers, substitute(command, '-', '', 'g'))
                    endif
                endif
            elseif executable(command) " no stack bin so check for maker bin
                call add(s:makers, substitute(command, '-', '', 'g'))
            endif
        endfor
        if has('nvim')
            call jobwait(s:jobs)
        endif
    endif
    return s:makers
endfunction

function! neomake#makers#ft#haskell#hdevtools() abort
    let params = {
        \ 'exe': 'hdevtools',
        \ 'args': ['check', '-g-Wall'],
        \ 'mapexpr': s:CleanUpSpaceAndBackticks(),
        \ 'errorformat':
            \ '%-Z %#,'.
            \ '%W%f:%l:%v: Warning: %m,'.
            \ '%W%f:%l:%v: Warning:,'.
            \ '%E%f:%l:%v: %m,'.
            \ '%E%>%f:%l:%v:,'.
            \ '%+C  %#%m,'.
            \ '%W%>%f:%l:%v:,'.
            \ '%+C  %#%tarning: %m,'
        \ }
    " hdevtools needs the GHC-PACKAGE-PATH environment variable to exist
    " when running on a project WITHOUT a cabal file, but it needs the
    " GHC-PACKAGE-PATH to NOT exist when running on a with a project WITH
    " a cabal file
    if !exists('s:uses_cabal')
        let s:uses_cabal = 0
        if executable('stack')
            let output = neomake#compat#systemlist(['stack', '--verbosity', 'silent', 'path', '--project-root'])
            if !empty(output)
                let rootdir = output[0]
                if !empty(glob(rootdir . '/*.cabal'))
                    let s:uses_cabal = 1
                endif
            endif
        endif
    endif
    if s:uses_cabal
        let params['stackexecargs'] = ['--no-ghc-package-path']
    endif
    return s:TryStack(params)
endfunction

function! neomake#makers#ft#haskell#ghcmod() abort
    " This filters out newlines, which is what neovim gives us instead of the
    " null bytes that ghc-mod sometimes spits out.
    let mapexpr = 'substitute(v:val, "\n", "", "g")'
    return s:TryStack({
        \ 'exe': 'ghc-mod',
        \ 'args': ['check'],
        \ 'mapexpr': mapexpr,
        \ 'errorformat':
            \ '%-G%\s%#,' .
            \ '%f:%l:%c:%trror: %m,' .
            \ '%f:%l:%c:%tarning: %m,'.
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%E%f:%l:%c:%m,' .
            \ '%E%f:%l:%c:,' .
            \ '%Z%m'
        \ })
endfunction

function! neomake#makers#ft#haskell#HlintEntryProcess(entry) abort
    " Postprocess hlint output to make it more readable as a single line
    let a:entry.text = substitute(a:entry.text, '\v(Found:)\s*\n', ' | \1', 'g')
    let a:entry.text = substitute(a:entry.text, '\v(Why not:)\s*\n', ' | \1', 'g')
    let a:entry.text = substitute(a:entry.text, '^No hints$', '', 'g')
    call neomake#postprocess#compress_whitespace(a:entry)
endfunction

function! neomake#makers#ft#haskell#hlint() abort
    return s:TryStack({
        \ 'exe': 'hlint',
        \ 'postprocess': function('neomake#makers#ft#haskell#HlintEntryProcess'),
        \ 'args': [],
        \ 'errorformat':
            \ '%E%f:%l:%v: Error: %m,' .
            \ '%W%f:%l:%v: Warning: %m,' .
            \ '%I%f:%l:%v: Suggestion: %m,' .
            \ '%C%m'
        \ })
endfunction

function! neomake#makers#ft#haskell#liquid() abort
    return s:TryStack({
      \ 'exe': 'liquid',
      \ 'args': [],
      \ 'mapexpr': s:CleanUpSpaceAndBackticks(),
      \ 'errorformat':
          \ '%E %f:%l:%c-%.%#Error: %m,' .
          \ '%C%.%#|%.%#,' .
          \ '%C %#^%#,' .
          \ '%C%m,'
      \ })
endfunction

function! s:CheckStackMakerAsync(_job_id, data, _event) dict abort
    if a:data == 0
        call add(s:makers, substitute(self.command, '-', '', 'g'))
    endif
endfunction

function! s:TryStack(maker) abort
    if executable('stack')
        if !has_key(a:maker, 'stackexecargs')
            let a:maker['stackexecargs'] = []
        endif
        let a:maker['args'] =
            \   ['--verbosity', 'silent', 'exec']
            \ + a:maker['stackexecargs']
            \ + ['--', a:maker['exe']]
            \ + a:maker['args']
        let a:maker['exe'] = 'stack'
    endif
    return a:maker
endfunction

function! s:CleanUpSpaceAndBackticks() abort
    return 'substitute(substitute(v:val, " \\{2,\\}", " ", "g"), "`", "''", "g")'
endfunction
" vim: ts=4 sw=4 et
