local debug = require('cmp.utils.debug')
local str = require('cmp.utils.str')
local char = require('cmp.utils.char')
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

---@class cmp.Core
---@field public suspending boolean
---@field public view cmp.View
---@field public sources cmp.Source[]
---@field public context cmp.Context
---@field public event cmp.Event
local core = {}

core.new = function()
  local self = setmetatable({}, { __index = core })
  self.suspending = false
  self.sources = {}
  self.context = context.new()
  self.event = event.new()
  self.view = view.new()
  self.view.event:on('keymap', function(...)
    self:on_keymap(...)
  end)
  for _, event_name in ipairs({ 'complete_done', 'menu_opened', 'menu_closed' }) do
    self.view.event:on(event_name, function(evt)
      self.event:emit(event_name, evt)
    end)
  end
  return self
end

---Register source
---@param s cmp.Source
core.register_source = function(self, s)
  self.sources[s.id] = s
end

---Unregister source
---@param source_id integer
core.unregister_source = function(self, source_id)
  self.sources[source_id] = nil
end

---Get new context
---@param option? cmp.ContextOption
---@return cmp.Context
core.get_context = function(self, option)
  self.context:abort()
  local prev = self.context:clone()
  prev.prev_context = nil
  prev.cache = nil
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
  -- It's needed to avoid conflicting with autocmd debouncing.
  return vim.schedule_wrap(function()
    self.suspending = false
  end)
end

---Get sources that sorted by priority
---@param filter? cmp.SourceStatus[]|fun(s: cmp.Source): boolean
---@return cmp.Source[]
core.get_sources = function(self, filter)
  local f = function(s)
    if type(filter) == 'table' then
      return vim.tbl_contains(filter, s.status)
    elseif type(filter) == 'function' then
      return filter(s)
    end
    return true
  end

  local sources = {}
  for _, c in pairs(config.get().sources) do
    for _, s in pairs(self.sources) do
      if c.name == s.name then
        if s:is_available() and f(s) then
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
      commit_character = chars,
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
        self.filter.timeout = self.view:visible() and config.get().performance.throttle or 0
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

---Returns the suffix of the specified `line`.
---
---Contains `%s`: returns everything after the last `%s` in `line`
---Else:          returns `line` unmodified
---@param line string
---@return string suffix
local function find_line_suffix(line)
  return line:match('%S*$') --[[@as string]]
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
  local prefix = find_line_suffix(cursor_before_line) or ''
  if #prefix == 0 then
    return callback()
  end

  -- Reset current completion if indentkeys matched.
  for _, key in ipairs(vim.split(vim.bo.indentkeys, ',')) do
    if vim.tbl_contains({ '=' .. prefix, '0=' .. prefix }, key) then
      self:reset()
      self:set_context(context.empty())
      break
    end
  end

  callback()
end

---Complete common string for current completed entries.
core.complete_common_string = function(self)
  if not self.view:visible() or self.view:get_selected_entry() then
    return false
  end

  config.set_onetime({
    sources = config.get().sources,
    matching = {
      disallow_prefix_unmatching = true,
      disallow_partial_matching = true,
      disallow_fuzzy_matching = true,
    },
  })

  self:filter()
  self.filter:sync(1000)

  config.set_onetime({})

  local cursor = api.get_cursor()
  local offset = self.view:get_offset() or cursor[2]
  local common_string
  for _, e in ipairs(self.view:get_entries()) do
    local vim_item = e:get_vim_item(offset)
    if not common_string then
      common_string = vim_item.word
    else
      common_string = str.get_common_string(common_string, vim_item.word)
    end
  end
  local cursor_before_line = api.get_cursor_before_line()
  local pretext = cursor_before_line:sub(offset)
  if common_string and #common_string > #pretext then
    feedkeys.call(keymap.backspace(pretext) .. common_string, 'n')
    return true
  end
  return false
end

---Invoke completion
---@param ctx cmp.Context
core.complete = function(self, ctx)
  if not api.is_suitable_mode() then
    return
  end

  self:set_context(ctx)

  -- Invoke completion sources.
  local sources = self:get_sources()
  for _, s in ipairs(sources) do
    local callback
    callback = (function(s_)
      return function()
        local new = context.new(ctx)
        if s_.incomplete and new:changed(s_.context) then
          s_:complete(new, callback)
        else
          if not self.view:get_active_entry() then
            self.filter.stop()
            self.filter.timeout = config.get().performance.debounce
            self:filter()
          end
        end
      end
    end)(s)
    s:complete(ctx, callback)
  end

  if not self.view:get_active_entry() then
    self.filter.timeout = self.view:visible() and config.get().performance.throttle or 1
    self:filter()
  end
end

---Update completion menu
local async_filter = async.wrap(function(self)
  self.filter.timeout = config.get().performance.throttle

  -- Check invalid condition.
  local ignore = false
  ignore = ignore or not api.is_suitable_mode()
  if ignore then
    return
  end

  -- Check fetching sources.
  local sources = {}
  for _, s in ipairs(self:get_sources({ source.SourceStatus.FETCHING, source.SourceStatus.COMPLETED })) do
    -- Reserve filter call for timeout.
    if not s.incomplete and config.get().performance.fetching_timeout > s:get_fetching_time() then
      self.filter.timeout = config.get().performance.fetching_timeout - s:get_fetching_time()
      self:filter()
      if #sources == 0 then
        return
      end
    end
    table.insert(sources, s)
  end

  local ctx = self:get_context()

  -- Display completion results.
  local did_open = self.view:open(ctx, sources)
  local fetching = #self:get_sources(function(s)
    return s.status == source.SourceStatus.FETCHING
  end)

  -- Check onetime config.
  if not did_open and fetching == 0 then
    config.set_onetime({})
  end
end)
core.filter = async.throttle(async_filter, config.get().performance.throttle)

---Confirm completion.
---@param e cmp.Entry
---@param option cmp.ConfirmOption
---@param callback function
core.confirm = function(self, e, option, callback)
  if not (e and not e.confirmed) then
    if callback then
      callback()
    end
    return
  end
  e.confirmed = true

  debug.log('entry.confirm', e:get_completion_item())

  async.sync(function(done)
    e:resolve(done)
  end, config.get().performance.confirm_resolve_timeout)

  local release = self:suspend()

  -- Close menus.
  self.view:close()

  feedkeys.call(keymap.indentkeys(), 'n')
  feedkeys.call('', 'n', function()
    -- Emulate `<C-y>` behavior to save `.` register.
    local ctx = context.new()
    local keys = {}
    table.insert(keys, keymap.backspace(ctx.cursor_before_line:sub(e:get_offset())))
    table.insert(keys, e:get_word())
    table.insert(keys, keymap.undobreak())
    feedkeys.call(table.concat(keys, ''), 'in')
  end)
  feedkeys.call('', 'n', function()
    -- Restore the line at the time of request.
    local ctx = context.new()
    if api.is_cmdline_mode() then
      local keys = {}
      table.insert(keys, keymap.backspace(ctx.cursor_before_line:sub(e:get_offset())))
      table.insert(keys, string.sub(e.context.cursor_before_line, e:get_offset()))
      feedkeys.call(table.concat(keys, ''), 'in')
    else
      vim.cmd([[silent! undojoin]])
      -- This logic must be used nvim_buf_set_text.
      -- If not used, the snippet engine's placeholder wil be broken.
      vim.api.nvim_buf_set_text(0, e.context.cursor.row - 1, e:get_offset() - 1, ctx.cursor.row - 1, ctx.cursor.col - 1, {
        e.context.cursor_before_line:sub(e:get_offset()),
      })
      vim.api.nvim_win_set_cursor(0, { e.context.cursor.row, e.context.cursor.col - 1 })
    end
  end)
  feedkeys.call('', 'n', function()
    -- Apply additionalTextEdits.
    local ctx = context.new()
    if #(e:get_completion_item().additionalTextEdits or {}) == 0 then
      e:resolve(function()
        local new = context.new()
        local text_edits = e:get_completion_item().additionalTextEdits or {}
        if #text_edits == 0 then
          return
        end

        local has_cursor_line_text_edit = (function()
          local minrow = math.min(ctx.cursor.row, new.cursor.row)
          local maxrow = math.max(ctx.cursor.row, new.cursor.row)
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
        vim.cmd([[silent! undojoin]])
        vim.lsp.util.apply_text_edits(text_edits, ctx.bufnr, e.source:get_position_encoding_kind())
      end)
    else
      vim.cmd([[silent! undojoin]])
      vim.lsp.util.apply_text_edits(e:get_completion_item().additionalTextEdits, ctx.bufnr, e.source:get_position_encoding_kind())
    end
  end)
  feedkeys.call('', 'n', function()
    local ctx = context.new()
    local completion_item = misc.copy(e:get_completion_item())
    if not completion_item.textEdit then
      completion_item.textEdit = {}
      local insertText = completion_item.insertText
      if misc.empty(insertText) then
        insertText = nil
      end
      completion_item.textEdit.newText = insertText or completion_item.word or completion_item.label
    end
    local behavior = option.behavior or config.get().confirmation.default_behavior
    if behavior == types.cmp.ConfirmBehavior.Replace then
      completion_item.textEdit.range = e:get_replace_range()
    else
      completion_item.textEdit.range = e:get_insert_range()
    end

    local diff_before = math.max(0, e.context.cursor.col - (completion_item.textEdit.range.start.character + 1))
    local diff_after = math.max(0, (completion_item.textEdit.range['end'].character + 1) - e.context.cursor.col)
    local new_text = completion_item.textEdit.newText
    completion_item.textEdit.range.start.line = ctx.cursor.line
    completion_item.textEdit.range.start.character = (ctx.cursor.col - 1) - diff_before
    completion_item.textEdit.range['end'].line = ctx.cursor.line
    completion_item.textEdit.range['end'].character = (ctx.cursor.col - 1) + diff_after
    if api.is_insert_mode() then
      if false then
        --To use complex expansion debug.
        vim.print({ -- luacheck: ignore
          item = e:get_completion_item(),
          diff_before = diff_before,
          diff_after = diff_after,
          new_text = new_text,
          text_edit_new_text = completion_item.textEdit.newText,
          range_start = completion_item.textEdit.range.start.character,
          range_end = completion_item.textEdit.range['end'].character,
          original_range_start = e:get_completion_item().textEdit.range.start.character,
          original_range_end = e:get_completion_item().textEdit.range['end'].character,
          cursor_line = ctx.cursor_line,
          cursor_col0 = ctx.cursor.col - 1,
        })
      end
      local is_snippet = completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
      if is_snippet then
        completion_item.textEdit.newText = ''
      end
      vim.lsp.util.apply_text_edits({ completion_item.textEdit }, ctx.bufnr, 'utf-8')

      local texts = vim.split(completion_item.textEdit.newText, '\n')
      vim.api.nvim_win_set_cursor(0, {
        completion_item.textEdit.range.start.line + #texts,
        (#texts == 1 and (completion_item.textEdit.range.start.character + #texts[1]) or #texts[#texts]),
      })
      if is_snippet then
        config.get().snippet.expand({
          body = new_text,
          insert_text_mode = completion_item.insertTextMode,
        })
      end
    else
      local keys = {}
      table.insert(keys, keymap.backspace(ctx.cursor_line:sub(completion_item.textEdit.range.start.character + 1, ctx.cursor.col - 1)))
      table.insert(keys, keymap.delete(ctx.cursor_line:sub(ctx.cursor.col, completion_item.textEdit.range['end'].character)))
      table.insert(keys, new_text)
      feedkeys.call(table.concat(keys, ''), 'in')
    end
  end)
  feedkeys.call(keymap.indentkeys(vim.bo.indentkeys), 'n')
  feedkeys.call('', 'n', function()
    e:execute(vim.schedule_wrap(function()
      release()
      self.event:emit('confirm_done', {
        entry = e,
        commit_character = option.commit_character,
      })
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
  self.context = context.empty()
end

return core
