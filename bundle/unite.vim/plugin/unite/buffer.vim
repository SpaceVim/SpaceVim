"=============================================================================
" FILE: buffer.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

if exists('g:loaded_unite_source_buffer')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

augroup plugin-unite-source-buffer
  autocmd!
  autocmd BufEnter,BufWinEnter,BufFilePost *
        \ call s:append(expand('<amatch>'))
augroup END

let g:loaded_unite_source_buffer = 1

function! s:append(path) abort "{{{
  if bufnr('%') != expand('<abuf>')
    return
  endif

  if !has('vim_starting') || bufname(bufnr('%')) != ''
    call unite#sources#buffer#variables#append(bufnr('%'))
  endif
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker
