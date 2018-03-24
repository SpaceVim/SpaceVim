"=============================================================================
" layers.vim --- layers public API
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section Layers, layers
"   SpaceVim support such layers:

let s:enabled_layers = []

""
" Load the {layer} you want. For all the layers SpaceVim supports, see @section(layers).
" the second argv is the layer variable.
function! SpaceVim#layers#load(layer, ...) abort
  if a:layer ==# '-l'
    call s:list_layers()
  endif
  if index(s:enabled_layers, a:layer) == -1
    call add(s:enabled_layers, a:layer)
  endif
  if a:0 == 1 && type(a:1) == 4
    try
      call SpaceVim#layers#{a:layer}#set_variable(a:1)
    catch /^Vim\%((\a\+)\)\=:E117/
    endtry
  endif
  if a:0 > 0 && type(a:1) == 1 
    for l in a:000
      call SpaceVim#layers#load(l)
    endfor
  endif
endfunction

function! SpaceVim#layers#disable(layer) abort
  let index = index(s:enabled_layers, a:layer)
  if index != -1
    call remove(s:enabled_layers, index)
  endif
endfunction

function! s:list_layers() abort
  tabnew SpaceVimLayers
  nnoremap <buffer> q :q<cr>
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell
  setf SpaceVimLayerManager
  nnoremap <silent> <buffer> q :bd<CR>
  let info = [
        \ 'SpaceVim layers:',
        \ '',
        \ ]
  call setline(1,info + s:find_layers())
  setl nomodifiable
endfunction

function! s:find_layers() abort
  let layers = SpaceVim#util#globpath(&rtp, "autoload/SpaceVim/layers/**/*.vim")
  let pattern = '/autoload/SpaceVim/layers/'
  let rst = []
  for layer in layers
    if layer =~# pattern
      let name = layer[matchend(layer, pattern):-5]
      let status = (index(s:enabled_layers, substitute(name, '/', '#','g')) != -1) ? 'loaded' : 'not loaded'
      if filereadable(expand('~/.SpaceVim/docs/layers/' . name . '.md'))
        let website = 'https://spacevim.org/layers/' . name
      else
        let website = 'no exists'
      endif
      if status == 'loaded'
        call add(rst, '+ ' . name . ':' . repeat(' ', 25 - len(name)) . status . repeat(' ', 10) . website)
      else
        call add(rst, '- ' . name . ':' . repeat(' ', 21 - len(name)) . status . repeat(' ', 10) . website)
      endif
    endif
  endfor
  return rst
endfunction

function! SpaceVim#layers#get() abort
  return s:enabled_layers
endfunction

function! SpaceVim#layers#isLoaded(layer) abort
  return index(s:enabled_layers, a:layer) != -1
endfunction



" vim:set et sw=2:
