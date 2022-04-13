local cache = require('cmp.utils.cache')
local char = require('cmp.utils.char')
local misc = require('cmp.utils.misc')
local str = require('cmp.utils.str')
local config = require('cmp.config')
local types = require('cmp.types')
local matcher = require('cmp.matcher')

---@class cmp.Entry
---@field public id number
---@field public cache cmp.Cache
---@field public match_cache cmp.Cache
---@field public score number
---@field public exact boolean
---@field public matches table
---@field public context cmp.Context
---@field public source cmp.Source
---@field public source_offset number
---@field public source_insert_range lsp.Range
---@field public source_replace_range lsp.Range
---@field public completion_item lsp.CompletionItem
---@field public resolved_completion_item lsp.CompletionItem|nil
---@field public resolved_callbacks fun()[]
---@field public resolving boolean
---@field public confirmed boolean
local entry = {}

---Create new entry
---@param ctx cmp.Context
---@param source cmp.Source
---@param completion_item lsp.CompletionItem
---@return cmp.Entry
entry.new = function(ctx, source, completion_item)
  local self = setmetatable({}, { __index = entry })
  self.id = misc.id('entry.new')
  self.cache = cache.new()
  self.match_cache = cache.new()
  self.score = 0
  self.exact = false
  self.matches = {}
  self.context = ctx
  self.source = source
  self.source_offset = source.request_offset
  self.source_insert_range = source:get_default_insert_range()
  self.source_replace_range = source:get_default_replace_range()
  self.completion_item = completion_item
  self.resolved_completion_item = nil
  self.resolved_callbacks = {}
  self.resolving = false
  self.confirmed = false
  return self
end

---Make offset value
---@return number
entry.get_offset = function(self)
  return self.cache:ensure({ 'get_offset', self.resolved_completion_item and 1 or 0 }, function()
    local offset = self.source_offset
    if misc.safe(self:get_completion_item().textEdit) then
      local range = misc.safe(self:get_completion_item().textEdit.insert) or misc.safe(self:get_completion_item().textEdit.range)
      if range then
        local c = misc.to_vimindex(self.context.cursor_line, range.start.character)
        for idx = c, self.source_offset do
          if not char.is_white(string.byte(self.context.cursor_line, idx)) then
            offset = idx
            break
          end
        end
      end
    else
      -- NOTE
      -- The VSCode does not implement this but it's useful if the server does not care about word patterns.
      -- We should care about this performance.
      local word = self:get_word()
      for idx = self.source_offset - 1, self.source_offset - #word, -1 do
        if char.is_semantic_index(self.context.cursor_line, idx) then
          local c = string.byte(self.context.cursor_line, idx)
          if char.is_white(c) then
            break
          end
          local match = true
          for i = 1, self.source_offset - idx do
            local c1 = string.byte(word, i)
            local c2 = string.byte(self.context.cursor_line, idx + i - 1)
            if not c1 or not c2 or c1 ~= c2 then
              match = false
              break
            end
          end
          if match then
            offset = math.min(offset, idx)
          end
        end
      end
    end
    return offset
  end)
end

---Create word for vim.CompletedItem
---NOTE: This method doesn't clear the cache after completionItem/resolve.
---@return string
entry.get_word = function(self)
  return self.cache:ensure({ 'get_word' }, function()
    --NOTE: This is nvim-cmp specific implementation.
    if misc.safe(self:get_completion_item().word) then
      return self:get_completion_item().word
    end

    local word
    if misc.safe(self:get_completion_item().textEdit) and not misc.empty(self:get_completion_item().textEdit.newText) then
      word = str.trim(self:get_completion_item().textEdit.newText)
      if self:get_completion_item().insertTextFormat == types.lsp.InsertTextFormat.Snippet then
        word = vim.lsp.util.parse_snippet(word)
      end
      local overwrite = self:get_overwrite()
      if 0 < overwrite[2] or self:get_completion_item().insertTextFormat == types.lsp.InsertTextFormat.Snippet then
        word = str.get_word(word, string.byte(self.context.cursor_after_line, 1), overwrite[1] or 0)
      end
    elseif not misc.empty(self:get_completion_item().insertText) then
      word = str.trim(self:get_completion_item().insertText)
      if self:get_completion_item().insertTextFormat == types.lsp.InsertTextFormat.Snippet then
        word = str.get_word(vim.lsp.util.parse_snippet(word))
      end
    else
      word = str.trim(self:get_completion_item().label)
    end
    return str.oneline(word)
  end)
