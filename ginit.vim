"=============================================================================
" ginit.vim --- Entry file for neovim-qt
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('g:GuiLoaded')
  if empty(g:spacevim_guifont)
    exe 'Guifont! SauceCodePro Nerd Font Mono:h11:cANSI:qDRAFT'
  else
    exe 'Guifont! ' . g:spacevim_guifont
  endif
  " As using neovim-qt by default

  " Disable gui popupmenu
  if exists(':GuiPopupmenu') == 2
    GuiPopupmenu 0
  endif

  " Disbale gui tabline
  if exists(':GuiTabline') == 2
    GuiTabline 0
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

