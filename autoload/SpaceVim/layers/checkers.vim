""
" @section checkers, layer-checkers
" @parentsection layers
" SpaceVim uses neomake as default syntax checker.

function! SpaceVim#layers#checkers#plugins() abort
    let plugins = []

    if g:spacevim_enable_neomake
        call add(plugins, ['neomake/neomake', {'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}])
    else
        call add(plugins, ['wsdjeg/syntastic', {'on_event': 'WinEnter', 'loadconf' : 1, 'merged' : 0}])
    endif

    return plugins
endfunction


function! SpaceVim#layers#checkers#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'c'], 'sign unplace *', 'clear all errors', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'h'], '', 'describe a syntax checker', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'v'], '', 'verify syntax checker setup', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'n'], 'lnext', 'next-error', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'l'], 'lopen', 'toggle showing the error list', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'p'], 'lprevious', 'previous-error', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'N'], 'lNext', 'previous-error', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['e', '.'], 'call call('
                \ . string(s:_function('s:error_transient_state')) . ', [])',
                \ 'error-transient-state', 1)
endfunction

function! s:error_transient_state() abort
    if empty(neomake#statusline#LoclistCounts())
        echo 'no buffers contain error message locations'
        return
    endif
    let state = SpaceVim#api#import('transient_state') 
    call state.set_title('Error Transient State')
    call state.defind_keys(
                \ {
                \ 'layout' : 'vertical split',
                \ 'left' : [
                \ {
                \ 'key' : 'n',
                \ 'desc' : 'next error',
                \ 'func' : '',
                \ 'cmd' : 'try | lnext | catch | endtry',
                \ 'exit' : 0,
                \ },
                \ ],
                \ 'right' : [
                \ {
                \ 'key' : ['p', 'N'],
                \ 'desc' : 'previous error',
                \ 'func' : '',
                \ 'cmd' : 'try | lprevious | catch | endtry',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : 'q',
                \ 'desc' : 'quit',
                \ 'func' : '',
                \ 'cmd' : '',
                \ 'exit' : 1,
                \ },
                \ ],
                \ }
                \ )
    call state.open()
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
    function! s:_function(fstr) abort
        return function(a:fstr)
    endfunction
else
    function! s:_SID() abort
        return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
    endfunction
    let s:_s = '<SNR>' . s:_SID() . '_'
    function! s:_function(fstr) abort
        return function(substitute(a:fstr, 's:', s:_s, 'g'))
    endfunction
endif
