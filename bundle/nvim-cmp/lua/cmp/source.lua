local context = require('cmp.context')
local config = require('cmp.config')
local entry = require('cmp.entry')
local debug = require('cmp.utils.debug')
local misc = require('cmp.utils.misc')
local cache = require('cmp.utils.cache')
local types = require('cmp.types')
local async = require('cmp.utils.async')
local pattern = require('cmp.utils.pattern')
local char = require('cmp.utils.char')

---@class cmp.Source
---@field public id number
---@field public name string
---@field public source any
---@field public cache cmp.Cache
---@field public revision number
---@field public context cmp.Context
---@field public incomplete boolean
---@field public is_triggered_by_symbol boolean
---@field public entries cmp.Entry[]
---@field public offset number
---@field public request_offset number
---@field public status cmp.SourceStatus
---@field public complete_dedup function
local source = {}

---@alias cmp.SourceStatus "1" | "2" | "3"
source.SourceStatus = {}
source.SourceStatus.WAITING = 1
source.SourceStatus.FETCHING = 2
source.SourceStatus.COMPLETED = 3

---@return cmp.Source
source.new = function(name, s)
  local self = setmetatable({}, { __index = source })
  self.id = misc.id('cmp.source.new')
  self.name = name
  self.source = s
  self.cache = cache.new()
  self.complete_dedup = async.dedup()
  self.revision = 0
  self:reset()
  return self
end

---Reset current completion state
---@return boolean
source.reset = function(self)
  self.cache:clear()
  self.revision = self.revision + 1
  self.context = context.empty()
  self.request_offset = -1
  self.is_triggered_by_symbol = false
  self.incomplete = false
  self.entries = {}
  self.offset = -1
  self.status = source.SourceStatus.WAITING
  self.complete_dedup(function() end)
end

---Return source option
---@return cmp.SourceConfig
source.get_config = function(self)
  return config.get_source_config(self.name) or {}
end

---Get fetching time
source.get_fetching_time = function(self)
  if self.status == source.SourceStatus.FETCHING then
    return vim.loop.now() - self.context.time
  end
  return 100 * 1000 -- return pseudo time if source isn't fetching.
end

---Return filtered entries
---@param ctx cmp.Context
---@return cmp.Entry[]
source.get_entries = function(self, ctx)
  if self.offset == -1 then
    return {}
  end

  local target_entries = (function()
    local key = { 'get_entries', self.revision }
    for i = ctx.cursor.col, self.offset, -1 do
      key[3] = string.sub(ctx.cursor_before_line, 1, i)
      local prev_entries = self.cache:get(key)
      if prev_entries then
        return prev_entries
      end
    end
    return self.entries
  end)()

  local inputs = {}
  local entries = {}
  for _, e in ipairs(target_entries) do
    local o = e:get_offset()
    if not inputs[o] then
      inputs[o] = string.sub(ctx.cursor_before_line, o)
    end

    local match = e:match(inputs[o])
    e.score = match.score
    e.exact = false
    if e.score >= 1 then
      e.matches = match.matches
      e.exact = e:get_filter_text() == inputs[o] or e:get_word() == inputs[o]
      table.insert(entries, e)
    end
  end
  self.cache:set({ 'get_entries', self.revision, ctx.cursor_before_line }, entries)

  local max_item_count = self:get_config().max_item_count or 200
  local limited_entries = {}
  for _, e in ipairs(entries) do
    table.insert(limited_entries, e)
    if max_item_count and #limited_entries >= max_item_count then
      break
    end
  end
  return limited_entries
end

---Get default insert range
---@return lsp.Range|nil
source.get_default_insert_range = function(self)
  if not self.context then
    return nil
  end

  return self.cache:ensure({ 'get_default_insert_range', self.revision }, function()
    return {
      start = {
        line = self.context.cursor.row - 1,
        character = misc.to_utfindex(self.context.cursor_line, self.offset),
      },
      ['end'] = {
        line = self.context.cursor.row - 1,
        character = misc.to_utfindex(self.context.cursor_line, self.context.cursor.col),
      },
    }
  end)
end

---Get default replace range
---@return lsp.Range|nil
source.get_default_replace_range = function(self)
  if not self.context then
    return nil
  end

  return self.cache:ensure({ 'get_default_replace_range', self.revision }, function()
    local _, e = pattern.offset('^' .. '\\%(' .. self:get_keyword_pattern() .. '\\)', string.sub(self.context.cursor_line, self.offset))
    return {
      start = {
        line = self.context.cursor.row - 1,
        character = misc.to_utfindex(self.context.cursor_line, self.offset),
      },
      ['end'] = {
        line = self.context.cursor.row - 1,
        character = misc.to_utfindex(self.context.cursor_line, e and self.offset + e - 1 or self.context.cursor.col),
      },
    }
  end)
end

---Return source name.
source.get_debug_name = function(self)
  local name = self.name
  if self.source.get_debug_name then
    name = self.source:get_debug_name()
  end
  return name
end

---Return the source is available or not.
source.is_available = function(self)
  if self.source.is_available then
    return self.source:is_available()
  end
  return true
end

