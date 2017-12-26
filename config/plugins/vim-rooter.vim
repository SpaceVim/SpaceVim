let g:rooter_patterns = get(g:, 'rooter_patterns', ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/'])
if index(g:spacevim_plugin_groups, 'lang#c') != -1
  call add(g:rooter_patterns, '.clang')
endif
call add(g:rooter_patterns, '.projections.json')
