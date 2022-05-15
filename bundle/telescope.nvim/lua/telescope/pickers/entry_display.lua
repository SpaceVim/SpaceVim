local strings = require "plenary.strings"
local state = require "telescope.state"
local resolve = require "telescope.config.resolve"

local entry_display = {}
entry_display.truncate = strings.truncate

entry_display.create = function(configuration)
  local generator = {}
  for _, v in ipairs(configuration.items) do
    if v.width then
      local justify = v.right_justify
      local width
      table.insert(generator, function(item)
        if width == nil then
          local status = state.get_status(vim.F.if_nil(configuration.prompt_bufnr, vim.api.nvim_get_current_buf()))
          local s = {}
          s[1] = vim.api.nvim_win_get_width(status.results_win) - #status.picker.selection_caret
          s[2] = vim.api.nvim_win_get_height(status.results_win)
          width = resolve.resolve_width(v.width)(nil, s[1], s[2])
        end
        if type(item) == "table" then
          return strings.align_str(entry_display.truncate(item[1], width), width, justify), item[2]
        else
          return strings.align_str(entry_display.truncate(item, width), width, justify)
        end
      end)
    else
      table.insert(generator, function(item)
        if type(item) == "table" then
          return item[1], item[2]
        else
          return item
        end
      end)
    end
  end

  return function(self, picker)
    local results = {}
    local highlights = {}
    for i = 1, #generator do
      if self[i] ~= nil then
        local str, hl = generator[i](self[i], picker)
        if hl then
          local hl_start = 0
          for j = 1, (i - 1) do
            hl_start = hl_start + #results[j] + (#configuration.separator or 1)
          end
          local hl_end = hl_start + #str:gsub("%s*$", "")

          if type(hl) == "function" then
            for _, hl_res in ipairs(hl()) do
              table.insert(highlights, { { hl_res[1][1] + hl_start, hl_res[1][2] + hl_start }, hl_res[2] })
            end
          else
            table.insert(highlights, { { hl_start, hl_end }, hl })
          end
        end

        table.insert(results, str)
      end
    end

    if configuration.separator_hl then
      local width = #configuration.separator or 1

      local hl_start, hl_end
      for _, v in ipairs(results) do
        hl_start = (hl_end or 0) + #tostring(v)
        hl_end = hl_start + width
        table.insert(highlights, { { hl_start, hl_end }, configuration.separator_hl })
      end
    end

    local final_str = table.concat(results, configuration.separator or "│")
    if configuration.hl_chars then
      for i = 1, #final_str do
        local c = final_str:sub(i, i)
        local hl = configuration.hl_chars[c]
        if hl then
          table.insert(highlights, { { i - 1, i }, hl })
        end
      end
    end

    return final_str, highlights
  end
end

entry_display.resolve = function(self, entry)
  local display, display_highlights
  if type(entry.display) == "function" then
    self:_increment "display_fn"
    display, display_highlights = entry:display(self)

    if type(display) == "string" then
      return display, display_highlights
    end
  else
    display = entry.display
  end

  if type(display) == "string" then
    return display, display_highlights
  end
end

return entry_display
