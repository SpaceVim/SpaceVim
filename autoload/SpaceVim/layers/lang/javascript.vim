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

let s:auto_fix = 0

function! SpaceVim#layers#lang#javascript#set_variable(var) abort
   let s:auto_fix = get(a:var, 'auto_fix', s:auto_fix)
endfunction

function! SpaceVim#layers#lang#javascript#config() abort
  call SpaceVim#mapping#gd#add('javascript', function('s:gotodef'))
  if s:auto_fix
    " Only use eslint
    let g:neomake_javascript_enabled_makers = ['eslint']
    " Use the fix option of eslint
    let g:neomake_javascript_eslint_args = ['-f', 'compact', '--fix']
    au User NeomakeFinished checktime
    au FocusGained * checktime
  endif
endfunction

function! s:gotodef() abort
  if exists(':TernDef')
    TernDef
  endif
endfunction


" vim:set et sw=2 cc=80:
