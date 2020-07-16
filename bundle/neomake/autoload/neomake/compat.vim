" Compatibility wrappers for different (Neo)Vim versions and platforms.

if neomake#utils#IsRunningWindows()
    let g:neomake#compat#dev_null = 'NUL'
else
    let g:neomake#compat#dev_null = '/dev/null'
endif

if v:version >= 704
    function! neomake#compat#getbufvar(buf, key, def) abort
        return getbufvar(a:buf, a:key, a:def)
    endfunction
    function! neomake#compat#getwinvar(win, key, def) abort
        return getwinvar(a:win, a:key, a:def)
    endfunction
else
    function! neomake#compat#getbufvar(buf, key, def) abort
        return get(getbufvar(a:buf, ''), a:key, a:def)
    endfunction
    function! neomake#compat#getwinvar(win, key, def) abort
        return get(getwinvar(a:win, ''), a:key, a:def)
    endfunction
endif

unlockvar neomake#compat#json_true
unlockvar neomake#compat#json_false
unlockvar neomake#compat#json_null
unlockvar neomake#compat#json_none

if exists('v:none')
    let neomake#compat#json_none = v:none
else
    let neomake#compat#json_none = []
endif

if exists('*json_decode')
    let neomake#compat#json_true = v:true
    let neomake#compat#json_false = v:false
    let neomake#compat#json_null = v:null

    if has('nvim')
        function! neomake#compat#json_decode(json) abort
            if a:json is# ''
                " Prevent Neovim from throwing E474: Attempt to decode a blank string.
                return g:neomake#compat#json_none
            endif
            return json_decode(a:json)
        endfunction
    else
        function! neomake#compat#json_decode(json) abort
            return json_decode(a:json)
        endfunction
    endif
else
    let neomake#compat#json_true = 1
    let neomake#compat#json_false = 0
    function! s:json_null() abort
    endfunction
    let neomake#compat#json_null = [function('s:json_null')]

    " Via Syntastic (https://github.com/vim-syntastic/syntastic/blob/6fb14d624b6081459360fdbba743f82cf84c8f92/autoload/syntastic/preprocess.vim#L576-L607),
    " based on https://github.com/MarcWeber/vim-addon-json-encoding/blob/master/autoload/json_encoding.vim.
    " @vimlint(EVL102, 1, l:true)
    " @vimlint(EVL102, 1, l:false)
    " @vimlint(EVL102, 1, l:null)
    function! neomake#compat#json_decode(json) abort " {{{2
        if a:json ==# ''
            return g:neomake#compat#json_none
        endif

        " The following is inspired by https://github.com/MarcWeber/vim-addon-manager and
        " http://stackoverflow.com/questions/17751186/iterating-over-a-string-in-vimscript-or-parse-a-json-file/19105763#19105763
        " A hat tip to Marc Weber for this trick
        " Replace newlines, which eval() does not like.
        let json = substitute(a:json, "\n", '', 'g')
        if substitute(json, '\v\"%(\\.|[^"\\])*\"|true|false|null|[+-]?\d+%(\.\d+%([Ee][+-]?\d+)?)?', '', 'g') !~# "[^,:{}[\\] \t]"
            " JSON artifacts
            let true = g:neomake#compat#json_true
            let false = g:neomake#compat#json_false
            let null = g:neomake#compat#json_null

            try
                let object = eval(json)
            catch
                throw 'Neomake: Failed to parse JSON input: '.v:exception
            endtry
        else
            throw 'Neomake: Failed to parse JSON input: invalid input'
        endif

        return object
    endfunction " }}}2
    " @vimlint(EVL102, 0, l:true)
    " @vimlint(EVL102, 0, l:false)
    " @vimlint(EVL102, 0, l:null)
endif

lockvar neomake#compat#json_true
lockvar neomake#compat#json_false
lockvar neomake#compat#json_null

if exists('*uniq')
    function! neomake#compat#uniq(l) abort
        return uniq(a:l)
    endfunction
else
    function! neomake#compat#uniq(l) abort
        let n = len(a:l)
        if n < 2
            return a:l
        endif
        let prev = a:l[0]
        let idx = 1
        while idx < n
            if a:l[idx] ==# prev && type(a:l[idx]) == type(prev)
                call remove(a:l, idx)
                let n -= 1
            else
                let prev = a:l[idx]
                let idx += 1
            endif
        endwhile
        return a:l
    endfunction
endif

if exists('*reltimefloat')
    function! neomake#compat#reltimefloat() abort
        return reltimefloat(reltime())
    endfunction
else
    function! neomake#compat#reltimefloat() abort
        let t = split(reltimestr(reltime()), '\V.')
        return str2float(t[0] . '.' . t[1])
    endfunction
endif

" Wrapper around systemlist() that supports a list for a:cmd.
" It returns an empty string on error.
" NOTE: Neovim before 0.2.0 would throw an error (which is caught), but it
" does not set v:shell_error!
function! neomake#compat#systemlist(cmd) abort
    if empty(a:cmd)
        return []
    endif
    if has('nvim') && exists('*systemlist')
        " @vimlint(EVL108, 1)
        if !has('nvim-0.2.0')
            try
                return systemlist(a:cmd)
            catch /^Vim\%((\a\+)\)\=:E902/
                return ''
            endtry
        endif
        " @vimlint(EVL108, 0)
        try
            return systemlist(a:cmd)
        catch /^Vim\%((return)\)\=:E475/
            call neomake#log#exception(printf('systemlist error: %s.', v:exception))
            return ''
        endtry
    endif

    if type(a:cmd) == type([])
        let cmd = join(map(a:cmd, 'neomake#utils#shellescape(v:val)'))
    else
        let cmd = a:cmd
    endif
    if exists('*systemlist')
        return systemlist(cmd)
    endif
    return split(system(cmd), '\n')
