function! SpaceVim#layers#lang#sh#config()
    call SpaceVim#layers#edit#add_ft_head_tamplate('sh',
                \ ['#!/usr/bin/env bash',
                \ '']
                \ )
endfunction
