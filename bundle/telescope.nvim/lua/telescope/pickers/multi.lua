local MultiSelect = {}
MultiSelect.__index = MultiSelect

function MultiSelect:new()
  return setmetatable({
    _entries = {},
  }, MultiSelect)
end

function MultiSelect:get()
  local marked_entries = {}
  for entry, count in pairs(self._entries) do
    table.insert(marked_entries, { count, entry })
  end

  table.sort(marked_entries, function(left, right)
    return left[1] < right[1]
  end)

  local selections = {}
  for _, entry in ipairs(marked_entries) do
    table.insert(selections, entry[2])
  end

  return selections
end

function MultiSelect:is_selected(entry)
  return self._entries[entry]
end

local multi_select_count = 0
function MultiSelect:add(entry)
  multi_select_count = multi_select_count + 1
  self._entries[entry] = multi_select_count
end

function MultiSelect:drop(entry)
  self._entries[entry] = nil
end

function MultiSelect:toggle(entry)
  if self:is_selected(entry) then
    self:drop(entry)
  else
    self:add(entry)
  end
end

return MultiSelect
