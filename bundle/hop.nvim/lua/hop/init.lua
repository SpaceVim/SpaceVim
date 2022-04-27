local defaults = require'hop.defaults'
local hint = require'hop.hint'
local jump_target = require'hop.jump_target'
local prio = require'hop.priority'
local window = require'hop.window'

local M = {}

-- Ensure options are sound.
--
-- Some options cannot be used together. For instance, multi_windows and current_line_only don’t really make sense used
-- together. This function will notify the user of such ill-formed configurations.
local function check_opts(opts)
  if not opts then
    return
  end

  if opts.multi_windows and opts.current_line_only then
    vim.notify('Cannot use current_line_only across multiple windows', 3)
  end
end

-- Allows to override global options with user local overrides.
local function override_opts(opts)
  check_opts(opts)
  return setmetatable(opts or {}, {__index = M.opts})
end

-- Display error messages.
local function eprintln(msg, teasing)
  if teasing then
    vim.api.nvim_echo({{msg, 'Error'}}, true, {})
  end
end

-- A hack to prevent #57 by deleting twice the namespace (it’s super weird).
local function clear_namespace(buf_handle, hl_ns)
  vim.api.nvim_buf_clear_namespace(buf_handle, hl_ns, 0, -1)
  vim.api.nvim_buf_clear_namespace(buf_handle, hl_ns, 0, -1)
end

-- Dim everything out to prepare the Hop session.
--
-- - hl_ns is the highlight namespace.
-- - top_line is the top line in the buffer to start highlighting at
-- - bottom_line is the bottom line in the buffer to stop highlighting at
local function apply_dimming(buf_handle, hl_ns, top_line, bottom_line, cursor_pos, direction, current_line_only)
  local start_line = top_line
  local end_line = bottom_line
  local start_col = 0
  local end_col = nil

  if direction == hint.HintDirection.AFTER_CURSOR then
    start_col = cursor_pos[2]
  elseif direction == hint.HintDirection.BEFORE_CURSOR then
    if cursor_pos[2] ~= 0 then
      end_col = cursor_pos[2] + 1
    end
  end

  if current_line_only then
    if direction == hint.HintDirection.BEFORE_CURSOR then
      start_line = cursor_pos[1] - 1
      end_line = cursor_pos[1] - 1
    else
      start_line = cursor_pos[1] - 1
      end_line = cursor_pos[1]
    end
  end

  vim.api.nvim_buf_set_extmark(buf_handle, hl_ns, start_line, start_col, {
    end_line = end_line,
    end_col = end_col,
    hl_group = 'HopUnmatched',
    hl_eol = true,
    priority = prio.DIM_PRIO
  })
end

-- Add the virtual cursor, taking care to handle the cases where:
-- - the virtualedit option is being used and the cursor is in a
--   tab character or past the end of the line
-- - the current line is empty
-- - there are multibyte characters on the line
local function add_virt_cur(ns)
  local cur_info = vim.fn.getcurpos()
  local cur_row = cur_info[2] - 1
  local cur_col = cur_info[3] - 1 -- this gives cursor column location, in bytes
  local cur_offset = cur_info[4]
  local virt_col = cur_info[5] - 1
  local cur_line = vim.api.nvim_get_current_line()

  -- first check to see if cursor is in a tab char or past end of line
  if cur_offset ~= 0 then
    vim.api.nvim_buf_set_extmark(0, ns, cur_row, cur_col, {
      virt_text = {{'█', 'Normal'}},
      virt_text_win_col = virt_col,
      priority = prio.CURSOR_PRIO
    })
  -- otherwise check to see if cursor is at end of line or on empty line
  elseif #cur_line == cur_col then
    vim.api.nvim_buf_set_extmark(0, ns, cur_row, cur_col, {
      virt_text = {{'█', 'Normal'}},
      virt_text_pos = 'overlay',
      priority = prio.CURSOR_PRIO
    })
  else
    vim.api.nvim_buf_set_extmark(0, ns, cur_row, cur_col, {
      -- end_col must be column of next character, in bytes
      end_col = vim.fn.byteidx(cur_line, vim.fn.charidx(cur_line, cur_col) + 1),
      hl_group = 'HopCursor',
      priority = prio.CURSOR_PRIO
    })
  end
end

