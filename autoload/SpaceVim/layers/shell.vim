""
" @section shell, layer-shell
" @parentsection layers
" SpaceVim uses deol.nvim for shell support in neovim and uses vimshell for
" vim. For more info, read |deol| and |vimshell|.

function! SpaceVim#layers#shell#plugins() abort
    let plugins = []
    if has('nvim')
        call add(plugins,['Shougo/deol.nvim'])
    else
        call add(plugins,['Shougo/vimshell.vim',                { 'on_cmd':['VimShell']}])
    endif
    return plugins
endfunction
