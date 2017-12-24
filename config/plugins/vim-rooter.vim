let g:rooter_patterns = get(g:, 'rooter_patterns', [])
if index(g:spacevim_plugin_groups, 'lang#c') != -1
  call add(g:rooter_patterns, '.clang')
endif
