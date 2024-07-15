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
local color_hi = '#000000'

local hi = require('spacevim.api.vim.highlight')
local notify = require('spacevim.api.notify')
local log = require('spacevim.logger').derive('cpicker')
local util = require('cpicker.util')
local color = require('spacevim.api.color')

local enabled_formats = {}
local increase_keys = {}
local reduce_keys = {}

local function update_buf_text()
  local rst = {}
  for _, format in ipairs(enabled_formats) do
    local ok, f = pcall(require, 'cpicker.formats.' .. format)
    if ok then
      local funcs = f.increase_reduce_functions()
      for i, text in ipairs(f.buf_text()) do
        table.insert(rst, text)
        increase_keys[#rst] = funcs[i][1]
        reduce_keys[#rst] = funcs[i][2]
      end
    end
  end
  table.insert(rst, '')
  local color_code_regex = {}
  for _, format in ipairs(enabled_formats) do
    local ok, f = pcall(require, 'cpicker.formats.' .. format)
    if ok then
      table.insert(rst, f.color_code() .. string.rep(' ', 20))
      table.insert(color_code_regex, { #f.color_code(), f.color_code_regex })
    end
  end
  util.update_color_code_syntax(color_code_regex)
  local normal_bg = hi.group2dict('Normal').guibg
  local normal_fg = hi.group2dict('Normal').guifg
  if
    math.abs(util.get_hsl_l(normal_bg) - util.get_hsl_l(color_hi))
    > math.abs(util.get_hsl_l(color_hi) - util.get_hsl_l(normal_fg))
  then
    hi.hi({
      name = 'SpaceVimPickerCode',
      guifg = color_hi,
      guibg = normal_bg,
      bold = 1,
    })
  else
    hi.hi({
      name = 'SpaceVimPickerCode',
      guifg = color_hi,
      guibg = normal_fg,
      bold = 1,
    })
  end
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
  vim.api.nvim_win_set_config(winid, {
    height = #rst + 1,
  })
end

-- https://zenn.dev/kawarimidoll/articles/a8ac50a17477bd

local function copy_color()
  local from, to = vim
    .regex(
      [[#[0123456789ABCDEF]\+\|rgb(\d\+,\s\d\+,\s\d\+)\|hsl(\d\+,\s\d\+%,\s\d\+%)\|hsv(\d\+,\s\d\+%,\s\d\+%)\|cmyk(\d\+%,\s\d\+%,\s\d\+%,\s\d\+%)\|hwb(\d\+,\s\d\+%,\s\d\+%)]]
    )
    :match_str(vim.fn.getline('.'))
  if from then
    vim.fn.setreg('+', string.sub(vim.fn.getline('.'), from, to + 1))
    notify.notify('copied:' .. string.sub(vim.fn.getline('.'), from, to + 1))
  end
end

local function increase()
  if increase_keys[vim.fn.line('.')] then
    local t, code = increase_keys[vim.fn.line('.')]()
    color_hi = util.get_hex_code(t, code)
    for _, format in ipairs(enabled_formats) do
      local ok, f = pcall(require, 'cpicker.formats.' .. format)
      if ok then
        f.on_change(t, code)
      end
    end
  end
  update_buf_text()
end

local function reduce()
  if reduce_keys[vim.fn.line('.')] then
    local t, code = reduce_keys[vim.fn.line('.')]()
    color_hi = util.get_hex_code(t, code)
    for _, format in ipairs(enabled_formats) do
      local ok, f = pcall(require, 'cpicker.formats.' .. format)
      if ok then
        f.on_change(t, code)
      end
    end
  end
  update_buf_text()
end

M.picker = function(formats)
  if #formats == 0 then
    enabled_formats = { 'rgb', 'hsl' }
  else
    enabled_formats = formats
  end
  log.info(vim.inspect(enabled_formats))
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
      width = 44,
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

M.set_default_color = function(hex)
  color_hi = hex
end

local color_mix_buf
local color_mix_win
local color_mix_color1
local color_mix_color2
local color_mix_color3
local color_mix_p1 = 0.5
local color_mix_p2 = 0.5

--              #FD2DAB     P1 ++++++++++
--              #282828     P2 +++++++++++++++++
--
--                ======= #383838
--                ======= rgb(123, 120, 211)
--                ======= color-mix(in srgb, #FD2DAB 20%, #282828 30%)

local function update_color_mix_buftext()
  local r1, g1, b1 = color.hex2rgb(color_mix_color1)
  local r2, g2, b2 = color.hex2rgb(color_mix_color2)
  local p1, p2
  if color_mix_p1 == 0 and color_mix_p2 == 0 then
    p1 = 0.5
    p2 = 0.5
  else
    p1 = color_mix_p1 / (color_mix_p1 + color_mix_p2)
    p2 = color_mix_p2 / (color_mix_p1 + color_mix_p2)
  end
  local r3, g3, b3 = r1 * p1 + r2 * p2, g1 * p1 + g2 * p2, b1 * p1 + b2 * p2
  color_mix_color3 = color.rgb2hex(r3, g3, b3)
  local normal_bg = hi.group2dict('Normal').guibg
  local normal_fg = hi.group2dict('Normal').guifg
  if
    math.abs(util.get_hsl_l(normal_bg) - util.get_hsl_l(color_mix_color3))
    > math.abs(util.get_hsl_l(color_mix_color3) - util.get_hsl_l(normal_fg))
  then
    hi.hi({
      name = 'SpaceVimPickerMixColor3Code',
      guifg = color_mix_color3,
      guibg = normal_bg,
      bold = 1,
    })
  else
    hi.hi({
      name = 'SpaceVimPickerMixColor3Code',
      guifg = color_mix_color3,
      guibg = normal_fg,
      bold = 1,
    })
  end
  hi.hi({
    name = 'SpaceVimPickerMixColor3Background',
    guibg = color_mix_color3,
    guifg = color_mix_color3,
  })
  local rst = {}
  table.insert(
    rst,
    '   '
      .. color_mix_color1
      .. '     '
      .. 'P1:'
      .. string.format(' %3s%%', math.floor(color_mix_p1 * 100 + 0.5))
      .. ' '
      .. util.generate_bar(color_mix_p1, '+')
  )
  table.insert(
    rst,
    '   '
      .. color_mix_color2
      .. '     '
      .. 'P2:'
      .. string.format(' %3s%%', math.floor(color_mix_p2 * 100 + 0.5))
      .. ' '
      .. util.generate_bar(color_mix_p2, '+')
  )
  table.insert(rst, ' ')
  table.insert(rst, '    =======  ' .. color_mix_color3 .. '                                       ')
  table.insert(
    rst,
    '    =======  '
      .. string.format(
        'color-mix(in srgb, %s %3s%%, %3s %3s%%)',
        color_mix_color1,
        math.floor(color_mix_p1 * 100 + 0.5),
        color_mix_color2,
        math.floor(color_mix_p2 * 100 + 0.5)
      )
  )
  vim.api.nvim_set_option_value('modifiable', true, {
    buf = color_mix_buf,
  })
  vim.api.nvim_buf_set_lines(color_mix_buf, 0, -1, false, rst)
  vim.api.nvim_set_option_value('modifiable', false, {
    buf = color_mix_buf,
  })
end

local function increase_p_f(p)
  if p <= 0.99 then
    p = p + 0.01
  elseif p < 1 then
    p = 1
  end
  return p
end

local function reduce_p_f(p)
  if p >= 0.01 then
    p = p - 0.01
  elseif p > 0 then
    p = 0
  end
  return p
end

local function increase_p()
  if vim.fn.line('.') == 1 then
    color_mix_p1 = increase_p_f(color_mix_p1)
  elseif vim.fn.line('.') == 2 then
    color_mix_p2 = increase_p_f(color_mix_p2)
  end
  update_color_mix_buftext()
end

local function reduce_p()
  if vim.fn.line('.') == 1 then
    color_mix_p1 = reduce_p_f(color_mix_p1)
  elseif vim.fn.line('.') == 2 then
    color_mix_p2 = reduce_p_f(color_mix_p2)
  end
  update_color_mix_buftext()
end

local function copy_color_mix()

  local from, to = vim
    .regex(
      [[#[0123456789ABCDEF]\+\|color-mix(in srgb, #..........................]]
    )
    :match_str(vim.fn.getline('.'))
  if from then
    vim.fn.setreg('+', string.sub(vim.fn.getline('.'), from, to + 1))
    notify.notify('copied:' .. string.sub(vim.fn.getline('.'), from, to + 1))
  end

end

M.color_mix = function(hex1, hex2)
  color_mix_color1 = hex1 or '#000000'
  color_mix_color2 = hex2 or '#FFFFFF'
  hi.hi({
    name = 'SpaceVimPickerMixColor1',
    guifg = color_mix_color1,
    bold = 1,
  })
  hi.hi({
    name = 'SpaceVimPickerMixColor2',
    guifg = color_mix_color2,
    bold = 1,
  })
  if not color_mix_buf or not vim.api.nvim_win_is_valid(color_mix_buf) then
    color_mix_buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_set_option_value('buftype', 'nofile', {
      buf = color_mix_buf,
    })
    vim.api.nvim_set_option_value('filetype', 'spacevim_cpicker_mix', {
      buf = color_mix_buf,
    })
    vim.api.nvim_set_option_value('bufhidden', 'wipe', {
      buf = color_mix_buf,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', 'l', '', {
      callback = increase_p,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', 'h', '', {
      callback = reduce_p,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', '<Right>', '', {
      callback = increase_p,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', '<Left>', '', {
      callback = reduce_p,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', 'q', '', {
      callback = function()
        vim.api.nvim_win_close(color_mix_win, true)
      end,
    })
    vim.api.nvim_buf_set_keymap(color_mix_buf, 'n', '<Cr>', '', {
      callback = copy_color_mix,
    })
  end
  if not color_mix_win or not vim.api.nvim_win_is_valid(color_mix_win) then
    color_mix_win = vim.api.nvim_open_win(color_mix_buf, true, {
      relative = 'cursor',
      border = 'single',
      width = 65,
      height = 6,
      row = 1,
      col = 1,
    })
  end
  vim.api.nvim_set_option_value('number', false, {
    win = color_mix_win,
  })
  vim.api.nvim_set_option_value('winhighlight', 'NormalFloat:Normal,FloatBorder:WinSeparator', {
    win = color_mix_win,
  })
  vim.api.nvim_set_option_value('modifiable', false, {
    buf = color_mix_buf,
  })
  update_color_mix_buftext()
end
return M
