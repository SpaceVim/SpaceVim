--=============================================================================
-- scrollbar.lua --- scrollbar for SpaceVim
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local win = require('spacevim.api.vim.window')

local default_conf = {
  max_size = 10,
  min_size = 3,
  width = 1,
  right_offset = 1,
  excluded_filetypes = {
    'startify',
    'git-commit',
    'leaderf',
    'NvimTree',
    'tagbar',
    'defx',
    'neo-tree',
    'qf',
  },
  shape = {
    head = '▲',
    body = '█',
    tail = '▼',
  },
  highlight = {
    head = 'Normal',
    body = 'Normal',
    tail = 'Normal',
  },
}

local scrollbar_bufnr = -1
local scrollbar_winid = -1
local scrollbar_size = -1

local function get(opt) end

local function fix_size(size)
  return vim.fn.float2nr(vim.fn.max({ get('min_size'), vim.fn.min({ get('max_size'), size }) }))
end

function M.show()
  local saved_ei = vim.o.eventignore
  vim.o.eventignore = 'all'
  local winnr = vim.fn.winnr()
  local bufnr = vim.fn.bufnr()
  local winid = vim.fn.win_getid()
  if win.is_float(winid) then
    M.clear()
    vim.o.eventignore = saved_ei
    return
  end

  local total = vim.api.nvim_buf_line_count(bufnr)
  local height = vim.fn.winheight(winnr)

  if total <= height then
    M.clear()
    vim.o.eventignore = saved_ei
    return
  end

  local curr_line = vim.fn.line('w0')
  local bar_size = fix_size(height * height / total)
  local width = vim.fn.winwidth(winnr)
  local col = width - get('width') - get('right_offset')
end

return M
