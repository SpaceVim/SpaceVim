local mod = {
  fs = require("tests.utils.fs"),
}

function mod.clear_environment()
  -- Create fresh window
  vim.cmd("top new | wincmd o")
  local keepbufnr = vim.api.nvim_get_current_buf()
  -- Clear ALL neo-tree state
  require("neo-tree.sources.manager")._clear_state()
  -- Cleanup any remaining buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= keepbufnr then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end
  assert(#vim.api.nvim_tabpage_list_wins(0) == 1, "Failed to properly clear tab")
  assert(#vim.api.nvim_list_bufs() == 1, "Failed to properly clear buffers")
end

mod.editfile = function(testfile)
  vim.cmd("e " .. testfile)
  assert.are.same(
    vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p"),
    vim.fn.fnamemodify(testfile, ":p")
  )
end

function mod.eq(...)
  return assert.are.same(...)
end

function mod.neq(...)
  return assert["not"].are.same(...)
end

---@param keys string
---@param mode? string
function mod.feedkeys(keys, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), mode or "x", true)
end

---@param tbl table
---@param keys string[]
function mod.tbl_pick(tbl, keys)
  if not keys or #keys == 0 then
    return tbl
  end

  local new_tbl = {}
  for _, key in ipairs(keys) do
    new_tbl[key] = tbl[key]
  end
  return new_tbl
end

local orig_require = _G.require
-- can be used to enable/disable package
-- for specific tests
function mod.get_require_switch()
  local disabled_packages = {}

  local function fake_require(name)
    if vim.tbl_contains(disabled_packages, name) then
      return error("test: package disabled")
    end

    return orig_require(name)
  end

  return {
    disable_package = function(name)
      _G.require = fake_require
      package.loaded[name] = nil
      table.insert(disabled_packages, name)
    end,
    enable_package = function(name)
      _G.require = fake_require
      disabled_packages = vim.tbl_filter(function(package_name)
        return package_name ~= name
      end, disabled_packages)
    end,
    restore = function()
      disabled_packages = {}
      _G.require = orig_require
    end,
  }
end

---@param bufnr number
---@param lines string[]
---@param linenr_start? integer (1-indexed)
---@param linenr_end? integer (1-indexed, inclusive)
function mod.assert_buf_lines(bufnr, lines, linenr_start, linenr_end)
  mod.eq(
    vim.api.nvim_buf_get_lines(
      bufnr,
      linenr_start and linenr_start - 1 or 0,
      linenr_end or -1,
      false
    ),
    lines
  )
end

---@param bufnr number
---@param ns_id integer
---@param linenr integer (1-indexed)
---@param byte_start? integer (0-indexed)
---@param byte_end? integer (0-indexed, inclusive)
function mod.get_line_extmarks(bufnr, ns_id, linenr, byte_start, byte_end)
  return vim.api.nvim_buf_get_extmarks(
    bufnr,
    ns_id,
    { linenr - 1, byte_start or 0 },
    { linenr - 1, byte_end and byte_end + 1 or -1 },
    { details = true }
  )
end

---@param bufnr number
---@param ns_id integer
---@param linenr integer (1-indexed)
---@param text string
---@return table[]
---@return { byte_start: integer, byte_end: integer } info (byte range: 0-indexed, inclusive)
function mod.get_text_extmarks(bufnr, ns_id, linenr, text)
  local line = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1]

  local byte_start = string.find(line, text) -- 1-indexed
  byte_start = byte_start - 1 -- 0-indexed
  local byte_end = byte_start + #text - 1 -- inclusive

  local extmarks = vim.api.nvim_buf_get_extmarks(
    bufnr,
    ns_id,
    { linenr - 1, byte_start },
    { linenr - 1, byte_end },
    { details = true }
  )

  return extmarks, { byte_start = byte_start, byte_end = byte_end }
end

---@param extmark table
---@param linenr number (1-indexed)
---@param text string
---@param hl_group string
function mod.assert_extmark(extmark, linenr, text, hl_group)
  mod.eq(extmark[2], linenr - 1)

  if text then
    local start_col = extmark[3]
    mod.eq(extmark[4].end_col - start_col, #text)
  end

  mod.eq(mod.tbl_pick(extmark[4], { "end_row", "hl_group" }), {
    end_row = linenr - 1,
    hl_group = hl_group,
  })
end

---@param bufnr number
---@param ns_id integer
---@param linenr integer (1-indexed)
---@param text string
---@param hl_group string
function mod.assert_highlight(bufnr, ns_id, linenr, text, hl_group)
  local extmarks, info = mod.get_text_extmarks(bufnr, ns_id, linenr, text)

  mod.eq(#extmarks, 1)
  mod.eq(extmarks[1][3], info.byte_start)
  mod.assert_extmark(extmarks[1], linenr, text, hl_group)
end

---@param callback fun(): boolean
---@param options? { interval?: integer, timeout?: integer }
function mod.wait_for(callback, options)
  options = options or {}
  vim.wait(options.timeout or 1000, callback, options.interval or 100)
end

return mod
