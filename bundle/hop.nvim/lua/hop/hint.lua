local perm = require'hop.perm'
local prio = require'hop.priority'

local M = {}

M.HintDirection = {
  BEFORE_CURSOR = 1,
  AFTER_CURSOR = 2,
}

M.HintPosition = {
  BEGIN = 1,
  MIDDLE = 2,
  END = 3,
}

local function tbl_to_str(label)
  local s = ''

  for i = 1, #label do
    s = s .. label[i]
  end

  return s
end

-- Reduce a hint.
--
-- This function will remove hints not starting with the input key and will reduce the other ones
-- with one level.
local function reduce_label(label, key)
  local snd_idx = vim.fn.byteidx(label, 1)
  if label:sub(1, snd_idx) == key then
    label = label:sub(snd_idx + 1)
  end

  if label == '' then
    label = nil
  end

  return label
end

-- Reduce all hints and return the one fully reduced, if any.
function M.reduce_hints(hints, key)
  local next_hints = {}

  for _, h in pairs(hints) do
      local prev_label = h.label
      h.label = reduce_label(h.label, key)

      if h.label == nil then
        return h
      elseif h.label ~= prev_label then
        next_hints[#next_hints + 1] = h
      end
  end

  return nil, next_hints
end

-- Create hints from jump targets.
--
-- This function associates jump targets with permutations, creating hints. A hint is then a jump target along with a
-- label.
--
-- If `indirect_jump_targets` is `nil`, `jump_targets` is assumed already ordered with all jump target with the same
-- score (0)
function M.create_hints(jump_targets, indirect_jump_targets, opts)
  local hints = {}
  local perms = perm.permutations(opts.keys, #jump_targets, opts)

  -- get or generate indirect_jump_targets
  if indirect_jump_targets == nil then
    indirect_jump_targets = {}

    for i = 1, #jump_targets do
      indirect_jump_targets[i] = { index = i, score = 0 }
    end
  end

  for i, indirect in pairs(indirect_jump_targets) do
    hints[indirect.index] = {
      label = tbl_to_str(perms[i]),
      jump_target = jump_targets[indirect.index]
    }
  end

  return hints
end

-- Create the extmarks for per-line hints.
--
-- Passing `opts.uppercase_labels = true` will display the hint as uppercase.
function M.set_hint_extmarks(hl_ns, hints, opts)
  for _, hint in pairs(hints) do
    local label = hint.label
    if opts.uppercase_labels then
      label = label:upper()
    end

    local col = hint.jump_target.column - 1

    if vim.fn.strdisplaywidth(label) == 1 then
      vim.api.nvim_buf_set_extmark(hint.jump_target.buffer or 0, hl_ns, hint.jump_target.line, col, {
        virt_text = { { label, "HopNextKey" } },
        virt_text_pos = 'overlay',
        hl_mode = 'combine',
        priority = prio.HINT_PRIO
      })
    else
      -- get the byte index of the second hint so that we can slice it correctly
      local snd_idx = vim.fn.byteidx(label, 1)
      vim.api.nvim_buf_set_extmark(hint.jump_target.buffer or 0, hl_ns, hint.jump_target.line, col, {
        virt_text = { { label:sub(1, snd_idx), "HopNextKey1" }, { label:sub(snd_idx + 1), "HopNextKey2" } },
        virt_text_pos = 'overlay',
        hl_mode = 'combine',
        priority = prio.HINT_PRIO
      })
    end
  end
end

function M.set_hint_preview(hl_ns, jump_targets)
  for _, jt in ipairs(jump_targets) do
    vim.api.nvim_buf_set_extmark(jt.buffer, hl_ns, jt.line, jt.column - 1, {
      end_row = jt.line,
      end_col = jt.column - 1 + jt.length,
      hl_group = 'HopPreview',
      hl_eol = true,
      priority = prio.HINT_PRIO
    })
  end
end

return M
