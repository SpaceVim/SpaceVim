""
" @section lang#elixir, layer-lang-elixir
" @parentsection layers
" @subsection Intro
" lang#elixir layer provide code completion,documentation lookup, jump to
" definition, mix integration and iex integration for elixir project. SpaceVim
" use neomake as default syntax checker which is loaded in
" @section(layer-checkers)

function! SpaceVim#layers#lang#elixir#plugins() abort
    let plugins = []
    call add(plugins, ['slashmili/alchemist.vim', {'on_ft' : 'elixir'}])
    return plugins
endfunction
