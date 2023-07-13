--[[ =============================================================================

Get metadata from entries.

This file is still WIP, so expect some changes if you're trying to consume these APIs.

This will provide standard mechanism for accessing information from an entry.

--============================================================================= ]]

local from_entry = {}

function from_entry.path(entry, validate, escape)
  escape = vim.F.if_nil(escape, true)
  local path = entry.path
  if path == nil then
    path = entry.filename
  end
  if path == nil then
    path = entry.value
  end
  if path == nil then
    require("telescope.log").error(string.format("Invalid Entry: '%s'", vim.inspect(entry)))
    return
  end

  -- only 0 if neither filereadable nor directory
  if validate then
    -- We need to expand for filereadable and isdirectory
    -- TODO(conni2461): we are not going to return the expanded path because
    --                  this would lead to cache misses in the perviewer.
    --                  Requires overall refactoring in previewer interface
    local expanded = vim.fn.expand(vim.fn.escape(path, "$?*[]"))
    if (vim.fn.filereadable(expanded) + vim.fn.isdirectory(expanded)) == 0 then
      return
    end
  end
  if escape then
    return vim.fn.fnameescape(path)
  end
  return path
end

return from_entry
