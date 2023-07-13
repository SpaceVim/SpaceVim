local vim = vim
local utils = require("neo-tree.utils")
local highlights = require("neo-tree.ui.highlights")
local events = require("neo-tree.events")
local manager = require("neo-tree.sources.manager")
local log = require("neo-tree.log")
local renderer = require("neo-tree.ui.renderer")

local neo_tree_preview_namespace = vim.api.nvim_create_namespace("neo_tree_preview")

local function create_floating_preview_window(state)
  local default_position = utils.resolve_config_option(state, "window.position", "left")
  state.current_position = state.current_position or default_position

  local winwidth = vim.api.nvim_win_get_width(state.winid)
  local winheight = vim.api.nvim_win_get_height(state.winid)
  local height = vim.o.lines - 4
  local width = 120
  local row, col = 0, 0

  if state.current_position == "left" then
    col = winwidth + 1
    width = math.min(vim.o.columns - col, 120)
  elseif state.current_position == "top" or state.current_position == "bottom" then
    height = height - winheight
    width = winwidth - 2
    if state.current_position == "top" then
      row = vim.api.nvim_win_get_height(state.winid) + 1
    end
  elseif state.current_position == "right" then
    width = math.min(vim.o.columns - winwidth - 4, 120)
    col = vim.o.columns - winwidth - width - 3
  elseif state.current_position == "float" then
    local pos = vim.api.nvim_win_get_position(state.winid)
    -- preview will be same height and top as tree
    row = pos[1] - 1
    height = winheight

    -- tree and preview window will be side by side and centered in the editor
    width = math.min(vim.o.columns - winwidth - 4, 120)
    local total_width = winwidth + width + 4
    local margin = math.floor((vim.o.columns - total_width) / 2)
    col = margin + winwidth + 2

    -- move the tree window to make the combined layout centered
    local popup = renderer.get_nui_popup(state.winid)
    popup:update_layout({
      relative = "editor",
      position = {
        row = row,
        col = margin,
      },
    })
  else
    local cur_pos = state.current_position or "unknown"
    log.error('Preview cannot be used when position = "' .. cur_pos .. '"')
    return
  end

  local popups = require("neo-tree.ui.popups")
  local options = popups.popup_options("Neo-tree Preview", width, {
    ns_id = highlights.ns_id,
    size = { height = height, width = width },
    relative = "editor",
    position = {
      row = row,
      col = col,
    },
    win_options = {
      number = true,
      winhighlight = "Normal:"
        .. highlights.FLOAT_NORMAL
        .. ",FloatBorder:"
        .. highlights.FLOAT_BORDER,
    },
  })
  options.zindex = 40
  options.buf_options.filetype = "neo-tree-preview"

  local NuiPopup = require("nui.popup")
  local win = NuiPopup(options)
  win:mount()
  return win
end

local Preview = {}
local instance = nil

---Creates a new preview.
---@param state table The state of the source.
---@return table preview A new preview. A preview is a table consisting of the following keys:
--  active = boolean           Whether the preview is active.
--  winid = number             The id of the window being used to preview.
--  is_neo_tree_window boolean Whether the preview window belongs to neo-tree.
--  bufnr = number             The buffer that is currently in the preview window.
--  start_pos = array or nil   An array-like table specifying the (0-indexed) starting position of the previewed text.
--  end_pos = array or nil     An array-like table specifying the (0-indexed) ending position of the preview text.
--  truth = table              A table containing information to be restored when the preview ends.
--  events = array             A list of events the preview is subscribed to.
--These keys should not be altered directly. Note that the keys `start_pos`, `end_pos` and `truth`
--may be inaccurate if `active` is false.
function Preview:new(state)
  local preview = {}
  preview.active = false
  preview.config = vim.deepcopy(state.config)
  setmetatable(preview, { __index = self })
  preview:findWindow(state)
  return preview
end

