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
  if vim.api.nvim_get_mode().mode ~= 'n' then
    opts.multi_windows = false
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

-- Create hint state
--
-- {
--  all_ctxs: All windows's context
--  buf_list: All buffers displayed in all windows
--  <xxx>_ns: Required namespaces
-- }
local function create_hint_state(opts)
  local window = require'hop.window'

  local hint_state = {}

  -- get all window's context and buffer list
  hint_state.all_ctxs = window.get_window_context(opts.multi_windows)
  hint_state.buf_list = {}
  for _, bctx in ipairs(hint_state.all_ctxs) do
    hint_state.buf_list[#hint_state.buf_list + 1] = bctx.hbuf
    for _, wctx in ipairs(bctx.contexts) do
      window.clip_window_context(wctx, opts.direction)
    end
  end

  -- create the highlight groups; the highlight groups will allow us to clean everything at once when Hop quits
  hint_state.hl_ns = vim.api.nvim_create_namespace('hop_hl')
  hint_state.dim_ns = vim.api.nvim_create_namespace('hop_dim')

  -- backup namespaces of diagnostic
  if vim.fn.has("nvim-0.6") == 1 then
    hint_state.diag_ns = vim.diagnostic.get_namespaces()
  end

  -- Store users cursorline state
  hint_state.cursorline = vim.api.nvim_win_get_option(vim.api.nvim_get_current_win(), 'cursorline')

  return hint_state
end

-- A hack to prevent #57 by deleting twice the namespace (it’s super weird).
local function clear_namespace(buf_list, hl_ns)
  for _, buf in ipairs(buf_list) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_clear_namespace(buf, hl_ns, 0, -1)
      vim.api.nvim_buf_clear_namespace(buf, hl_ns, 0, -1)
    end
  end
end

-- Set the highlight of unmatched lines of the buffer.
--
-- - hl_ns is the highlight namespace.
-- - top_line is the top line in the buffer to start highlighting at
-- - bottom_line is the bottom line in the buffer to stop highlighting at
local function set_unmatched_lines(buf_handle, hl_ns, top_line, bottom_line, cursor_pos, direction, current_line_only)
  local hint = require'hop.hint'
  local prio = require'hop.priority'

  local start_line = top_line
  local end_line = bottom_line
  local start_col = 0
  local end_col = nil

  if direction == hint.HintDirection.AFTER_CURSOR then
    start_col = cursor_pos[2]
  elseif direction == hint.HintDirection.BEFORE_CURSOR then
    end_line = bottom_line - 1
    if cursor_pos[2] ~= 0 then end_col = cursor_pos[2] end
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

  local extmark_options = {
    end_line = end_line,
    hl_group = 'HopUnmatched',
    hl_eol = true,
    priority = prio.DIM_PRIO
  }

  if end_col then
    local current_line = vim.api.nvim_buf_get_lines(buf_handle, cursor_pos[1] - 1, cursor_pos[1], true)[1]
    local current_width = vim.fn.strdisplaywidth(current_line)

    if end_col > current_width then
      end_col = current_width - 1
    end

    extmark_options.end_col = end_col
  end

  vim.api.nvim_buf_set_extmark(buf_handle, hl_ns, start_line, start_col,
                               extmark_options)
end

-- Dim everything out to prepare the Hop session for all windows.
local function apply_dimming(hint_state, opts)
  local window = require'hop.window'

  for _, bctx in ipairs(hint_state.all_ctxs) do
    for _, wctx in ipairs(bctx.contexts) do
      window.clip_window_context(wctx, opts.direction)
      -- dim everything out, add the virtual cursor and hide diagnostics
      set_unmatched_lines(bctx.hbuf, hint_state.dim_ns, wctx.top_line, wctx.bot_line, wctx.cursor_pos, opts.direction, opts.current_line_only)
    end

    if vim.fn.has("nvim-0.6") == 1 then
      for ns in pairs(hint_state.diag_ns) do
        vim.diagnostic.show(ns, bctx.hbuf, nil, { virtual_text = false })
      end
    end
  end
end

-- Add the virtual cursor, taking care to handle the cases where:
-- - the virtualedit option is being used and the cursor is in a
--   tab character or past the end of the line
-- - the current line is empty
-- - there are multibyte characters on the line
local function add_virt_cur(ns)
  local prio = require'hop.priority'

  local cur_info = vim.fn.getcurpos()
  local cur_row = cur_info[2] - 1
  local cur_col = cur_info[3] - 1 -- this gives cursor column location, in bytes
  local cur_offset = cur_info[4]
  local virt_col = cur_info[5] - 1
  local cur_line = vim.api.nvim_get_current_line()

  -- toggle cursorline off if currently set
  local cursorline_info = vim.api.nvim_win_get_option(vim.api.nvim_get_current_win(), 'cursorline')
  if cursorline_info == true then
    vim.api.nvim_win_set_option(vim.api.nvim_get_current_win(), 'cursorline', false)
  end

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

-- Get pattern from input for hint and preview
function M.get_input_pattern(prompt, maxchar, opts)
  local hint = require'hop.hint'
  local jump_target = require'hop.jump_target'

  local hs = {}
  if opts then
    hs = create_hint_state(opts)
    hs.preview_ns = vim.api.nvim_create_namespace('hop_preview')
    apply_dimming(hs, opts)
    add_virt_cur(hs.hl_ns)
  end

  local K_Esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  local K_BS = vim.api.nvim_replace_termcodes('<BS>', true, false, true)
  local K_C_H = vim.api.nvim_replace_termcodes('<C-H>', true, false, true)
  local K_CR = vim.api.nvim_replace_termcodes('<CR>', true, false, true)
  local K_NL = vim.api.nvim_replace_termcodes('<NL>', true, false, true)
  local pat_keys = {}
  local pat = ''

  while (true) do
    pat = vim.fn.join(pat_keys, '')
    if opts then
      clear_namespace(hs.buf_list, hs.preview_ns)
      if #pat > 0 then
        local ok, re = pcall(jump_target.regex_by_case_searching, pat, false, opts)
        if ok then
            local jump_target_gtr = jump_target.jump_targets_by_scanning_lines(re)
            local generated = jump_target_gtr(opts)
            hint.set_hint_preview(hs.preview_ns, generated.jump_targets)
        end
      end
    end
    vim.api.nvim_echo({}, false, {})
    vim.cmd('redraw')
    vim.api.nvim_echo({{prompt, 'Question'}, {pat}}, false, {})

    local ok, key = pcall(vim.fn.getchar)
    if not ok then -- Interrupted by <C-c>
      pat = nil
      break
    end

    if type(key) == 'number' then
      key = vim.fn.nr2char(key)
    elseif key:byte() == 128 then
      -- It's a special key in string
    end

    if key == K_Esc then
      pat = nil
      break
    elseif key == K_CR or key == K_NL then
      break
    elseif key == K_BS or key == K_C_H then
      pat_keys[#pat_keys] = nil
    else
      pat_keys[#pat_keys + 1] = key
    end

    if maxchar and #pat_keys >= maxchar then
      pat = vim.fn.join(pat_keys, '')
      break
    end
  end

  if opts then
    clear_namespace(hs.buf_list, hs.preview_ns)
    -- quit only when got nothin for pattern to avoid blink of highlight
    if not pat then M.quit(hs) end
  end
  vim.api.nvim_echo({}, false, {})
  vim.cmd('redraw')
  return pat
end

-- Move the cursor at a given location.
--
-- Add option to shift cursor by column offset
--
-- This function will update the jump list.
function M.move_cursor_to(w, line, column, hint_offset, direction)
  -- If we do not ask for an offset jump, we don’t have to retrieve any additional lines because we will jump to the
  -- actual jump target. If we do want a jump with an offset, we need to retrieve the line the jump target lies in so
  -- that we can compute the offset correctly. This is linked to the fact that currently, Neovim doesn’s have an API to
  -- « offset something by N visual columns. »

  -- If it is pending for operator shift column to the right by 1
  if vim.api.nvim_get_mode().mode == 'no' and direction ~= 1 then
    column = column + 1
  end

  if hint_offset ~= nil and not (hint_offset == 0) then
    -- Add `hint_offset` based on `charidx`.
    local buf_line = vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(w), line - 1, line, false)[1]
    -- Since `charidx` returns -1 when `column` is the tail, subtract 1 and add 1 to the return value to get
    -- the correct value.
    local char_idx = vim.fn.charidx(buf_line, column - 1) + 1 + hint_offset
    column = vim.fn.byteidx(buf_line, char_idx)
  end

  -- update the jump list
  vim.cmd("normal! m'")
  vim.api.nvim_set_current_win(w)
  vim.api.nvim_win_set_cursor(w, { line, column })
end

function M.hint_with(jump_target_gtr, opts)
  if opts == nil then
    opts = override_opts(opts)
  end

  M.hint_with_callback(jump_target_gtr, opts, function(jt)
    M.move_cursor_to(jt.window, jt.line + 1, jt.column - 1, opts.hint_offset, opts.direction)
  end)
end

function M.hint_with_callback(jump_target_gtr, opts, callback)
  local hint = require'hop.hint'

  if opts == nil then
    opts = override_opts(opts)
  end

  if not M.initialized then
    vim.notify('Hop is not initialized; please call the setup function', 4)
    return
  end

  -- create hint state
  local hs = create_hint_state(opts)

  -- create jump targets
  local generated = jump_target_gtr(opts)
  local jump_target_count = #generated.jump_targets

  local target_idx = nil
  if jump_target_count == 0 then
    target_idx = 0
  elseif vim.v.count > 0 then
    target_idx = vim.v.count
  elseif jump_target_count == 1 and opts.jump_on_sole_occurrence then
    target_idx = 1
  end

  if target_idx ~= nil then
    local jt = generated.jump_targets[target_idx]
    if jt then
      callback(jt)
    else
      eprintln(' -> there’s no such thing we can see…', opts.teasing)
    end

    clear_namespace(hs.buf_list, hs.hl_ns)
    clear_namespace(hs.buf_list, hs.dim_ns)
    return
  end

  -- we have at least two targets, so generate hints to display
  hs.hints = hint.create_hints(generated.jump_targets, generated.indirect_jump_targets, opts)

  -- dim everything out, add the virtual cursor and hide diagnostics
  apply_dimming(hs, opts)
  add_virt_cur(hs.hl_ns)
  hint.set_hint_extmarks(hs.hl_ns, hs.hints, opts)
  vim.cmd('redraw')

  local h = nil
  while h == nil do
    local ok, key = pcall(vim.fn.getchar)
    if not ok then
      M.quit(hs)
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
      h = M.refine_hints(key, hs, callback, opts)
      vim.cmd('redraw')
    else
      -- If it's not, quit Hop
      M.quit(hs)
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
function M.refine_hints(key, hint_state, callback, opts)
  local hint = require'hop.hint'

  local h, hints = hint.reduce_hints(hint_state.hints, key)

  if h == nil then
    if #hints == 0 then
      eprintln('no remaining sequence starts with ' .. key, opts.teasing)
      return
    end

    hint_state.hints = hints

    clear_namespace(hint_state.buf_list, hint_state.hl_ns)
    hint.set_hint_extmarks(hint_state.hl_ns, hints, opts)
  else
    M.quit(hint_state)

    -- prior to jump, register the current position into the jump list
    vim.cmd("normal! m'")

    callback(h.jump_target)
    return h
  end
end

-- Quit Hop and delete its resources.
function M.quit(hint_state)
  clear_namespace(hint_state.buf_list, hint_state.hl_ns)
  clear_namespace(hint_state.buf_list, hint_state.dim_ns)

  -- Restore users cursorline setting
  if hint_state.cursorline == true then
    vim.api.nvim_win_set_option(vim.api.nvim_get_current_win(), 'cursorline', true)
  end

  for _, buf in ipairs(hint_state.buf_list) do
    -- sometimes, buffers might be unloaded; that’s the case with floats for instance (we can invoke Hop from them but
    -- then they disappear); we need to check whether the buffer is still valid before trying to do anything else with
    -- it
    if vim.api.nvim_buf_is_valid(buf) and vim.fn.has("nvim-0.6") == 1 then
      for ns in pairs(hint_state.diag_ns) do vim.diagnostic.show(ns, buf) end
    end
  end
end

function M.hint_words(opts)
  local jump_target = require'hop.jump_target'

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
  local jump_target = require'hop.jump_target'

  opts = override_opts(opts)

  -- The pattern to search is either retrieved from the (optional) argument
  -- or directly from user input.
  local pat
  if pattern then
    pat = pattern
  else
    vim.cmd('redraw')
    vim.fn.inputsave()
    pat = M.get_input_pattern('Hop pattern: ', nil, opts)
    vim.fn.inputrestore()
    if not pat then return end
  end

  if #pat == 0 then
    eprintln('-> empty pattern', opts.teasing)
    return
  end

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.regex_by_case_searching(pat, false, opts)),
    opts
  )
