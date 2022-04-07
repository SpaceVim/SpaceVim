if exists("g:virtualenv_loaded")
    finish
endif

let g:virtualenv_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

if !has('python3') && !has('python')
    finish
endif

if !exists("g:virtualenv_auto_activate")
    let g:virtualenv_auto_activate = 1
endif

if !exists("g:virtualenv_stl_format")
    let g:virtualenv_stl_format = '%n'
endif

if !exists("g:virtualenv_directory")
    if isdirectory($WORKON_HOME)
        let g:virtualenv_directory = $WORKON_HOME
    else
        let g:virtualenv_directory = '~/.virtualenvs'
    endif
endif

let g:virtualenv_directory = expand(g:virtualenv_directory)

command! -bar VirtualEnvList :call virtualenv#list()
command! -bar VirtualEnvDeactivate :call virtualenv#deactivate()
command! -bar -nargs=? -complete=customlist,s:CompleteVirtualEnv VirtualEnvActivate :call virtualenv#activate(<q-args>)

function! s:Error(message)
    echohl ErrorMsg | echo a:message | echohl None
endfunction

function! s:CompleteVirtualEnv(arg_lead, cmd_line, cursor_pos)
    return virtualenv#names(a:arg_lead)
endfunction

" DEPRECATED: Leaving in for compatibility
function! VirtualEnvStatusline()
    return virtualenv#statusline()
endfunction

if g:virtualenv_auto_activate == 1
    call virtualenv#activate('', 1)
endif

let &cpo = s:save_cpo
