""" add CtrlSpace plugin

function! SpaceVim#layers#ctrlspace#plugins() abort
    return [
          \['vim-ctrlspace/vim-ctrlspace', { 'merged' : 0, 'loadconf' : 1}],
          \]
endfunction
