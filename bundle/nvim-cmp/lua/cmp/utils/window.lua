local misc = require('cmp.utils.misc')
local opt = require('cmp.utils.options')
local buffer = require('cmp.utils.buffer')
local api = require('cmp.utils.api')
local config = require('cmp.config')

---@class cmp.WindowStyle
---@field public relative string
---@field public row integer
---@field public col integer
---@field public width integer|float
---@field public height integer|float
---@field public border string|string[]|nil
---@field public zindex integer|nil

---@class cmp.Window
---@field public name string
---@field public win integer|nil
---@field public thumb_win integer|nil
---@field public sbar_win integer|nil
---@field public style cmp.WindowStyle
---@field public opt table<string, any>
---@field public buffer_opt table<string, any>
local window = {}

---new
---@return cmp.Window
window.new = function()
  local self = setmetatable({}, { __index = window })
  self.name = misc.id('cmp.utils.window.new')
  self.win = nil
  self.sbar_win = nil
  self.thumb_win = nil
  self.style = {}
  self.opt = {}
  self.buffer_opt = {}
  return self
end

---Set window option.
---NOTE: If the window already visible, immediately applied to it.
---@param key string
---@param value any
window.option = function(self, key, value)
  if vim.fn.exists('+' .. key) == 0 then
    return
  end

  if value == nil then
    return self.opt[key]
  end

  self.opt[key] = value
  if self:visible() then
    opt.win_set_option(self.win, key, value)
  end
end

---Set buffer option.
---NOTE: If the buffer already visible, immediately applied to it.
---@param key string
---@param value any
window.buffer_option = function(self, key, value)
  if vim.fn.exists('+' .. key) == 0 then
    return
  end

  if value == nil then
    return self.buffer_opt[key]
  end

  self.buffer_opt[key] = value
  local existing_buf = buffer.get(self.name)
  if existing_buf then
    opt.buf_set_option(existing_buf, key, value)
  end
end

---Set style.
---@param style cmp.WindowStyle
window.set_style = function(self, style)
  self.style = style
  local info = self:info()

  if vim.o.lines and vim.o.lines <= info.row + info.height + 1 then
    self.style.height = vim.o.lines - info.row - info.border_info.vert - 1
  end

  self.style.zindex = self.style.zindex or 1

  --- GUI clients are allowed to return fractional bounds, but we need integer
  --- bounds to open the window
  self.style.width = math.ceil(self.style.width)
  self.style.height = math.ceil(self.style.height)
end

---Return buffer id.
---@return integer
window.get_buffer = function(self)
  local buf, created_new = buffer.ensure(self.name)
  if created_new then
    for k, v in pairs(self.buffer_opt) do
      opt.buf_set_option(buf, k, v)
    end
  end
  return buf
end

---Open window
---@param style cmp.WindowStyle
window.open = function(self, style)
  if style then
    self:set_style(style)
  end

  if self.style.width < 1 or self.style.height < 1 then
    return
  end

  if self.win and vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_set_config(self.win, self.style)
  else
    local s = misc.copy(self.style)
    s.noautocmd = true
    self.win = vim.api.nvim_open_win(self:get_buffer(), false, s)
    for k, v in pairs(self.opt) do
      opt.win_set_option(self.win, k, v)
    end
  end
  self:update()
end

---Update
window.update = function(self)
  local info = self:info()
  if info.scrollable then
    -- Draw the background of the scrollbar

    if not info.border_info.visible then
      local style = {
        relative = 'editor',
        style = 'minimal',
        width = 1,
        height = self.style.height,
        row = info.row,
        col = info.col + info.width - info.scrollbar_offset, -- info.col was already contained the scrollbar offset.
        zindex = (self.style.zindex and (self.style.zindex + 1) or 1),
      }
      if self.sbar_win and vim.api.nvim_win_is_valid(self.sbar_win) then
        vim.api.nvim_win_set_config(self.sbar_win, style)
      else
        style.noautocmd = true
        self.sbar_win = vim.api.nvim_open_win(buffer.ensure(self.name .. 'sbar_buf'), false, style)
        opt.win_set_option(self.sbar_win, 'winhighlight', 'EndOfBuffer:PmenuSbar,NormalFloat:PmenuSbar')
      end
    end

    -- Draw the scrollbar thumb
    local thumb_height = math.floor(info.inner_height * (info.inner_height / self:get_content_height()) + 0.5)
    local thumb_offset = math.floor(info.inner_height * (vim.fn.getwininfo(self.win)[1].topline / self:get_content_height()))

    local style = {
      relative = 'editor',
      style = 'minimal',
      width = 1,
      height = math.max(1, thumb_height),
      row = info.row + thumb_offset + (info.border_info.visible and info.border_info.top or 0),
      col = info.col + info.width - 1, -- info.col was already added scrollbar offset.
      zindex = (self.style.zindex and (self.style.zindex + 2) or 2),
    }
    if self.thumb_win and vim.api.nvim_win_is_valid(self.thumb_win) then
      vim.api.nvim_win_set_config(self.thumb_win, style)
    else
      style.noautocmd = true
      self.thumb_win = vim.api.nvim_open_win(buffer.ensure(self.name .. 'thumb_buf'), false, style)
      opt.win_set_option(self.thumb_win, 'winhighlight', 'EndOfBuffer:PmenuThumb,NormalFloat:PmenuThumb')
    end
  else
    if self.sbar_win and vim.api.nvim_win_is_valid(self.sbar_win) then
      vim.api.nvim_win_hide(self.sbar_win)
      self.sbar_win = nil
    end
    if self.thumb_win and vim.api.nvim_win_is_valid(self.thumb_win) then
      vim.api.nvim_win_hide(self.thumb_win)
      self.thumb_win = nil
    end
  end

  -- In cmdline, vim does not redraw automatically.
  if api.is_cmdline_mode() then
    vim.api.nvim_win_call(self.win, function()
      misc.redraw()
    end)
  end
