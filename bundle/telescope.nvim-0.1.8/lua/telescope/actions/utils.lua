---@tag telescope.actions.utils
---@config { ["module"] = "telescope.actions.utils", ["name"] = "ACTIONS_UTILS" }

---@brief [[
--- Utilities to wrap functions around picker selections and entries.
---
--- Generally used from within other |telescope.actions|
---@brief ]]

local action_state = require "telescope.actions.state"

local utils = {}

--- Apply `f` to the entries of the current picker.
--- - Notes:
---   - Mapped entries include all currently filtered results, not just the visible ones.
---   - Indices are 1-indexed, whereas rows are 0-indexed.
--- - Warning: `map_entries` has no return value.
---   - The below example showcases how to collect results
---
--- Usage:
--- <code>
---   local action_state = require "telescope.actions.state"
---   local action_utils = require "telescope.actions.utils"
---   function entry_value_by_row()
---     local prompt_bufnr = vim.api.nvim_get_current_buf()
---     local current_picker = action_state.get_current_picker(prompt_bufnr)
---     local results = {}
---     action_utils.map_entries(prompt_bufnr, function(entry, index, row)
---       results[row] = entry.value
---     end)
---     return results
---   end
--- </code>
---@param prompt_bufnr number: The prompt bufnr
---@param f function: Function to map onto entries of picker that takes (entry, index, row) as viable arguments
function utils.map_entries(prompt_bufnr, f)
  vim.validate {
    f = { f, "function" },
  }
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local index = 1
  -- indices are 1-indexed, rows are 0-indexed
  for entry in current_picker.manager:iter() do
    local row = current_picker:get_row(index)
    f(entry, index, row)
    index = index + 1
  end
end

--- Apply `f` to the multi selections of the current picker and return a table of mapped selections.
--- - Notes:
---   - Mapped selections may include results not visible in the results pop up.
---   - Selected entries are returned in order of their selection.
--- - Warning: `map_selections` has no return value.
---   - The below example showcases how to collect results
---
--- Usage:
--- <code>
---   local action_state = require "telescope.actions.state"
---   local action_utils = require "telescope.actions.utils"
---   function selection_by_index()
---     local prompt_bufnr = vim.api.nvim_get_current_buf()
---     local current_picker = action_state.get_current_picker(prompt_bufnr)
---     local results = {}
---     action_utils.map_selections(prompt_bufnr, function(entry, index)
---       results[index] = entry.value
---     end)
---     return results
---   end
--- </code>
---@param prompt_bufnr number: The prompt bufnr
---@param f function: Function to map onto selection of picker that takes (selection) as a viable argument
function utils.map_selections(prompt_bufnr, f)
  vim.validate {
    f = { f, "function" },
  }
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  for _, selection in ipairs(current_picker:get_multi_selection()) do
    f(selection)
  end
end

--- Utility to collect mappings of prompt buffer in array of `{mode, keybind, name}`.
---@param prompt_bufnr number: The prompt bufnr
function utils.get_registered_mappings(prompt_bufnr)
  local ret = {}
  for _, mode in ipairs { "n", "i" } do
    for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(prompt_bufnr, mode)) do
      -- ensure only telescope mappings
      if mapping.desc then
        if mapping.desc:sub(1, 10) == "telescope|" then
          table.insert(ret, { mode = mode, keybind = mapping.lhs, desc = mapping.desc:sub(11) })
        elseif mapping.desc:sub(1, 11) == "telescopej|" then
          local fname = utils._get_anon_function_name(vim.json.decode(mapping.desc:sub(12)))
          fname = fname:lower() == mapping.lhs:lower() and "<anonymous>" or fname
          table.insert(ret, {
            mode = mode,
            keybind = mapping.lhs,
            desc = fname,
          })
        end
      end
    end
  end
  return ret
end

-- Best effort to infer function names for actions.which_key
function utils._get_anon_function_name(info)
  local Path = require "plenary.path"
  local fname
  -- if fn defined in string (ie loadstring) source is string
  -- if fn defined in file, source is file name prefixed with a `@´
  local path = Path:new((info.source:gsub("@", "")))
  if not path:exists() then
    return "<anonymous>"
  end
  for i, line in ipairs(path:readlines()) do
    if i == info.linedefined then
      fname = line
      break
    end
  end

  -- test if assignment or named function, otherwise anon
  if (fname:match "=" == nil) and (fname:match "function %S+%(" == nil) then
    return "<anonymous>"
  else
    local patterns = {
      { "function", "" }, -- remove function
      { "local", "" }, -- remove local
      { "[%s=]", "" }, -- remove whitespace and =
      { [=[%[["']]=], "" }, -- remove left-hand bracket of table assignment
      { [=[["']%]]=], "" }, -- remove right-ahnd bracket of table assignment
      { "%((.+)%)", "" }, -- remove function arguments
      { "(.+)%.", "" }, -- remove TABLE. prefix if available
    }
    for _, tbl in ipairs(patterns) do
      fname = (fname:gsub(tbl[1], tbl[2])) -- make sure only string is returned
    end
    -- not sure if this can happen, catch all just in case
    if fname == nil or fname == "" then
      return "<anonymous>"
    end
    return fname
  end
end

return utils