endfunction

function! neomake#compat#globpath_list(path, pattern, suf) abort
    if v:version >= 705 || (v:version == 704 && has('patch279'))
        return globpath(a:path, a:pattern, a:suf, 1)
    endif
    return split(globpath(a:path, a:pattern, a:suf), '\n')
endfunction

function! neomake#compat#glob_list(pattern) abort
    if v:version <= 703
        return split(glob(a:pattern, 1), '\n')
    endif
    return glob(a:pattern, 1, 1)
endfunction

if neomake#utils#IsRunningWindows()
    " Windows needs a shell to handle PATH/%PATHEXT% etc.
    function! neomake#compat#get_argv(exe, args, args_is_list) abort
        let prefix = &shell.' '.&shellcmdflag.' '
        if a:args_is_list
            if a:exe ==# &shell && get(a:args, 0) ==# &shellcmdflag
                " Remove already existing &shell/&shellcmdflag from e.g. NeomakeSh.
                let argv = join(a:args[1:])
            else
                let argv = join(map(copy([a:exe] + a:args), 'neomake#utils#shellescape(v:val)'))
            endif
        else
            let argv = a:exe . (empty(a:args) ? '' : ' '.a:args)
            if argv[0:len(prefix)-1] ==# prefix
                return argv
            endif
        endif
        return prefix.argv
    endfunction
elseif has('nvim')
    function! neomake#compat#get_argv(exe, args, args_is_list) abort
        if a:args_is_list
            return [a:exe] + a:args
        endif
        return a:exe . (empty(a:args) ? '' : ' '.a:args)
    endfunction
elseif neomake#has_async_support()  " Vim-async.
    function! neomake#compat#get_argv(exe, args, args_is_list) abort
        if a:args_is_list
            return [a:exe] + a:args
        endif
        " Use a shell to handle argv properly (Vim splits at spaces).
        let argv = a:exe . (empty(a:args) ? '' : ' '.a:args)
        return [&shell, &shellcmdflag, argv]
    endfunction
else
    " Vim (synchronously), via system().
    function! neomake#compat#get_argv(exe, args, args_is_list) abort
        if a:args_is_list
            return join(map(copy([a:exe] + a:args), 'neomake#utils#shellescape(v:val)'))
        endif
        return a:exe . (empty(a:args) ? '' : ' '.a:args)
    endfunction
endif

if v:version >= 704 || (v:version == 703 && has('patch831'))
    function! neomake#compat#gettabwinvar(t, w, v, d) abort
        return gettabwinvar(a:t, a:w, a:v, a:d)
    endfunction
else
    " Wrapper around gettabwinvar that has no default (older Vims).
    function! neomake#compat#gettabwinvar(t, w, v, d) abort
        let r = gettabwinvar(a:t, a:w, a:v)
        if r is# ''
            unlet r
            let r = a:d
        endif
        return r
    endfunction
endif

" Not really necessary for now, but allows to overwriting and extending.
if exists('*nvim_get_mode')
    function! neomake#compat#get_mode() abort
        let mode = nvim_get_mode()
        return mode.mode
    endfunction
else
    function! neomake#compat#get_mode() abort
        return mode(1)
    endfunction
endif

function! neomake#compat#in_completion() abort
    if pumvisible()
        return 1
    endif
    if has('patch-8.0.0283')
        let mode = mode(1)
        if mode[1] ==# 'c' || mode[1] ==# 'x'
            return 1
        endif
    endif
    return 0
endfunction

let s:prev_windows = []
if exists('*win_getid')
    function! neomake#compat#save_prev_windows() abort
        call add(s:prev_windows, [win_getid(winnr('#')), win_getid(winnr())])
    endfunction

    function! neomake#compat#restore_prev_windows() abort
        " Go back, maintaining the '#' window (CTRL-W_p).
        let [aw_id, pw_id] = remove(s:prev_windows, 0)
        let pw = win_id2win(pw_id)
        if !pw
            call neomake#log#debug(printf(
                        \ 'Cannot restore previous windows (previous window with ID %d not found).',
                        \ pw_id))
        elseif winnr() != pw
            let aw = win_id2win(aw_id)
            if aw
                exec aw . 'wincmd w'
            endif
            exec pw . 'wincmd w'
        endif
    endfunction
else
    function! neomake#compat#save_prev_windows() abort
        call add(s:prev_windows, [winnr('#'), winnr()])
    endfunction

    function! neomake#compat#restore_prev_windows() abort
        " Go back, maintaining the '#' window (CTRL-W_p).
        let [aw, pw] = remove(s:prev_windows, 0)
        if pw > winnr('$')
            call neomake#log#debug(printf(
                        \ 'Cannot restore previous windows (%d > %d).',
                        \ pw, winnr('$')))
        elseif winnr() != pw
            if aw
                exec aw . 'wincmd w'
            endif
            exec pw . 'wincmd w'
        endif
    endfunction
endif

if v:version >= 704 || (v:version == 703 && has('patch442'))
    function! neomake#compat#doautocmd(event) abort
        exec 'doautocmd <nomodeline> ' . a:event
    endfunction
else
    function! neomake#compat#doautocmd(event) abort
        exec 'doautocmd ' . a:event
    endfunction
endif
" vim: ts=4 sw=4 et
