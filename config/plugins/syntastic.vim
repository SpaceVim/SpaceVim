scriptencoding utf-8
if !filereadable('pom.xml') && !filereadable('build.gradle') && isdirectory('bin')
    let g:syntastic_java_javac_options = '-d bin'
endif
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_java_javac_delete_output = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = get(g:settings, 'error_symbol', '✖')
let g:syntastic_warning_symbol = get(g:settings, 'warning_symbol', '➤')
