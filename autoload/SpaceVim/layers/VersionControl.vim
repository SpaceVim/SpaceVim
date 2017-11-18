function! SpaceVim#layers#VersionControl#config() abort
  let g:_spacevim_mappings_space.g = get(g:_spacevim_mappings_space, 'g',  {'name' : '+VersionControl/git'})
  call SpaceVim#mapping#space#def('nnoremap', ['g', '.'], 'call call('
        \ . string(s:_function('s:buffer_transient_state')) . ', [])',
        \ 'buffer transient state', 1)
endfunction

function! s:buffer_transient_state() abort
    let state = SpaceVim#api#import('transient_state') 
    call state.set_title('VCS Transient State')
    call state.defind_keys(
                \ {
                \ 'layout' : 'vertical split',
                \ 'left' : [
                \ {
                \ 'key' : 'n',
                \ 'desc' : 'next hunk',
                \ 'func' : '',
                \ 'cmd' : 'normal ]c',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : ['N', 'p'],
                \ 'desc' : 'previous hunk',
                \ 'func' : '',
                \ 'cmd' : 'normal [c',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : ['r', 's', 'h'],
                \ 'desc' : 'revert/stage/show',
                \ 'func' : '',
                \ 'cmd' : 'normal [c',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : 't',
                \ 'desc' : 'toggle diff signs',
                \ 'func' : '',
                \ 'cmd' : '',
                \ 'exit' : 0,
                \ },
                \ ],
                \ 'right' : [
                \ {
                \ 'key' : {
                \ 'name' : 'w/u',
                \ 'pos': [[0,1], [2,3]],
                \ 'handles' : [
                \ ['w', 'Gina add %'],
                \ ['u', 'Gina reset %'],
                \ ],
                \ },
                \ 'desc' : 'stage/unstage in current file',
                \ 'func' : '',
                \ 'cmd' : '',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : ['c', 'C'],
                \ 'desc' : 'commit with popup/direct commit',
                \ 'func' : '',
                \ 'cmd' : '',
                \ 'exit' : 1,
                \ },
                \ {
                \ 'key' : ['f', 'F', 'P'],
                \ 'desc' : 'fetch/pull/push popup',
                \ 'func' : '',
                \ 'cmd' : '',
                \ 'exit' : 1,
                \ },
                \ {
                \ 'key' : ['l', 'D'],
                \ 'desc' : 'log/diff popup',
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
