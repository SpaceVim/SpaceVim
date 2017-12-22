function! SpaceVim#layers#lang#plugins() abort
    let plugins = [
                \ ['digitaltoad/vim-jade',                   { 'on_ft' : ['jade']}],
                \ ['juvenn/mustache.vim',                    { 'on_ft' : ['mustache']}],
                \ ['kchmck/vim-coffee-script',               { 'on_ft' : ['coffee']}],
                \ ['elixir-lang/vim-elixir',                 { 'on_ft' : 'elixir'}],
                \ ['PotatoesMaster/i3-vim-syntax',           { 'on_ft' : 'i3'}],
                \ ['isundil/vim-irssi-syntax',               { 'on_ft' : 'irssi'}],
                \ ['lervag/vimtex',                          { 'on_ft' : 'tex'}],
                \ ['vimperator/vimperator.vim',              { 'on_ft' : 'vimperator'}],
                \ ['voxpupuli/vim-puppet',                   {'on_ft' : 'puppet'}],
                \ ['peterhoeg/vim-qml',                      { 'on_ft' : 'qml'}],
                \ ['cespare/vim-toml',                      { 'on_ft' : 'toml'}],
                \ ] 
    return plugins
endfunction

function! SpaceVim#layers#lang#config() abort
endfunction
