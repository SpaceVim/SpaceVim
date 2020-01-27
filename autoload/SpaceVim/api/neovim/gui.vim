"=============================================================================
" gui.vim --- gui api for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:self = {}


function! s:self.gui_name() abort
  if !has('nvim-0.3')
    return ''
  endif

  let uis = nvim_list_uis()
  if len(uis) == 0
    echoerr 'No UIs are attached'
    return
  endif

  " Use the last UI in the list
  let ui_chan = uis[-1].chan
  let info = nvim_get_chan_info(ui_chan)
  return get(info.client, 'name', '')
endfunction


function! s:self.toggle_tabline(enable) abort
  call rpcnotify(0, 'Gui', 'Option', 'Tabline', a:enable)
endfunction

function! s:self.toggle_popupmenu(enable) abort
  call rpcnotify(0, 'Gui', 'Option', 'Popupmenu', a:enable)
endfunction

function! SpaceVim#api#neovim#gui#get() abort

  return deepcopy(s:self)

endfunction
