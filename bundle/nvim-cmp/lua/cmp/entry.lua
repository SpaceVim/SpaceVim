local cache = require('cmp.utils.cache')
local char = require('cmp.utils.char')
local misc = require('cmp.utils.misc')
local str = require('cmp.utils.str')
local config = require('cmp.config')
local types = require('cmp.types')
local matcher = require('cmp.matcher')

---@class cmp.Entry
---@field public id integer
---@field public cache cmp.Cache
---@field public match_cache cmp.Cache
---@field public score integer
---@field public exact boolean
---@field public matches table
---@field public context cmp.Context
---@field public source cmp.Source
---@field public source_offset integer
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
---@param item_defaults? lsp.internal.CompletionItemDefaults
---@return cmp.Entry
entry.new = function(ctx, source, completion_item, item_defaults)
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
  self.completion_item = self:fill_defaults(completion_item, item_defaults)
  self.resolved_completion_item = nil
  self.resolved_callbacks = {}
  self.resolving = false
  self.confirmed = false
  return self
end

---Make offset value
---@return integer
entry.get_offset = function(self)
  return self.cache:ensure('get_offset', function()
    local offset = self.source_offset
    if self:get_completion_item().textEdit then
      local range = self:get_insert_range()
      if range then
        offset = self.context.cache:ensure('entry:' .. 'get_offset:' .. tostring(range.start.character), function()
          local start = math.min(range.start.character + 1, offset)
          for idx = start, self.source_offset do
            local byte = string.byte(self.context.cursor_line, idx)
            if byte == nil or not char.is_white(byte) then
              return idx
            end
          end
          return offset
        end)
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
  return self.cache:ensure('get_word', function()
    --NOTE: This is nvim-cmp specific implementation.
    if self:get_completion_item().word then
      return self:get_completion_item().word
    end

    local word
    if self:get_completion_item().textEdit and not misc.empty(self:get_completion_item().textEdit.newText) then
      word = str.trim(self:get_completion_item().textEdit.newText)
      local overwrite = self:get_overwrite()
      if 0 < overwrite[2] or self:get_completion_item().insertTextFormat == types.lsp.InsertTextFormat.Snippet then
        word = str.get_word(word, string.byte(self.context.cursor_after_line, 1), overwrite[1] or 0)
      end
    elseif not misc.empty(self:get_completion_item().insertText) then
      word = str.trim(self:get_completion_item().insertText)
      if self:get_completion_item().insertTextFormat == types.lsp.InsertTextFormat.Snippet then
        word = str.get_word(word)
      end
    else
      word = str.trim(self:get_completion_item().label)
    end
    return str.oneline(word)
  end) --[[@as string]]
end

---Get overwrite information
---@return integer[]
entry.get_overwrite = function(self)
  return self.cache:ensure('get_overwrite', function()
    if self:get_completion_item().textEdit then
      local range = self:get_insert_range()
      if range then
        return self.context.cache:ensure('entry:' .. 'get_overwrite:' .. tostring(range.start.character) .. ':' .. tostring(range['end'].character), function()
          local vim_start = range.start.character + 1
          local vim_end = range['end'].character + 1
          local before = self.context.cursor.col - vim_start
          local after = vim_end - self.context.cursor.col
          return { before, after }
        end)
      end
    end
    return { 0, 0 }
  end)
end

---Create filter text
---@return string
entry.get_filter_text = function(self)
  return self.cache:ensure('get_filter_text', function()
    local word
    if self:get_completion_item().filterText then
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
  return self.cache:ensure('get_insert_text', function()
    local word
    if self:get_completion_item().textEdit then
      word = str.trim(self:get_completion_item().textEdit.newText)
      if self:get_completion_item().insertTextFormat == types.lsp.InsertTextFormat.Snippet then
        word = str.remove_suffix(str.remove_suffix(word, '$0'), '${0}')
      end
    elseif self:get_completion_item().insertText then
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
---@param suggest_offset integer
---@param entries_buf integer The buffer this entry will be rendered into.
---@return { abbr: { text: string, bytes: integer, width: integer, hl_group: string }, kind: { text: string, bytes: integer, width: integer, hl_group: string }, menu: { text: string, bytes: integer, width: integer, hl_group: string } }
entry.get_view = function(self, suggest_offset, entries_buf)
  local item = self:get_vim_item(suggest_offset)
  return self.cache:ensure('get_view:' .. tostring(entries_buf), function()
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
---@param suggest_offset integer
---@return vim.CompletedItem
entry.get_vim_item = function(self, suggest_offset)
  return self.cache:ensure('get_vim_item:' .. tostring(suggest_offset), function()
    local completion_item = self:get_completion_item()
    local word = self:get_word()
    local abbr = str.oneline(completion_item.label)

    -- ~ indicator
    local is_expandable = false
    local expandable_indicator = config.get().formatting.expandable_indicator
    if #(completion_item.additionalTextEdits or {}) > 0 then
      is_expandable = true
    elseif completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
      is_expandable = self:get_insert_text() ~= word
    elseif completion_item.kind == types.lsp.CompletionItemKind.Snippet then
      is_expandable = true
    end
    if expandable_indicator and is_expandable then
      abbr = abbr .. '~'
    end

    -- append delta text
    if suggest_offset < self:get_offset() then
      word = string.sub(self.context.cursor_before_line, suggest_offset, self:get_offset() - 1) .. word
    end

    -- labelDetails.
    local menu = nil
    if completion_item.labelDetails then
      menu = ''
      if completion_item.labelDetails.detail then
        menu = menu .. completion_item.labelDetails.detail
      end
      if completion_item.labelDetails.description then
        menu = menu .. completion_item.labelDetails.description
      end
    end

    -- remove duplicated string.
    if self:get_offset() ~= self.context.cursor.col then
      for i = 1, #word do
        if str.has_prefix(self.context.cursor_after_line, string.sub(word, i, #word)) then
          word = string.sub(word, 1, i - 1)
          break
        end
      end
    end

    local cmp_opts = self:get_completion_item().cmp or {}

    local vim_item = {
      word = word,
      abbr = abbr,
      kind = cmp_opts.kind_text or types.lsp.CompletionItemKind[self:get_kind()] or types.lsp.CompletionItemKind[1],
      kind_hl_group = cmp_opts.kind_hl_group,
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
  return self:get_completion_item().commitCharacters or {}
end

---Return insert range
---@return lsp.Range|nil
entry.get_insert_range = function(self)
  local insert_range
  if self:get_completion_item().textEdit then
    if self:get_completion_item().textEdit.insert then
      insert_range = self:get_completion_item().textEdit.insert
    else
      insert_range = self:get_completion_item().textEdit.range --[[@as lsp.Range]]
    end
    insert_range = self:convert_range_encoding(insert_range)
  else
    insert_range = {
      start = {
        line = self.context.cursor.row - 1,
        character = self:get_offset() - 1,
      },
      ['end'] = self.source_insert_range['end'],
    }
  end
  return insert_range
end

---Return replace range
---@return lsp.Range|nil
entry.get_replace_range = function(self)
  return self.cache:ensure('get_replace_range', function()
    local replace_range
    if self:get_completion_item().textEdit then
      if self:get_completion_item().textEdit.replace then
        replace_range = self:get_completion_item().textEdit.replace
      else
        replace_range = self:get_completion_item().textEdit.range --[[@as lsp.Range]]
      end
      replace_range = self:convert_range_encoding(replace_range)
    end

    if not replace_range or ((self.context.cursor.col - 1) == replace_range['end'].character) then
      replace_range = {
        start = {
          line = self.source_replace_range.start.line,
          character = self:get_offset() - 1,
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
---@return { score: integer, matches: table[] }
entry.match = function(self, input, matching_config)
  return self.match_cache:ensure(input .. ':' .. (self.resolved_completion_item and '1' or '0' .. ':') .. (matching_config.disallow_fuzzy_matching and '1' or '0') .. ':' .. (matching_config.disallow_partial_fuzzy_matching and '1' or '0') .. ':' .. (matching_config.disallow_partial_matching and '1' or '0') .. ':' .. (matching_config.disallow_prefix_unmatching and '1' or '0'), function()
    local option = {
      disallow_fuzzy_matching = matching_config.disallow_fuzzy_matching,
      disallow_partial_fuzzy_matching = matching_config.disallow_partial_fuzzy_matching,
      disallow_partial_matching = matching_config.disallow_partial_matching,
      disallow_prefix_unmatching = matching_config.disallow_prefix_unmatching,
      synonyms = {
        self:get_word(),
        self:get_completion_item().label,
      },
    }

    local score, matches, filter_text, _
    local checked = {} ---@type table<string, boolean>

    filter_text = self:get_filter_text()
    checked[filter_text] = true
    score, matches = matcher.match(input, filter_text, option)

    -- Support the language server that doesn't respect VSCode's behaviors.
    if score == 0 then
      if self:get_completion_item().textEdit and not misc.empty(self:get_completion_item().textEdit.newText) then
        local diff = self.source_offset - self:get_offset()
        if diff > 0 then
          local prefix = string.sub(self.context.cursor_line, self:get_offset(), self:get_offset() + diff)
          local accept = nil
          accept = accept or string.match(prefix, '^[^%a]+$')
          accept = accept or string.find(self:get_completion_item().textEdit.newText, prefix, 1, true)
          if accept then
            filter_text = prefix .. self:get_filter_text()
            if not checked[filter_text] then
              checked[filter_text] = true
              score, matches = matcher.match(input, filter_text, option)
            end
          end
        end
      end
    end

    -- Fix highlight if filterText is not the same to vim_item.abbr.
    if score > 0 then
      local vim_item = self:get_vim_item(self.source_offset)
      filter_text = vim_item.abbr or vim_item.word
      if not checked[filter_text] then
        local diff = self.source_offset - self:get_offset()
        _, matches = matcher.match(input:sub(1 + diff), filter_text, option)
      end
    end

    return { score = score, matches = matches }
  end)
end

---Get resolved completion item if possible.
---@return lsp.CompletionItem
entry.get_completion_item = function(self)
  return self.cache:ensure('get_completion_item', function()
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
---@return string[]
entry.get_documentation = function(self)
  local item = self:get_completion_item()

  local documents = {}

  -- detail
  if item.detail and item.detail ~= '' then
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

  local documentation = item.documentation
  if type(documentation) == 'string' and documentation ~= '' then
    local value = str.trim(documentation)
    if value ~= '' then
      table.insert(documents, {
        kind = types.lsp.MarkupKind.PlainText,
        value = value,
      })
    end
  elseif type(documentation) == 'table' and not misc.empty(documentation.value) then
    local value = str.trim(documentation.value)
    if value ~= '' then
      table.insert(documents, {
        kind = documentation.kind,
        value = value,
      })
    end
  end

  return vim.lsp.util.convert_input_to_markdown_lines(documents)
end

---Get completion item kind
---@return lsp.CompletionItemKind
entry.get_kind = function(self)
  return self:get_completion_item().kind or types.lsp.CompletionItemKind.Text
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
      self.resolving = false
      if not completion_item then
        return
      end
      self.resolved_completion_item = completion_item or self.completion_item
      self.cache:clear()
      for _, c in ipairs(self.resolved_callbacks) do
        c()
      end
    end)
  end
end

---@param completion_item lsp.CompletionItem
---@param defaults? lsp.internal.CompletionItemDefaults
---@return lsp.CompletionItem
entry.fill_defaults = function(_, completion_item, defaults)
  defaults = defaults or {}

  if defaults.data then
    completion_item.data = completion_item.data or defaults.data
  end

  if defaults.commitCharacters then
    completion_item.commitCharacters = completion_item.commitCharacters or defaults.commitCharacters
  end

  if defaults.insertTextFormat then
    completion_item.insertTextFormat = completion_item.insertTextFormat or defaults.insertTextFormat
  end

  if defaults.insertTextMode then
    completion_item.insertTextMode = completion_item.insertTextMode or defaults.insertTextMode
  end

  if defaults.editRange then
    if not completion_item.textEdit then
      if defaults.editRange.insert then
        completion_item.textEdit = {
          insert = defaults.editRange.insert,
          replace = defaults.editRange.replace,
          newText = completion_item.textEditText or completion_item.label,
        }
      else
        completion_item.textEdit = {
          range = defaults.editRange, --[[@as lsp.Range]]
          newText = completion_item.textEditText or completion_item.label,
        }
      end
    end
  end

  return completion_item
end

---Convert the oneline range encoding.
entry.convert_range_encoding = function(self, range)
  local from_encoding = self.source:get_position_encoding_kind()
  return self.context.cache:ensure('entry.convert_range_encoding:' .. range.start.character .. ':' .. range['end'].character .. ':' .. from_encoding, function()
    return {
      start = types.lsp.Position.to_utf8(self.context.cursor_line, range.start, from_encoding),
      ['end'] = types.lsp.Position.to_utf8(self.context.cursor_line, range['end'], from_encoding),
    }
  end)
end

---Return true if the entry is invalid.
entry.is_invalid = function(self)
  local is_invalid = false
  is_invalid = is_invalid or misc.empty(self.completion_item.label)
  if self.completion_item.textEdit then
    local range = self.completion_item.textEdit.range or self.completion_item.textEdit.insert
    is_invalid = is_invalid or range.start.line ~= range['end'].line or range.start.line ~= self.context.cursor.line
  end
  return is_invalid
end

return entry
