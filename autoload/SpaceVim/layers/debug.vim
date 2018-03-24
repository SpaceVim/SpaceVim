"=============================================================================
" debug.vim --- SpaceVim debug layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#debug#plugins() abort
  let plugins = []
  call add(plugins,['idanarye/vim-vebugger', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#debug#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'l'], 'call SpaceVim#layers#debug#launching(&ft)', 'launching debugger', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'b'], 'VBGtoggleBreakpointThisLine', 'Toggle a breakpoint for the current line', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'B'], 'VBGclearBreakpoints', 'Clear all breakpoints', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'c'], 'VBGcontinue', 'Continue the execution', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'o'], 'VBGstepOver', 'step over', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'i'], 'VBGstepIn', 'step into functions', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'O'], 'VBGstepOut', 'step out of current function', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'k'], 'VBGkill', 'Terminates the debugger', 1)
  let g:_spacevim_mappings_space.d.e = {'name' : '+Evaluate/Execute'}
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'e', 's'], 'VBGevalSelectedText', 'Evaluate and print the selected text', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'e', 'e'], 'VBGevalWordUnderCursor', 'Evaluate the <cword> under the cursor', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'e', 'S'], 'VBGexecuteSelectedText', 'Execute the selected text', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', '.'], 'call call('
        \ . string(s:_function('s:buffer_transient_state')) . ', [])',
        \ 'debug transient state', 1)
  let g:vebugger_breakpoint_text = '🞊'
  let g:vebugger_currentline_text = '🠲'
endfunction

function! SpaceVim#layers#debug#launching(ft) abort
  if a:ft ==# 'python'
    exe 'VBGstartPDB ' . bufname('%')
  elseif a:ft ==# 'ruby'
    exe 'VBGstartRDebug ' . bufname('%')
  else
    echohl WarningMsg
    echo 'read :h vebugger-launching'
    echohl None
  endif
endfunction

function! s:buffer_transient_state() abort
    let state = SpaceVim#api#import('transient_state') 
    call state.set_title('Debug Transient State')
    call state.defind_keys(
                \ {
                \ 'layout' : 'vertical split',
                \ 'left' : [
                \ {
                \ 'key' : 'o',
                \ 'desc' : 'step over',
                \ 'func' : '',
                \ 'cmd' : 'VBGstepOver',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : 'i',
                \ 'desc' : 'step into functions',
                \ 'func' : '',
                \ 'cmd' : 'VBGstepIn',
                \ 'exit' : 0,
                \ },
                \ ],
                \ 'right' : [
                \ {
                \ 'key' : 'O',
                \ 'desc' : 'step out of current function',
                \ 'func' : '',
                \ 'cmd' : 'VBGstepOut',
                \ 'exit' : 0,
                \ },
                \ {
                \ 'key' : 'k',
                \ 'desc' : 'Terminates the debugger',
                \ 'func' : '',
                \ 'cmd' : 'VBGkill',
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
