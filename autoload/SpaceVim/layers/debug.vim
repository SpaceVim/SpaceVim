"=============================================================================
" debug.vim --- SpaceVim debug layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

function! SpaceVim#layers#debug#plugins() abort
  let plugins = []
  " @todo fork verbugger
  call add(plugins,['wsdjeg/vim-debug', {'merged' : 0}])
  if g:spacevim_filemanager !=# 'vimfiler'
    call add(plugins, ['Shougo/vimproc.vim', {'build' : [(executable('gmake') ? 'gmake' : 'make')]}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#debug#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'l'], 'call SpaceVim#layers#debug#launching(&ft)', 'launching-debugger', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'b'], 'VBGtoggleBreakpointThisLine', 'toggle-line-breakpoint', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'B'], 'VBGclearBreakpoints', 'clear-all-breakpoints', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'c'], 'VBGcontinue', 'continue-the-execution', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'o'], 'VBGstepOver', 'step-over', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'i'], 'VBGstepIn', 'step-into-functions', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'O'], 'VBGstepOut', 'step-out-of-current-function', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'k'], 'VBGkill', 'terminates-the-debugger', 1)
  let g:_spacevim_mappings_space.d.e = {'name' : '+Evaluate/Execute'}
  call SpaceVim#mapping#space#def('vnoremap', ['d', 'e', 's'], 'VBGevalSelectedText', 'evaluate-selected-text', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'e', 'e'], 'VBGevalWordUnderCursor', 'evaluate-cursor-symbol', 1)
  call SpaceVim#mapping#space#def('vnoremap', ['d', 'e', 'S'], 'VBGexecuteSelectedText', 'execute-selected-text', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', '.'], 'call call('
        \ . string(s:_function('s:debug_transient_state')) . ', [])',
        \ 'debug-transient-state', 1)
  let g:vebugger_breakpoint_text = '->'
  let g:vebugger_currentline_text = '++'
endfunction

function! SpaceVim#layers#debug#launching(ft) abort
  if a:ft ==# 'python'
    exe 'VBGstartPDB ' . bufname('%')
  elseif a:ft ==# 'ruby'
    exe 'VBGstartRDebug ' . bufname('%')
  elseif a:ft ==# 'powershell'
    exe 'VBGstartPowerShell ' . bufname('%')
  else
    echohl WarningMsg
    echo 'read :h vebugger-launching'
    echohl None
  endif
endfunction

function! s:debug_transient_state() abort
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
