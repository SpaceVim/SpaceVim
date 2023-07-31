--=============================================================================
-- tomlprew.lua --- toml to json
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local toml = require('spacevim.api.data.toml')

local M = {}


function M.preview()
  
  local bufnr = vim.fn.bufnr()
  local context = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n')
  local js = toml.parse(context)
  vim.cmd([[
  silent only
  rightbelow vsplit __toml_json_preview__.json
  set ft=SpaceVimTomlViewer
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixwidth
  setlocal modifiable
  ]])
  bufnr = vim.fn.bufnr()
  vim.api.nvim_buf_set_lines(bufnr, 1, -1, false, vim.split(vim.json.encode(js), '\n'))
  vim.cmd([[
  silent Neoformat! json
  setlocal nomodifiable
  set syntax=json
  ]])


end


return M
