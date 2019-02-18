function! SpaceVim#dev#g#updatedoc() abort
 let keys = keys(g:_spacevim_mappings_g)
 let lines = []
 for key in keys
     if key ==# '`'
         let line = '`` g' . key . ' `` | ' . g:_spacevim_mappings_g[key][1]
     else
         let line = '`g' . key . '` | ' . g:_spacevim_mappings_g[key][1]
     endif
     call add(lines, line)
 endfor
 call append(line('.'), lines)
endfunction