-- Move the cursor at a given location.
--
-- If inclusive is `true`, the jump target will be incremented visually by 1, so that operator-pending motions can
-- correctly take into account the right offset. This is the main difference between motions such as `f` (inclusive)
-- and `t` (exclusive).
--
-- This function will update the jump list.
function M.move_cursor_to(w, line, column, inclusive)
  -- If we do not ask for inclusive jump, we don’t have to retreive any additional lines because we will jump to the
  -- actual jump target. If we do want an inclusive jump, we need to retreive the line the jump target lies in so that
  -- we can compute the offset correctly. This is linked to the fact that currently, Neovim doesn’s have an API to «
  -- offset something by 1 visual column. »
  if inclusive then
    local buf_line = vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(w), line - 1, line, false)[1]
    column = vim.fn.byteidx(buf_line, column + 1)
  end

  -- update the jump list
  vim.cmd("normal! m'")
  vim.api.nvim_set_current_win(w)
  vim.api.nvim_win_set_cursor(w, { line, column})
end

function M.hint_with(jump_target_gtr, opts)
  if opts == nil then
    opts = override_opts(opts)
  end

  M.hint_with_callback(jump_target_gtr, opts, function(jt)
    M.move_cursor_to(jt.window, jt.line + 1, jt.column - 1, opts.inclusive_jump)
  end)
end

function M.hint_with_callback(jump_target_gtr, opts, callback)
  if opts == nil then
    opts = override_opts(opts)
  end

  if not M.initialized then
    vim.notify('Hop is not initialized; please call the setup function', 4)
    return
  end

  local all_ctxs = window.get_window_context(opts.multi_windows)

  -- create the highlight groups; the highlight groups will allow us to clean everything at once when Hop quits
  local hl_ns = vim.api.nvim_create_namespace('hop_hl')
  local dim_ns = vim.api.nvim_create_namespace('')

  -- create jump targets
  local generated = jump_target_gtr(opts)
  local jump_target_count = #generated.jump_targets

  local h = nil
  if jump_target_count == 0 then
    eprintln(' -> there’s no such thing we can see…', opts.teasing)
    clear_namespace(0, hl_ns)
    clear_namespace(0, dim_ns)
    return
  elseif jump_target_count == 1 and opts.jump_on_sole_occurrence then
    local jt = generated.jump_targets[1]
    callback(jt)

    clear_namespace(0, hl_ns)
    clear_namespace(0, dim_ns)
    return
  end

  -- we have at least two targets, so generate hints to display
  local hints = hint.create_hints(generated.jump_targets, generated.indirect_jump_targets, opts)

  local hint_state = {
    hints = hints,
    hl_ns = hl_ns,
    dim_ns = dim_ns,
  }

  local buf_list = {}
  for _, bctx in ipairs(all_ctxs) do
    buf_list[#buf_list + 1] = bctx.hbuf
    for _, wctx in ipairs(bctx.contexts) do
      window.clip_window_context(wctx, opts.direction)
      -- dim everything out, add the virtual cursor and hide diagnostics
      apply_dimming(bctx.hbuf, dim_ns, wctx.top_line, wctx.bot_line, wctx.cursor_pos, opts.direction, opts.current_line_only)
    end
  end

  add_virt_cur(hl_ns)
  if vim.fn.has("nvim-0.6") == 1 then
    hint_state.diag_ns = vim.diagnostic.get_namespaces()
    for ns in pairs(hint_state.diag_ns) do vim.diagnostic.show(ns, 0, nil, { virtual_text = false }) end
  end
  hint.set_hint_extmarks(hl_ns, hints, opts)
  vim.cmd('redraw')

  while h == nil do
    local ok, key = pcall(vim.fn.getchar)
    if not ok then
      for _, buf in ipairs(buf_list) do
        M.quit(buf, hint_state)
      end
      break
    end
    local not_special_key = true
    -- :h getchar(): "If the result of expr is a single character, it returns a
    -- number. Use nr2char() to convert it to a String." Also the result is a
    -- special key if it's a string and its first byte is 128.
    --
    -- Note of caution: Even though the result of `getchar()` might be a single
    -- character, that character might still be multiple bytes.
    if type(key) == 'number' then
      key = vim.fn.nr2char(key)
    elseif key:byte() == 128 then
      not_special_key = false
    end

    if not_special_key and opts.keys:find(key, 1, true) then
      -- If this is a key used in Hop (via opts.keys), deal with it in Hop
      h = M.refine_hints(buf_list, key, hint_state, callback, opts)
      vim.cmd('redraw')
    else
      -- If it's not, quit Hop
      for _, buf in ipairs(buf_list) do
        M.quit(buf, hint_state)
      end
      -- If the key captured via getchar() is not the quit_key, pass it through
      -- to nvim to be handled normally (including mappings)
      if key ~= vim.api.nvim_replace_termcodes(opts.quit_key, true, false, true) then
        vim.api.nvim_feedkeys(key, '', true)
      end
      break
    end
  end
end

-- Refine hints in the given buffer.
--
-- Refining hints allows to advance the state machine by one step. If a terminal step is reached, this function jumps to
-- the location. Otherwise, it stores the new state machine.
function M.refine_hints(buf_list, key, hint_state, callback, opts)
  local h, hints = hint.reduce_hints(hint_state.hints, key)

  if h == nil then
    if #hints == 0 then
      eprintln('no remaining sequence starts with ' .. key, opts.teasing)
      return
    end

    hint_state.hints = hints

    for _, buf in ipairs(buf_list) do
      clear_namespace(buf, hint_state.hl_ns)
    end
    hint.set_hint_extmarks(hint_state.hl_ns, hints, opts)
    vim.cmd('redraw')
  else
    for _, buf in ipairs(buf_list) do
      M.quit(buf, hint_state)
    end

    -- prior to jump, register the current position into the jump list
    vim.cmd("normal! m'")

    callback(h.jump_target)
    return h
  end
end

-- Quit Hop and delete its resources.
function M.quit(buf_handle, hint_state)
  clear_namespace(buf_handle, hint_state.hl_ns)
  clear_namespace(buf_handle, hint_state.dim_ns)

  if vim.fn.has("nvim-0.6") == 1 then
    for ns in pairs(hint_state.diag_ns) do vim.diagnostic.show(ns, buf_handle) end
  end
end

function M.hint_words(opts)
  opts = override_opts(opts)

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.regex_by_word_start()),
    opts
  )
