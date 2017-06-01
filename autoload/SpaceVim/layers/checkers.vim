""
" @section checkers, layer-checkers
" @parentsection layers
" SpaceVim uses neomake as default syntax checker.

function! SpaceVim#layers#checkers#plugins() abort
    let plugins = []

    if g:spacevim_enable_lint_type == 0
		call add(plugins, ['neomake/neomake', {'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}])
    elseif g:spacevim_enable_lint_type == 1
        call add(plugins, ['wsdjeg/syntastic', {'on_event': 'WinEnter', 'loadconf' : 1, 'merged' : 0}])
	elseif g:spacevim_enable_lint_type == 2
		call add(plugins, ['w0rp/ale'])
    endif

    return plugins
endfunction


function! SpaceVim#layers#checkers#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['e', '.'], 'lopen', 'error-transient-state', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'c'], '', 'clear all errors', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'h'], '', 'describe a syntax checker', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'v'], '', 'verify syntax checker setup', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'n'], 'lnext', 'next-error', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'l'], 'lopen', 'toggle showing the error list', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'p'], 'lprevious', 'previous-error', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'N'], 'lNext', 'previous-error', 1)
endfunction
