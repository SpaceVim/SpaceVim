--=============================================================================
-- cpicker.lua
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

-- detached cpicker need this var
if not vim.g.spacevim_data_dir then
  vim.g.spacevim_data_dir = '~/.cache/'
end

if vim.api.nvim_create_user_command then
  local function complete()
    return { 'rgb', 'hsl', 'hsv', 'cmyk', 'hwb', 'linear', 'lab' }
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
  vim.api.nvim_create_user_command('CpickerCursorChangeHighlight', function(opt)
    local name, hl = require('cpicker.util').get_cursor_hl()
    require('cpicker.util').set_default_color(opt.fargs)
    require('cpicker').change_cursor_highlight(name, hl, opt.fargs)
  end, { nargs = '*', complete = complete })
  -- if vim.g.cpicker_enable_color_patch then

  local group = vim.api.nvim_create_augroup('cpicker', { clear = true })
  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    group = group,
    pattern = { '*' },
    callback = function(ev)
      require('cpicker.util').patch_color(ev.match)
    end,
  })
  require('cpicker.util').patch_color(vim.g.colors_name)
  vim.api.nvim_create_user_command('CpickerClearColorPatch', function(opt)
    require('cpicker.util').clear_color_patch()
  end, { nargs = '*', complete = complete })

  -- end
end
