"=============================================================================
" ctrlspace.vim --- SpaceVim CtrlSpace layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Jethro Cao < jethrocao at gmail dot com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" Layer Options
" home-mapping-key            : main keybinding for invoking CtrlSpace
" autosave-workspaces         : autosave current workspace on exit & switch
" autoload-workspaces         : autoload last workspace on start
" enable-spacevim-styled-keys : defines SpaceVim styled fuzzy finding keys



" Use the following default settings
if has('nvim') 
  " Neovim requires adding trailing space to the mapping key;
  " see plugin GitHub page for explanation
  let s:home_mapping_key = '<C-Space> '
else
  let s:home_mapping_key = '<C-Space>'
endif
let s:autosave_ws = 1
let s:autoload_ws = 0
let s:enable_spacevim_styled_keys = 0



function! SpaceVim#layers#ctrlspace#plugins() abort
    return [
          \['vim-ctrlspace/vim-ctrlspace', { 'merged' : 0 }],
          \]
endfunction



function! SpaceVim#layers#ctrlspace#set_variable(var) abort
  let s:home_mapping_key            = get(a:var, 'home-mapping-key', s:home_mapping_key)
  let s:autosave_ws                 = get(a:var, 'autosave-workspaces', s:autosave_ws)
  let s:autoload_ws                 = get(a:var, 'autoload-workspaces', s:autoload_ws)
  let s:enable_spacevim_styled_keys = get(a:var,
                                        \ 'enable-spacevim-styled-keys',
                                        \ s:enable_spacevim_styled_keys)
endfunction



function! SpaceVim#layers#ctrlspace#config() abort
  " configure CtrlSpace's main options
  let g:CtrlSpaceDefaultMappingKey        = s:home_mapping_key
  let g:CtrlSpaceSaveWorkspaceOnExit      = s:autosave_ws
  let g:CtrlSpaceSaveWorkspaceOnSwitch    = s:autosave_ws
  let g:CtrlSpaceLoadLastWorkspaceOnStart = s:autoload_ws

  " configure CtrlSpace's glob command for collecting files
  if executable("rg")
    let g:CtrlSpaceGlobCommand = 'rg --color=never --files'
  elseif executable("ag")
    let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
  else
    let g:CtrlSpaceGlobCommand = ''
    let l:info1 = "CtrlSpace: no suitable grepping tool found"
    let l:info2 = "CtrlSpace: using Vim's globpath() to collect files"
    let l:info3 = "CtrlSpace: install rg or ag for faster file collection and .gitignore respect"
    call SpaceVim#logger#info(l:info1)
    call SpaceVim#logger#info(l:info2)
    call SpaceVim#logger#info(l:info3)
  endif

  " define SpaceVim styled fuzzy finding keys for user preference/compatibility
  if s:enable_spacevim_styled_keys
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'L'], 'CtrlSpace h', 'CtrlSpace: list tab-local buffers', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'l'], 'CtrlSpace H', 'CtrlSpace: search tab-local buffers', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'B'], 'CtrlSpace a', 'CtrlSpace: list all buffers', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'b'], 'CtrlSpace A', 'CtrlSpace: search all buffers', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'F'], 'CtrlSpace |', 'CtrlSpace: list files in dir of curr buff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['f', 'f'], 'CtrlSpace |/', 'CtrlSpace: search files in dir of curr buff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['p', 'F'], 'CtrlSpace o', 'CtrlSpace: list project files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['p', 'f'], 'CtrlSpace O', 'CtrlSpace search project files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 'T'], 'CtrlSpace l', 'CtrlSpace: list tabs', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['w', 't'], 'CtrlSpace L', 'CtrlSpace: search tabs', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['p', 'W'], 'CtrlSpace w', 'CtrlSpace: list workspaces', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['p', 'w'], 'CtrlSpace W', 'CtrlSpace: search workspaces', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['p', 'B'], 'CtrlSpace b', 'CtrlSpace: list bookmarks', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['p', 'b'], 'CtrlSpace B', 'CtrlSpace: search bookmarks', 1)
  endif
endfunction
