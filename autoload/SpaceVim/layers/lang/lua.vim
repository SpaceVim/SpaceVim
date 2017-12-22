""
" @section lang#lua, layer-lang-lua
" @parentsection layers
" This layer includes utilities and language-specific mappings for lua development.
"
" @subsection Mappings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         lua run
" <

function! SpaceVim#layers#lang#lua#plugins() abort
  let plugins = []
  " Improved Lua 5.3 syntax and indentation support for Vim
  call add(plugins, ['tbastos/vim-lua', {'on_ft' : 'lua'}])
  call add(plugins, ['WolfgangMehner/lua-support', {'on_ft' : 'lua'}])
  call add(plugins, ['SpaceVim/vim-luacomplete', {'on_ft' : 'lua', 'if' : has('lua')}])
  return plugins
endfunction

let s:lua_repl_command = ''

function! SpaceVim#layers#lang#lua#config() abort
  if has('lua')
    augroup spacevim_lua
      autocmd FileType lua setlocal omnifunc=luacomplete#complete
    augroup END
  endif

  call SpaceVim#mapping#space#regesit_lang_mappings('lua', funcref('s:language_specified_mappings'))
  call SpaceVim#plugins#runner#reg_runner('lua', 'lua %s')
  if !empty(s:lua_repl_command)
      call SpaceVim#plugins#repl#reg('lua',s:lua_repl_command)
  else
    if executable('luap')
      call SpaceVim#plugins#repl#reg('lua', 'luap')
    else
      call SpaceVim#plugins#repl#reg('lua', 'lua')
    endif
  endif
endfunction

function! SpaceVim#layers#lang#lua#set_variable(opt) abort
  let s:lua_repl_command = get(a:opt, 'repl_command', '') 
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

au BufEnter *.lua :LuaOutputMethod buffer
