"=============================================================================
" colorscheme.vim --- SpaceVim colorscheme layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section colorscheme, colorscheme
" @parentsection layers
" The ldefault colorscheme for SpaceVim is gruvbox. The colorscheme can be
" changed with the `g:spacevim_colorscheme` option by adding the following
" line to your `~/.SpaceVim/init.vim`.
" >
"   let g:spacevim_colorscheme = 'solarized'
" <
"
" The following colorschemes are include in SpaceVim. If the colorscheme you
" want is not included in the list below, a PR is welcome.
"
" Also, there's one thing which everyone should know and pay attention to.
" NOT all of below colorschemes support spell check very well. For example,
" a colorscheme called atom doesn't support spell check very well.
"
" SpaceVim is not gonna fix them since these should be in charge of each author.


function! SpaceVim#layers#colorscheme#plugins() abort
  return [
        \ ['Gabirel/molokai', { 'merged' : 0 }],
        \ ['joshdick/onedark.vim', { 'merged' : 0 }],
        \ ['nanotech/jellybeans.vim', { 'merged' : 0 }],
        \ ['rakr/vim-one', { 'merged' : 0 }],
        \ ['arcticicestudio/nord-vim', { 'merged' : 0 }],
        \ ['icymind/NeoSolarized', { 'merged' : 0 }],
        \ ['w0ng/vim-hybrid', { 'merged' : 0 }],
        \ ]
  "
  " TODO:
  " \ ['mhartington/oceanic-next', { 'merged' : 0 }],
  " \ ['junegunn/seoul256.vim', { 'merged' : 0 }],
  " \ ['kabbamine/yowish.vim', { 'merged' : 0 }],
  " \ ['KeitaNakamura/neodark.vim', { 'merged' : 0 }],
  " \ ['NLKNguyen/papercolor-theme', { 'merged' : 0 }],
  " \ ['SpaceVim/FlatColor', { 'merged' : 0 }],

endfunction

let s:cs = [
      \ 'gruvbox',
      \ 'molokai',
      \ 'onedark',
      \ 'jellybeans',
      \ 'one',
      \ 'nord',
      \ 'hybrid',
      \ 'NeoSolarized',
      \ ]
let s:NUMBER = SpaceVim#api#import('data#number')

function! SpaceVim#layers#colorscheme#config() abort
  if s:random_colorscheme == 1
    let id = s:NUMBER.random(0, len(s:cs))
    let g:spacevim_colorscheme = s:cs[id]
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['T', 'n'],
        \ 'call call(' . string(s:_function('s:cycle_spacevim_theme'))
        \ . ', [])', 'cycle-spacevim-theme', 1)
endfunction

let s:random_colorscheme = 0
function! SpaceVim#layers#colorscheme#set_variable(var) abort
  let s:random_colorscheme = get(a:var, 'random-theme', 0)
endfunction


" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif
function! s:cycle_spacevim_theme() abort
  let id = s:NUMBER.random(0, len(s:cs))
  exe 'colorscheme ' . s:cs[id]
endfunction
