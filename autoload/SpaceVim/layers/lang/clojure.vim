function! SpaceVim#layers#lang#clojure#plugins() abort
  let plugins = []
  if has('nvim')
    call add(plugins, ['clojure-vim/acid.nvim'])
    call add(plugins, ['clojure-vim/async-clj-highlight'])
  else
  endif
  return plugins
endfunction


function! SpaceVim#layers#lang#clojure#config() abort
  
endfunction
