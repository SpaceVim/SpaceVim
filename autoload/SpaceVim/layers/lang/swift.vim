func! SpaceVim#layers#lang#swift#plugins() abort
  let plugins = []
  call add(plugins, ['keith/swift.vim', {'merged' : 0}])
  return plugins
endf
