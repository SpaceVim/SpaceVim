-- Copyright 2019 Yazdani Kiyan under MIT License
local api = vim.api

local lib = require "nvim-tree.lib"
local utils = require "nvim-tree.utils"
local view = require "nvim-tree.view"

local M = {}

local function get_split_cmd()
  local side = view.View.side
  if side == "right" then
    return "aboveleft"
  end
  if side == "left" then
    return "belowright"
  end
  if side == "top" then
    return "bot"
  end
  return "top"
end

---Get user to pick a window. Selectable windows are all windows in the current
---tabpage that aren't NvimTree.
---@return integer|nil -- If a valid window was picked, return its id. If an
---       invalid window was picked / user canceled, return nil. If there are
---       no selectable windows, return -1.
local function pick_window()
  local tabpage = api.nvim_get_current_tabpage()
  local win_ids = api.nvim_tabpage_list_wins(tabpage)
  local tree_winid = view.get_winnr(tabpage)

  local selectable = vim.tbl_filter(function(id)
    local bufid = api.nvim_win_get_buf(id)
    for option, v in pairs(M.window_picker.exclude) do
      local ok, option_value = pcall(api.nvim_buf_get_option, bufid, option)
      if ok and vim.tbl_contains(v, option_value) then
        return false
      end
    end

    local win_config = api.nvim_win_get_config(id)
    return id ~= tree_winid and win_config.focusable and not win_config.external
  end, win_ids)

  -- If there are no selectable windows: return. If there's only 1, return it without picking.
  if #selectable == 0 then
    return -1
  end
  if #selectable == 1 then
    return selectable[1]
  end

  local i = 1
  local win_opts = {}
  local win_map = {}
  local laststatus = vim.o.laststatus
  vim.o.laststatus = 2

  local not_selectable = vim.tbl_filter(function(id)
    return not vim.tbl_contains(selectable, id)
  end, win_ids)

  if laststatus == 3 then
    for _, win_id in ipairs(not_selectable) do
      local ok_status, statusline = pcall(api.nvim_win_get_option, win_id, "statusline")
      local ok_hl, winhl = pcall(api.nvim_win_get_option, win_id, "winhl")

      win_opts[win_id] = {
        statusline = ok_status and statusline or "",
        winhl = ok_hl and winhl or "",
      }

      -- Clear statusline for windows not selectable
      api.nvim_win_set_option(win_id, "statusline", " ")
    end
  end

  -- Setup UI
  for _, id in ipairs(selectable) do
    local char = M.window_picker.chars:sub(i, i)
    local ok_status, statusline = pcall(api.nvim_win_get_option, id, "statusline")
    local ok_hl, winhl = pcall(api.nvim_win_get_option, id, "winhl")

    win_opts[id] = {
      statusline = ok_status and statusline or "",
      winhl = ok_hl and winhl or "",
    }
    win_map[char] = id

    api.nvim_win_set_option(id, "statusline", "%=" .. char .. "%=")
    api.nvim_win_set_option(id, "winhl", "StatusLine:NvimTreeWindowPicker,StatusLineNC:NvimTreeWindowPicker")

    i = i + 1
    if i > #M.window_picker.chars then
      break
    end
  end

  vim.cmd "redraw"
  print "Pick window: "
  local _, resp = pcall(utils.get_user_input_char)
  resp = (resp or ""):upper()
  utils.clear_prompt()

  -- Restore window options
  for _, id in ipairs(selectable) do
    for opt, value in pairs(win_opts[id]) do
      api.nvim_win_set_option(id, opt, value)
    end
  end

  if laststatus == 3 then
    for _, id in ipairs(not_selectable) do
      for opt, value in pairs(win_opts[id]) do
        api.nvim_win_set_option(id, opt, value)
      end
    end
  end

  vim.o.laststatus = laststatus

  if not vim.tbl_contains(vim.split(M.window_picker.chars, ""), resp) then
    return
  end

  return win_map[resp]
end

