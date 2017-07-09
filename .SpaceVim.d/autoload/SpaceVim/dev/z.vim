function! SpaceVim#dev#z#updatedoc()
 let keys = keys(g:_spacevim_mappings_z)
 let lines = []
 for key in keys
     if key == '`'
         let line = '`` z' . key . ' `` | ' . g:_spacevim_mappings_z[key][1]
     else
         let line = '`z' . key . '` | ' . g:_spacevim_mappings_z[key][1]
     endif
     call add(lines, line)
 endfor
 call append(line('.'), lines)
endfunction
