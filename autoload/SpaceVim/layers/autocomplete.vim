function! SpaceVim#layers#autocomplete#plugins() abort
    return [
                \ ['honza/vim-snippets', {'on_i' : 1, 'loadconf_before' : 1}],
                \ ['Shougo/neco-syntax',           { 'on_i' : 1}],
                \ ['ujihisa/neco-look',            { 'on_i' : 1}],
                \ ['Shougo/neco-vim',              { 'on_i' : 1, 'loadconf_before' : 1}],
                \ ['Shougo/context_filetype.vim',  { 'on_i' : 1}],
                \ ['Shougo/neoinclude.vim',        { 'on_i' : 1}],
                \ ['Shougo/neosnippet-snippets',   { 'merged' : 0}],
                \ ['Shougo/neopairs.vim',          { 'on_i' : 1}],
                \ ]
endfunction