local function open_file_in_tab(filename)
  if M.quit_on_open then
    view.close()
  else
    -- Switch window first to ensure new window doesn't inherit settings from
    -- NvimTree
    if lib.target_winid > 0 and api.nvim_win_is_valid(lib.target_winid) then
      api.nvim_set_current_win(lib.target_winid)
    else
      vim.cmd "wincmd p"
    end
  end

  -- This sequence of commands are here to ensure a number of things: the new
  -- buffer must be opened in the current tabpage first so that focus can be
  -- brought back to the tree if it wasn't quit_on_open. It also ensures that
  -- when we open the new tabpage with the file, its window doesn't inherit
  -- settings from NvimTree, as it was already loaded.

  vim.cmd("edit " .. vim.fn.fnameescape(filename))

  local alt_bufid = vim.fn.bufnr "#"
  if alt_bufid ~= -1 then
    api.nvim_set_current_buf(alt_bufid)
  end

  if not M.quit_on_open then
    vim.cmd "wincmd p"
  end

  vim.cmd("tabe " .. vim.fn.fnameescape(filename))
end

function M.fn(mode, filename)
  if mode == "tabnew" then
    open_file_in_tab(filename)
    return
  end

  if mode == "edit_in_place" then
    require("nvim-tree.view").abandon_current_window()
    vim.cmd("edit " .. vim.fn.fnameescape(filename))
    return
  end

  local tabpage = api.nvim_get_current_tabpage()
  local win_ids = api.nvim_tabpage_list_wins(tabpage)

  local target_winid
  if not M.window_picker.enable or mode == "edit_no_picker" then
    target_winid = lib.target_winid
  else
    local pick_window_id = pick_window()
    if pick_window_id == nil then
      return
    end
    target_winid = pick_window_id
  end

  if target_winid == -1 then
    target_winid = lib.target_winid
  end

  local do_split = mode == "split" or mode == "vsplit"
  local vertical = mode ~= "split"

  -- Check if file is already loaded in a buffer
  local buf_loaded = false
  for _, buf_id in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf_id) and filename == api.nvim_buf_get_name(buf_id) then
      buf_loaded = true
      break
    end
  end

  -- Check if filename is already open in a window
  local found = false
  for _, id in ipairs(win_ids) do
    if filename == api.nvim_buf_get_name(api.nvim_win_get_buf(id)) then
      if mode == "preview" then
        return
      end
      found = true
      api.nvim_set_current_win(id)
      break
    end
  end

  if not found then
    if not target_winid or not vim.tbl_contains(win_ids, target_winid) then
      -- Target is invalid, or window does not exist in current tabpage: create
      -- new window
      local split_cmd = get_split_cmd()
      local splitside = view.is_vertical() and "vsp" or "sp"
      vim.cmd(split_cmd .. " " .. splitside)
      target_winid = api.nvim_get_current_win()
      lib.target_winid = target_winid

      -- No need to split, as we created a new window.
      do_split = false
    elseif not vim.o.hidden then
      -- If `hidden` is not enabled, check if buffer in target window is
      -- modified, and create new split if it is.
      local target_bufid = api.nvim_win_get_buf(target_winid)
      if api.nvim_buf_get_option(target_bufid, "modified") then
        do_split = true
      end
    end

    local cmd
    if do_split or #api.nvim_list_wins() == 1 then
      cmd = string.format("%ssplit ", vertical and "vertical " or "")
    else
      cmd = "edit "
    end

    cmd = cmd .. vim.fn.fnameescape(filename)
    api.nvim_set_current_win(target_winid)
    pcall(vim.cmd, cmd)
    lib.set_target_win()
  end

  if M.resize_window then
    view.resize()
  end

  if mode == "preview" then
    if not buf_loaded then
      vim.bo.bufhidden = "delete"
      vim.cmd [[
      augroup RemoveBufHidden
          autocmd!
          autocmd TextChanged <buffer> setlocal bufhidden= | autocmd! RemoveBufHidden
          autocmd TextChangedI <buffer> setlocal bufhidden= | autocmd! RemoveBufHidden
      augroup end
    ]]
    end
    view.focus()
    return
  end

  if M.quit_on_open then
    view.close()
  end
end

function M.setup(opts)
  M.quit_on_open = opts.actions.open_file.quit_on_open
  M.resize_window = opts.actions.open_file.resize_window
  if opts.actions.open_file.window_picker.chars then
    opts.actions.open_file.window_picker.chars = tostring(opts.actions.open_file.window_picker.chars):upper()
  end
  M.window_picker = opts.actions.open_file.window_picker
end

return M
