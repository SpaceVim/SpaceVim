"=============================================================================
" FILE: neomru.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

if exists('g:loaded_neomru')
      \ || ($SUDO_USER != '' && $USER !=# $SUDO_USER
      \     && $HOME !=# expand('~'.$USER)
      \     && $HOME ==# expand('~'.$SUDO_USER))
  finish
endif

command! NeoMRUReload call neomru#_reload()
command! NeoMRUSave call neomru#_save()

command! -nargs=? -complete=file NeoMRUImportFile
      \ call neomru#_import_file(<q-args>)
command! -nargs=? -complete=file NeoMRUImportDirectory
      \ call neomru#_import_directory(<q-args>)

augroup neomru
  autocmd!
  autocmd BufEnter,VimEnter,BufWinEnter,BufWritePost *
        \ call s:append(expand('<amatch>'))
  autocmd VimLeavePre *
        \ call neomru#_save({'event' : 'VimLeavePre'})
augroup END

let g:loaded_neomru = 1

function! s:append(path) abort
  if bufnr('%') != expand('<abuf>')
        \ || a:path == ''
    return
  endif

  call neomru#_append()
endfunction
