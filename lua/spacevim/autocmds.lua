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

local touchpadoff

local function disable_touchpad(_)
  touchpadoff = 1
  vim.fn.system('synclient touchpadoff=1')
end

local function enable_touchpad(_)
  touchpadoff = 0
  vim.fn.system('synclient touchpadoff=0')
end

local function reload_touchpad_status(_)
  if touchpadoff == 1 then
    disable_touchpad()
  end
end

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
  create_autocmd({ 'BufEnter' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.cmd('syntax sync fromstart')
      vim.b._spacevim_project_name = vim.g._spacevim_project_name or ''
    end,
  })
  create_autocmd({ 'BufEnter' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      if vim.fn.winnr('$') == 1 and vim.o.buftype == 'quickfix' then
        vim.cmd('bd')
        vim.cmd('q')
      end
    end,
  })
  create_autocmd({ 'BufEnter', 'FileType' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.fn['SpaceVim#mapping#space#refrashLSPC']()
    end,
  })
  create_autocmd({ 'VimEnter' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.fn['SpaceVim#autocmds#VimEnter']()
    end,
  })
  create_autocmd({ 'VimLeavePre' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.fn['SpaceVim#plugins#manager#terminal']()
    end,
  })
  create_autocmd({ 'QuitPre' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.fn['SpaceVim#plugins#windowsmanager#UpdateRestoreWinInfo']()
    end,
  })
  create_autocmd({ 'WinEnter' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.fn['SpaceVim#plugins#windowsmanager#MarkBaseWin']()
    end,
  })
  create_autocmd({ 'BufLeave' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.fn['SpaceVim#plugins#history#savepos']()
    end,
  })
  create_autocmd({ 'VimEnter', 'FocusGained' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.fn['SpaceVim#plugins#history#readcache']()
    end,
  })
  create_autocmd({ 'FocusLost', 'VimLeave' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.fn['SpaceVim#plugins#history#writecache']()
    end,
  })
  create_autocmd({ 'BufReadPost' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.fn['SpaceVim#plugins#history#jumppos']()
    end,
  })

  create_autocmd({ 'BufWinLeave' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      vim.b._winview = vim.fn.winsaveview()
    end,
  })
  create_autocmd({ 'BufWinEnter' }, {
    pattern = { '*' },
    group = spacevim_core,
    callback = function(_)
      if vim.fn.exists('b:_winview') == 1 then
        vim.fn.winrestview(vim.b._winview)
      end
    end,
  })
  create_autocmd({'StdinReadPost'}, {
    pattern = {'*'},
    group = spacevim_core,
    callback = function(_)
      vim.api.nvim_create_augroup('SPwelcome', {clear = true})
    end,
  })
  create_autocmd({'SessionLoadPost'}, {
    pattern = {'*'},
    group = spacevim_core,
    callback = function(_)
      vim.g._spacevim_session_loaded = 1
    end,
  })



  if vim.fn.executable('synclient') == 1 and vim.g.spacevim_auto_disable_touchpad == 1 then
    touchpadoff = 0
    create_autocmd({ 'InsertEnter' }, {
      pattern = { '*' },
      group = spacevim_core,
      callback = disable_touchpad,
    })
    create_autocmd({ 'InsertLeave' }, {
      pattern = { '*' },
      group = spacevim_core,
      callback = enable_touchpad,
    })
    create_autocmd({ 'FocusGained' }, {
      pattern = { '*' },
      group = spacevim_core,
      callback = reload_touchpad_status,
    })
    create_autocmd({ 'FocusLost' }, {
      pattern = { '*' },
      group = spacevim_core,
      callback = function(_)
        vim.fn.system('synclient touchpadoff=0')
      end,
    })
  end
end

return M
