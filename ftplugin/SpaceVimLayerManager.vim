if exists('g:_SpaceVimLayerManager_ftplugin')
  finish
else
  let g:_SpaceVimLayerManager_ftplugin = 1
endif
function! SpaceVimLayerManager#statusline(...)
    if &ft ==# 'SpaceVimLayerManager'
        call airline#extensions#apply_left_override('SpaceVimLayers', '')
        " Alternatively, set the various w:airline_section variables
        "let w:airline_section_a = 'SpaceVimPluginManager'
        "let w:airline_section_b = ''
        "let w:airline_section_c = ''
        "let w:airline_render_left = 1
        "let w:airline_render_right = 0
    endif
endfunction
try
    call airline#add_statusline_func('SpaceVimLayerManager#statusline')
catch
endtry