end

---Get overwrite information
---@return number, number
entry.get_overwrite = function(self)
  return self.cache:ensure({ 'get_overwrite', self.resolved_completion_item and 1 or 0 }, function()
    if misc.safe(self:get_completion_item().textEdit) then
      local r = misc.safe(self:get_completion_item().textEdit.insert) or misc.safe(self:get_completion_item().textEdit.range)
      local s = misc.to_vimindex(self.context.cursor_line, r.start.character)
      local e = misc.to_vimindex(self.context.cursor_line, r['end'].character)
      local before = self.context.cursor.col - s
      local after = e - self.context.cursor.col
      return { before, after }
    end
    return { 0, 0 }
  end)
end

---Create filter text
---@return string
entry.get_filter_text = function(self)
  return self.cache:ensure({ 'get_filter_text', self.resolved_completion_item and 1 or 0 }, function()
    local word
    if misc.safe(self:get_completion_item().filterText) then
      word = self:get_completion_item().filterText
    else
      word = str.trim(self:get_completion_item().label)
    end
    return word
  end)
end

---Get LSP's insert text
---@return string
entry.get_insert_text = function(self)
  return self.cache:ensure({ 'get_insert_text', self.resolved_completion_item and 1 or 0 }, function()
    local word
    if misc.safe(self:get_completion_item().textEdit) then
      word = str.trim(self:get_completion_item().textEdit.newText)
      if self:get_completion_item().insertTextFormat == types.lsp.InsertTextFormat.Snippet then
        word = str.remove_suffix(str.remove_suffix(word, '$0'), '${0}')
      end
    elseif misc.safe(self:get_completion_item().insertText) then
      word = str.trim(self:get_completion_item().insertText)
      if self:get_completion_item().insertTextFormat == types.lsp.InsertTextFormat.Snippet then
        word = str.remove_suffix(str.remove_suffix(word, '$0'), '${0}')
      end
    else
      word = str.trim(self:get_completion_item().label)
    end
    return word
  end)
end

---Return the item is deprecated or not.
---@return boolean
entry.is_deprecated = function(self)
  return self:get_completion_item().deprecated or vim.tbl_contains(self:get_completion_item().tags or {}, types.lsp.CompletionItemTag.Deprecated)
end

---Return view information.
---@param suggest_offset number
---@param entries_buf number The buffer this entry will be rendered into.
---@return { abbr: { text: string, bytes: number, width: number, hl_group: string }, kind: { text: string, bytes: number, width: number, hl_group: string }, menu: { text: string, bytes: number, width: number, hl_group: string } }
entry.get_view = function(self, suggest_offset, entries_buf)
  local item = self:get_vim_item(suggest_offset)
  return self.cache:ensure({ 'get_view', self.resolved_completion_item and 1 or 0, entries_buf }, function()
    local view = {}
    -- The result of vim.fn.strdisplaywidth depends on which buffer it was
    -- called in because it reads the values of the option 'tabstop' when
    -- rendering <Tab> characters.
    vim.api.nvim_buf_call(entries_buf, function()
      view.abbr = {}
      view.abbr.text = item.abbr or ''
      view.abbr.bytes = #view.abbr.text
      view.abbr.width = vim.fn.strdisplaywidth(view.abbr.text)
      view.abbr.hl_group = item.abbr_hl_group or (self:is_deprecated() and 'CmpItemAbbrDeprecated' or 'CmpItemAbbr')
      view.kind = {}
      view.kind.text = item.kind or ''
      view.kind.bytes = #view.kind.text
      view.kind.width = vim.fn.strdisplaywidth(view.kind.text)
      view.kind.hl_group = item.kind_hl_group or ('CmpItemKind' .. (types.lsp.CompletionItemKind[self:get_kind()] or ''))
      view.menu = {}
      view.menu.text = item.menu or ''
      view.menu.bytes = #view.menu.text
      view.menu.width = vim.fn.strdisplaywidth(view.menu.text)
      view.menu.hl_group = item.menu_hl_group or 'CmpItemMenu'
      view.dup = item.dup
    end)
    return view
  end)
end

---Make vim.CompletedItem
---@param suggest_offset number
---@return vim.CompletedItem
entry.get_vim_item = function(self, suggest_offset)
  return self.cache:ensure({ 'get_vim_item', suggest_offset, self.resolved_completion_item and 1 or 0 }, function()
    local completion_item = self:get_completion_item()
    local word = self:get_word()
    local abbr = str.oneline(completion_item.label)

    -- ~ indicator
    local is_snippet = false
    if #(misc.safe(completion_item.additionalTextEdits) or {}) > 0 then
      is_snippet = true
    elseif completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
      is_snippet = self:get_insert_text() ~= word
    elseif completion_item.kind == types.lsp.CompletionItemKind.Snippet then
      is_snippet = true
    end
    if is_snippet then
      abbr = abbr .. '~'
    end

    -- append delta text
    if suggest_offset < self:get_offset() then
      word = string.sub(self.context.cursor_before_line, suggest_offset, self:get_offset() - 1) .. word
    end

    -- labelDetails.
    local menu = nil
    if misc.safe(completion_item.labelDetails) then
      menu = ''
      if misc.safe(completion_item.labelDetails.detail) then
        menu = menu .. completion_item.labelDetails.detail
      end
      if misc.safe(completion_item.labelDetails.description) then
        menu = menu .. completion_item.labelDetails.description
      end
    end

    -- remove duplicated string.
    if self:get_offset() ~= self.context.cursor.col then
      for i = 1, #word - 1 do
        if str.has_prefix(self.context.cursor_after_line, string.sub(word, i, #word)) then
          word = string.sub(word, 1, i - 1)
          break
        end
      end
    end

    local vim_item = {
      word = word,
      abbr = abbr,
      kind = types.lsp.CompletionItemKind[self:get_kind()] or types.lsp.CompletionItemKind[1],
      menu = menu,
      dup = self:get_completion_item().dup or 1,
    }
    if config.get().formatting.format then
      vim_item = config.get().formatting.format(self, vim_item)
    end
    vim_item.word = str.oneline(vim_item.word or '')
    vim_item.abbr = str.oneline(vim_item.abbr or '')
    vim_item.kind = str.oneline(vim_item.kind or '')
    vim_item.menu = str.oneline(vim_item.menu or '')
    vim_item.equal = 1
    vim_item.empty = 1

    return vim_item
  end)
end

---Get commit characters
---@return string[]
entry.get_commit_characters = function(self)
  return misc.safe(self:get_completion_item().commitCharacters) or {}
end

---Return insert range
---@return lsp.Range|nil
entry.get_insert_range = function(self)
  local insert_range
  if misc.safe(self:get_completion_item().textEdit) then
    if misc.safe(self:get_completion_item().textEdit.insert) then
      insert_range = self:get_completion_item().textEdit.insert
    else
      insert_range = self:get_completion_item().textEdit.range
    end
  else
    insert_range = {
      start = {
        line = self.context.cursor.row - 1,
        character = math.min(misc.to_utfindex(self.context.cursor_line, self:get_offset()), self.source_insert_range.start.character),
      },
      ['end'] = self.source_insert_range['end'],
    }
  end
  return insert_range
end

---Return replace range
---@return lsp.Range|nil
entry.get_replace_range = function(self)
  return self.cache:ensure({ 'get_replace_range', self.resolved_completion_item and 1 or 0 }, function()
    local replace_range
    if misc.safe(self:get_completion_item().textEdit) and misc.safe(self:get_completion_item().textEdit.replace) then
      replace_range = self:get_completion_item().textEdit.replace
    else
      replace_range = {
        start = {
          line = self.source_replace_range.start.line,
          character = math.min(misc.to_utfindex(self.context.cursor_line, self:get_offset()), self.source_replace_range.start.character),
        },
        ['end'] = self.source_replace_range['end'],
      }
    end
    return replace_range
  end)
end

---Match line.
---@param input string
---@param matching_config cmp.MatchingConfig
---@return { score: number, matches: table[] }
entry.match = function(self, input, matching_config)
  return self.match_cache:ensure({
    input,
    self.resolved_completion_item and 1 or 0,
    matching_config.disallow_fuzzy_matching and 1 or 0,
    matching_config.disallow_partial_matching and 1 or 0,
    matching_config.disallow_prefix_unmatching and 1 or 0,
  }, function()
    local option = {
      disallow_fuzzy_matching = matching_config.disallow_fuzzy_matching,
      disallow_partial_matching = matching_config.disallow_partial_matching,
      disallow_prefix_unmatching = matching_config.disallow_prefix_unmatching,
      synonyms = {
        self:get_word(),
        self:get_completion_item().label,
      },
    }

    local score, matches, _
    score, matches = matcher.match(input, self:get_filter_text(), option)

    -- Support the language server that doesn't respect VSCode's behaviors.
    if score == 0 then
      if misc.safe(self:get_completion_item().textEdit) and not misc.empty(self:get_completion_item().textEdit.newText) then
        local diff = self.source_offset - self:get_offset()
        if diff > 0 then
          local prefix = string.sub(self.context.cursor_line, self:get_offset(), self:get_offset() + diff)
          local accept = false
          accept = accept or string.match(prefix, '^[^%a]+$')
          accept = accept or string.find(self:get_completion_item().textEdit.newText, prefix, 1, true)
          if accept then
            score, matches = matcher.match(input, prefix .. self:get_filter_text(), option)
          end
        end
      end
    end

    if self:get_filter_text() ~= self:get_completion_item().label then
      _, matches = matcher.match(input, self:get_completion_item().label, { self:get_word() })
    end

    return { score = score, matches = matches }
  end)
end

---Get resolved completion item if possible.
---@return lsp.CompletionItem
entry.get_completion_item = function(self)
  return self.cache:ensure({ 'get_completion_item', self.resolved_completion_item and 1 or 0 }, function()
    if self.resolved_completion_item then
      local completion_item = misc.copy(self.completion_item)
      for k, v in pairs(self.resolved_completion_item) do
        completion_item[k] = v or completion_item[k]
      end
      return completion_item
    end
    return self.completion_item
  end)
end

---Create documentation
---@return string
entry.get_documentation = function(self)
  local item = self:get_completion_item()

  local documents = {}

  -- detail
  if misc.safe(item.detail) and item.detail ~= '' then
    local ft = self.context.filetype
    local dot_index = string.find(ft, '%.')
    if dot_index ~= nil then
      ft = string.sub(ft, 0, dot_index - 1)
    end
    table.insert(documents, {
      kind = types.lsp.MarkupKind.Markdown,
      value = ('```%s\n%s\n```'):format(ft, str.trim(item.detail)),
    })
  end

  if type(item.documentation) == 'string' and item.documentation ~= '' then
    table.insert(documents, {
      kind = types.lsp.MarkupKind.PlainText,
      value = str.trim(item.documentation),
    })
  elseif type(item.documentation) == 'table' and item.documentation.value ~= '' then
    table.insert(documents, item.documentation)
  end

  return vim.lsp.util.convert_input_to_markdown_lines(documents)
end

---Get completion item kind
---@return lsp.CompletionItemKind
entry.get_kind = function(self)
  return misc.safe(self:get_completion_item().kind) or types.lsp.CompletionItemKind.Text
end

---Execute completion item's command.
---@param callback fun()
entry.execute = function(self, callback)
  self.source:execute(self:get_completion_item(), callback)
end

---Resolve completion item.
---@param callback fun()
entry.resolve = function(self, callback)
  if self.resolved_completion_item then
    return callback()
  end
  table.insert(self.resolved_callbacks, callback)

  if not self.resolving then
    self.resolving = true
    self.source:resolve(self.completion_item, function(completion_item)
      self.resolved_completion_item = misc.safe(completion_item) or self.completion_item
      for _, c in ipairs(self.resolved_callbacks) do
        c()
      end
    end)
  end
end

return entry
