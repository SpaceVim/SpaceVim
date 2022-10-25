---@tag telescope.resolve
---@config { ["module"] = "telescope.resolve" }

---@brief [[
--- Provides "resolver functions" to allow more customisable inputs for options.
---@brief ]]

--[[

Ultimately boils down to getting `height` and `width` for:
- prompt
- preview
- results

No matter what you do, I will not make prompt have more than one line (atm)

Result of `resolve` should be a table with:

{
  preview = {
    get_width = function(self, max_columns, max_lines) end
    get_height = function(self, max_columns, max_lines) end
  },

  result = {
    get_width = function(self, max_columns, max_lines) end
    get_height = function(self, max_columns, max_lines) end
  },

  prompt = {
    get_width = function(self, max_columns, max_lines) end
    get_height = function(self, max_columns, max_lines) end
  },

  total ?
}

!!NOT IMPLEMENTED YET!!

height =
    1. 0 <= number < 1
        This means total height as a percentage

    2. 1 <= number
        This means total height as a fixed number

    3. function(picker, columns, lines)
        -> returns one of the above options
        return math.min(110, max_rows * .5)

        if columns > 120 then
            return 110
        else
            return 0.6
        end

    3. {
        previewer = x,
        results = x,
        prompt = x,
    }, this means I do my best guess I can for these, given your options

width =
    exactly the same, but switch to width


{
    height = 0.5,
    width = {
        previewer = 0.25,
        results = 30,
    }
}

https://github.com/nvim-lua/telescope.nvim/pull/43

After we get layout, we should try and make top-down sorting work.
That's the next step to scrolling.

{
    vertical = {
    },
    horizontal = {
    },

    height = ...
    width = ...
}



--]]

local resolver = {}
local _resolve_map = {}

local throw_invalid_config_option = function(key, value)
  error(string.format("Invalid configuration option for '%s': '%s'", key, tostring(value)), 2)
end

-- Booleans
_resolve_map[function(val)
  return val == false
end] = function(_, val)
  return function(...)
    return val
  end
end

-- Percentages
_resolve_map[function(val)
  return type(val) == "number" and val >= 0 and val < 1
end] = function(selector, val)
  return function(...)
    local selected = select(selector, ...)
    return math.floor(val * selected)
  end
end

-- Numbers
_resolve_map[function(val)
  return type(val) == "number" and val >= 1
end] = function(selector, val)
  return function(...)
    local selected = select(selector, ...)
    return math.min(val, selected)
  end
end

-- function:
--    Function must have same signature as get_window_layout
--        function(self, max_columns, max_lines): number
--
--    Resulting number is used for this configuration value.
_resolve_map[function(val)
  return type(val) == "function"
end] = function(_, val)
  return val
end

_resolve_map[function(val)
  return type(val) == "table" and val["max"] ~= nil and val[1] ~= nil and val[1] >= 0 and val[1] < 1
end] =
  function(selector, val)
    return function(...)
      local selected = select(selector, ...)
      return math.min(math.floor(val[1] * selected), val["max"])
    end
  end

_resolve_map[function(val)
  return type(val) == "table" and val["min"] ~= nil and val[1] ~= nil and val[1] >= 0 and val[1] < 1
end] =
  function(selector, val)
    return function(...)
      local selected = select(selector, ...)
      return math.max(math.floor(val[1] * selected), val["min"])
    end
  end

-- Add padding option
_resolve_map[function(val)
  return type(val) == "table" and val["padding"] ~= nil
end] = function(selector, val)
  local resolve_pad = function(value)
    for k, v in pairs(_resolve_map) do
      if k(value) then
        return v(selector, value)
      end
    end
    throw_invalid_config_option("padding", value)
  end

  return function(...)
    local selected = select(selector, ...)
    local padding = resolve_pad(val["padding"])
    return math.floor(selected - 2 * padding(...))
  end
end

