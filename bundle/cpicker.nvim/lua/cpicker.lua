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

local enabled_formats = {}
local increase_keys = {}
local reduce_keys = {}
local color_code_regex = {}
local cursor_hl
local cursor_hl_name

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
  color_code_regex = {}
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
    .regex(table.concat(
      vim.tbl_map(function(t)
        return t[2]
      end, color_code_regex),
      '\\|'
    ))
    :match_str(vim.fn.getline('.'))
  if from then
    vim.fn.setreg('+', string.sub(vim.fn.getline('.'), from, to))
    notify.notify('copied:' .. string.sub(vim.fn.getline('.'), from, to))
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
  if cursor_hl and cursor_hl_name then
    cursor_hl.fg = color_hi
    vim.api.nvim_set_hl(0, cursor_hl_name, cursor_hl)
    util.update_color_patch(cursor_hl_name, cursor_hl)
  end
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
  if cursor_hl and cursor_hl_name then
    cursor_hl.fg = color_hi
    vim.api.nvim_set_hl(0, cursor_hl_name, cursor_hl)
    util.update_color_patch(cursor_hl_name, cursor_hl)
  end
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
    -- use set syntax instead of filetype
    -- if using filetype, when open cpicker first time the SpaceVimPickerCode syntax is cleared
    vim.api.nvim_set_option_value('syntax', 'spacevim_cpicker', {
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
  vim.api.nvim_set_option_value('wrap', false, {
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

function M.change_cursor_highlight(name, hl, formats)
  cursor_hl_name = name
  cursor_hl = hl
  M.picker(formats)
end
return M
