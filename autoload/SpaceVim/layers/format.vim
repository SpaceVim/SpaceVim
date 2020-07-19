"=============================================================================
" format.vim --- format Layer file for SpaceVim
" Copyright (c) 2012-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section format, layer-format
" @parentsection layers
" SpaceVim uses neoformat as the default code format tools. Neoformat uses a
" variety of formatters for many filetypes. for more info see |neoformat|
" if you want to run a formatter on save, just put this config into bootstrap
" function.
" >
"   augroup fmt
"   autocmd!
"   autocmd BufWritePre * undojoin | Neoformat
"   augroup END
" <

function! SpaceVim#layers#format#plugins() abort
    return [
                \ [g:_spacevim_root_dir . 'bundle/neoformat', {'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}],
                \ ]
endfunction

function! SpaceVim#layers#format#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'f'], 'Neoformat', 'format-code', 1)
endfunction
