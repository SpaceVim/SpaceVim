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

function! SpaceVim#layers#lang#lua#config() abort
  if has('lua')
    augroup spacevim_lua
        autocmd FileType lua setlocal omnifunc=luacomplete#complete
    augroup END
  endif

    call SpaceVim#mapping#space#regesit_lang_mappings('lua', funcref('s:language_specified_mappings'))
endfunction

" Add language specific mappings
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'Lua', 'lua run', 1)
endfunction

au BufEnter *.lua :LuaOutputMethod buffer
