"=============================================================================
" tags.vim --- SpaceVim tags layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#tags#plugins() abort
  return [
        \ ['ludovicchabant/vim-gutentags', {'merged' : 0}],
        \ ['SpaceVim/gtags.vim', {'merged' : 0}],
        \ ['tsukkee/unite-tag', {'merged' : 0}],
        \ ]
endfunction

function! SpaceVim#layers#tags#config() abort
  let g:_spacevim_mappings_space.m.g = {'name' : '+gtags'}
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'c'], 'GtagsGenerate!', 'create a gtags database', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'u'], 'GtagsGenerate', 'update tag database', 1)
  if SpaceVim#layers#isLoaded('denite')
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'f'], 'Denite gtags_path', 'list all file in GTAGS', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'd'], 'DeniteCursorWord gtags_def', 'find definitions', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'r'], 'DeniteCursorWord gtags_ref', 'find references', 1)
  elseif SpaceVim#layers#isLoaded('unite')
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'f'], 'Unite gtags/path', 'list all file in GTAGS', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'd'], 'Unite gtags/def', 'find definitions', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'r'], 'Unite gtags/ref', 'find references', 1)
  else
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'f'], 'Gtags -p', 'list all file in GTAGS', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'd'], 'exe "Gtags -d " . expand("<cword>")', 'find definitions', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'r'], 'exe "Gtags -r " . expand("<cword>")', 'find references', 1)
  endif
  augroup spacevim_layer_tags
    autocmd!
    autocmd BufEnter *
          \   if empty(&buftype) && &filetype != 'help'
          \|      nnoremap <silent><buffer> <C-]> :call MyTagfunc()<CR>
          \|      nnoremap <silent><buffer> <C-[> :call MyTagfuncBack()<CR>
          \|  endif
  augroup END
endfunction

function! MyTagfunc() abort
    mark H
    let s:MyTagfunc_flag = 1
    UniteWithCursorWord -immediately tag
endfunction

function! MyTagfuncBack() abort
    if exists('s:MyTagfunc_flag')&&s:MyTagfunc_flag
        exe "normal! `H"
        let s:MyTagfunc_flag =0
    endif
endfunction

