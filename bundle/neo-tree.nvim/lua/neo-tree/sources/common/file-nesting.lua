local iter = require("plenary.iterators").iter
local utils = require("neo-tree.utils")
local Path = require("plenary.path")

-- File nesting a la JetBrains (#117).
local M = {}
M.config = {}

--- Checks if file-nesting module is enabled by config
---@return boolean
function M.is_enabled()
  return next(M.config) ~= nil
end

--- Returns `item` nesting parent path if exists
---@return string?
function M.get_parent(item)
  for base_exts, nesting_exts in pairs(M.config) do
    for _, exts in ipairs(nesting_exts) do
      if item.exts == exts then
        local parent_id = utils.path_join(item.parent_path, item.base) .. "." .. base_exts
        if Path:new(parent_id):exists() then
          return parent_id
        end
      end
    end
  end

  return nil
end

--- Checks if `item` have a valid nesting lookup
---@return boolean
function M.can_have_nesting(item)
  return utils.truthy(M.config[item.exts])
end

--- Checks if `target` should be nested into `base`
---@return boolean
function M.should_nest_file(base, target)
  local ext_lookup = M.config[base.exts]

  return utils.truthy(
    base.base == target.base and ext_lookup and iter(ext_lookup):find(target.exts)
  )
end

---Setup the module with the given config
---@param config table
function M.setup(config)
  M.config = config or {}
end

return M
