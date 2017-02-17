""
" @section lang#elixir, layer-lang-elixir
" @parentsection layers
" @subsection Intro
" The lang#elixir layer provides code completion, documentation lookup, jump to
" definition, mix integration, and iex integration for Elixir. SpaceVim
" uses neomake as default syntax checker which is loaded in
" @section(layer-checkers)

function! SpaceVim#layers#lang#elixir#plugins() abort
    let plugins = []
    call add(plugins, ['slashmili/alchemist.vim', {'on_ft' : 'elixir'}])
    return plugins
endfunction
