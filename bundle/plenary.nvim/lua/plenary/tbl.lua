local tbl = {}

function tbl.apply_defaults(original, defaults)
  if original == nil then
    original = {}
  end

  original = vim.deepcopy(original)

  for k, v in pairs(defaults) do
    if original[k] == nil then
      original[k] = v
    end
  end

  return original
end

function tbl.pack(...)
  return { n = select("#", ...), ... }
end

function tbl.unpack(t, i, j)
  return unpack(t, i or 1, j or t.n or #t)
end

---Freeze a table. A frozen table is not able to be modified.
---http://lua-users.org/wiki/ReadOnlyTables
---@param t table
---@return table
function tbl.freeze(t)
  return setmetatable({}, {
    __index = t,
    __newindex = function()
      error "Attempt to modify frozen table"
    end,
  })
end

return tbl
