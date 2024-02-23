local action_mt = {}

--- Checks all replacement combinations to determine which function to run.
--- If no replacement can be found, then it will run the original function
local run_replace_or_original = function(replacements, original_func, ...)
  for _, replacement_map in ipairs(replacements or {}) do
    for condition, replacement in pairs(replacement_map) do
      if condition == true or condition(...) then
        return replacement(...)
      end
    end
  end

  return original_func(...)
end

local append_action_copy = function(new, v, old)
  table.insert(new, v)
  new._func[v] = old._func[v]
  new._static_pre[v] = old._static_pre[v]
  new._pre[v] = old._pre[v]
  new._replacements[v] = old._replacements[v]
  new._static_post[v] = old._static_post[v]
  new._post[v] = old._post[v]
end

-- TODO(conni2461): Not a fan of this solution/hack. Needs to be addressed
local all_mts = {}

--TODO(conni2461): It gets worse. This is so bad but because we have now n mts for n actions
--                 We have to check all actions for relevant mts to set replace and before, after
--                 Its not bad for performance because its being called on startup when we attach mappings.
--                 Its just a bad solution
local find_all_relevant_mts = function(action_name, f)
  for _, mt in ipairs(all_mts) do
    for fun, _ in pairs(mt._func) do
      if fun == action_name then
        f(mt)
      end
    end
  end
end

--- an action is metatable which allows replacement(prepend or append) of the function
---@class Action
---@field _func table<string, function>: the original action function
---@field _static_pre table<string, function>: will allways run before the function even if its replaced
---@field _pre table<string, function>: the functions that will run before the action
---@field _replacements table<string, function>: the function that replaces this action
---@field _static_post table<string, function>: will allways run after the function even if its replaced
---@field _post table<string, function>: the functions that will run after the action
action_mt.create = function()
  local mt = {
    __call = function(t, ...)
      local values = {}
      for _, action_name in ipairs(t) do
        if t._static_pre[action_name] then
          t._static_pre[action_name](...)
        end
        if vim.tbl_isempty(t._replacements) and t._pre[action_name] then
          t._pre[action_name](...)
        end

        local result = {
          run_replace_or_original(t._replacements[action_name], t._func[action_name], ...),
        }
        for _, res in ipairs(result) do
          table.insert(values, res)
        end

        if t._static_post[action_name] then
          t._static_post[action_name](...)
        end
        if vim.tbl_isempty(t._replacements) and t._post[action_name] then
          t._post[action_name](...)
        end
      end

      return unpack(values)
    end,

    __add = function(lhs, rhs)
      local new_action = setmetatable({}, action_mt.create())
      for _, v in ipairs(lhs) do
        append_action_copy(new_action, v, lhs)
      end

      for _, v in ipairs(rhs) do
        append_action_copy(new_action, v, rhs)
      end
      new_action.clear = function()
        lhs.clear()
        rhs.clear()
      end

      return new_action
    end,

    _func = {},
    _static_pre = {},
    _pre = {},
    _replacements = {},
    _static_post = {},
    _post = {},
  }

  mt.__index = mt

  mt.clear = function()
    mt._pre = {}
    mt._replacements = {}
    mt._post = {}
  end

  --- Replace the reference to the function with a new one temporarily
  function mt:replace(v)
    assert(#self == 1, "Cannot replace an already combined action")

    return self:replace_map { [true] = v }
  end

  function mt:replace_if(condition, replacement)
    assert(#self == 1, "Cannot replace an already combined action")

    return self:replace_map { [condition] = replacement }
  end

  --- Replace table with
  -- Example:
  --
  -- actions.select:replace_map {
  --   [function() return filetype == 'lua' end] = actions.file_split,
  --   [function() return filetype == 'other' end] = actions.file_split_edit,
  -- }
  function mt:replace_map(tbl)
    assert(#self == 1, "Cannot replace an already combined action")

    local action_name = self[1]
    find_all_relevant_mts(action_name, function(another)
      if not another._replacements[action_name] then
        another._replacements[action_name] = {}
      end

      table.insert(another._replacements[action_name], 1, tbl)
    end)

    return self
  end

  function mt:enhance(opts)
    assert(#self == 1, "Cannot enhance already combined actions")

    local action_name = self[1]
    find_all_relevant_mts(action_name, function(another)
      if opts.pre then
        another._pre[action_name] = opts.pre
      end

      if opts.post then
        another._post[action_name] = opts.post
      end
    end)

    return self
  end

  table.insert(all_mts, mt)
  return mt
end

action_mt.transform = function(k, mt, _, v)
  local res = setmetatable({ k }, mt)
  if type(v) == "table" then
    res._static_pre[k] = v.pre
    res._static_post[k] = v.post
    res._func[k] = v.action
  else
    res._func[k] = v
  end
  return res
end

action_mt.transform_mod = function(mod)
  -- Pass the metatable of the module if applicable.
  --    This allows for custom errors, lookups, etc.
  local redirect = setmetatable({}, getmetatable(mod) or {})

  for k, v in pairs(mod) do
    local mt = action_mt.create()
    redirect[k] = action_mt.transform(k, mt, _, v)
  end

  redirect._clear = function()
    for k, v in pairs(redirect) do
      if k ~= "_clear" then
        pcall(v.clear)
      end
    end
  end

  return redirect
end

action_mt.clear_all = function()
  for _, v in ipairs(all_mts) do
    pcall(v.clear)
  end
end

return action_mt
