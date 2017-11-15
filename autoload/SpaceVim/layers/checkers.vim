""
" @section checkers, layer-checkers
" @parentsection layers
" SpaceVim uses neomake as default syntax checker.

function! SpaceVim#layers#checkers#plugins() abort
  let plugins = []

  if g:spacevim_enable_neomake
    call add(plugins, ['neomake/neomake', {'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}])
  elseif g:spacevim_enable_ale
    call add(plugins, ['w0rp/ale', {'merged' : 0, 'loadconf_before' : 1}])
  else
    call add(plugins, ['wsdjeg/syntastic', {'on_event': 'WinEnter', 'loadconf' : 1, 'merged' : 0}])
  endif

  return plugins
endfunction


function! SpaceVim#layers#checkers#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'c'], 'call call('
        \ . string(s:_function('s:clear_errors')) . ', [])',
        \ 'clear all errors', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'h'], '', 'describe a syntax checker', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'v'], '', 'verify syntax checker setup', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'n'], 'lnext', 'next-error', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'l'], 'lopen | wincmd w', 'toggle showing the error list', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'L'], 'lopen', 'toggle showing the error list', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'p'], 'lprevious', 'previous-error', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'N'], 'lNext', 'previous-error', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'v'], 'call call('
        \ . string(s:_function('s:verify_syntax_setup')) . ', [])',
        \ 'verify syntax setup', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', '.'], 'call call('
        \ . string(s:_function('s:error_transient_state')) . ', [])',
        \ 'error-transient-state', 1)

  augroup SpaceVim_layer_checker
    autocmd!
    if g:spacevim_enable_ale
      autocmd User ALELint let &l:statusline = SpaceVim#layers#core#statusline#get(1)
    endif
  augroup END
endfunction

function! s:verify_syntax_setup() abort
  if g:spacevim_enable_neomake
    NeomakeInfo
  elseif g:spacevim_enable_ale
  else
  endif
endfunction

function! s:error_transient_state() abort
  if g:spacevim_enable_neomake
    let has_errors = neomake#statusline#LoclistCounts()
  elseif g:spacevim_enable_ale
    let has_errors = ''
  else
    let has_errors = ''
  endif
  if empty(has_errors)
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

" TODO clear errors
function! s:clear_errors() abort
  sign unplace *
endfunction