---Preview a buffer in the preview window and optionally reveal and highlight the previewed text.
---@param bufnr number? The number of the buffer to be previewed.
---@param start_pos table? The (0-indexed) starting position of the previewed text. May be absent.
---@param end_pos table? The (0-indexed) ending position of the previewed text. May be absent
function Preview:preview(bufnr, start_pos, end_pos)
  if self.is_neo_tree_window then
    log.warn("Could not find appropriate window for preview")
    return
  end

  bufnr = bufnr or self.bufnr
  if not self.active then
    self:activate()
  end

  if not self.active then
    return
  end

  if bufnr ~= self.bufnr then
    self:setBuffer(bufnr)
  end

  self:clearHighlight()

  self.bufnr = bufnr
  self.start_pos = start_pos
  self.end_pos = end_pos

  self:reveal()
  self:highlight()
end

---Reverts the preview and inactivates it, restoring the preview window to its previous state.
function Preview:revert()
  self.active = false
  self:unsubscribe()
  self:clearHighlight()

  if not renderer.is_window_valid(self.winid) then
    self.winid = nil
    return
  end

  if self.config.use_float then
    vim.api.nvim_win_close(self.winid, true)
    self.winid = nil
    return
  else
    local foldenable = utils.get_value(self.truth, "options.foldenable", nil, false)
    if foldenable ~= nil then
      vim.api.nvim_win_set_option(self.winid, "foldenable", self.truth.options.foldenable)
    end
    vim.api.nvim_win_set_var(self.winid, "neo_tree_preview", 0)
  end

  local bufnr = self.truth.bufnr
  if type(bufnr) ~= "number" then
    return
  end
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  self:setBuffer(bufnr)
  self.bufnr = bufnr
  if vim.api.nvim_win_is_valid(self.winid) then
    vim.api.nvim_win_call(self.winid, function()
      vim.fn.winrestview(self.truth.view)
    end)
  end
  vim.api.nvim_buf_set_option(self.bufnr, "bufhidden", self.truth.options.bufhidden)
end

---Subscribe to event and add it to the preview event list.
--@param source string? Name of the source to add the event to. Will use `events.subscribe` if nil.
--@param event table Event to subscribe to.
function Preview:subscribe(source, event)
  if source == nil then
    events.subscribe(event)
  else
    manager.subscribe(source, event)
  end
  self.events = self.events or {}
  table.insert(self.events, { source = source, event = event })
end

---Unsubscribe to all events in the preview event list.
function Preview:unsubscribe()
  if self.events == nil then
    return
  end
  for _, event in ipairs(self.events) do
    if event.source == nil then
      events.unsubscribe(event.event)
    else
      manager.unsubscribe(event.source, event.event)
    end
  end
  self.events = {}
end

---Finds the appropriate window and updates the preview accordingly.
---@param state table The state of the source.
function Preview:findWindow(state)
  local winid, is_neo_tree_window
  if self.config.use_float then
    if
      type(self.winid) == "number"
      and vim.api.nvim_win_is_valid(self.winid)
      and utils.is_floating(self.winid)
    then
      return
    end
    local win = create_floating_preview_window(state)
    if not win then
      self.active = false
      return
    end
    winid = win.winid
    is_neo_tree_window = false
  else
    winid, is_neo_tree_window = utils.get_appropriate_window(state)
    self.bufnr = vim.api.nvim_win_get_buf(winid)
  end

  if winid == self.winid then
    return
  end
  self.winid, self.is_neo_tree_window = winid, is_neo_tree_window

  if self.active then
    self:revert()
    self:preview()
  end
end

---Activates the preview, but does not populate the preview window,
function Preview:activate()
  if self.active then
    return
  end
  if not renderer.is_window_valid(self.winid) then
    return
  end
  if self.config.use_float then
    self.truth = {}
  else
    self.truth = {
      bufnr = self.bufnr,
      view = vim.api.nvim_win_call(self.winid, vim.fn.winsaveview),
      options = {
        bufhidden = vim.api.nvim_buf_get_option(self.bufnr, "bufhidden"),
        foldenable = vim.api.nvim_win_get_option(self.winid, "foldenable"),
      },
    }
    vim.api.nvim_buf_set_option(self.bufnr, "bufhidden", "hide")
    vim.api.nvim_win_set_option(self.winid, "foldenable", false)
  end
  self.active = true
  vim.api.nvim_win_set_var(self.winid, "neo_tree_preview", 1)
