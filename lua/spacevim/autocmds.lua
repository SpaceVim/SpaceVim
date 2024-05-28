--=============================================================================
-- autocmds.lua --- core autocmds for SpaceVim
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local log = require('spacevim.logger')

local create_autocmd = vim.api.nvim_create_autocmd

function M.init()
  log.debug('init spacevim_core autocmd group')
  local spacevim_core = vim.api.nvim_create_augroup('spacevim_core', { clear = true })
  if vim.g.spacevim_relativenumber == 1 then
    create_autocmd({ 'BufEnter', 'WinEnter' }, {
      pattern = { '*' },
      group = spacevim_core,
      callback = function(ev)
        if vim.o.number then
          vim.o.relativenumber = true
        end
      end,
    })
    create_autocmd({ 'BufLeave', 'WinLeave' }, {
      pattern = { '*' },
      group = spacevim_core,
      callback = function(ev)
        if vim.o.number then
          vim.o.relativenumber = false
        end
      end,
    })
  end

  if vim.g.spacevim_enable_cursorline == 1 then
    local cursorline_flag = false
    create_autocmd({ 'BufEnter', 'WinEnter', 'InsertLeave' }, {
      pattern = { '*' },
      group = spacevim_core,
      callback = function(_)
        if not cursorline_flag then
          vim.o.cursorline = true
        end
      end,
    })
  end
  if vim.g.spacevim_enable_cursorcolumn == 1 then
    create_autocmd({ 'BufEnter', 'WinEnter', 'InsertLeave' }, {
      pattern = { '*' },
      group = spacevim_core,
      callback = function(_)
        vim.api.nvim_set_option_value('cursorcolumn', true, {
          scope = 'local',
        })
      end,
    })
    create_autocmd({ 'BufLeave', 'WinLeave', 'InsertEnter' }, {
      pattern = { '*' },
      group = spacevim_core,
      callback = function(_)
        vim.api.nvim_set_option_value('cursorcolumn', false, {
          scope = 'local',
        })
      end,
    })
  end
  create_autocmd({ 'BufWritePre' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      require('spacevim.plugin.mkdir').create_current()
    end,
  })
  create_autocmd({ 'ColorScheme' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      require('spacevim.api.vim.highlight').hide_in_normal('EndOfBuffer')
      require('spacevim.api.vim.highlight').hide_in_normal('StartifyEndOfBuffer')
    end,
  })
  -- NOTE: ctags find the tags file from the current path instead of the path of currect file
  create_autocmd({ 'BufNewFile', 'BufEnter' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.cmd('set cpoptions+=d')
    end,
  })
  create_autocmd({ 'FileType' }, {
    pattern = { 'qf' },
    group = spacevim_core,
    callback = function(_)
        vim.api.nvim_set_option_value('buflisted', false, {
          scope = 'local',
        })
    end,
  })
  -- ensure every file does syntax highlighting (full)
  create_autocmd({'BufEnter'}, {
    pattern = {'*'},
    group = spacevim_core,
    callback = function(_)
      vim.cmd('syntax sync fromstart')
    end
  })
end

return M
