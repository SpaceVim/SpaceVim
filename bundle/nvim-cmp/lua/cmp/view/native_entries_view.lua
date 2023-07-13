local event = require('cmp.utils.event')
local autocmd = require('cmp.utils.autocmd')
local keymap = require('cmp.utils.keymap')
local feedkeys = require('cmp.utils.feedkeys')
local types = require('cmp.types')
local config = require('cmp.config')
local api = require('cmp.utils.api')

---@class cmp.NativeEntriesView
---@field private offset integer
---@field private items vim.CompletedItem
---@field private entries cmp.Entry[]
---@field private preselect_index integer
---@field public event cmp.Event
local native_entries_view = {}

native_entries_view.new = function()
  local self = setmetatable({}, { __index = native_entries_view })
  self.event = event.new()
  self.offset = -1
  self.items = {}
  self.entries = {}
  self.preselect_index = 0
  autocmd.subscribe('CompleteChanged', function()
    self.event:emit('change')
  end)
  return self
end

native_entries_view.ready = function(_)
  if vim.fn.pumvisible() == 0 then
    return true
  end
  return vim.fn.complete_info({ 'mode' }).mode == 'eval'
end

native_entries_view.on_change = function(self)
  if #self.entries > 0 and self.offset <= vim.api.nvim_win_get_cursor(0)[2] + 1 then
    local preselect_enabled = config.get().preselect == types.cmp.PreselectMode.Item

    local completeopt = vim.o.completeopt
    if self.preselect_index == 1 and preselect_enabled then
      vim.o.completeopt = 'menu,menuone,noinsert'
    else
      vim.o.completeopt = config.get().completion.completeopt
    end
    vim.fn.complete(self.offset, self.items)
    vim.o.completeopt = completeopt

    if self.preselect_index > 1 and preselect_enabled then
      self:preselect(self.preselect_index)
    end
  end
end

native_entries_view.open = function(self, offset, entries)
  local dedup = {}
  local items = {}
  local dedup_entries = {}
  local preselect_index = 0
  for _, e in ipairs(entries) do
    local item = e:get_vim_item(offset)
    if item.dup == 1 or not dedup[item.abbr] then
      dedup[item.abbr] = true
      table.insert(items, item)
      table.insert(dedup_entries, e)
      if preselect_index == 0 and e.completion_item.preselect then
        preselect_index = #dedup_entries
      end
    end
  end
  self.offset = offset
  self.items = items
  self.entries = dedup_entries
  self.preselect_index = preselect_index
  self:on_change()
end

native_entries_view.close = function(self)
  if api.is_insert_mode() and self:visible() then
    vim.api.nvim_select_popupmenu_item(-1, false, true, {})
  end
  self.offset = -1
  self.entries = {}
  self.items = {}
  self.preselect_index = 0
end

native_entries_view.abort = function(_)
  if api.is_suitable_mode() then
    vim.api.nvim_select_popupmenu_item(-1, true, true, {})
  end
end

native_entries_view.visible = function(_)
  return vim.fn.pumvisible() == 1
end

native_entries_view.info = function(self)
  if self:visible() then
    local info = vim.fn.pum_getpos()
    return {
      width = info.width + (info.scrollbar and 1 or 0) + (info.col == 0 and 0 or 1),
      height = info.height,
      row = info.row,
      col = info.col == 0 and 0 or info.col - 1,
    }
  end
end

native_entries_view.preselect = function(self, index)
  if self:visible() then
    if index <= #self.entries then
      vim.api.nvim_select_popupmenu_item(index - 1, false, false, {})
    end
  end
end

native_entries_view.select_next_item = function(self, option)
  local callback = function()
    self.event:emit('change')
  end
  if self:visible() then
    if (option.behavior or types.cmp.SelectBehavior.Insert) == types.cmp.SelectBehavior.Insert then
      feedkeys.call(keymap.t(string.rep('<C-n>', option.count)), 'n', callback)
    else
      feedkeys.call(keymap.t(string.rep('<Down>', option.count)), 'n', callback)
    end
  end
end

native_entries_view.select_prev_item = function(self, option)
  local callback = function()
    self.event:emit('change')
  end
  if self:visible() then
    if (option.behavior or types.cmp.SelectBehavior.Insert) == types.cmp.SelectBehavior.Insert then
      feedkeys.call(keymap.t(string.rep('<C-p>', option.count)), 'n', callback)
    else
      feedkeys.call(keymap.t(string.rep('<Up>', option.count)), 'n', callback)
    end
  end
end

native_entries_view.get_offset = function(self)
  if self:visible() then
    return self.offset
  end
  return nil
end

native_entries_view.get_entries = function(self)
  if self:visible() then
    return self.entries
  end
  return {}
end

native_entries_view.get_first_entry = function(self)
  if self:visible() then
    return self.entries[1]
  end
end

native_entries_view.get_selected_entry = function(self)
  if self:visible() then
    local idx = vim.fn.complete_info({ 'selected' }).selected
    if idx > -1 then
      return self.entries[math.max(0, idx) + 1]
    end
  end
end

native_entries_view.get_active_entry = function(self)
  if self:visible() and (vim.v.completed_item or {}).word then
    return self:get_selected_entry()
  end
end

return native_entries_view
