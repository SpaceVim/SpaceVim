"=============================================================================
" chinese.vim --- SpaceVim chinese layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#chinese#plugins() abort
  let plugins = [
        \ ['yianwillis/vimcdoc', {'merged' : 0}],
        \ ['ianva/vim-youdao-translater', { 'on_cmd' : ['Ydv','Ydc','Yde']}],
        \ ]
  if SpaceVim#layers#isLoaded('ctrlp')
    call add(plugins, ['vimcn/ctrlp.cnx', {'merged' : 0}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#chinese#config() abort
  let g:_spacevim_mappings_space.x.g = {'name' : '+translate'}
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'g', 't'], 'Ydc', 'translate current word', 1)
  " do not load vimcdoc plugin 
  let g:loaded_vimcdoc = 1
endfunction
