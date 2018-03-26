"=============================================================================
" sudo.vim --- SpaceVim sudo layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#sudo#plugins() abort
  let plugins = []
  return plugins
endfunction

function! SpaceVim#layers#sudo#config() abort
  if has('nvim') 
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'W'], 'call SudoWriteCurrentFile()', 'save buffer with sudo', 1)
    command! W call SudoWriteCurrentFile()
    cnoremap w!! :call SudoWriteCurrentFile()
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
  let cmd = printf('sudo -p '''' -n %s', a:cmd)
  if &verbose
    echomsg '[suda]' cmd
  endif
  let result = a:0 ? system(cmd, a:1) : system(cmd)
  if v:shell_error == 0
    return result
  endif
  try
    call inputsave()
    redraw | let password = inputsecret('Password: ')
  finally
    call inputrestore()
  endtry
  let cmd = printf('sudo -p '''' -S %s', a:cmd)
  return system(cmd, password . "\n" . (a:0 ? a:1 : ''))
endfunction


" suda functions from https://github.com/lambdalisue/suda.vim/blob/master/autoload/suda.vim 
" write to a temporary file and tee to the current filename with suda
function! s:sudoWrite(path, ...) abort range
  let path = a:path
  let options = extend({
        \ 'cmdarg': v:cmdarg,
        \ 'cmdbang': v:cmdbang,
        \ 'range': '',
        \}, a:0 ? a:1 : {}
        \)
  let tempfile = tempname()
  try
    let path_exists = !empty(getftype(path))
    let echo_message = execute(printf(
          \ '%swrite%s %s %s',
          \ options.range,
          \ options.cmdbang ? '!' : '',
          \ options.cmdarg,
          \ tempfile,
          \))
    let result = s:sudoSystem(
          \ printf('tee %s', shellescape(path)),
          \ join(readfile(tempfile, 'b'), "\n")
          \)
    if v:shell_error
      throw result
    endif
    " Rewrite message with a correct file name
    let echo_message = substitute(
          \ echo_message,
          \ tempfile,
          \ fnamemodify(path, ':~'),
          \ 'g',
          \)
    if path_exists
      let echo_message = substitute(echo_message, '\[New\] ', '', 'g')
    endif
    return substitute(echo_message, '^\r\?\n', '', '')
  finally
    silent call delete(tempfile)
  endtry
endfunction

" 
function! SudoWriteCurrentFile() abort
  try
    let lhs = expand('%')
    let echo_message = s:sudoWrite(lhs, {
          \ 'range': '''[,'']',
          \})
    redraw | echo echo_message
  endtry
endfunction
