if exists('g:GuiLoaded')
  if empty(g:spacevim_guifont)
    exe 'Guifont! DejaVu Sans Mono for Powerline:h11:cANSI:qDRAFT'
  else
    exe 'Guifont! ' . g:spacevim_guifont
  endif
endif

" vim:set et sw=2:

