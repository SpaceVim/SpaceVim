scriptencoding utf-8

let s:LOG = SpaceVim#api#import('logger')

call s:LOG.set_name('Gtags')

""
" set the path to gtags log file.
let g:gtags_log_file = get(g:, 'gtags_log_file', '')

if !empty(g:gtags_log_file)
    call s:LOG.set_file(g:gtags_log_file)
endif

function! gtags#logger#log(level, msg) abort
    if a:level ==# 'info'
        call s:LOG.info(a:msg)
    elseif a:level ==# 'warn'
        call s:LOG.warn(a:msg)
    elseif a:level ==# 'error'
        call s:LOG.error(a:msg)
    endif
endfunction

function! gtags#logger#view(...)
    echo s:LOG.view(get(a:000, 0, 'info'))
endfunction



