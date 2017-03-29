scriptencoding utf-8
if !filereadable('pom.xml') && !filereadable('build.gradle') && isdirectory('bin')
  let g:syntastic_java_javac_options = '-encoding UTF-8'
endif
let g:syntastic_java_javac_options = get(g:,'spacevim_java_javac_options', '')
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_java_javac_delete_output = 0
let g:syntastic_java_javac_options = get(g:,'spacevim_java_javac_options', '')
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = get(g:, 'spacevim_error_symbol', '✖')
let g:syntastic_warning_symbol = get(g:, 'spacevim_warning_symbol', '➤')
let g:syntastic_vimlint_options = {
      \'EVL102': 1 ,
      \'EVL103': 1 ,
      \'EVL205': 1 ,
      \'EVL105': 1 ,
      \}

" vim:set et sw=2:
