local cache = require('cmp.utils.cache')
local misc = require('cmp.utils.misc')
local buffer = require('cmp.utils.buffer')
local api = require('cmp.utils.api')

---@class cmp.WindowStyle
---@field public relative string
---@field public row number
---@field public col number
---@field public width number
---@field public height number
---@field public zindex number|nil

---@class cmp.Window
---@field public name string
---@field public win number|nil
---@field public swin1 number|nil
---@field public swin2 number|nil
---@field public style cmp.WindowStyle
---@field public opt table<string, any>
---@field public buffer_opt table<string, any>
---@field public cache cmp.Cache
local window = {}

---new
---@return cmp.Window
window.new = function()
  local self = setmetatable({}, { __index = window })
  self.name = misc.id('cmp.utils.window.new')
  self.win = nil
  self.swin1 = nil
  self.swin2 = nil
  self.style = {}
  self.cache = cache.new()
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
    vim.api.nvim_win_set_option(self.win, key, value)
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
    vim.api.nvim_buf_set_option(existing_buf, key, value)
  end
end

---Set style.
---@param style cmp.WindowStyle
window.set_style = function(self, style)
  if vim.o.columns and vim.o.columns <= style.col + style.width then
    style.width = vim.o.columns - style.col - 1
  end
  if vim.o.lines and vim.o.lines <= style.row + style.height then
    style.height = vim.o.lines - style.row - 1
  end
  self.style = style
  self.style.zindex = self.style.zindex or 1
end

---Return buffer id.
---@return number
window.get_buffer = function(self)
  local buf, created_new = buffer.ensure(self.name)
  if created_new then
    for k, v in pairs(self.buffer_opt) do
      vim.api.nvim_buf_set_option(buf, k, v)
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
      vim.api.nvim_win_set_option(self.win, k, v)
    end
  end
  self:update()
end

---Update
window.update = function(self)
  if self:has_scrollbar() then
    local total = self:get_content_height()
    local info = self:info()
    local bar_height = math.ceil(info.height * (info.height / total))
    local bar_offset = math.min(info.height - bar_height, math.floor(info.height * (vim.fn.getwininfo(self.win)[1].topline / total)))
    local style1 = {}
    style1.relative = 'editor'
    style1.style = 'minimal'
    style1.width = 1
    style1.height = info.height
    style1.row = info.row
    style1.col = info.col + info.width - (info.has_scrollbar and 1 or 0)
    style1.zindex = (self.style.zindex and (self.style.zindex + 1) or 1)
    if self.swin1 and vim.api.nvim_win_is_valid(self.swin1) then
      vim.api.nvim_win_set_config(self.swin1, style1)
    else
      style1.noautocmd = true
      self.swin1 = vim.api.nvim_open_win(buffer.ensure(self.name .. 'sbuf1'), false, style1)
      vim.api.nvim_win_set_option(self.swin1, 'winhighlight', 'EndOfBuffer:PmenuSbar,Normal:PmenuSbar,NormalNC:PmenuSbar,NormalFloat:PmenuSbar')
    end
    local style2 = {}
    style2.relative = 'editor'
    style2.style = 'minimal'
    style2.width = 1
    style2.height = bar_height
    style2.row = info.row + bar_offset
    style2.col = info.col + info.width - (info.has_scrollbar and 1 or 0)
    style2.zindex = (self.style.zindex and (self.style.zindex + 2) or 2)
    if self.swin2 and vim.api.nvim_win_is_valid(self.swin2) then
      vim.api.nvim_win_set_config(self.swin2, style2)
    else
      style2.noautocmd = true
      self.swin2 = vim.api.nvim_open_win(buffer.ensure(self.name .. 'sbuf2'), false, style2)
      vim.api.nvim_win_set_option(self.swin2, 'winhighlight', 'EndOfBuffer:PmenuThumb,Normal:PmenuThumb,NormalNC:PmenuThumb,NormalFloat:PmenuThumb')
    end
  else
    if self.swin1 and vim.api.nvim_win_is_valid(self.swin1) then
      vim.api.nvim_win_hide(self.swin1)
      self.swin1 = nil
    end
    if self.swin2 and vim.api.nvim_win_is_valid(self.swin2) then
      vim.api.nvim_win_hide(self.swin2)
      self.swin2 = nil
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
    if self.swin1 and vim.api.nvim_win_is_valid(self.swin1) then
      vim.api.nvim_win_hide(self.swin1)
      self.swin1 = nil
    end
    if self.swin2 and vim.api.nvim_win_is_valid(self.swin2) then
      vim.api.nvim_win_hide(self.swin2)
      self.swin2 = nil
    end
  end
end

---Return the window is visible or not.
window.visible = function(self)
  return self.win and vim.api.nvim_win_is_valid(self.win)
end

---Return the scrollbar will shown or not.
window.has_scrollbar = function(self)
  return (self.style.height or 0) < self:get_content_height()
end

---Return win info.
window.info = function(self)
  local border_width = self:get_border_width()
  local has_scrollbar = self:has_scrollbar()
  return {
    row = self.style.row,
    col = self.style.col,
    width = self.style.width + border_width + (has_scrollbar and 1 or 0),
    height = self.style.height,
    border_width = border_width,
    has_scrollbar = has_scrollbar,
  }
end

---Get border width
---@return number
window.get_border_width = function(self)
  local border = self.style.border
  if type(border) == 'table' then
    local new_border = {}
    while #new_border < 8 do
      for _, b in ipairs(border) do
        table.insert(new_border, b)
      end
    end
    border = new_border
  end

  local w = 0
  if border then
    if type(border) == 'string' then
      if border == 'single' then
        w = 2
      elseif border == 'solid' then
        w = 2
      elseif border == 'double' then
        w = 2
      elseif border == 'rounded' then
        w = 2
      elseif border == 'shadow' then
        w = 1
      end
    elseif type(border) == 'table' then
      local b4 = type(border[4]) == 'table' and border[4][1] or border[4]
      if #b4 > 0 then
        w = w + 1
      end
      local b8 = type(border[8]) == 'table' and border[8][1] or border[8]
      if #b8 > 0 then
        w = w + 1
      end
    end
  end
  return w
end

---Get scroll height.
---@return number
window.get_content_height = function(self)
  if not self:option('wrap') then
    return vim.api.nvim_buf_line_count(self:get_buffer())
  end

  return self.cache:ensure({
    'get_content_height',
    self.style.width,
    self:get_buffer(),
    vim.api.nvim_buf_get_changedtick(self:get_buffer()),
  }, function()
    local height = 0
    local buf = self:get_buffer()
    -- The result of vim.fn.strdisplaywidth depends on the buffer it was called
    -- in (see comment in cmp.Entry.get_view).
    vim.api.nvim_buf_call(buf, function()
      for _, text in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
        height = height + math.ceil(math.max(1, vim.fn.strdisplaywidth(text)) / self.style.width)
      end
    end)
    return height
  end)
end

return window
