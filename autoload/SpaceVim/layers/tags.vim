"=============================================================================
" tags.vim --- SpaceVim tags layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#tags#plugins() abort
  return [
        \ ['SpaceVim/gtags.vim', {'merged' : 0}],
        \ ]
endfunction

function! SpaceVim#layers#tags#config() abort
  let g:_spacevim_mappings_space.m.g = {'name' : '+gtags'}
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'c'], 'GtagsGenerate!', 'create a gtags database', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'u'], 'GtagsGenerate', 'update tag database', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'f'], 'Gtags -p', 'list all file in GTAGS', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'd'], 'exe "Gtags -d " . expand("<cword>")', 'find definitions', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'r'], 'exe "Gtags -r " . expand("<cword>")', 'find references', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 't'], 'GtagsRemind', 'pop the tags stack', 1)

  augroup spacevim_layer_tags
    autocmd!
    autocmd BufEnter *
          \   if empty(&buftype) && &filetype != 'help'
          \|      nnoremap <silent><buffer> <Leader>] :call MyTagfunc()<CR>
          \|      nnoremap <silent><buffer> <Leader>[ :call MyTagfuncBack()<CR>
          \|  endif
  augroup END
endfunction

function! MyTagfunc() abort
  exe "Gtags -d " . expand("<cword>")
endfunction

function! MyTagfuncBack() abort
  GtagsRemind
endfunction

