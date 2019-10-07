"=============================================================================
" lua.vim --- SpaceVim lang#lua layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#lua, layer-lang-lua
" @parentsection layers
" This layer includes utilities and language-specific mappings for lua development.
" >
"   [[layers]]
"     name = 'lang#lua'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current script
"   normal          SPC l b         compile current file
" <
"
" This layer also provides REPL support for lua, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#lua#plugins() abort
  let plugins = []
  " Improved Lua 5.3 syntax and indentation support for Vim
  call add(plugins, ['wsdjeg/vim-lua', {'on_ft' : 'lua'}])
  call add(plugins, ['WolfgangMehner/lua-support', {'on_ft' : 'lua'}])
  return plugins
endfunction

let s:lua_repl_command = ''
let s:lua_foldmethod = 'manual'

function! SpaceVim#layers#lang#lua#config() abort

  augroup spacevim_lang_lua
    autocmd!
    autocmd FileType lua set comments=f:--
    autocmd FileType lua let &l:foldmethod=s:lua_foldmethod
  augroup END
  call SpaceVim#mapping#space#regesit_lang_mappings('lua', function('s:language_specified_mappings'))
  let luaexe = filter(['lua53', 'lua52', 'lua51'], 'executable(v:val)')
  let exe_lua = empty(luaexe) ? 'lua' : luaexe[0]
  call SpaceVim#plugins#runner#reg_runner('lua', {
        \ 'exe' : exe_lua,
        \ 'opt' : ['-'],
        \ 'usestdin' : 1,
        \ })
  let g:neomake_lua_enabled_makers = ['luac']
  let luacexe = filter(['luac53', 'luac52', 'luac51'], 'executable(v:val)')
  let exe_luac = empty(luacexe) ? 'luac' : luacexe[0]
  let g:neomake_lua_luac_maker = {
        \ 'exe': exe_luac,
        \ 'args': ['-p'],
        \ 'errorformat': '%*\f: %#%f:%l: %m',
        \ }
  if !empty(s:lua_repl_command)
    let lua_repl = s:lua_repl_command
  elseif executable('luap')
    let lua_repl = 'luap'
  elseif !empty(luaexe)
    let lua_repl = luaexe + ['-i']
  else
    let lua_repl = ['lua', '-i']
  endif
  call SpaceVim#plugins#repl#reg('lua', lua_repl)
endfunction

function! SpaceVim#layers#lang#lua#set_variable(opt) abort
  let s:lua_repl_command = get(a:opt, 'repl_command', '') 
  let s:lua_foldmethod = get(a:opt, 'foldmethod', 'manual')
endfunction

" Add language specific mappings
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','b'], 'LuaCompile', 'lua compile', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','f'], 'Neoformat', 'format current file', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("lua")',
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
