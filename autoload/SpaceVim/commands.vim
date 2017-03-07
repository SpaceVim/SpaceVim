function! SpaceVim#commands#load() abort
    ""
    " Load exist layer, {layers} can be a string of a layer name, or a list
    " of layer names.
    command! -nargs=+ SPLayer call SpaceVim#layers#load(<f-args>)
    ""
    " Set or check SpaceVim option. {opt} should be the option name of
    " spacevim, This command will use [value] as the value of option name.
    command! -nargs=+ SPSet call SpaceVim#options#set(<f-args>)
    ""
    " print the debug information of spacevim, [!] forces the output into a
    " new buffer.
    command! -nargs=0 -bang SPDebugInfo echo SpaceVim#logger#viewLog('<bang>' == '!')
endfunction
