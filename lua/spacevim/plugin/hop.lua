local M = {}
-- Like hop.jump_target.regex_by_line_start_skip_whitespace() except it also
-- marks empty or whitespace only lines
local function regexLines()
  return {
    oneshot = true,
    match = function(str)
      return vim.regex('http[s]*://'):match_str(str)
    end,
  }
end

-- Like :HopLineStart except it also jumps to empty or whitespace only lines
function M.hintLines(opts)
  -- Taken from override_opts()
  opts = setmetatable(opts or {}, { __index = require('hop').opts })

  local gen = require('hop.jump_target').jump_targets_by_scanning_lines
  require('hop').hint_with(gen(regexLines()), opts)
end

return M
