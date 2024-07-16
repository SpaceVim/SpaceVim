--=============================================================================
-- cpicker.lua
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

if vim.api.nvim_create_user_command then
  local function complete()
    return { 'rgb', 'hsl', 'hsv', 'cmyk', 'hwb' }
  end
  vim.api.nvim_create_user_command('Cpicker', function(opt)
    require('cpicker').picker(opt.fargs)
  end, { nargs = '*', complete = complete })
  vim.api.nvim_create_user_command('CpickerCursorForeground', function(opt)
    require('cpicker.util').set_default_color(opt.fargs)
    require('cpicker').picker(opt.fargs)
  end, { nargs = '*', complete = complete })
  vim.api.nvim_create_user_command('CpickerColorMix', function(opt)
    require('cpicker.mix').color_mix(unpack(opt.fargs))
  end, { nargs = '*', complete = complete })
end
