local utils = require("neo-tree.utils")

local M = {}

M.normalize_map_key = function(key)
  if key == nil then
    return nil
  end
  if key:match("^<[^>]+>$") then
    local parts = utils.split(key, "-")
    if #parts == 2 then
      local mod = parts[1]:lower()
      if mod == "<a" then
        mod = "<m"
      end
      local alpha = parts[2]
      if #alpha > 2 then
        alpha = alpha:lower()
      end
      key = string.format("%s-%s", mod, alpha)
      return key
    else
      key = key:lower()
      if key == "<backspace>" then
        return "<bs>"
      elseif key == "<enter>" then
        return "<cr>"
      elseif key == "<return>" then
        return "<cr>"
      end
    end
  end
  return key
end

M.normalize_map = function(map)
  local new_map = {}
  for key, value in pairs(map) do
    local normalized_key = M.normalize_map_key(key)
    if normalized_key ~= nil then
      new_map[normalized_key] = value
    end
  end
  return new_map
end

local tests = {
  { "<BS>", "<bs>" },
  { "<Backspace>", "<bs>" },
  { "<Enter>", "<cr>" },
  { "<C-W>", "<c-W>" },
  { "<A-q>", "<m-q>" },
  { "<C-Left>", "<c-left>" },
  { "<C-Right>", "<c-right>" },
  { "<C-Up>", "<c-up>" },
}
for _, test in ipairs(tests) do
  local key = M.normalize_map_key(test[1])
  assert(key == test[2], string.format("%s != %s", key, test[2]))
end

return M