end

---Set the buffer in the preview window without executing BufEnter or BufWinEnter autocommands.
--@param bufnr number The buffer number of the buffer to set.
function Preview:setBuffer(bufnr)
  local eventignore = vim.opt.eventignore
  vim.opt.eventignore:append("BufEnter,BufWinEnter")
  vim.api.nvim_win_set_buf(self.winid, bufnr)
  if self.config.use_float then
    -- I'm not sufe why float windows won;t show numbers without this
    vim.api.nvim_win_set_option(self.winid, "number", true)
  end
  vim.opt.eventignore = eventignore
end

---Move the cursor to the previewed position and center the screen.
function Preview:reveal()
  local pos = self.start_pos or self.end_pos
  if not self.active or not self.winid or not pos then
    return
  end
  vim.api.nvim_win_set_cursor(self.winid, { (pos[1] or 0) + 1, pos[2] or 0 })
  vim.api.nvim_win_call(self.winid, function()
    vim.cmd("normal! zz")
  end)
end

---Highlight the previewed range
function Preview:highlight()
  if not self.active or not self.bufnr then
    return
  end
  local start_pos, end_pos = self.start_pos, self.end_pos
  if not start_pos and not end_pos then
    return
  elseif not start_pos then
    start_pos = end_pos
  elseif not end_pos then
    end_pos = start_pos
  end

  local highlight = function(line, col_start, col_end)
    vim.api.nvim_buf_add_highlight(
      self.bufnr,
      neo_tree_preview_namespace,
      highlights.PREVIEW,
      line,
      col_start,
      col_end
    )
  end

  local start_line, end_line = start_pos[1], end_pos[1]
  local start_col, end_col = start_pos[2], end_pos[2]
  if start_line == end_line then
    highlight(start_line, start_col, end_col)
  else
    highlight(start_line, start_col, -1)
    for line = start_line + 1, end_line - 1 do
      highlight(line, 0, -1)
    end
    highlight(end_line, 0, end_col)
  end
end

---Clear the preview highlight in the buffer currently in the preview window.
function Preview:clearHighlight()
  if type(self.bufnr) == "number" and vim.api.nvim_buf_is_valid(self.bufnr) then
    vim.api.nvim_buf_clear_namespace(self.bufnr, neo_tree_preview_namespace, 0, -1)
  end
end

local toggle_state = false

Preview.hide = function()
  toggle_state = false
  if instance then
    instance:revert()
  end
  instance = nil
end

Preview.is_active = function()
  return instance and instance.active
end

Preview.show = function(state)
  local node = state.tree:get_node()
  if node.type == "directory" then
    return
  end

  if instance then
    instance:findWindow(state)
  else
    instance = Preview:new(state)
  end

  local extra = node.extra or {}
  local position = extra.position
  local end_position = extra.end_position
  local path = node.path or node:get_id()
  local bufnr = extra.bufnr or vim.fn.bufadd(path)

  if bufnr and bufnr > 0 and instance then
    instance:preview(bufnr, position, end_position)
  end
end

Preview.toggle = function(state)
  if toggle_state then
    Preview.hide()
  else
    Preview.show(state)
    if instance and instance.active then
      toggle_state = true
    else
      Preview.hide()
      return
    end
    local winid = state.winid
    local source_name = state.name
    local preview_event = {
      event = events.VIM_CURSOR_MOVED,
      handler = function()
        if not toggle_state or vim.api.nvim_get_current_win() == instance.winid then
          return
        end
        if vim.api.nvim_get_current_win() == winid then
          log.debug("Cursor moved in tree window, updating preview")
          Preview.show(state)
        else
          log.debug("Neo-tree window lost focus, disposing preview")
          Preview.hide()
        end
      end,
      id = "preview-event",
    }
    instance:subscribe(source_name, preview_event)
  end
end

Preview.focus = function()
  if Preview.is_active() then
    vim.fn.win_gotoid(instance.winid)
  end
end

return Preview
