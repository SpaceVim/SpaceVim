"=============================================================================
" ginit.vim --- Entry file for neovim-qt
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('g:GuiLoaded')
  if empty(g:spacevim_guifont)
    exe 'Guifont! DejaVu Sans Mono for Powerline:h11:cANSI:qDRAFT'
  else
    exe 'Guifont! ' . g:spacevim_guifont
  endif
  if g:spacevim_colorscheme !=# '' "{{{
    try
      exec 'set background=' . g:spacevim_colorscheme_bg
      exec 'colorscheme ' . g:spacevim_colorscheme
    catch
      exec 'colorscheme '. g:spacevim_colorscheme_default
    endtry
  else
    exec 'colorscheme '. g:spacevim_colorscheme_default
  endif
endif

" vim:set et sw=2:

