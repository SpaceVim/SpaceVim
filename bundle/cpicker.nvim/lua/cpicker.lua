--=============================================================================
-- cpicker.lua
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local winid
local bufnr

local hi = require('spacevim.api.vim.highlight')
local color = require('spacevim.api.color')
local notify = require('spacevim.api.notify')

local red = 0 -- [0, 255]
local green = 0 -- [0, 255]
local blue = 0 -- [0, 255]
local hue = 0 -- [0, 360]
local saturation = 0 -- [0, 100%]
local lightness = 0 -- [0, 100%]
local enabled_formats = {}
local increase_keys = {}
local reduce_keys = {}

local function decimalToHex(decimal)
  local hex = ''
  local hexChars = '0123456789ABCDEF'
  while decimal > 0 do
    local mod = decimal % 16
    hex = string.sub(hexChars, mod + 1, mod + 1) .. hex
    decimal = math.floor(decimal / 16)
  end
  if hex == '' then
    return '00'
  elseif #hex == 1 then
    return '0' .. hex
  else
    return hex
  end
end

local function generate_bar(n, char, m)
  return string.rep(char, math.floor(24 * n / (m or 255)))
end
local function increase_rgb_red()
  if red < 255 then
    red = red + 1
    hue, saturation, lightness = color.rgb2hsl(red, green, blue)
  end
end
local function reduce_rgb_red()
  if red > 0 then
    red = red - 1
    hue, saturation, lightness = color.rgb2hsl(red, green, blue)
  end
end
local function increase_rgb_green()
  if green < 255 then
    green = green + 1
    hue, saturation, lightness = color.rgb2hsl(red, green, blue)
  end
end
local function reduce_rgb_green()
  if green > 0 then
    green = green - 1
    hue, saturation, lightness = color.rgb2hsl(red, green, blue)
  end
end

local function increase_rgb_blue()
  if blue < 255 then
    blue = blue + 1
    hue, saturation, lightness = color.rgb2hsl(red, green, blue)
  end
end

local function reduce_rgb_blue()
  if blue > 0 then
    blue = blue - 1
    hue, saturation, lightness = color.rgb2hsl(red, green, blue)
  end
end

local function increase_hsl_h()
  if hue < 360 then
    hue = hue + 1
    red, green, blue = color.hsl2rgb(hue, saturation, lightness)
  end
end
local function reduce_hsl_h()
  if hue >= 1 then
    hue = hue - 1
  elseif hue > 0 then
    hue = 0
  end
  red, green, blue = color.hsl2rgb(hue, saturation, lightness)
end
local function increase_hsl_s()
  if saturation <= 0.99 then
    saturation = saturation + 0.01
  elseif saturation < 1 then
    saturation = 1
  end
  red, green, blue = color.hsl2rgb(hue, saturation, lightness)
end
local function reduce_hsl_s()
  if saturation >= 0.01 then
    saturation = saturation - 0.01
  elseif saturation > 0 and saturation < 0.01 then
    saturation = 0
  end
  red, green, blue = color.hsl2rgb(hue, saturation, lightness)
end
local function increase_hsl_l()
  if lightness <= 0.99 then
    lightness = lightness + 0.01
  elseif lightness < 1 then
    lightness = 1
  end
  red, green, blue = color.hsl2rgb(hue, saturation, lightness)
end
local function reduce_hsl_l()
  if lightness >= 0.01 then
    lightness = lightness - 0.01
  elseif lightness > 0 and lightness < 0.01 then
    lightness = 0
  end
  red, green, blue = color.hsl2rgb(hue, saturation, lightness)
end

local function update_buf_text()
  local rst = {}
  local r_bar = generate_bar(red, '+')
  local g_bar = generate_bar(green, '+')
  local b_bar = generate_bar(blue, '+')
  local h_bar = generate_bar(hue, '+', 360)
  local s_bar = generate_bar(saturation, '+', 1)
  local l_bar = generate_bar(lightness, '+', 1)
  if enabled_formats.all or enabled_formats.rgb then
    table.insert(rst, 'R:    ' .. string.format('%4s', red) .. ' ' .. r_bar)
    increase_keys[#rst] = increase_rgb_red
    reduce_keys[#rst] = reduce_rgb_red
    table.insert(rst, 'G:    ' .. string.format('%4s', green) .. ' ' .. g_bar)
    increase_keys[#rst] = increase_rgb_green
    reduce_keys[#rst] = reduce_rgb_green
    table.insert(rst, 'B:    ' .. string.format('%4s', blue) .. ' ' .. b_bar)
    increase_keys[#rst] = increase_rgb_blue
    reduce_keys[#rst] = reduce_rgb_blue
  end
  if enabled_formats.all or enabled_formats.hsl then
    table.insert(rst, 'H:    ' .. string.format('%4s', math.floor(hue + 0.5)) .. ' ' .. h_bar)
    increase_keys[#rst] = increase_hsl_h
    reduce_keys[#rst] = reduce_hsl_h
    table.insert(
      rst,
      'S:    ' .. string.format('%3s', math.floor(saturation * 100 + 0.5)) .. '% ' .. s_bar
    )
    increase_keys[#rst] = increase_hsl_s
    reduce_keys[#rst] = reduce_hsl_s
    table.insert(
      rst,
      'L:    ' .. string.format('%3s', math.floor(lightness * 100 + 0.5)) .. '% ' .. l_bar
    )
    increase_keys[#rst] = increase_hsl_l
    reduce_keys[#rst] = reduce_hsl_l
  end
  table.insert(rst, '')
  local r = decimalToHex(red)
  local g = decimalToHex(green)
  local b = decimalToHex(blue)
  if not vim.g.cpicker_default_format or vim.g.cpicker_default_format == 'hex' then
    table.insert(rst, '   =========' .. '  #' .. r .. g .. b)
  elseif vim.g.cpicker_default_format == 'rgb' then
    table.insert(rst, '   =========' .. string.format('  rgb(%s, %s, %s)', red, green, blue))
  elseif vim.g.cpicker_default_format == 'hsl' then
    table.insert(
      rst,
      '   ========='
        .. string.format(
          '  hsl(%s, %s%%, %s%%)',
          math.floor(hue + 0.5),
          math.floor(saturation * 100 + 0.5),
          math.floor(lightness * 100 + 0.5)
        )
    )
  elseif vim.g.cpicker_default_format == 'all' then
    table.insert(rst, '   =========' .. '  #' .. r .. g .. b)
    table.insert(rst, '   =========' .. string.format('  rgb(%s, %s, %s)', red, green, blue))
    table.insert(
      rst,
      '   ========='
        .. string.format(
          '  hsl(%s, %s%%, %s%%)',
          math.floor(hue + 0.5),
          math.floor(saturation * 100 + 0.5),
          math.floor(lightness * 100 + 0.5)
        )
    )
  end
  local color_hi = '#' .. r .. g .. b
  local normal_bg = hi.group2dict('Normal').guibg
  hi.hi({
    name = 'SpaceVimPickerCode',
    guifg = color_hi,
    guibg = normal_bg,
  })
  hi.hi({
    name = 'SpaceVimPickerNoText',
    guifg = normal_bg,
    guibg = normal_bg,
  })
  hi.hi({
    name = 'SpaceVimPickerBackground',
    guibg = color_hi,
    guifg = color_hi,
  })

  vim.api.nvim_set_option_value('modifiable', true, {
    buf = bufnr,
  })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, rst)
  vim.api.nvim_set_option_value('modifiable', false, {
    buf = bufnr,
  })
end

-- https://zenn.dev/kawarimidoll/articles/a8ac50a17477bd

local function copy_color()
  local from, to  = vim
    .regex([[#[0123456789ABCDEF]\+\|rgb(\d\+,\s\d\+,\s\d\+)\|hsl(\d\+,\s\d\+%,\s\d\+%)]])
    :match_str(vim.fn.getline('.'))
  if from then
    vim.fn.setreg('+', string.sub(vim.fn.getline('.'), from, to + 1))
    notify.notify('copyed:' .. string.sub(vim.fn.getline('.'), from, to + 1))
  end
end

local function increase()
  if increase_keys[vim.fn.line('.')] then
    increase_keys[vim.fn.line('.')]()
  end
  update_buf_text()
end

local function reduce()
  if reduce_keys[vim.fn.line('.')] then
    reduce_keys[vim.fn.line('.')]()
  end
  update_buf_text()
end

M.picker = function(formats)
  enabled_formats = {}
  for _, v in ipairs(formats) do
    enabled_formats[v] = true
  end
  if not bufnr or not vim.api.nvim_win_is_valid(bufnr) then
    bufnr = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_set_option_value('buftype', 'nofile', {
      buf = bufnr,
    })
    vim.api.nvim_set_option_value('filetype', 'spacevim_cpicker', {
      buf = bufnr,
    })
    vim.api.nvim_set_option_value('bufhidden', 'wipe', {
      buf = bufnr,
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'l', '', {
      callback = increase,
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'h', '', {
      callback = reduce,
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Right>', '', {
      callback = increase,
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Left>', '', {
      callback = reduce,
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '', {
      callback = function()
        vim.api.nvim_win_close(winid, true)
      end,
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Cr>', '', {
      callback = copy_color,
    })
  end
  if not winid or not vim.api.nvim_win_is_valid(winid) then
    winid = vim.api.nvim_open_win(bufnr, true, {
      relative = 'cursor',
      border = 'single',
      width = 40,
      height = 10,
      row = 1,
      col = 1,
    })
  end
  vim.api.nvim_set_option_value('number', false, {
    win = winid,
  })
  vim.api.nvim_set_option_value('winhighlight', 'NormalFloat:Normal,FloatBorder:WinSeparator', {
    win = winid,
  })
  vim.api.nvim_set_option_value('modifiable', false, {
    buf = bufnr,
  })
  update_buf_text()
end

return M
