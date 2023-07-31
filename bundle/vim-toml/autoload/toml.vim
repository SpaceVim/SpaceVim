"=============================================================================
" toml.vim --- toml autoload plugin
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if has('nvim-0.9.0')
  function! toml#preview() abort

    lua require('spacevim.plugin.tomlprew').preview()

  endfunction

  finish
endif


let s:preview_bufnr = -1
let s:toml_bufnr = -1

let s:TOML = SpaceVim#api#import('data#toml')
let s:JSON = SpaceVim#api#import('data#json')

function! toml#preview() abort
  let s:toml_bufnr = bufnr()
  let context = join(getbufline(s:toml_bufnr, 1, "$"), "\n")
  let json_obj = s:TOML.parse(context)
  let json = s:JSON.json_encode(json_obj)
  " close other windows
  silent only
  " open preview windows
  rightbelow vsplit __toml_json_preview__.json
  set ft=SpaceVimTomlViewer
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixwidth
  let s:preview_bufnr = bufnr()
  setlocal modifiable
  call setline(1, json)
  silent Neoformat! json
  setlocal nomodifiable
  set syntax=json


endfunction
