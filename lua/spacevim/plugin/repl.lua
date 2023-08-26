--=============================================================================
-- repl.lua --- REPL for spacevim
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local job = require('spacevim.api.job')

local log = require('spacevim.logger').derive('repl')

local lines = 0
local bufnr = -1
local status = {}
local start_time

local M = {}

local function open_windows()
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.cmd('bd ' .. bufnr)
  end
  vim.cmd('botright split __REPL__')
  local l = math.floor(vim.o.lines * 30 / 100)
  vim.cmd('resize ' .. l)
  vim.api.nvim_set_option_value('buftype', false, {
    buf = bufnr
  })
end

local function start(exe)
  lines = 0
  status = {
    is_running = true,
    is_exit = false,
    has_errors = false,
    exit_code = 0
  }

  start_time = vim.fn.reltime()
  open_windows()
  vim.api.nvim_buf_set_lines(bufnr, lines, lines + 3, false, {'[REPL executable] ' .. vim.fn.string(exe), '', string.rep('-', 20)})
end


function M.start(ft)
  
end

return M
