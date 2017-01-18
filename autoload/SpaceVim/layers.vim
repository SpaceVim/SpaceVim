""
" @section Layers, layers
"   SpaceVim support such layers:


""
" Load the {layer} you want, for all the layers SpaceVim supported, see @section(layers).
function! SpaceVim#layers#load(layer) abort
    if index(g:spacevim_plugin_groups, a:layer) == -1
        call add(g:spacevim_plugin_groups, a:layer)
    endif
endfunction
