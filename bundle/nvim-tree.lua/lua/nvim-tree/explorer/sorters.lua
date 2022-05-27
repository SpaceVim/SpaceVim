local M = {
  sort_by = nil,
  node_comparator = nil,
}

---Create a shallow copy of a portion of a list.
---@param t table
---@param first integer First index, inclusive
---@param last integer Last index, inclusive
---@return table
local function tbl_slice(t, first, last)
  local slice = {}
  for i = first, last or #t, 1 do
    table.insert(slice, t[i])
  end

  return slice
end

local function merge(t, first, mid, last, comparator)
  local n1 = mid - first + 1
  local n2 = last - mid
  local ls = tbl_slice(t, first, mid)
  local rs = tbl_slice(t, mid + 1, last)
  local i = 1
  local j = 1
  local k = first

  while i <= n1 and j <= n2 do
    if comparator(ls[i], rs[j]) then
      t[k] = ls[i]
      i = i + 1
    else
      t[k] = rs[j]
      j = j + 1
    end
    k = k + 1
  end

  while i <= n1 do
    t[k] = ls[i]
    i = i + 1
    k = k + 1
  end

  while j <= n2 do
    t[k] = rs[j]
    j = j + 1
    k = k + 1
  end
end

local function split_merge(t, first, last, comparator)
  if (last - first) < 1 then
    return
  end

  local mid = math.floor((first + last) / 2)

  split_merge(t, first, mid, comparator)
  split_merge(t, mid + 1, last, comparator)
  merge(t, first, mid, last, comparator)
end

---Perform a merge sort on a given list.
---@param t any[]
---@param comparator function|nil
function M.merge_sort(t, comparator)
  if not comparator then
    comparator = function(left, right)
      return left < right
    end
  end

  split_merge(t, 1, #t, comparator)
end

local function node_comparator_name_ignorecase_or_not(a, b, ignorecase)
  if not (a and b) then
    return true
  end
  if a.nodes and not b.nodes then
    return true
  elseif not a.nodes and b.nodes then
    return false
  end

  if ignorecase then
    return a.name:lower() <= b.name:lower()
  else
    return a.name <= b.name
  end
end

function M.node_comparator_name_case_sensisive(a, b)
  return node_comparator_name_ignorecase_or_not(a, b, false)
end

function M.node_comparator_name_ignorecase(a, b)
  return node_comparator_name_ignorecase_or_not(a, b, true)
end

function M.node_comparator_modification_time(a, b)
  if not (a and b) then
    return true
  end
  if a.nodes and not b.nodes then
    return true
  elseif not a.nodes and b.nodes then
    return false
  end

  local last_modified_a = 0
  local last_modified_b = 0

  if a.fs_stat ~= nil then
    last_modified_a = a.fs_stat.mtime.sec
  end

  if b.fs_stat ~= nil then
    last_modified_b = b.fs_stat.mtime.sec
  end

  return last_modified_b <= last_modified_a
end

function M.setup(opts)
  M.sort_by = opts.sort_by
  if M.sort_by == "modification_time" then
    M.node_comparator = M.node_comparator_modification_time
  elseif M.sort_by == "case_sensitive" then
    M.node_comparator = M.node_comparator_name_case_sensisive
  else
    M.node_comparator = M.node_comparator_name_ignorecase
  end
end

return M
