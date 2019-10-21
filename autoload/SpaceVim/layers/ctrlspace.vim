"=============================================================================
" ctrlspace.vim --- SpaceVim CtrlSpace layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Jethro Cao < jethrocao at gmail dot com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" Layer Options:
" mapping_key - main keybinding for invoking CtrlSpace
" autosave_ws - autosave current workspace on exit & switch
" autoload_ws - autoload last workspace on start



" Use the following default settings
if has('nvim') 
  " Neovim requires adding trailing space to the map key; 
  " see project page on GitHub for explanation
  s:mapping_key = '<C-Space >'
else
  s:mapping_key = '<C-Space>'
endif
s:autosave_ws = 1
s:autoload_ws = 0
" TODO: confirm true/false in TOML are mapped correctly to 1/0



function! SpaceVim#layers#ctrlspace#plugins() abort
    return [
          \['vim-ctrlspace/vim-ctrlspace', { 'merged' : 0, 'loadconf' : 1}],
          \]
endfunction



function! SpaceVim#layers#ctrlspace#set_variable(var) abort
  let s:mapping_key = get(a:var, 'mapping_key', s:mapping_key)
  let s:autosave_ws = get(a:var, 'autosave_ws', s:autosave_ws)
  let s:autoload_ws = get(a:var, 'autoload_ws', s:autoload_ws)
endfunction



function! SpaceVim#layers#ctrlspace#config() abort
  " configure the plugin's main options
  let g:CtrlSpaceDefaultMappingKey = s:mapping_key
  let g:CtrlSpaceSaveWorkspaceOnExit = s:autosave_ws
  let g:CtrlSpaceSaveWorkspaceOnSwitch = s:autosave_ws
  let g:CtrlSpaceLoadLastWorkspaceOnStart = s:autoload_ws

  " TODO: configure glob command based on g:spacevim_search_tools
  if executable("rg")
    let g:CtrlSpaceGlobCommand = 'rg --color=never --files'
  elseif executable("ag")
    let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
  else
    let g:CtrlSpaceGlobCommand = ''
    let l:warn_msg = "no suitable grepping tool found, using Vim globpath() to collect files; please install rg or ag"
    call SpaceVim#logger#warn(l:warn_msg)
  endif

  " TODO: implement [SPC] keybinds
endfunction