--- Converts input to a function that returns the height.
--- The input must take one of five forms:
--- 1. 0 <= number < 1 <br>
---     This means total height as a percentage.
--- 2. 1 <= number <br>
---     This means total height as a fixed number.
--- 3. function <br>
---     Must have signature:
---       function(self, max_columns, max_lines): number
--- 4. table of the form: { val, max = ..., min = ... } <br>
---     val has to be in the first form 0 <= val < 1 and only one is given,
---     `min` or `max` as fixed number
--- 5. table of the form: {padding = `foo`} <br>
---     where `foo` has one of the previous three forms. <br>
---     The height is then set to be the remaining space after padding.
---     For example, if the window has height 50, and the input is {padding = 5},
---     the height returned will be `40 = 50 - 2*5`
---
--- The returned function will have signature:
---     function(self, max_columns, max_lines): number
resolver.resolve_height = function(val)
  for k, v in pairs(_resolve_map) do
    if k(val) then
      return v(3, val)
    end
  end
  throw_invalid_config_option("height", val)
end

--- Converts input to a function that returns the width.
--- The input must take one of five forms:
--- 1. 0 <= number < 1 <br>
---     This means total width as a percentage.
--- 2. 1 <= number <br>
---     This means total width as a fixed number.
--- 3. function <br>
---     Must have signature:
---       function(self, max_columns, max_lines): number
--- 4. table of the form: { val, max = ..., min = ... } <br>
---     val has to be in the first form 0 <= val < 1 and only one is given,
---     `min` or `max` as fixed number
--- 5. table of the form: {padding = `foo`} <br>
---     where `foo` has one of the previous three forms. <br>
---     The width is then set to be the remaining space after padding.
---     For example, if the window has width 100, and the input is {padding = 5},
---     the width returned will be `90 = 100 - 2*5`
---
--- The returned function will have signature:
---     function(self, max_columns, max_lines): number
resolver.resolve_width = function(val)
  for k, v in pairs(_resolve_map) do
    if k(val) then
      return v(2, val)
    end
  end

  throw_invalid_config_option("width", val)
end

--- Calculates the adjustment required to move the picker from the middle of the screen to
--- an edge or corner. <br>
--- The `anchor` can be any of the following strings:
---   - "", "CENTER", "NW", "N", "NE", "E", "SE", "S", "SW", "W"
--- The anchors have the following meanings:
---   - "" or "CENTER":<br>
---     the picker will remain in the middle of the screen.
---   - Compass directions:<br>
---     the picker will move to the corresponding edge/corner
---     e.g. "NW" -> "top left corner", "E" -> "right edge", "S" -> "bottom edge"
resolver.resolve_anchor_pos = function(anchor, p_width, p_height, max_columns, max_lines)
  anchor = anchor:upper()
  local pos = { 0, 0 }
  if anchor == "CENTER" then
    return pos
  end
  if anchor:find "W" then
    pos[1] = math.ceil((p_width - max_columns) / 2) + 1
  elseif anchor:find "E" then
    pos[1] = math.ceil((max_columns - p_width) / 2) - 1
  end
  if anchor:find "N" then
    pos[2] = math.ceil((p_height - max_lines) / 2) + 1
  elseif anchor:find "S" then
    pos[2] = math.ceil((max_lines - p_height) / 2) - 1
  end
  return pos
end

-- Win option always returns a table with preview, results, and prompt.
-- It handles many different ways. Some examples are as follows:
--
-- -- Disable
-- borderchars = false
--
-- -- All three windows share the same
-- borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
--
-- -- Each window gets it's own configuration
-- borderchars = {
--   preview = {...},
--   results = {...},
--   prompt = {...},
-- }
--
-- -- Default to [1] but override with specific items
-- borderchars = {
--   {...}
--   prompt = {...},
-- }
resolver.win_option = function(val, default)
  if type(val) ~= "table" or vim.tbl_islist(val) then
    if val == nil then
      val = default
    end

    return {
      preview = val,
      results = val,
      prompt = val,
    }
  elseif type(val) == "table" then
    assert(not vim.tbl_islist(val))

    local val_to_set = val[1]
    if val_to_set == nil then
      val_to_set = default
    end

    return {
      preview = vim.F.if_nil(val.preview, val_to_set),
      results = vim.F.if_nil(val.results, val_to_set),
      prompt = vim.F.if_nil(val.prompt, val_to_set),
    }
  end
end

return resolver
