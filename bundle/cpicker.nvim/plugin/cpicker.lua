--=============================================================================
-- cpicker.lua
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

if vim.api.nvim_create_user_command then
  local function complete(...)
    return {'all', 'rgb', 'hsl'}
  end
  vim.api.nvim_create_user_command('Cpicker', function(opt)
    require('cpicker').picker(opt.fargs)

  end, { nargs = '*', complete = complete })
end
