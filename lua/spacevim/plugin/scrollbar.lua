--=============================================================================
-- scrollbar.lua --- scrollbar for SpaceVim
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local win = require('spacevim.api.vim.window')

local default_conf = {
  max_size = 10,
  min_size = 3,
  width = 1,
  right_offset = 1,
  excluded_filetypes = {
    'startify',
    'git-commit',
    'leaderf',
    'NvimTree',
    'tagbar',
    'defx',
    'neo-tree',
    'qf',
  },
  shape = {
    head = '▲',
    body = '█',
    tail = '▼',
  },
  highlight = {
    head = 'Normal',
    body = 'Normal',
    tail = 'Normal',
  },
}
local function get(opt)

  return default_conf[opt]

end

local scrollbar_bufnr = -1
local scrollbar_winid = -1
local scrollbar_size = -1
local ns_id = vim.api.nvim_create_namespace('scrollbar')

local function add_highlight(bufnr, size)
  local highlight = get('highlight')
  vim.api.nvim_buf_add_highlight(bufnr, ns_id, highlight.head, 0, 0, -1)
  for i = 1, size - 2 do
    vim.api.nvim_buf_add_highlight(bufnr, ns_id, highlight.body, i, 0, -1)
  end
  vim.api.nvim_buf_add_highlight(bufnr, ns_id, highlight.tail, size - 1, 0, -1)
end

local function fix_size(size)
  return math.max(get('min_size'), math.min(get('max_size'), math.floor(size + 0.5)))
end

local function gen_bar_lines(size)
  local shape = get('shape')
  local lines = { shape.head }
  for _ = 2, size - 1 do
    table.insert(lines, shape.body)
  end
  table.insert(lines, shape.tail)
  return lines
end

local function create_scrollbar_buffer(size, lines)
  if not vim.api.nvim_buf_is_valid(scrollbar_bufnr) then
    scrollbar_bufnr = vim.api.nvim_create_buf(false, true)
  end
  vim.api.nvim_buf_set_lines(scrollbar_bufnr, 0, -1, false, lines)
  add_highlight(scrollbar_bufnr, size)
  return scrollbar_bufnr
end

function M.show()
  local saved_ei = vim.o.eventignore
  vim.o.eventignore = 'all'
  local winnr = vim.fn.winnr()
  local bufnr = vim.fn.bufnr()
  local winid = vim.fn.win_getid()
  if win.is_float(winid) then
    M.clear()
    vim.o.eventignore = saved_ei
    return
  end

  local total = vim.api.nvim_buf_line_count(bufnr)
  local height = vim.fn.winheight(winnr)

  if total <= height then
    M.clear()
    vim.o.eventignore = saved_ei
    return
  end

  local curr_line = vim.fn.line('w0')
  local bar_size = fix_size(height * height / total)
  local width = vim.fn.winwidth(winnr)
  local col = width - get('width') - get('right_offset')
  local precision = height - bar_size
  local each_line = (total - height) * 1.0 / precision
  local visble_line = vim.fn.min({ curr_line, total - height + 1 })
  local row
  if each_line >= 1 then
    row = vim.fn.float2nr(visble_line / each_line)
  else
    row = vim.fn.float2nr(visble_line / each_line - 1 / each_line)
  end

  local opts = {
    style = 'minimal',
    relative = 'win',
    win = winid,
    width = get('width'),
    height = bar_size,
    row = row,
    col = vim.fn.float2nr(col),
    focusable = false,
    zindex = 10,
  }

  if win.is_float(scrollbar_winid) then
    if bar_size ~= scrollbar_size then
      scrollbar_size = bar_size
      local bar_lines = gen_bar_lines(bar_size)
      vim.api.nvim_buf_set_lines(scrollbar_bufnr, 0, -1, false, bar_lines)
      add_highlight(scrollbar_bufnr, bar_size)
    end
    vim.api.nvim_win_set_config(scrollbar_winid, opts)
  else
    scrollbar_size = bar_size
    local bar_lines = gen_bar_lines(bar_size)
    scrollbar_bufnr = create_scrollbar_buffer(bar_size, bar_lines)
    scrollbar_winid = vim.api.nvim_open_win(scrollbar_bufnr, false, opts)
    vim.fn.setwinvar(
      vim.fn.win_id2win(scrollbar_winid),
      '&winhighlight',
      'Normal:ScrollbarWinHighlight'
    )
  end
  vim.o.eventignore = saved_ei
end

function M.clear()
  if vim.api.nvim_win_is_valid(scrollbar_winid) then
    vim.api.nvim_win_close(scrollbar_winid, true)
  end
end

function M.usable()
  return true
end

return M
