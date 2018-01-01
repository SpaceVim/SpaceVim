function! SpaceVim#layers#cscope#plugins() abort
  let plugins = [
        \ ['SpaceVim/cscope.vim'],
        \ ]
  return plugins
endfunction


function! SpaceVim#layers#cscope#config() abort
    let g:_spacevim_mappings_space.m.c = {'name' : '+cscope'}
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'c'], 'GtagsGenerate!', 'create a gtags database', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'u'], 'GtagsGenerate', 'update tag database', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'f'], 'Unite gtags/path', 'list all file in GTAGS', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'd'], 'Unite gtags/def', 'find definitions', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'c', 'r'], 'Unite gtags/ref', 'find references', 1)
endfunction
