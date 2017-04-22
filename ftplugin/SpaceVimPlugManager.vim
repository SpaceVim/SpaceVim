function! MyPlugin(...)
    call airline#extensions#apply_left_override('SpaceVimPlugins', '')
    " Alternatively, set the various w:airline_section variables
    "let w:airline_section_a = 'SpaceVimPluginManager'
    "let w:airline_section_b = ''
    "let w:airline_section_c = ''
    "let w:airline_render_left = 1
    "let w:airline_render_right = 0
endfunction
call airline#add_statusline_func('MyPlugin')
