"=============================================================================
" FILE: window.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

if exists('g:loaded_unite_source_window')
      \ || ($SUDO_USER != '' && $USER !=# $SUDO_USER
      \     && $HOME !=# expand('~'.$USER)
      \     && $HOME ==# expand('~'.$SUDO_USER))
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

augroup plugin-unite-source-window
  autocmd!
  autocmd WinEnter,BufWinEnter * call s:append()
augroup END

let g:loaded_unite_source_window = 1

function! s:append() abort "{{{
  if &filetype == 'unite'
    " Ignore unite window.
    return
  endif

  " Save unite window information.
  let w:unite_window = {
        \ 'time' : localtime(),
        \ 'cwd' : getcwd(),
        \}
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker
