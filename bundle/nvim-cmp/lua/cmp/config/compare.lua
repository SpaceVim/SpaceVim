local types = require('cmp.types')
local misc = require('cmp.utils.misc')

local compare = {}

-- offset
compare.offset = function(entry1, entry2)
  local diff = entry1:get_offset() - entry2:get_offset()
  if diff < 0 then
    return true
  elseif diff > 0 then
    return false
  end
end

-- exact
compare.exact = function(entry1, entry2)
  if entry1.exact ~= entry2.exact then
    return entry1.exact
  end
end

-- score
compare.score = function(entry1, entry2)
  local diff = entry2.score - entry1.score
  if diff < 0 then
    return true
  elseif diff > 0 then
    return false
  end
end

-- recently_used
compare.recently_used = setmetatable({
  records = {},
  add_entry = function(self, e)
    self.records[e.completion_item.label] = vim.loop.now()
  end,
}, {
  __call = function(self, entry1, entry2)
    local t1 = self.records[entry1.completion_item.label] or -1
    local t2 = self.records[entry2.completion_item.label] or -1
    if t1 ~= t2 then
      return t1 > t2
    end
  end,
})

-- kind
compare.kind = function(entry1, entry2)
  local kind1 = entry1:get_kind()
  kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
  local kind2 = entry2:get_kind()
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
end

-- sortText
compare.sort_text = function(entry1, entry2)
  if misc.safe(entry1.completion_item.sortText) and misc.safe(entry2.completion_item.sortText) then
    local diff = vim.stricmp(entry1.completion_item.sortText, entry2.completion_item.sortText)
    if diff < 0 then
      return true
    elseif diff > 0 then
      return false
    end
  end
end

-- length
compare.length = function(entry1, entry2)
  local diff = #entry1.completion_item.label - #entry2.completion_item.label
  if diff < 0 then
    return true
  elseif diff > 0 then
    return false
  end
end

-- order
compare.order = function(entry1, entry2)
  local diff = entry1.id - entry2.id
  if diff < 0 then
    return true
  elseif diff > 0 then
    return false
  end
end

return compare
