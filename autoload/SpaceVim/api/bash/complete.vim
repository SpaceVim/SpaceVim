"=============================================================================
" complete.vim --- SpaceVim complete API for bash
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}

let s:completer = g:_spacevim_root_dir . '/autoload/SpaceVim/bin/get_complete'

let s:COP = SpaceVim#api#import('vim#compatible')

" this is for vim command completion 

" @vimlint(EVL103, 1, a:ArgLead)
" @vimlint(EVL103, 1, a:CmdLine)
" @vimlint(EVL103, 1, a:CursorPos)
function! s:self.complete(ArgLead, CmdLine, CursorPos) abort
  if a:CmdLine =~? '^\s\{0,\}\w\+$'
    return s:COP.systemlist('compgen -c ' . a:CmdLine)
  endif
  let result = s:COP.systemlist([s:completer, a:CmdLine])
  return map(result, 'substitute(v:val, "[ ]*$", "", "g")')
endfunction


" this is for vim input()

function! s:self.complete_input(ArgLead, CmdLine, CursorPos) abort
  if a:CmdLine =~? '^\s\{0,\}\w\+$'
    return s:COP.systemlist('compgen -c ' . a:CmdLine)
  endif
  let result = s:COP.systemlist([s:completer, a:CmdLine])
  if a:ArgLead ==# ''
    let result = map(result, 'a:CmdLine . v:val')
  else
    let leader = substitute(a:CmdLine, '[^ ]*$', '', 'g')
    let result = map(result, 'leader . v:val')
  endif
  return result

endfunction
" @vimlint(EVL103, 0, a:ArgLead)
" @vimlint(EVL103, 0, a:CmdLine)
" @vimlint(EVL103, 0, a:CursorPos)


function! SpaceVim#api#bash#complete#get() abort

  return deepcopy(s:self)

endfunction
