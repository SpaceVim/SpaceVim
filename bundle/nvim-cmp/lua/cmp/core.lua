local debug = require('cmp.utils.debug')
local char = require('cmp.utils.char')
local pattern = require('cmp.utils.pattern')
local feedkeys = require('cmp.utils.feedkeys')
local async = require('cmp.utils.async')
local keymap = require('cmp.utils.keymap')
local context = require('cmp.context')
local source = require('cmp.source')
local view = require('cmp.view')
local misc = require('cmp.utils.misc')
local config = require('cmp.config')
local types = require('cmp.types')
local api = require('cmp.utils.api')
local event = require('cmp.utils.event')

local SOURCE_TIMEOUT = 500
local THROTTLE_TIME = 120
local DEBOUNCE_TIME = 20

---@class cmp.Core
---@field public suspending boolean
---@field public view cmp.View
---@field public sources cmp.Source[]
---@field public sources_by_name table<string, cmp.Source>
---@field public context cmp.Context
---@field public event cmp.Event
local core = {}

core.new = function()
  local self = setmetatable({}, { __index = core })
  self.suspending = false
  self.sources = {}
  self.sources_by_name = {}
  self.context = context.new()
  self.event = event.new()
  self.view = view.new()
  self.view.event:on('keymap', function(...)
    self:on_keymap(...)
  end)
  return self
end

---Register source
---@param s cmp.Source
core.register_source = function(self, s)
  self.sources[s.id] = s
  if not self.sources_by_name[s.name] then
    self.sources_by_name[s.name] = {}
  end
  table.insert(self.sources_by_name[s.name], s)
end

---Unregister source
---@param source_id string
core.unregister_source = function(self, source_id)
  local name = self.sources[source_id].name
  self.sources_by_name[name] = vim.tbl_filter(function(s)
    return s.id ~= source_id
  end, self.sources_by_name[name])
  self.sources[source_id] = nil
end

---Get new context
---@param option cmp.ContextOption
---@return cmp.Context
core.get_context = function(self, option)
  local prev = self.context:clone()
  prev.prev_context = nil
  local ctx = context.new(prev, option)
  self:set_context(ctx)
  return self.context
end

---Set new context
---@param ctx cmp.Context
core.set_context = function(self, ctx)
  self.context = ctx
end

---Suspend completion
core.suspend = function(self)
  self.suspending = true
  return function()
    self.suspending = false
  end
end

---Get sources that sorted by priority
---@param statuses cmp.SourceStatus[]
---@return cmp.Source[]
core.get_sources = function(self, statuses)
  local sources = {}
  for _, c in pairs(config.get().sources) do
    for _, s in ipairs(self.sources_by_name[c.name] or {}) do
      if not statuses or vim.tbl_contains(statuses, s.status) then
        if s:is_available() then
          table.insert(sources, s)
        end
      end
    end
  end
  return sources
end

