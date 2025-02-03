command! -nargs=*
            \ -complete=custom,SpaceVim#commands#complete_plugin
            \ SPUpdate call SpaceVim#commands#update_plugin(<f-args>)

command! -nargs=+
            \ -complete=custom,SpaceVim#commands#complete_plugin
            \ SPReinstall call SpaceVim#commands#reinstall_plugin(<f-args>)

command! -nargs=* SPInstall call SpaceVim#commands#install_plugin(<f-args>)


command! -nargs=*
            \ -complete=custom,SpaceVim#commands#complete_plugin
            \ DeinUpdate call SpaceVim#commands#update_plugin(<f-args>)

let g:spacevim_plugin_manager_max_processes =
      \ get(g:, 'spacevim_plugin_manager_max_processes', 8)
let g:spacevim_plugin_manager =
      \ get(g:, 'spacevim_plugin_manager', 'dein')
