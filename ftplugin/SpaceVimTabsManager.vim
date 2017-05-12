if exists('g:_SpaceVimTabsManager_ftplugin')
  finish
else
  let g:_SpaceVimTabsManager_ftplugin = 1
endif
function! SpaceVimTabsManager#statusline(...)
    if &ft ==# 'SpaceVimTabsManager'
        call airline#extensions#apply_left_override('SpaceVimTabsManager', '')
        " Alternatively, set the various w:airline_section variables
        "let w:airline_section_a = 'SpaceVimPluginManager'
        "let w:airline_section_b = ''
        "let w:airline_section_c = ''
        "let w:airline_render_left = 1
        "let w:airline_render_right = 0
    endif
endfunction
try
    call airline#add_statusline_func('SpaceVimTabsManager#statusline')
catch
endtry
