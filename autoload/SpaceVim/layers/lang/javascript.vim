function! SpaceVim#layers#lang#javascript#plugins() abort
  let plugins = []
  call add(plugins,['pangloss/vim-javascript', { 'on_ft' : ['javascript']}])
  if has('nvim')
    call add(plugins,['carlitux/deoplete-ternjs',           { 'on_ft' : ['javascript']}])
  endif
  call add(plugins,['ternjs/tern_for_vim',                { 'on_ft' : ['javascript'],
        \ 'build' : 'npm install',
        \ }])
  call add(plugins,['othree/javascript-libraries-syntax.vim', { 'on_ft' : ['javascript','coffee','ls','typescript']}])
  call add(plugins,['mmalecki/vim-node.js',                   { 'on_ft' : ['javascript']}])
  call add(plugins,['othree/yajs.vim',                        { 'on_ft' : ['javascript']}])
  call add(plugins,['othree/es.next.syntax.vim',              { 'on_ft' : ['javascript']}])
  call add(plugins,['maksimr/vim-jsbeautify',                 { 'on_ft' : ['javascript']}])
  return plugins
endfunction

function! SpaceVim#layers#lang#javascript#config() abort
  call SpaceVim#mapping#gd#add('javascript', function('s:gotodef'))
endfunction

function! s:gotodef() abort
  if exists(':TernDef')
    TernDef
  endif
endfunction


" vim:set et sw=2 cc=80:
