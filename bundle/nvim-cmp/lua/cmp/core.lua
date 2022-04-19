local debug = require('cmp.utils.debug')
local str = require('cmp.utils.str')
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
local DEBOUNCE_TIME = 80
local THROTTLE_TIME = 40

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
  self.view.event:on('complete_done', function(evt)
    self.event:emit('complete_done', evt)
  end)
  return self
end

---Register source
---@param s cmp.Source
core.register_source = function(self, s)
  self.sources[s.id] = s
end

---Unregister source
---@param source_id string
core.unregister_source = function(self, source_id)
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
---@param filter cmp.SourceStatus[]|fun(s: cmp.Source): boolean
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
        self.filter.timeout = self.view:visible() and THROTTLE_TIME or 0
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
  if not self.view:visible() or self.view:get_active_entry() then
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
  local offset = self.view:get_offset()
  local common_string
  for _, e in ipairs(self.view:get_entries()) do
    local vim_item = e:get_vim_item(offset)
    if not common_string then
      common_string = vim_item.word
    else
      common_string = str.get_common_string(common_string, vim_item.word)
    end
  end
  if common_string and #common_string > (1 + cursor[2] - offset) then
    feedkeys.call(keymap.backspace(string.sub(api.get_current_line(), offset, cursor[2])) .. common_string, 'n')
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
          for _, s__ in ipairs(self:get_sources({ source.SourceStatus.FETCHING })) do
            if s_ == s__ then
              break
            end
            if not s__.incomplete and SOURCE_TIMEOUT > s__:get_fetching_time() then
              return
            end
          end
          if not self.view:get_active_entry() then
            self.filter.stop()
            self.filter.timeout = self.view:visible() and DEBOUNCE_TIME or 0
            self:filter()
          end
        end
      end
    end)(s)
    s:complete(ctx, callback)
  end

  if not self.view:get_active_entry() then
    self.filter.timeout = self.view:visible() and THROTTLE_TIME or 0
    self:filter()
  end
end

---Update completion menu
core.filter = async.throttle(function(self)
  self.filter.timeout = self.view:visible() and THROTTLE_TIME or 0

  -- Check invalid condition.
  local ignore = false
  ignore = ignore or not api.is_suitable_mode()
  if ignore then
    return
  end

  -- Check fetching sources.
  local sources = {}
  for _, s in ipairs(self:get_sources({ source.SourceStatus.FETCHING, source.SourceStatus.COMPLETED })) do
    if not s.incomplete and SOURCE_TIMEOUT > s:get_fetching_time() then
      -- Reserve filter call for timeout.
      self.filter.timeout = SOURCE_TIMEOUT - s:get_fetching_time()
      self:filter()
      break
    end
    table.insert(sources, s)
  end

  local ctx = self:get_context()

  -- Display completion results.
  self.view:open(ctx, sources)

  -- Check onetime config.
  if #self:get_sources(function(s)
    if s.status == source.SourceStatus.FETCHING then
      return true
    elseif #s:get_entries(ctx) > 0 then
      return true
    end
    return false
  end) == 0 then
    config.set_onetime({})
  end
end, THROTTLE_TIME)

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

  feedkeys.call(keymap.indentkeys(), 'n')
  feedkeys.call('', 'n', function()
    local ctx = context.new()
    local keys = {}
    table.insert(keys, keymap.backspace(ctx.cursor.character - misc.to_utfindex(ctx.cursor_line, e:get_offset())))
    table.insert(keys, e:get_word())
    table.insert(keys, keymap.undobreak())
    feedkeys.call(table.concat(keys, ''), 'int')
  end)
  feedkeys.call('', 'n', function()
    local ctx = context.new()
    if api.is_cmdline_mode() then
      local keys = {}
      table.insert(keys, keymap.backspace(ctx.cursor.character - misc.to_utfindex(ctx.cursor_line, e:get_offset())))
      table.insert(keys, string.sub(e.context.cursor_before_line, e:get_offset()))
      feedkeys.call(table.concat(keys, ''), 'in')
    else
      vim.api.nvim_buf_set_text(0, ctx.cursor.row - 1, e:get_offset() - 1, ctx.cursor.row - 1, ctx.cursor.col - 1, {
        string.sub(e.context.cursor_before_line, e:get_offset()),
      })
      vim.api.nvim_win_set_cursor(0, { e.context.cursor.row, e.context.cursor.col - 1 })
    end
  end)
  feedkeys.call('', 'n', function()
    local ctx = context.new()
    if #(misc.safe(e:get_completion_item().additionalTextEdits) or {}) == 0 then
      e:resolve(function()
        local new = context.new()
        local text_edits = misc.safe(e:get_completion_item().additionalTextEdits) or {}
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
        vim.lsp.util.apply_text_edits(text_edits, ctx.bufnr, 'utf-16')
      end)
    else
      vim.lsp.util.apply_text_edits(e:get_completion_item().additionalTextEdits, ctx.bufnr, 'utf-16')
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

    local diff_before = math.max(0, e.context.cursor.character - completion_item.textEdit.range.start.character)
    local diff_after = math.max(0, completion_item.textEdit.range['end'].character - e.context.cursor.character)
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
      vim.lsp.util.apply_text_edits({ completion_item.textEdit }, ctx.bufnr, 'utf-16')
      local texts = vim.split(completion_item.textEdit.newText, '\n')
      local position = completion_item.textEdit.range.start
      position.line = position.line + (#texts - 1)
      if #texts == 1 then
        position.character = position.character + misc.to_utfindex(texts[1])
      else
        position.character = misc.to_utfindex(texts[#texts])
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
