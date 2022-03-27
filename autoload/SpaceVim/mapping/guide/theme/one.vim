"=============================================================================
" one.vim --- one theme for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#guide#theme#one#palette() abort
  if &background ==# 'dark'
    return [
          \ ['#2c323c', '#98c379', 114, 16],
          \ ['#abb2bf', '#3b4048', 16, 145],
          \ ['#abb2bf', '#2c323c', 16, 145],
          \ ['#2c323c', 16],
          \ ['#2c323c', '#afd7d7', 114, 152],
          \ ['#2c323c', '#ff8787', 114, 210],
          \ ['#2c323c', '#d75f5f', 114, 167],
          \ ['#2c323c', '#689d6a', 114, 72],
          \ ['#2c323c', '#8f3f71', 114, 132],
          \ ]
  else
    return [
          \ ['#fafafa', '#50a14f', 71, 255],
          \ ['#494b53', '#d3d3d3', 251, 23],
          \ ['#494b53',  '#d3d3d3', 251, 23],
          \ ['#f0f0f0', 254],
          \ ['#fafafa', '#0184bc', 255, 31],
          \ ['#fafafa', '#a626a4', 255, 127],
          \ ['#fafafa', '#a626a4', 255, 127],
          \ ['#fafafa', '#4078f2', 255, 33],
          \ ['#fafafa', '#e45649', 255, 166],
          \ ]
  endif
endfunction
