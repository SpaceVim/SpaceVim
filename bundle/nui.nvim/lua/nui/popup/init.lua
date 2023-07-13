local Border = require("nui.popup.border")
local Object = require("nui.object")
local buf_storage = require("nui.utils.buf_storage")
local autocmd = require("nui.utils.autocmd")
local keymap = require("nui.utils.keymap")

local utils = require("nui.utils")
local _ = utils._
local defaults = utils.defaults
local is_type = utils.is_type

local layout_utils = require("nui.layout.utils")
local u = {
  clear_namespace = _.clear_namespace,
  get_next_id = _.get_next_id,
  size = layout_utils.size,
  position = layout_utils.position,
  update_layout_config = layout_utils.update_layout_config,
}

-- luacov: disable
-- @deprecated
---@param opacity number
---@deprecated
local function calculate_winblend(opacity)
  assert(0 <= opacity, "opacity must be equal or greater than 0")
  assert(opacity <= 1, "opacity must be equal or lesser than 0")
  return 100 - (opacity * 100)
end
-- luacov: enable

local function merge_default_options(options)
  options.relative = defaults(options.relative, "win")

  options.enter = defaults(options.enter, false)
  options.zindex = defaults(options.zindex, 50)

  options.buf_options = defaults(options.buf_options, {})
  options.win_options = defaults(options.win_options, {})

  options.border = defaults(options.border, "none")

  return options
end

local function normalize_options(options)
  options = _.normalize_layout_options(options)

  if is_type("string", options.border) then
    options.border = {
      style = options.border,
    }
  end

  return options
end

--luacheck: push no max line length

---@alias nui_popup_internal_position { relative: "'cursor'"|"'editor'"|"'win'", win: number, bufpos?: number[], row: number, col: number }
---@alias nui_popup_internal_size { height: number, width: number }
---@alias nui_popup_win_config { focusable: boolean, style: "'minimal'", zindex: number, relative: "'cursor'"|"'editor'"|"'win'", win?: number, bufpos?: number[], row: number, col: number, width: number, height: number, border?: table, anchor?: "NW"|"NE"|"SW"|"SE" }
---@alias nui_popup_internal { layout: nui_layout_config, layout_ready: boolean, loading: boolean, mounted: boolean, position: nui_popup_internal_position, size: nui_popup_internal_size, win_enter: boolean, unmanaged_bufnr?: boolean, buf_options: table<string,any>, win_options: table<string,any>, win_config: nui_popup_win_config }

--luacheck: pop

---@class NuiPopup
---@field border NuiPopupBorder
---@field bufnr integer
---@field ns_id integer
---@field private _ nui_popup_internal
---@field win_config nui_popup_win_config
---@field winid number
local Popup = Object("NuiPopup")

function Popup:init(options)
  local id = u.get_next_id()

  options = merge_default_options(options)
  options = normalize_options(options)

  self._ = {
    id = id,
    buf_options = options.buf_options,
    layout = {},
    layout_ready = false,
    loading = false,
    mounted = false,
    win_enter = options.enter,
    win_options = options.win_options,
    win_config = {
      focusable = options.focusable,
      style = "minimal",
      anchor = options.anchor,
      zindex = options.zindex,
    },
    augroup = {
      hide = string.format("%s_hide", id),
      unmount = string.format("%s_unmount", id),
    },
  }

  self.win_config = self._.win_config

  self.ns_id = _.normalize_namespace_id(options.ns_id)

  if options.bufnr then
    self.bufnr = options.bufnr
    self._.unmanaged_bufnr = true
  else
    self:_buf_create()
  end

  -- luacov: disable
  -- @deprecated
  if not self._.win_options.winblend and is_type("number", options.opacity) then
    self._.win_options.winblend = calculate_winblend(options.opacity)
  end

  -- @deprecated
  if not self._.win_options.winhighlight and not is_type("nil", options.highlight) then
    self._.win_options.winhighlight = options.highlight
  end
  -- luacov: enable

  self.border = Border(self, options.border)
  self.win_config.border = self.border:get()

  if options.position and options.size then
    self:update_layout(options)
  end
end

function Popup:_open_window()
  if self.winid or not self.bufnr then
    return
  end

  self.win_config.noautocmd = true
  self.winid = vim.api.nvim_open_win(self.bufnr, self._.win_enter, self.win_config)
  self.win_config.noautocmd = nil

  vim.api.nvim_win_call(self.winid, function()
    autocmd.exec("BufWinEnter", {
      buffer = self.bufnr,
      modeline = false,
    })
  end)

  assert(self.winid, "failed to create popup window")

  _.set_win_options(self.winid, self._.win_options)
end

function Popup:_close_window()
  if not self.winid then
    return
  end

  if vim.api.nvim_win_is_valid(self.winid) then
    vim.api.nvim_win_close(self.winid, true)
  end

  self.winid = nil
end

function Popup:_buf_create()
  if not self.bufnr then
    self.bufnr = vim.api.nvim_create_buf(false, true)
    assert(self.bufnr, "failed to create buffer")
  end
end

