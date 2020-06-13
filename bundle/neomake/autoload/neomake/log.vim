let s:level_to_name = {0: 'error  ', 1: 'warning', 2: 'verbose', 3: 'debug  '}
let s:name_to_level = {'error': 0, 'warning': 1, 'verbose': 2, 'debug': 3}
let s:short_level_to_name = {0: 'E', 1: 'W', 2: 'V', 3: 'D'}
let s:is_testing = exists('g:neomake_test_messages')
let s:pid = getpid()
let s:indent = 0
let s:indent_str = ''

if !exists('s:last_msg_ts')
    let s:last_msg_ts = neomake#compat#reltimefloat()
endif

function! s:reltime_lastmsg() abort
    let cur = neomake#compat#reltimefloat()
    let diff = (cur - s:last_msg_ts)
    let s:last_msg_ts = cur

    if diff < 0.01
        return '     '
    elseif diff < 10
        let format = '+%.2f'
    elseif diff < 100
        let format = '+%.1f'
    elseif diff < 100
        let format = '  +%.0f'
    elseif diff < 1000
        let format = ' +%.0f'
    else
        let format = '+%.0f'
    endif
    return printf(format, diff)
endfunction

function! s:log(level, msg, ...) abort
    let context = a:0 ? a:1 : {}
    let verbosity = neomake#utils#get_verbosity(context)
    let logfile = get(g:, 'neomake_logfile', '')

    if !s:is_testing && verbosity < a:level && empty(logfile)
        return
    endif

    let msg = s:indent_str . a:msg
    if a:0
        if has_key(a:1, 'options')
            let context = copy(a:1.options)
            let context.make_id = a:1.make_id
        else
            let context = copy(a:1)
        endif
        let msg = printf('[%s.%s:%s:%d] %s',
                    \ get(context, 'make_id', '-'),
                    \ get(context, 'id', '-'),
                    \ get(context, 'bufnr', get(context, 'file_mode', 0) ? '?' : '-'),
                    \ get(context, 'winnr', winnr()),
                    \ msg)
    endif

    " Use Vader's log for messages during tests.
    " @vimlint(EVL104, 1, l:timediff)
    if s:is_testing && (verbosity >= a:level || get(g:, 'neomake_test_log_all_messages', 0))
        let timediff = s:reltime_lastmsg()
        if timediff !=# '     '
            let test_msg = '['.s:short_level_to_name[a:level].' '.timediff.']: '.msg
        else
            let test_msg = '['.s:level_to_name[a:level].']: '.msg
        endif

        if exists('*vader#log')
            " Might not exist with rpcrequest-based nvim test, or throw errors
            " if called too early.
            call vader#log(test_msg)
        endif
        " Only keep context entries that are relevant for / used in the message.
        let context = a:0
                    \ ? extend(filter(copy(context), "index(['id', 'make_id', 'bufnr', 'winnr'], v:key) != -1"), {'winnr': winnr()}, 'keep')
                    \ : {}
        call add(g:neomake_test_messages, [a:level, a:msg, context])
        if index(['.', '!', ')', ']'], a:msg[-1:-1]) == -1
            let g:neomake_test_errors += ['Log msg does not end with punctuation: "'.a:msg.'".']
        endif
    elseif verbosity >= a:level
        if verbosity > 2
            echom 'Neomake: '.msg
        else
            if a:level ==# 0
                echohl ErrorMsg
            else
                echohl WarningMsg
            endif
            " Use message without context for non-debug msgs.
            echom 'Neomake: '.a:msg
            echohl None
        endif
    endif
    if !empty(logfile)
        if !exists('s:logfile_writefile_opts')
            " Use 'append' with writefile, but only if it is available.  Otherwise, just
            " overwrite the file.  'S' is used to disable fsync in Neovim
            " (https://github.com/neovim/neovim/pull/6427).
            if has('patch-7.4.503')
                let s:logfile_writefile_opts = 'aS'
            else
                let s:logfile_writefile_opts = ''
                echohl WarningMsg
                echom 'Neomake: appending to the logfile is not supported in your Vim version.'
                echohl NONE
            endif
        endif

        let time = strftime('%H:%M:%S')
        if !exists('timediff')
            let timediff = s:reltime_lastmsg()
        endif
        try
            call writefile([printf('%s %s [%s %s] %s',
                        \ time, s:pid, s:short_level_to_name[a:level], timediff, msg)],
                        \ logfile, s:logfile_writefile_opts)
        catch
            unlet g:neomake_logfile
            call neomake#log#error(printf('Error when trying to write to logfile %s: %s.  Unsetting g:neomake_logfile.', logfile, v:exception))
        endtry
    endif
    " @vimlint(EVL104, 0, l:timediff)
endfunction

function! neomake#log#indent(offset) abort
    if a:offset < 0 && s:indent <= 0
        throw 'invalid offset (already 0)'
    endif
    let s:indent += a:offset
    let s:indent_str = repeat(' ', s:indent*2)
endfunction

function! neomake#log#error(...) abort
    call call('s:log', [0] + a:000)
endfunction

function! neomake#log#warning(...) abort
    call call('s:log', [1] + a:000)
endfunction

function! neomake#log#info(...) abort
    call call('s:log', [2] + a:000)
endfunction

function! neomake#log#debug(...) abort
    call call('s:log', [3] + a:000)
endfunction

function! neomake#log#debug_obj(msg, obj) abort
    if s:is_testing || neomake#utils#get_verbosity() >= 3 || !empty(get(g:, 'neomake_logfile', ''))
        call neomake#log#debug(a:msg.': '.neomake#utils#Stringify(a:obj).'.')
    endif
endfunction

function! neomake#log#exception(error, ...) abort
    let log_context = a:0 ? a:1 : {'bufnr': bufnr('%')}
    echom printf('Neomake error in: %s', v:throwpoint)
    call neomake#log#error(a:error, log_context)
    call neomake#log#debug(printf('(in %s)', v:throwpoint), log_context)
endfunction

let s:warned = {}
function! neomake#log#warn_once(msg, key) abort
    if !has_key(s:warned, a:key)
        let s:warned[a:key] = 1
        echohl WarningMsg
        echom 'Neomake: ' . a:msg
        echohl None
        let v:warningmsg = 'Neomake: '.a:msg
        call neomake#log#debug('Neomake warning: '.a:msg)
    endif
endfunction

function! neomake#log#reset_warnings() abort
    let s:warned = {}
endfunction
" vim: ts=4 sw=4 et