---Keypress handler
core.on_keymap = function(self, keys, fallback)
  local mode = api.get_mode()
  for key, mapping in pairs(config.get().mapping) do
    if keymap.equals(key, keys) and mapping[mode] then
      return mapping[mode](fallback)
    end
  end

  --Commit character. NOTE: This has a lot of cmp specific implementation to make more user-friendly.
  local chars = keymap.t(keys)
  local e = self.view:get_active_entry()
  if e and vim.tbl_contains(config.get().confirmation.get_commit_characters(e:get_commit_characters()), chars) then
    local is_printable = char.is_printable(string.byte(chars, 1))
    self:confirm(e, {
      behavior = is_printable and 'insert' or 'replace',
    }, function()
      local ctx = self:get_context()
      local word = e:get_word()
      if string.sub(ctx.cursor_before_line, -#word, ctx.cursor.col - 1) == word and is_printable then
        fallback()
      else
        self:reset()
      end
    end)
    return
  end

  fallback()
end

---Prepare completion
core.prepare = function(self)
  for keys, mapping in pairs(config.get().mapping) do
    for mode in pairs(mapping) do
      keymap.listen(mode, keys, function(...)
        self:on_keymap(...)
      end)
    end
  end
end

---Check auto-completion
core.on_change = function(self, trigger_event)
  local ignore = false
  ignore = ignore or self.suspending
  ignore = ignore or (vim.fn.pumvisible() == 1 and (vim.v.completed_item).word)
  ignore = ignore or not self.view:ready()
  if ignore then
    self:get_context({ reason = types.cmp.ContextReason.Auto })
    return
  end

  self:autoindent(trigger_event, function()
    local ctx = self:get_context({ reason = types.cmp.ContextReason.Auto })
    debug.log(('ctx: `%s`'):format(ctx.cursor_before_line))
    if ctx:changed(ctx.prev_context) then
      self.view:on_change()
      debug.log('changed')

      if vim.tbl_contains(config.get().completion.autocomplete or {}, trigger_event) then
        self:complete(ctx)
      else
        self.filter.timeout = THROTTLE_TIME
        self:filter()
      end
    else
      debug.log('unchanged')
    end
  end)
end

---Cursor moved.
core.on_moved = function(self)
  local ignore = false
  ignore = ignore or self.suspending
  ignore = ignore or (vim.fn.pumvisible() == 1 and (vim.v.completed_item).word)
  ignore = ignore or not self.view:visible()
  if ignore then
    return
  end
  self:filter()
end

---Check autoindent
---@param trigger_event cmp.TriggerEvent
---@param callback function
core.autoindent = function(self, trigger_event, callback)
  if trigger_event ~= types.cmp.TriggerEvent.TextChanged then
    return callback()
  end
  if not api.is_insert_mode() then
    return callback()
  end

  -- Check prefix
  local cursor_before_line = api.get_cursor_before_line()
  local prefix = pattern.matchstr('[^[:blank:]]\\+$', cursor_before_line) or ''
  if #prefix == 0 then
    return callback()
  end

  -- Scan indentkeys.
  for _, key in ipairs(vim.split(vim.bo.indentkeys, ',')) do
    if vim.tbl_contains({ '=' .. prefix, '0=' .. prefix }, key) then
      local release = self:suspend()
      vim.schedule(function() -- Check autoindent already applied.
        if cursor_before_line == api.get_cursor_before_line() then
          feedkeys.call(keymap.autoindent(), 'n', function()
            release()
            callback()
          end)
        else
          callback()
        end
      end)
      return
    end
  end

  -- indentkeys does not matched.
  callback()
end

---Invoke completion
---@param ctx cmp.Context
core.complete = function(self, ctx)
  if not api.is_suitable_mode() then
    return
  end
  self:set_context(ctx)

  for _, s in ipairs(self:get_sources({ source.SourceStatus.WAITING, source.SourceStatus.COMPLETED })) do
    s:complete(
      ctx,
      (function(src)
        local callback
        callback = function()
          local new = context.new(ctx)
          if new:changed(new.prev_context) and ctx == self.context then
            src:complete(new, callback)
          else
            self.filter.stop()
            self.filter.timeout = DEBOUNCE_TIME
            self:filter()
          end
        end
        return callback
      end)(s)
    )
  end

  self.filter.timeout = THROTTLE_TIME
  self:filter()
end

---Update completion menu
core.filter = async.throttle(
  vim.schedule_wrap(function(self)
    if not api.is_suitable_mode() then
      return
    end
    if self.view:get_active_entry() ~= nil then
      return
    end
    local ctx = self:get_context()

    -- To wait for processing source for that's timeout.
    local sources = {}
    for _, s in ipairs(self:get_sources({ source.SourceStatus.FETCHING, source.SourceStatus.COMPLETED })) do
      local time = SOURCE_TIMEOUT - s:get_fetching_time()
      if not s.incomplete and time > 0 then
        if #sources == 0 then
          self.filter.stop()
          self.filter.timeout = time + 1
          self:filter()
          return
        end
        break
      end
      table.insert(sources, s)
    end
    self.filter.timeout = THROTTLE_TIME

    self.view:open(ctx, sources)
  end),
  THROTTLE_TIME
)

---Confirm completion.
---@param e cmp.Entry
---@param option cmp.ConfirmOption
---@param callback function
core.confirm = function(self, e, option, callback)
  if not (e and not e.confirmed) then
    return callback()
  end
  e.confirmed = true

  debug.log('entry.confirm', e:get_completion_item())

  local release = self:suspend()

  -- Close menus.
  self.view:close()

  feedkeys.call('', 'n', function()
    local ctx = context.new()
    local keys = {}
    table.insert(keys, keymap.backspace(ctx.cursor.character - vim.str_utfindex(ctx.cursor_line, e:get_offset() - 1)))
    table.insert(keys, e:get_word())
    table.insert(keys, keymap.undobreak())
    feedkeys.call(table.concat(keys, ''), 'int')
  end)
  feedkeys.call('', 'n', function()
    local ctx = context.new()
    if api.is_cmdline_mode() then
      local keys = {}
      table.insert(keys, keymap.backspace(ctx.cursor.character - vim.str_utfindex(ctx.cursor_line, e:get_offset() - 1)))
      table.insert(keys, string.sub(e.context.cursor_before_line, e:get_offset()))
      feedkeys.call(table.concat(keys, ''), 'int')
    else
      vim.api.nvim_buf_set_text(0, ctx.cursor.row - 1, e:get_offset() - 1, ctx.cursor.row - 1, ctx.cursor.col - 1, {
        string.sub(e.context.cursor_before_line, e:get_offset()),
      })
      vim.api.nvim_win_set_cursor(0, { e.context.cursor.row, e.context.cursor.col - 1 })
    end
  end)
  feedkeys.call('', 'n', function()
    if #(misc.safe(e:get_completion_item().additionalTextEdits) or {}) == 0 then
      local pre = context.new()
      e:resolve(function()
        local new = context.new()
        local text_edits = misc.safe(e:get_completion_item().additionalTextEdits) or {}
        if #text_edits == 0 then
          return
        end

        local has_cursor_line_text_edit = (function()
          local minrow = math.min(pre.cursor.row, new.cursor.row)
          local maxrow = math.max(pre.cursor.row, new.cursor.row)
          for _, te in ipairs(text_edits) do
            local srow = te.range.start.line + 1
            local erow = te.range['end'].line + 1
            if srow <= minrow and maxrow <= erow then
              return true
            end
          end
          return false
        end)()
        if has_cursor_line_text_edit then
          return
        end
        vim.fn['cmp#apply_text_edits'](new.bufnr, text_edits)
      end)
    else
      vim.fn['cmp#apply_text_edits'](vim.api.nvim_get_current_buf(), e:get_completion_item().additionalTextEdits)
    end
  end)
  feedkeys.call('', 'n', function()
    local ctx = context.new()
    local completion_item = misc.copy(e:get_completion_item())
    if not misc.safe(completion_item.textEdit) then
      completion_item.textEdit = {}
      completion_item.textEdit.newText = misc.safe(completion_item.insertText) or completion_item.word or completion_item.label
    end
    local behavior = option.behavior or config.get().confirmation.default_behavior
    if behavior == types.cmp.ConfirmBehavior.Replace then
      completion_item.textEdit.range = e:get_replace_range()
    else
      completion_item.textEdit.range = e:get_insert_range()
    end

    local diff_before = e.context.cursor.character - completion_item.textEdit.range.start.character
    local diff_after = completion_item.textEdit.range['end'].character - e.context.cursor.character
    local new_text = completion_item.textEdit.newText

    if api.is_insert_mode() then
      local is_snippet = completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
      completion_item.textEdit.range.start.line = ctx.cursor.line
      completion_item.textEdit.range.start.character = ctx.cursor.character - diff_before
      completion_item.textEdit.range['end'].line = ctx.cursor.line
      completion_item.textEdit.range['end'].character = ctx.cursor.character + diff_after
      if is_snippet then
        completion_item.textEdit.newText = ''
      end
      vim.fn['cmp#apply_text_edits'](ctx.bufnr, { completion_item.textEdit })
      local texts = vim.split(completion_item.textEdit.newText, '\n')
      local position = completion_item.textEdit.range.start
      position.line = position.line + (#texts - 1)
      if #texts == 1 then
        position.character = position.character + vim.str_utfindex(texts[1])
      else
        position.character = vim.str_utfindex(texts[#texts])
      end
      local pos = types.lsp.Position.to_vim(0, position)
      vim.api.nvim_win_set_cursor(0, { pos.row, pos.col - 1 })
      if is_snippet then
        config.get().snippet.expand({
          body = new_text,
          insert_text_mode = completion_item.insertTextMode,
        })
      end
    else
      local keys = {}
      table.insert(keys, string.rep(keymap.t('<BS>'), diff_before))
      table.insert(keys, string.rep(keymap.t('<Del>'), diff_after))
      table.insert(keys, new_text)
      feedkeys.call(table.concat(keys, ''), 'int')
    end
  end)
  feedkeys.call('', 'n', function()
    e:execute(vim.schedule_wrap(function()
      release()
      self.event:emit('confirm_done', e)
      if callback then
        callback()
      end
    end))
  end)
end

---Reset current completion state
core.reset = function(self)
  for _, s in pairs(self.sources) do
    s:reset()
  end
  self:get_context() -- To prevent new event
end

return core
