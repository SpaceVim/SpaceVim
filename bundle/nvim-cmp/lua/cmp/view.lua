local config = require('cmp.config')
local async = require('cmp.utils.async')
local event = require('cmp.utils.event')
local keymap = require('cmp.utils.keymap')
local docs_view = require('cmp.view.docs_view')
local custom_entries_view = require('cmp.view.custom_entries_view')
local wildmenu_entries_view = require('cmp.view.wildmenu_entries_view')
local native_entries_view = require('cmp.view.native_entries_view')
local ghost_text_view = require('cmp.view.ghost_text_view')

---@class cmp.View
---@field public event cmp.Event
---@field private resolve_dedup cmp.AsyncDedup
---@field private native_entries_view cmp.NativeEntriesView
---@field private custom_entries_view cmp.CustomEntriesView
---@field private wildmenu_entries_view cmp.CustomEntriesView
---@field private change_dedup cmp.AsyncDedup
---@field private docs_view cmp.DocsView
---@field private ghost_text_view cmp.GhostTextView
local view = {}

---Create menu
view.new = function()
  local self = setmetatable({}, { __index = view })
  self.resolve_dedup = async.dedup()
  self.custom_entries_view = custom_entries_view.new()
  self.native_entries_view = native_entries_view.new()
  self.wildmenu_entries_view = wildmenu_entries_view.new()
  self.docs_view = docs_view.new()
  self.ghost_text_view = ghost_text_view.new()
  self.event = event.new()

  return self
end

---Return the view components are available or not.
---@return boolean
view.ready = function(self)
  return self:_get_entries_view():ready()
end

---OnChange handler.
view.on_change = function(self)
  self:_get_entries_view():on_change()
end

---Open menu
---@param ctx cmp.Context
---@param sources cmp.Source[]
view.open = function(self, ctx, sources)
  local source_group_map = {}
  for _, s in ipairs(sources) do
    local group_index = s:get_source_config().group_index or 0
    if not source_group_map[group_index] then
      source_group_map[group_index] = {}
    end
    table.insert(source_group_map[group_index], s)
  end

  local group_indexes = vim.tbl_keys(source_group_map)
  table.sort(group_indexes, function(a, b)
    return a ~= b and (a < b) or nil
  end)

  local entries = {}
  for _, group_index in ipairs(group_indexes) do
    local source_group = source_group_map[group_index] or {}

    -- check the source triggered by character
    local has_triggered_by_symbol_source = false
    for _, s in ipairs(source_group) do
      if #s:get_entries(ctx) > 0 then
        if s.is_triggered_by_symbol then
          has_triggered_by_symbol_source = true
          break
        end
      end
    end

    -- create filtered entries.
    local offset = ctx.cursor.col
    for i, s in ipairs(source_group) do
      if s.offset <= ctx.cursor.col then
        if not has_triggered_by_symbol_source or s.is_triggered_by_symbol then
          -- source order priority bonus.
          local priority = s:get_source_config().priority or ((#source_group - (i - 1)) * config.get().sorting.priority_weight)

          for _, e in ipairs(s:get_entries(ctx)) do
            e.score = e.score + priority
            table.insert(entries, e)
            offset = math.min(offset, e:get_offset())
          end
        end
      end
    end

    -- sort.
    local comparetors = config.get().sorting.comparators
    table.sort(entries, function(e1, e2)
      for _, fn in ipairs(comparetors) do
        local diff = fn(e1, e2)
        if diff ~= nil then
          return diff
        end
      end
    end)

    -- open
    if #entries > 0 then
      self:_get_entries_view():open(offset, entries)
      break
    end
  end

  -- complete_done.
  if #entries == 0 then
    self:close()
  end
end

---Close menu
view.close = function(self)
  if self:visible() then
    self.event:emit('complete_done', {
      entry = self:_get_entries_view():get_selected_entry(),
    })
  end
  self:_get_entries_view():close()
  self.docs_view:close()
  self.ghost_text_view:hide()
end

---Abort menu
view.abort = function(self)
  self:_get_entries_view():abort()
  self.docs_view:close()
  self.ghost_text_view:hide()
end

---Return the view is visible or not.
---@return boolean
view.visible = function(self)
  return self:_get_entries_view():visible()
end

---Scroll documentation window if possible.
---@param delta number
view.scroll_docs = function(self, delta)
  self.docs_view:scroll(delta)
end

---Select prev menu item.
---@param option cmp.SelectOption
view.select_next_item = function(self, option)
  self:_get_entries_view():select_next_item(option)
end

---Select prev menu item.
---@param option cmp.SelectOption
view.select_prev_item = function(self, option)
  self:_get_entries_view():select_prev_item(option)
end

---Get offset.
view.get_offset = function(self)
  return self:_get_entries_view():get_offset()
end

---Get entries.
---@return cmp.Entry[]
view.get_entries = function(self)
  return self:_get_entries_view():get_entries()
end

---Get first entry
---@param self cmp.Entry|nil
view.get_first_entry = function(self)
  return self:_get_entries_view():get_first_entry()
end

---Get current selected entry
---@return cmp.Entry|nil
view.get_selected_entry = function(self)
  return self:_get_entries_view():get_selected_entry()
end

---Get current active entry
---@return cmp.Entry|nil
view.get_active_entry = function(self)
  return self:_get_entries_view():get_active_entry()
end

---Return current configured entries_view
---@return cmp.CustomEntriesView|cmp.NativeEntriesView
view._get_entries_view = function(self)
  self.native_entries_view.event:clear()
  self.custom_entries_view.event:clear()
  self.wildmenu_entries_view.event:clear()

  local c = config.get()
  local v = self.custom_entries_view
  if (c.view and c.view.entries and (c.view.entries.name or c.view.entries)) == 'wildmenu' then
    v = self.wildmenu_entries_view
  elseif (c.view and c.view.entries and (c.view.entries.name or c.view.entries)) == 'native' then
    v = self.native_entries_view
  end
  v.event:on('change', function()
    self:on_entry_change()
  end)
  return v
end

---On entry change
view.on_entry_change = async.throttle(function(self)
  if not self:visible() then
    return
  end
  local e = self:get_selected_entry()
  if e then
    for _, c in ipairs(config.get().confirmation.get_commit_characters(e:get_commit_characters())) do
      keymap.listen('i', c, function(...)
        self.event:emit('keymap', ...)
      end)
    end
    e:resolve(vim.schedule_wrap(self.resolve_dedup(function()
      if not self:visible() then
        return
      end
      self.docs_view:open(e, self:_get_entries_view():info())
    end)))
  else
    self.docs_view:close()
  end

  e = e or self:get_first_entry()
  if e then
    self.ghost_text_view:show(e)
  else
    self.ghost_text_view:hide()
  end
end, 20)

return view
