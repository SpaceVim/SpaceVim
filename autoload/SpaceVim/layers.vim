""
" @section Layers, layers
"   SpaceVim support such layers:


""
" Load the {layer} you want. For all the layers SpaceVim supports, see @section(layers).
function! SpaceVim#layers#load(layer, ...) abort
  if index(g:spacevim_plugin_groups, a:layer) == -1
    call add(g:spacevim_plugin_groups, a:layer)
  endif
  if a:0 > 1
    for l in a:000
      call SpaceVim#layers#load(l)
    endfor
  endif
endfunction

" vim:set et sw=2:
