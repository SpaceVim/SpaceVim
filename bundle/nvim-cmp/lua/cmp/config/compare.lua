local types = require('cmp.types')
local cache = require('cmp.utils.cache')

---@type cmp.Comparator[]
local compare = {}

--- Comparators (:help cmp-config.sorting.comparators) should return
--- true when the first entry should come EARLIER (i.e., higher ranking) than the second entry,
--- or nil if no pairwise ordering preference from the comparator.
--- See also :help table.sort() and cmp.view.open() to see how comparators are used.

---@class cmp.ComparatorFunctor
---@overload fun(entry1: cmp.Entry, entry2: cmp.Entry): boolean | nil
---@alias cmp.ComparatorFunction fun(entry1: cmp.Entry, entry2: cmp.Entry): boolean | nil
---@alias cmp.Comparator cmp.ComparatorFunction | cmp.ComparatorFunctor

---offset: Entries with smaller offset will be ranked higher.
---@type cmp.ComparatorFunction
compare.offset = function(entry1, entry2)
  local diff = entry1:get_offset() - entry2:get_offset()
  if diff < 0 then
    return true
  elseif diff > 0 then
    return false
  end
  return nil
end

---exact: Entries with exact == true will be ranked higher.
---@type cmp.ComparatorFunction
compare.exact = function(entry1, entry2)
  if entry1.exact ~= entry2.exact then
    return entry1.exact
  end
  return nil
end

---score: Entries with higher score will be ranked higher.
---@type cmp.ComparatorFunction
compare.score = function(entry1, entry2)
  local diff = entry2.score - entry1.score
  if diff < 0 then
    return true
  elseif diff > 0 then
    return false
  end
  return nil
end

---recently_used: Entries that are used recently will be ranked higher.
---@type cmp.ComparatorFunctor
compare.recently_used = setmetatable({
  records = {},
  add_entry = function(self, e)
    self.records[e.completion_item.label] = vim.loop.now()
  end,
}, {
  ---@type fun(self: table, entry1: cmp.Entry, entry2: cmp.Entry): boolean|nil
  __call = function(self, entry1, entry2)
    local t1 = self.records[entry1.completion_item.label] or -1
    local t2 = self.records[entry2.completion_item.label] or -1
    if t1 ~= t2 then
      return t1 > t2
    end
    return nil
  end,
})

---kind: Entires with smaller ordinal value of 'kind' will be ranked higher.
---(see lsp.CompletionItemKind enum).
---Exceptions are that Text(1) will be ranked the lowest, and snippets be the highest.
---@type cmp.ComparatorFunction
compare.kind = function(entry1, entry2)
  local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
  local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
  kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
  kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
  if kind1 ~= kind2 then
    if kind1 == types.lsp.CompletionItemKind.Snippet then
      return true
    end
    if kind2 == types.lsp.CompletionItemKind.Snippet then
      return false
    end
    local diff = kind1 - kind2
    if diff < 0 then
      return true
    elseif diff > 0 then
      return false
    end
  end
  return nil
end

---sort_text: Entries will be ranked according to the lexicographical order of sortText.
---@type cmp.ComparatorFunction
compare.sort_text = function(entry1, entry2)
  if entry1.completion_item.sortText and entry2.completion_item.sortText then
    local diff = vim.stricmp(entry1.completion_item.sortText, entry2.completion_item.sortText)
    if diff < 0 then
      return true
    elseif diff > 0 then
      return false
    end
  end
  return nil
end

---length: Entires with shorter label length will be ranked higher.
---@type cmp.ComparatorFunction
compare.length = function(entry1, entry2)
  local diff = #entry1.completion_item.label - #entry2.completion_item.label
  if diff < 0 then
    return true
  elseif diff > 0 then
    return false
  end
  return nil
end

----order: Entries with smaller id will be ranked higher.
---@type fun(entry1: cmp.Entry, entry2: cmp.Entry): boolean|nil
compare.order = function(entry1, entry2)
  local diff = entry1.id - entry2.id
  if diff < 0 then
    return true
  elseif diff > 0 then
    return false
  end
  return nil
end

---locality: Entries with higher locality (i.e., words that are closer to the cursor)
---will be ranked higher. See GH-183 for more details.
---@type cmp.ComparatorFunctor
compare.locality = setmetatable({
  lines_count = 10,
  lines_cache = cache.new(),
  locality_map = {},
  update = function(self)
    local config = require('cmp').get_config()
    if not vim.tbl_contains(config.sorting.comparators, compare.locality) then
      return
    end

    local win, buf = vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf()
    local cursor_row = vim.api.nvim_win_get_cursor(win)[1] - 1
    local max = vim.api.nvim_buf_line_count(buf)

    if self.lines_cache:get('buf') ~= buf then
      self.lines_cache:clear()
      self.lines_cache:set('buf', buf)
    end

    self.locality_map = {}
    for i = math.max(0, cursor_row - self.lines_count), math.min(max, cursor_row + self.lines_count) do
      local is_above = i < cursor_row
      local buffer = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1] or ''
      local locality_map = self.lines_cache:ensure({ 'line', buffer }, function()
        local locality_map = {}
        local regexp = vim.regex(config.completion.keyword_pattern)
        while buffer ~= '' do
          local s, e = regexp:match_str(buffer)
          if s and e then
            local w = string.sub(buffer, s + 1, e)
            local d = math.abs(i - cursor_row) - (is_above and 1 or 0)
            locality_map[w] = math.min(locality_map[w] or math.huge, d)
            buffer = string.sub(buffer, e + 1)
          else
            break
          end
        end
        return locality_map
      end)
      for w, d in pairs(locality_map) do
        self.locality_map[w] = math.min(self.locality_map[w] or d, math.abs(i - cursor_row))
      end
    end
  end,
}, {
  ---@type fun(self: table, entry1: cmp.Entry, entry2: cmp.Entry): boolean|nil
  __call = function(self, entry1, entry2)
    local local1 = self.locality_map[entry1:get_word()]
    local local2 = self.locality_map[entry2:get_word()]
    if local1 ~= local2 then
      if local1 == nil then
        return false
      end
      if local2 == nil then
        return true
      end
      return local1 < local2
    end
    return nil
  end,
})

---scopes: Entries defined in a closer scope will be ranked higher (e.g., prefer local variables to globals).
---@type cmp.ComparatorFunctor
compare.scopes = setmetatable({
  scopes_map = {},
  update = function(self)
    local config = require('cmp').get_config()
    if not vim.tbl_contains(config.sorting.comparators, compare.scopes) then
      return
    end

    local ok, locals = pcall(require, 'nvim-treesitter.locals')
    if ok then
      local win, buf = vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf()
      local cursor_row = vim.api.nvim_win_get_cursor(win)[1] - 1

      -- Cursor scope.
      local cursor_scope = nil
      for _, scope in ipairs(locals.get_scopes(buf)) do
        if scope:start() <= cursor_row and cursor_row <= scope:end_() then
          if not cursor_scope then
            cursor_scope = scope
          else
            if cursor_scope:start() <= scope:start() and scope:end_() <= cursor_scope:end_() then
              cursor_scope = scope
            end
          end
        elseif cursor_scope and cursor_scope:end_() <= scope:start() then
          break
        end
      end

      -- Definitions.
      local definitions = locals.get_definitions_lookup_table(buf)

      -- Narrow definitions.
      local depth = 0
      for scope in locals.iter_scope_tree(cursor_scope, buf) do
        local s, e = scope:start(), scope:end_()

        -- Check scope's direct child.
        for _, definition in pairs(definitions) do
          if s <= definition.node:start() and definition.node:end_() <= e then
            if scope:id() == locals.containing_scope(definition.node, buf):id() then
              local get_node_text = vim.treesitter.get_node_text or vim.treesitter.query.get_node_text
              local text = get_node_text(definition.node, buf) or ''
              if not self.scopes_map[text] then
                self.scopes_map[text] = depth
              end
            end
          end
        end
        depth = depth + 1
      end
    end
  end,
}, {
  ---@type fun(self: table, entry1: cmp.Entry, entry2: cmp.Entry): boolean|nil
  __call = function(self, entry1, entry2)
    local local1 = self.scopes_map[entry1:get_word()]
    local local2 = self.scopes_map[entry2:get_word()]
    if local1 ~= local2 then
      if local1 == nil then
        return false
      end
      if local2 == nil then
        return true
      end
      return local1 < local2
    end
  end,
})

return compare
