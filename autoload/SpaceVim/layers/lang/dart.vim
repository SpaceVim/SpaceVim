function! SpaceVim#layers#lang#dart#plugins() abort
  let plugins = []
  call add(plugins, ['dart-lang/dart-vim-plugin', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#dart#config() abort
  call SpaceVim#plugins#runner#reg_runner('dart', 'dart %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('dart', funcref('s:language_specified_mappings'))
  call SpaceVim#plugins#repl#reg('dart', ['pub', 'global', 'run', 'dart_repl'])
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("dart")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
endfunction
