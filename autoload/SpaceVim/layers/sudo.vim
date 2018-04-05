"=============================================================================
" sudo.vim --- SpaceVim sudo layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#sudo#plugins() abort
  let l:plugins = []
  return l:plugins
endfunction

function! SpaceVim#layers#sudo#config() abort
  if has('nvim') 
    command! W call <SID>SudoWriteCurrentFile()
    cnoremap w!! W
  else 
    " http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'W'], 'write !sudo tee % >/dev/null', 'save buffer with sudo', 1)
    cnoremap w!! %!sudo tee > /dev/null %
    command! W w !sudo tee % > /dev/null
  endif
endfunction

" suda functions from https://github.com/lambdalisue/suda.vim/blob/master/autoload/suda.vim 
" a wrapper for system
function! s:sudoSystem(cmd, ...) abort
  let l:cmd = printf('sudo -p '''' -n %s', a:cmd)
  if &verbose
    echomsg '[suda]' l:cmd
  endif
  let l:result = a:0 ? system(l:cmd, a:1) : system(l:cmd)
  if v:shell_error == 0
    return l:result
  endif
  try
    call inputsave()
    redraw | let l:password = inputsecret('Password: ')
  finally
    call inputrestore()
  endtry
  let l:cmd = printf('sudo -p '''' -S %s', a:cmd)
  return system(l:cmd, l:password . "\n" . (a:0 ? a:1 : ''))
endfunction


" suda functions from https://github.com/lambdalisue/suda.vim/blob/master/autoload/suda.vim 
" write to a temporary file and tee to the current filename with suda
function! s:sudoWrite(path, ...) abort 
  let l:path = a:path
  let l:tempfile = tempname()
  try
    let l:path_exists = !empty(getftype(l:path))
    let l:echo_message = execute(printf(
          \ 'write %s',
          \ l:tempfile,
          \))
    let l:result = s:sudoSystem(
          \ printf('tee %s', shellescape(l:path)),
          \ join(readfile(l:tempfile, 'b'), "\n")
          \)
    if v:shell_error
      throw l:result
    endif
    " Rewrite message with a correct file name
    let l:echo_message = substitute(
          \ l:echo_message,
          \ l:tempfile,
          \ fnamemodify(l:path, ':~'),
          \ 'g',
          \)
    if l:path_exists
       let l:echo_message = substitute(l:echo_message, '\[New\] ', '', 'g')
    endif
    return substitute(l:echo_message, '^\r\?\n', '', '')
  finally
    silent call delete(l:tempfile)
  endtry
endfunction

" 
function! s:SudoWriteCurrentFile() abort
  try
    let l:lhs = expand('%')
    let l:echo_message = s:sudoWrite(l:lhs)
    redraw | echo l:echo_message
  endtry
endfunction