end

function M.hint_char1(opts)
  local jump_target = require'hop.jump_target'

  opts = override_opts(opts)

  local c = M.get_input_pattern('Hop 1 char: ', 1)
  if not c then
    return
  end

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.regex_by_case_searching(c, true, opts)),
    opts
  )
end

function M.hint_char2(opts)
  local jump_target = require'hop.jump_target'

  opts = override_opts(opts)

  local c = M.get_input_pattern('Hop 2 char: ', 2)
  if not c then
    return
  end

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.regex_by_case_searching(c, true, opts)),
    opts
  )
end

function M.hint_lines(opts)
  local jump_target = require'hop.jump_target'

  opts = override_opts(opts)

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  M.hint_with(
    generator(jump_target.by_line_start()),
    opts
  )
end

function M.hint_vertical(opts)
  local hint = require'hop.hint'
  local jump_target = require'hop.jump_target'

  opts = override_opts(opts)
  -- only makes sense as end position given movement goal.
  opts.hint_position = hint.HintPosition.END

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end

  -- FIXME: need to exclude current and include empty lines.
  M.hint_with(
    generator(jump_target.regex_by_vertical()),
    opts
  )
end


function M.hint_lines_skip_whitespace(opts)
  local jump_target = require'hop.jump_target'

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
  local jump_target = require'hop.jump_target'

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
  M.opts = setmetatable(opts or {}, {__index = require'hop.defaults'})
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