function Popup:mount()
  if not self._.layout_ready then
    return error("layout is not ready")
  end

  if self._.loading or self._.mounted then
    return
  end

  self._.loading = true

  autocmd.create_group(self._.augroup.hide, { clear = true })
  autocmd.create_group(self._.augroup.unmount, { clear = true })
  autocmd.create("QuitPre", {
    group = self._.augroup.unmount,
    buffer = self.bufnr,
    callback = vim.schedule_wrap(function()
      self:unmount()
    end),
  }, self.bufnr)
  autocmd.create("BufWinEnter", {
    group = self._.augroup.unmount,
    buffer = self.bufnr,
    callback = function()
      -- When two popup using the same buffer and both of them
      -- are hiddden, calling `:show` for one of them fires
      -- `BufWinEnter` for both of them. And in that scenario
      -- one of them will not have `self.winid`.
      if self.winid then
        -- @todo skip registering `WinClosed` multiple times
        --       for the same popup
        autocmd.create("WinClosed", {
          group = self._.augroup.hide,
          pattern = tostring(self.winid),
          callback = function()
            self:hide()
          end,
        }, self.bufnr)
      end
    end,
  }, self.bufnr)

  self.border:mount()

  self:_buf_create()

  _.set_buf_options(self.bufnr, self._.buf_options)

  self:_open_window()

  self._.loading = false
  self._.mounted = true
end

function Popup:hide()
  if self._.loading or not self._.mounted then
    return
  end

  self._.loading = true

  pcall(autocmd.delete_group, self._.augroup.hide)

  self.border:_close_window()

  self:_close_window()

  self._.loading = false
end

function Popup:show()
  if self._.loading or not self._.mounted then
    return
  end

  self._.loading = true

  autocmd.create_group(self._.augroup.hide, { clear = true })

  self.border:_open_window()

  self:_open_window()

  self._.loading = false
end

function Popup:_buf_destory()
  if not self.bufnr then
    return
  end

  if vim.api.nvim_buf_is_valid(self.bufnr) then
    u.clear_namespace(self.bufnr, self.ns_id)
    if not self._.unmanaged_bufnr then
      vim.api.nvim_buf_delete(self.bufnr, { force = true })
    end
  end

  buf_storage.cleanup(self.bufnr)

  if not self._.unmanaged_bufnr then
    self.bufnr = nil
  end
end

function Popup:unmount()
  if self._.loading or not self._.mounted then
    return
  end

  self._.loading = true

  pcall(autocmd.delete_group, self._.augroup.hide)
  pcall(autocmd.delete_group, self._.augroup.unmount)

  self.border:unmount()

  self:_buf_destory()

  self:_close_window()

  self._.loading = false
  self._.mounted = false
end

-- set keymap for this popup window
---@param mode string check `:h :map-modes`
---@param key string|string[] key for the mapping
---@param handler string | fun(): nil handler for the mapping
---@param opts table<"'expr'"|"'noremap'"|"'nowait'"|"'remap'"|"'script'"|"'silent'"|"'unique'", boolean>
---@return nil
function Popup:map(mode, key, handler, opts, force)
  if not self.bufnr then
    error("popup buffer not found.")
  end

  return keymap.set(self.bufnr, mode, key, handler, opts, force)
end

---@param mode string check `:h :map-modes`
---@param key string|string[] key for the mapping
---@return nil
function Popup:unmap(mode, key, force)
  if not self.bufnr then
    error("popup buffer not found.")
  end

  return keymap._del(self.bufnr, mode, key, force)
end

---@param event string | string[]
---@param handler string | function
---@param options nil | table<"'once'" | "'nested'", boolean>
function Popup:on(event, handler, options)
  if not self.bufnr then
    error("popup buffer not found.")
  end

  autocmd.buf.define(self.bufnr, event, handler, options)
end

---@param event nil | string | string[]
function Popup:off(event)
  if not self.bufnr then
    error("popup buffer not found.")
  end

  autocmd.buf.remove(self.bufnr, nil, event)
end

-- luacov: disable
-- @deprecated
-- Use `popup:update_layout`.
---@deprecated
function Popup:set_layout(config)
  return self:update_layout(config)
end
-- luacov: enable

---@param config? nui_layout_config
function Popup:update_layout(config)
  config = config or {}

  u.update_layout_config(self._, config)

  self.border:_relayout()

  self._.layout_ready = true

  if self.winid then
    -- upstream issue: https://github.com/neovim/neovim/issues/20370
    local win_config_style = self.win_config.style
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.win_config.style = ""
    vim.api.nvim_win_set_config(self.winid, self.win_config)
    self.win_config.style = win_config_style
  end
end

-- luacov: disable
-- @deprecated
-- Use `popup:update_layout`.
---@deprecated
function Popup:set_size(size)
  self:update_layout({ size = size })
end
-- luacov: enable

-- luacov: disable
-- @deprecated
-- Use `popup:update_layout`.
---@deprecated
function Popup:set_position(position, relative)
  self:update_layout({ position = position, relative = relative })
end
-- luacov: enable

---@alias NuiPopup.constructor fun(options: table): NuiPopup
---@type NuiPopup|NuiPopup.constructor
local NuiPopup = Popup

return NuiPopup
