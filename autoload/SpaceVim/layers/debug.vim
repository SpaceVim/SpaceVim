function! SpaceVim#layers#debug#plugins() abort
  let plugins = []
  call add(plugins,['idanarye/vim-vebugger', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#debug#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'l'], 'call SpaceVim#layers#debug#launching(&ft)', 'launching debugger', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 't'], 'VBGtoggleBreakpointThisLine', 'Toggle a breakpoint for the current line', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['d', 'c'], 'VBGcontinue', 'Continue the execution', 1)
endfunction

function! SpaceVim#layers#debug#launching(ft) abort
  if a:ft ==# 'python'
    exe 'VBGstartPDB ' . bufname('%')
  endif
endfunction
