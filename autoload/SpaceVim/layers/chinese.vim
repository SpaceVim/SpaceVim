function! SpaceVim#layers#chinese#plugins() abort
    let plugins = [
                \ ['yianwillis/vimcdoc', {'merged' : 0}],
                \ ]
    if index(g:spacevim_plugin_groups, 'ctrlp') != -1
      call add(plugins, [['vimcn/ctrlp.cnx', {'merged' : 0}]])
    endif
    return plugins
endfunction

function! SpaceVim#layers#chinese#config() abort
    
endfunction
