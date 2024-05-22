--=============================================================================
-- autosave.lua --- autosave plugin
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local default_opt = {
  timeoutlen = 60 * 5 * 1000,
  backupdir = '~/.cache/SpaceVim/backup/',
  save_all_buffers = false,
  event = { 'InsertLeave', 'TextChanged' },
  filetype = {},
  filetypeExclude = {},
  buftypeExclude = {},
  bufNameExclude = {},
}

local logger = require('spacevim.logger').derive('autosave')
local f = require('spacevim.api').import('file')
local autosave_timer = -1
local M = {}

local function location_path(bufname)
  if vim.fn.empty(default_opt.backupdir) == 1 then
    return bufname
  else
    local pth = f.unify_path(default_opt.backupdir, ':p')
      .. f.path_to_fname(bufname, '+=')
      .. '.backup'
    logger.info('backup path is:' .. pth)
    return pth
  end
end

local function save_buffer(bufnr)
  if
    vim.fn.getbufvar(bufnr, '&modified') == 1
    and vim.fn.empty(vim.fn.getbufvar(bufnr, '&buftype')) == 1
    and vim.fn.filewritable(vim.fn.bufname(bufnr)) == 1
    and vim.fn.empty(vim.fn.bufname(bufnr)) == 0
  then
    local lines = vim.fn.getbufline(bufnr, 1, '$')
    local f = location_path(vim.fn.bufname(bufnr))
    local ok, rst = pcall(vim.fn.writefile, lines, f)
    if not ok then
      logger.info('failed to autosave file:' .. f)
      logger.warn(rst)
    end
    if vim.fn.empty(default_opt.backupdir) == 1 then
      vim.fn.setbufvar(bufnr, '&modified', 0)
      vim.cmd('silent checktime ' .. bufnr)
    end
  end
end

local function auto_dosave(...)
  if default_opt.save_all_buffers then
    for _, nr in ipairs(vim.fn.range(1, vim.fn.bufnr('$'))) do
      save_buffer(nr)
    end
  else
    save_buffer(vim.fn.bufnr('%'))
  end
end
local function setup_timer(_timeoutlen)
  if vim.fn.has('timers') == 0 then
    logger.warn('failed to setup timer, needs `+timers` feature!')
    return
  end
  if _timeoutlen == 0 then
    vim.fn.timer_stop(autosave_timer)
    logger.debug('disabled autosave timer!')
  end
  if _timeoutlen < 1000 or _timeoutlen > 60 * 100 * 1000 then
    local msg =
      "timeoutlen must be given in millisecods and can't be > 100*60*1000 (100 minutes) or < 1000 (1 second)"
    logger.warn(msg)
    return
  end
  vim.fn.timer_stop(autosave_timer)
  autosave_timer = vim.fn.timer_start(_timeoutlen, auto_dosave, { ['repeat'] = -1 })
  if vim.fn.empty(autosave_timer) == 0 then
    logger.debug('setup new autosave timer, timeoutlen:' .. _timeoutlen)
  end
end

local function setup_events()
  if #default_opt.event > 0 then
    vim.api.nvim_create_autocmd(default_opt.event, {
      pattern = { '*' },
      callback = auto_dosave,
    })
  end
end

function M.config(opt)
  for option, value in pairs(default_opt) do
    if opt[option] ~= nil then
      logger.debug('set option`' .. option .. '` to :' .. vim.inspect(value))
      default_opt[option] = value
    end
  end
  setup_timer(default_opt.timeoutlen)
  setup_events()
end

return M