end

function M.hint_patterns(opts, pattern)
  opts = override_opts(opts)

  -- The pattern to search is either retrieved from the (optional) argument
  -- or directly from user input.
  if pattern == nil then
    vim.fn.inputsave()

    local ok
    ok, pattern = pcall(vim.fn.input, 'Search: ')
    vim.fn.inputrestore()

    if not ok then
      return
    end
  end

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.regex_by_case_searching(pattern, false, opts)),
    opts
  )
end

function M.hint_char1(opts)
  opts = override_opts(opts)

  local ok, c = pcall(vim.fn.getchar)
  if not ok then
    return
  end

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.regex_by_case_searching(vim.fn.nr2char(c), true, opts)),
    opts
  )
end

function M.hint_char2(opts)
  opts = override_opts(opts)

  local ok, a = pcall(vim.fn.getchar)
  if not ok then
    return
  end

  local ok2, b = pcall(vim.fn.getchar)
  if not ok2 then
    return
  end

  local pattern = vim.fn.nr2char(a)

  -- if we have a fallback key defined in the opts, if the second character is that key, we then fallback to the same
  -- behavior as hint_char1()
  if opts.char2_fallback_key == nil or b ~= vim.fn.char2nr(vim.api.nvim_replace_termcodes(opts.char2_fallback_key, true, false, true)) then
    pattern = pattern .. vim.fn.nr2char(b)
  end

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.regex_by_case_searching(pattern, true, opts)),
    opts
  )
end

function M.hint_lines(opts)
  opts = override_opts(opts)

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.regex_by_line_start()),
    opts
  )
end

function M.hint_lines_skip_whitespace(opts)
  opts = override_opts(opts)

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.regex_by_line_start_skip_whitespace()),
    opts
  )
end

function M.hint_anywhere(opts)
  opts = override_opts(opts)

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.regex_by_anywhere()),
    opts
  )
end

-- Setup user settings.
function M.setup(opts)
  -- Look up keys in user-defined table with fallback to defaults.
  M.opts = setmetatable(opts or {}, {__index = defaults})
  M.initialized = true

  -- Insert the highlights and register the autocommand if asked to.
  local highlight = require'hop.highlight'
  highlight.insert_highlights()

  if M.opts.create_hl_autocmd then
    highlight.create_autocmd()
  end

  -- register Hop extensions, if any
  if M.opts.extensions ~= nil then
    for _, ext_name in pairs(opts.extensions) do
      local ok, extension = pcall(require, ext_name)
      if not ok then
        -- 4 is error; thanks Neovim… :(
        vim.notify(string.format('extension %s wasn’t correctly loaded', ext_name), 4)
      else
        if extension.register == nil then
          vim.notify(string.format('extension %s lacks the register function', ext_name), 4)
        else
          extension.register(opts)
        end
      end
    end
  end
end

return M
