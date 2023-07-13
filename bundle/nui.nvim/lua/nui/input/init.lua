local Popup = require("nui.popup")
local Text = require("nui.text")
local defaults = require("nui.utils").defaults
local is_type = require("nui.utils").is_type
local event = require("nui.utils.autocmd").event

-- exiting insert mode places cursor one character backward,
-- so patch the cursor position to one character forward
-- when unmounting input.
---@param target_cursor number[]
---@param force? boolean
local function patch_cursor_position(target_cursor, force)
  local cursor = vim.api.nvim_win_get_cursor(0)

  if target_cursor[2] == cursor[2] and force then
    -- didn't exit insert mode yet, but it's gonna
    vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + 1 })
  elseif target_cursor[2] - 1 == cursor[2] then
    -- already exited insert mode
    vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + 1 })
  end
end

---@alias nui_input_internal nui_popup_internal|{ default_value: string, prompt: NuiText }

---@class NuiInput: NuiPopup
---@field private _ nui_input_internal
local Input = Popup:extend("NuiInput")

---@param popup_options table
---@param options table
function Input:init(popup_options, options)
  popup_options.enter = true

  popup_options.buf_options = defaults(popup_options.buf_options, {})
  popup_options.buf_options.buftype = "prompt"

  if not is_type("table", popup_options.size) then
    popup_options.size = {
      width = popup_options.size,
    }
  end

  popup_options.size.height = 1

  Input.super.init(self, popup_options)

  self._.default_value = defaults(options.default_value, "")
  self._.prompt = Text(defaults(options.prompt, ""))
  self._.disable_cursor_position_patch = defaults(options.disable_cursor_position_patch, false)

  local props = {}

  self.input_props = props

  props.on_submit = function(value)
    local target_cursor = vim.api.nvim_win_get_cursor(self._.position.win)

    local prompt_normal_mode = vim.fn.mode() == "n"

    self:unmount()

    vim.schedule(function()
      if prompt_normal_mode then
        -- NOTE: on prompt-buffer normal mode <CR> causes neovim to enter insert mode.
        --  ref: https://github.com/neovim/neovim/blob/d8f5f4d09078/src/nvim/normal.c#L5327-L5333
        vim.api.nvim_command("stopinsert")
      end

      if not self._.disable_cursor_position_patch then
        patch_cursor_position(target_cursor, prompt_normal_mode)
      end

      if options.on_submit then
        options.on_submit(value)
      end
    end)
  end

  props.on_close = function()
    local target_cursor = vim.api.nvim_win_get_cursor(self._.position.win)

    self:unmount()

    vim.schedule(function()
      if vim.fn.mode() == "i" then
        vim.api.nvim_command("stopinsert")
      end

      if not self._.disable_cursor_position_patch then
        patch_cursor_position(target_cursor)
      end

      if options.on_close then
        options.on_close()
      end
    end)
  end

  if options.on_change then
    props.on_change = function()
      local value_with_prompt = vim.api.nvim_buf_get_lines(self.bufnr, 0, 1, false)[1]
      local value = string.sub(value_with_prompt, self._.prompt:length() + 1)
      options.on_change(value)
    end
  end
end

function Input:mount()
  local props = self.input_props

  Input.super.mount(self)

  if props.on_change then
    vim.api.nvim_buf_attach(self.bufnr, false, {
      on_lines = props.on_change,
    })
  end

  if #self._.default_value then
    self:on(event.InsertEnter, function()
      vim.api.nvim_feedkeys(self._.default_value, "t", true)
    end, { once = true })
  end

  vim.fn.prompt_setprompt(self.bufnr, self._.prompt:content())
  if self._.prompt:length() > 0 then
    vim.schedule(function()
      self._.prompt:highlight(self.bufnr, self.ns_id, 1, 0)
    end)
  end

  vim.fn.prompt_setcallback(self.bufnr, props.on_submit)
  vim.fn.prompt_setinterrupt(self.bufnr, props.on_close)

  vim.api.nvim_command("startinsert!")
end

---@alias NuiInput.constructor fun(popup_options: table, options: table): NuiInput
---@type NuiInput|NuiInput.constructor
local NuiInput = Input

return NuiInput