end

---Close window
window.close = function(self)
  if self.win and vim.api.nvim_win_is_valid(self.win) then
    if self.win and vim.api.nvim_win_is_valid(self.win) then
      vim.api.nvim_win_hide(self.win)
      self.win = nil
    end
    if self.sbar_win and vim.api.nvim_win_is_valid(self.sbar_win) then
      vim.api.nvim_win_hide(self.sbar_win)
      self.sbar_win = nil
    end
    if self.thumb_win and vim.api.nvim_win_is_valid(self.thumb_win) then
      vim.api.nvim_win_hide(self.thumb_win)
      self.thumb_win = nil
    end
  end
end

---Return the window is visible or not.
window.visible = function(self)
  return self.win and vim.api.nvim_win_is_valid(self.win)
end

---Return win info.
window.info = function(self)
  local border_info = self:get_border_info()
  local scrollbar = config.get().window.completion.scrollbar
  local info = {
    row = self.style.row,
    col = self.style.col,
    width = self.style.width + border_info.left + border_info.right,
    height = self.style.height + border_info.top + border_info.bottom,
    inner_width = self.style.width,
    inner_height = self.style.height,
    border_info = border_info,
    scrollable = false,
    scrollbar_offset = 0,
  }

  if self:get_content_height() > info.inner_height and scrollbar then
    info.scrollable = true
    if not border_info.visible then
      info.scrollbar_offset = 1
      info.width = info.width + 1
    end
  end

  return info
end

---Return border information.
---@return { top: integer, left: integer, right: integer, bottom: integer, vert: integer, horiz: integer, visible: boolean }
window.get_border_info = function(self)
  local border = self.style.border
  if not border or border == 'none' then
    return {
      top = 0,
      left = 0,
      right = 0,
      bottom = 0,
      vert = 0,
      horiz = 0,
      visible = false,
    }
  end
  if type(border) == 'string' then
    if border == 'shadow' then
      return {
        top = 0,
        left = 0,
        right = 1,
        bottom = 1,
        vert = 1,
        horiz = 1,
        visible = false,
      }
    end
    return {
      top = 1,
      left = 1,
      right = 1,
      bottom = 1,
      vert = 2,
      horiz = 2,
      visible = true,
    }
  end

  local new_border = {}
  while #new_border <= 8 do
    for _, b in ipairs(border) do
      table.insert(new_border, type(b) == 'string' and b or b[1])
    end
  end
  local info = {}
  info.top = new_border[2] == '' and 0 or 1
  info.right = new_border[4] == '' and 0 or 1
  info.bottom = new_border[6] == '' and 0 or 1
  info.left = new_border[8] == '' and 0 or 1
  info.vert = info.top + info.bottom
  info.horiz = info.left + info.right
  info.visible = not (vim.tbl_contains({ '', ' ' }, new_border[2]) and vim.tbl_contains({ '', ' ' }, new_border[4]) and vim.tbl_contains({ '', ' ' }, new_border[6]) and vim.tbl_contains({ '', ' ' }, new_border[8]))
  return info
end

---Get scroll height.
---NOTE: The result of vim.fn.strdisplaywidth depends on the buffer it was called in (see comment in cmp.Entry.get_view).
---@return integer
window.get_content_height = function(self)
  if not self:option('wrap') then
    return vim.api.nvim_buf_line_count(self:get_buffer())
  end
  local height = 0
  vim.api.nvim_buf_call(self:get_buffer(), function()
    for _, text in ipairs(vim.api.nvim_buf_get_lines(self:get_buffer(), 0, -1, false)) do
      height = height + math.max(1, math.ceil(vim.fn.strdisplaywidth(text) / self.style.width))
    end
  end)
  return height
end

return window
