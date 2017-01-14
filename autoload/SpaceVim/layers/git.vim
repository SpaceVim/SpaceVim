function! SpaceVim#layers#git#plugins() abort
    return [
                \ ['cohama/agit.vim',                        { 'on_cmd':['Agit','AgitFile']}],
                \ ['gregsexton/gitv',                        { 'on_cmd':['Gitv']}],
                \ ['junegunn/gv.vim',               { 'on_cmd' : 'GV'}],
                \ ['lambdalisue/vim-gita',          {'on_cmd': 'Gita'}],
                \ ['tpope/vim-fugitive'],
                \ ]
endfunction


function! SpaceVim#layers#git#config() abort
    
endfunction
