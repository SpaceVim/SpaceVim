local state = {}

TelescopeGlobalState = TelescopeGlobalState or {}
TelescopeGlobalState.global = TelescopeGlobalState.global or {}

--- Set the status for a particular prompt bufnr
function state.set_status(prompt_bufnr, status)
  TelescopeGlobalState[prompt_bufnr] = status
end

function state.set_global_key(key, value)
  TelescopeGlobalState.global[key] = value
end

function state.get_global_key(key)
  return TelescopeGlobalState.global[key]
end

function state.get_status(prompt_bufnr)
  return TelescopeGlobalState[prompt_bufnr] or {}
end

function state.clear_status(prompt_bufnr)
  state.set_status(prompt_bufnr, nil)
end

function state.get_existing_prompt_bufnrs()
  local prompt_bufnrs = {}

  for key, _ in pairs(TelescopeGlobalState) do
    if type(key) == "number" then
      table.insert(prompt_bufnrs, key)
    end
  end

  return prompt_bufnrs
end

return state
