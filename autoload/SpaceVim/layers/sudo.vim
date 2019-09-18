"=============================================================================
" sudo.vim --- SpaceVim sudo layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#sudo#plugins() abort
  let l:plugins = []
  if has('nvim') 
    call add(l:plugins, ['lambdalisue/suda.vim'])
  endif
  return l:plugins
endfunction

function! SpaceVim#layers#sudo#config() abort
  let g:suda_startup = 0 
  if has('nvim') 
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'W'], 'call call('
          \ . string(s:_function('s:SudoWriteCurrentFile')) . ', [])',
          \ 'save buffer with sudo', 1)
    command! W call <SID>SudoWriteCurrentFile()
    cnoremap w!! W
  else 
    " http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'W'], 'write !sudo tee % >/dev/null', 'save buffer with sudo', 1)
    cnoremap w!! W
    command! W w !sudo tee % > /dev/null
  endif
endfunction

function! s:SudoWriteCurrentFile() abort
  let l:lhs = expand('%')
  try 
    let l:echo_message = suda#write(l:lhs)
    redraw | echo l:echo_message
  finally
    doautocmd BufWritePost l:lhs
    checktime
  endtry
endfunction

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
