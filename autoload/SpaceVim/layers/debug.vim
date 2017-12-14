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
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'o'], 'VBGstepOut', 'step out of current function', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'k'], 'VBGkill', 'Terminates the debugger', 1)
  let g:_spacevim_mappings_space.d.e = {'name' : '+Evaluate/Execute'}
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'e', 's'], 'VBGevalSelectedText', 'Evaluate and print the selected text', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'e', 'e'], 'VBGevalWordUnderCursor', 'Evaluate the <cword> under the cursor', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'e', 'S'], 'VBGexecuteSelectedText', 'Execute the selected text', 1)
endfunction

function! SpaceVim#layers#debug#launching(ft) abort
  if a:ft ==# 'python'
    exe 'VBGstartPDB ' . bufname('%')
  endif
endfunction
