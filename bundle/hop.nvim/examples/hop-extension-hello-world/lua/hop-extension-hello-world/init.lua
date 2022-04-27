local M = {}
M.opts = {}

function M.hint_around_cursor(opts)
  -- the jump target generator; we are simply going to retreive the cursor position and hint around it as an example
  local jump_targets = function() -- opts ignored
    local cursor_pos = require'hop.window'.get_window_context().cursor_pos
    local line = cursor_pos[1] - 1
    local col = cursor_pos[2] + 1

    local jump_targets = {}

    -- left
    if col > 0 then
      jump_targets[#jump_targets + 1] = { line = line, column = col - 1, window = 0 }
    end

    -- right
    jump_targets[#jump_targets + 1] = { line = line, column = col + 1, window = 0 }

    return { jump_targets = jump_targets }
  end

  require'hop'.hint_with(jump_targets, opts)
end

function M.register(opts)
  vim.notify('registering the nice extension', 0)
  M.opts = opts
end

return M