---Get keyword_pattern
---@return string
source.get_keyword_pattern = function(self)
  local c = self:get_config()
  if c.keyword_pattern then
    return c.keyword_pattern
  end
  if self.source.get_keyword_pattern then
    return self.source:get_keyword_pattern({
      option = self:get_config().opts,
    })
  end
  return config.get().completion.keyword_pattern
end

---Get keyword_length
---@return number
source.get_keyword_length = function(self)
  local c = self:get_config()
  if c.keyword_length then
    return c.keyword_length
  end
  return config.get().completion.keyword_length or 1
end

---Get trigger_characters
---@return string[]
source.get_trigger_characters = function(self)
  local trigger_characters = {}
  if self.source.get_trigger_characters then
    trigger_characters = self.source:get_trigger_characters({
      option = self:get_config().opts,
    }) or {}
  end
  if config.get().completion.get_trigger_characters then
    return config.get().completion.get_trigger_characters(trigger_characters)
  end
  return trigger_characters
end

---Invoke completion
---@param ctx cmp.Context
---@param callback function
---@return boolean Return true if not trigger completion.
source.complete = function(self, ctx, callback)
  local offset = ctx:get_offset(self:get_keyword_pattern())
  if ctx.cursor.col <= offset then
    self:reset()
  end

  local before_char = string.sub(ctx.cursor_before_line, -1)
  local before_char_iw = string.match(ctx.cursor_before_line, '(.)%s*$') or before_char

  if ctx:get_reason() == types.cmp.ContextReason.TriggerOnly then
    if string.match(before_char, '^%a+$') then
      before_char = ''
    end
    if string.match(before_char_iw, '^%a+$') then
      before_char_iw = ''
    end
  end

  local completion_context
  if ctx:get_reason() == types.cmp.ContextReason.Manual then
    completion_context = {
      triggerKind = types.lsp.CompletionTriggerKind.Invoked,
    }
  else
    if vim.tbl_contains(self:get_trigger_characters(), before_char) then
      completion_context = {
        triggerKind = types.lsp.CompletionTriggerKind.TriggerCharacter,
        triggerCharacter = before_char,
      }
    elseif vim.tbl_contains(self:get_trigger_characters(), before_char_iw) then
      completion_context = {
        triggerKind = types.lsp.CompletionTriggerKind.TriggerCharacter,
        triggerCharacter = before_char_iw,
      }
    elseif ctx:get_reason() ~= types.cmp.ContextReason.TriggerOnly then
      if self:get_keyword_length() <= (ctx.cursor.col - offset) then
        if self.incomplete and self.context.cursor.col ~= ctx.cursor.col then
          completion_context = {
            triggerKind = types.lsp.CompletionTriggerKind.TriggerForIncompleteCompletions,
          }
        elseif not vim.tbl_contains({ self.request_offset, self.offset }, offset) then
          completion_context = {
            triggerKind = types.lsp.CompletionTriggerKind.Invoked,
          }
        end
      end
    else
      self:reset()
    end
  end

  if not completion_context then
    if ctx:get_reason() == types.cmp.ContextReason.TriggerOnly then
      self:reset()
    end
    debug.log(self:get_debug_name(), 'skip completion')
    return
  end

  if completion_context.triggerKind == types.lsp.CompletionTriggerKind.TriggerCharacter then
    self.is_triggered_by_symbol = char.is_symbol(string.byte(completion_context.triggerCharacter))
  end

  debug.log(self:get_debug_name(), 'request', offset, vim.inspect(completion_context))
  local prev_status = self.status
  self.status = source.SourceStatus.FETCHING
  self.request_offset = offset
  self.offset = offset
  self.context = ctx
  self.source:complete(
    {
      context = ctx,
      offset = self.offset,
      option = self:get_config().opts,
      completion_context = completion_context,
    },
    self.complete_dedup(vim.schedule_wrap(function(response)
      response = response or {}

      self.incomplete = response.isIncomplete or false

      if #(response.items or response) > 0 then
        debug.log(self:get_debug_name(), 'retrieve', #(response.items or response))
        local old_offset = self.offset
        local old_entries = self.entries

        self.status = source.SourceStatus.COMPLETED
        self.entries = {}
        for i, item in ipairs(response.items or response) do
          if (misc.safe(item) or {}).label then
            local e = entry.new(ctx, self, item)
            self.entries[i] = e
            self.offset = math.min(self.offset, e:get_offset())
          end
        end
        self.revision = self.revision + 1
        if #self:get_entries(ctx) == 0 then
          self.offset = old_offset
          self.entries = old_entries
          self.revision = self.revision + 1
        end
      else
        debug.log(self:get_debug_name(), 'continue', 'nil')
        if completion_context.triggerKind == types.lsp.CompletionTriggerKind.TriggerCharacter then
          self:reset()
        end
        self.status = prev_status
      end
      callback()
    end))
  )
  return true
end

---Resolve CompletionItem
---@param item lsp.CompletionItem
---@param callback fun(item: lsp.CompletionItem)
source.resolve = function(self, item, callback)
  if not self.source.resolve then
    return callback(item)
  end
  self.source:resolve(item, function(resolved_item)
    callback(resolved_item or item)
  end)
end

---Execute command
---@param item lsp.CompletionItem
---@param callback fun()
source.execute = function(self, item, callback)
  if not self.source.execute then
    return callback()
  end
  self.source:execute(item, function()
    callback()
  end)
end

return source
