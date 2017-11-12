function! SpaceVim#layers#lang#javascript#plugins() abort
  return [
      \ ['chrisbra/vim-zsh', { 'on_ft' : 'zsh' }]
      \ ]
endfunction

function! SpaceVim#layers#lang#sh#config()
    call SpaceVim#layers#edit#add_ft_head_tamplate('sh',
                \ ['#!/usr/bin/env bash',
                \ '']
                \ )
  call SpaceVim#layers#edit#add_ft_head_tamplate('zsh', [
      \ '#!/usr/bin/env zsh',
      \ ''
      \ ])
endfunction
