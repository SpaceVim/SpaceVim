let g:unite_source_menu_menus =
            \ get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.CustomKeyMaps = {'description':
            \ 'Custom mapped keyboard shortcuts                   [unite]<SPACE>'}
let g:unite_source_menu_menus.CustomKeyMaps.command_candidates =
            \ get(g:unite_source_menu_menus.CustomKeyMaps,'command_candidates', [])

function! SpaceVim#mapping#def(type,key,value,desc,...) abort
    exec a:type . ' ' . a:key . ' ' . a:value
    let description = '➤ '
                \. a:desc
                \. repeat(' ', 80 - len(a:desc) - len(a:key))
                \. a:key
    let cmd = len(a:000) > 0 ? a:000[0] : a:value
    call add(g:unite_source_menu_menus.CustomKeyMaps.command_candidates, [description,cmd])
endfunction
