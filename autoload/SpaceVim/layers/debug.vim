"=============================================================================
" debug.vim --- SpaceVim debug layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

""
" @section debug, layers-debug
" @parentsection layers
" `debug` layer debug workflow for SpaceVim. All of the functionality is based
" on vebugger or vimspector.
"
" @subsection layer options
"
" 1. `debugger_plugin`: set the debug engine. It can be `vimspector` or
" `vebugger`.
"
" @subsection key bindings
" >
"   Key binding     Description
"   SPC d c	      	launch-or-continue-debugger
"   SPC d r	      	restart-debugger-with-the-same-config
"   SPC d x	      	run-to-cursor
"   SPC d p	      	pause-debugger
"   SPC d b	      	toggle-line-breakpoint
"   SPC d B	      	clear-all-breakpoints
"   SPC d o	      	step-over
"   SPC d i	      	step-into-functions
"   SPC d O	      	step-out-of-current-function
"   SPC d u	      	move-up-a-frame
"   SPC d d	      	move-down-a-frame
"   SPC d k	        terminate-the-debugger
"   SPC d e	        evaluate-cursor-symbol-or-selection
" <

let s:debugger_plugin = 'vebugger'

function! SpaceVim#layers#debug#set_variable(var) abort
  let s:debugger_plugin = get(a:var, 'debugger_plugin', '')
endfunction

function! SpaceVim#layers#debug#plugins() abort
  let plugins = []

  " @todo fork verbugger

  if s:debugger_plugin ==# 'vimspector'
    call add(plugins,['puremourning/vimspector', {'merged' : 0}])
  else
    call add(plugins,['wsdjeg/vim-debug', {'merged' : 0}])
  endif

  if g:spacevim_filemanager !=# 'vimfiler'
    call add(plugins, ['Shougo/vimproc.vim', {'build' : [(executable('gmake') ? 'gmake' : 'make')]}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#debug#health() abort
  call SpaceVim#layers#debug#plugins()
  call SpaceVim#layers#debug#config()
  return 1
endfunction

function! SpaceVim#layers#debug#config() abort

  if s:debugger_plugin ==# 'vimspector'
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'c'], 'call vimspector#Continue()', 'launch-or-continue-debugger', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'r'], 'call vimspector#Restart()', 'restart-debugger-with-the-same-config', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'x'], 'call vimspector#RunToCursor()', 'run-to-cursor', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'p'], 'call vimspector#Pause()', 'pause-debugger', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'b'], 'call vimspector#ToggleBreakpoint()', 'toggle-line-breakpoint', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'B'], 'call vimspector#ClearBreakpoints()', 'clear-all-breakpoints', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'o'], 'call vimspector#StepOver()', 'step-over', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'i'], 'call vimspector#StepInto()', 'step-into-functions', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'O'], 'call vimspector#StepOut()', 'step-out-of-current-function', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'u'], 'call vimspector#UpFrame()', 'move-up-a-frame', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'd'], 'call vimspector#DownFrame()', 'move-down-a-frame', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['d', 'k'], 'call vimspector#Stop() | VimspectorReset', 'terminate-the-debugger', 1)
    call SpaceVim#mapping#space#def('nmap', ['d', 'e'], '<Plug>VimspectorBalloonEval', 'evaluate-cursor-symbol-or-selection', 0)
    call SpaceVim#mapping#space#def('xmap', ['d', 'e'], '<Plug>VimspectorBalloonEval', 'evaluate-cursor-symbol-or-selection', 0)
  else
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
    let g:vebugger_breakpoint_text = '->'
    let g:vebugger_currentline_text = '++'
  endif

  call SpaceVim#mapping#space#def('nnoremap', ['d', '.'], 'call call('
        \ . string(s:_function('s:debug_transient_state')) . ', [])',
        \ 'debug-transient-state', 1)
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

    if s:debugger_plugin ==# 'vimspector'
      call state.defind_keys(
                  \ {
                  \ 'layout' : 'vertical split',
                  \ 'left' : [
                  \ {
                  \ 'key' : 'c',
                  \ 'desc' : 'Continue execution',
                  \ 'func' : '',
                  \ 'cmd' : 'call vimspector#Continue()',
                  \ 'exit' : 0,
                  \ },
                  \ {
                  \ 'key' : 'u',
                  \ 'desc' : 'Move up a frame',
                  \ 'func' : '',
                  \ 'cmd' : 'call vimspector#UpFrame()',
                  \ 'exit' : 0,
                  \ },
                  \ {
                  \ 'key' : 'd',
                  \ 'desc' : 'Move down a frame',
                  \ 'func' : '',
                  \ 'cmd' : 'call vimspector#DownFrame()',
                  \ 'exit' : 0,
                  \ },
                  \ ],
                  \ 'right' : [
                  \ {
                  \ 'key' : 'o',
                  \ 'desc' : 'step over',
                  \ 'func' : '',
                  \ 'cmd' : 'call vimspector#StepOver()',
                  \ 'exit' : 0,
                  \ },
                  \ {
                  \ 'key' : 'i',
                  \ 'desc' : 'step into functions',
                  \ 'func' : '',
                  \ 'cmd' : 'call vimspector#StepInto()',
                  \ 'exit' : 0,
                  \ },
                  \ {
                  \ 'key' : 'O',
                  \ 'desc' : 'step out of current function',
                  \ 'func' : '',
                  \ 'cmd' : 'call vimspector#StepOut()',
                  \ 'exit' : 0,
                  \ },
                  \ {
                  \ 'key' : 'k',
                  \ 'desc' : 'Terminates the debugger',
                  \ 'func' : '',
                  \ 'cmd' : 'call vimspector#Stop() | VimspectorReset',
                  \ 'exit' : 1,
                  \ },
                  \ ],
                  \ }
            \ )
    else
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
    endif
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
