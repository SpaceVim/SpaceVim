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
    nnoremap <silent> <Leader>gs :Gita status<CR>
    nnoremap <silent> <Leader>gd :Gita diff<CR>
    nnoremap <silent> <Leader>gc :Gita commit<CR>
    nnoremap <silent> <Leader>gb :Gita blame<CR>
    nnoremap <silent> <Leader>gp :Gita push<CR>
endfunction
