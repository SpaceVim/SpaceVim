--
--------------------------------------------------------------------------------
--         File:  hover.lua
--------------------------------------------------------------------------------
--

local vim = vim
local api = vim.api
local feature = 'textDocument/hover'
local default_response_handler = vim.lsp.handlers[feature]

local hover_initialise = {
  buffer_changes = 0,
  complete_item = nil,
  complete_item_index = -1,
  insert_mode = false,
  window = nil
}

local hover = hover_initialise
local util = require 'util'

local complete_visible = function()
  return vim.fn.pumvisible() ~= 0
end

local get_markdown_lines = function(result)
  local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)

  return  vim.lsp.util.trim_empty_lines(markdown_lines)
end

local get_window_alignment = function(complete_columns, screen_columns)
  if complete_columns < screen_columns / 2 then
    alignment = 'right'
  else
    alignment = 'left'
  end

  return alignment
end

local create_window = function(method, result)
  return util.focusable_float(method, function()
    local markdown_lines = get_markdown_lines(result)
    if vim.tbl_isempty(markdown_lines) then return end

    local complete_display_info = vim.fn.pum_getpos()
    local alignment = get_window_alignment(complete_display_info['col'], api.nvim_get_option('columns'))

    local hover_buffer, hover_window

    hover_buffer, hover_window = util.fancy_floating_markdown(markdown_lines, {
      pad_left = 1; pad_right = 1;
      col = complete_display_info['col']; width = complete_display_info['width']; row = vim.fn.winline();
      align = alignment;
    })

    hover.window = hover_window

    if hover_window ~= nil and api.nvim_win_is_valid(hover_window) then
      vim.lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, hover_window)
    end

    return hover_buffer, hover_window
  end)
end

local handle_response = function(_, method, result)
  if complete_visible() == false then return default_response_handler(_, method, result, _) end
  if not (result and result.contents) then return end

  return create_window(method, result)
end

local set_response_handler = function()
  for _, client in pairs(vim.lsp.buf_get_clients(0)) do
    local handlers = client.config and client.config.handlers
    if handlers then
      if handlers[feature] == handle_response then
        break
      end
      handlers[feature] = handle_response
    end
  end
end

local decode_user_data = function(user_data)
  if user_data == nil or (user_data ~= nil and #user_data == 0) then return end

  return  vim.fn.json_decode(user_data)
end

local client_with_hover = function()
  for _, value in pairs(vim.lsp.buf_get_clients(0)) do
    if value.resolved_capabilities.hover == false then return false end
  end

  return true
end

local buffer_changed = function()
  buffer_changes = api.nvim_buf_get_changedtick(0)
  if hover.buffer_changes == buffer_changes then return false end

  hover.buffer_changes = buffer_changes

  return hover.buffer_changes
end

local close_window = function()
  if hover.window == nil or not api.nvim_win_is_valid(hover.window) then return end

  api.nvim_win_close(hover.window, true)
end

local get_complete_item = function()
  local complete_info = api.nvim_call_function('complete_info', {{ 'eval', 'selected', 'items', 'user_data' }})
  if complete_info['selected'] == -1 or complete_info['selected'] == hover.complete_item_index then return false end

  hover.complete_item_index = complete_info['selected']

  return complete_info['items'][hover.complete_item_index + 1]
end

local request_hover = function()
  local complete_item = get_complete_item()
  if not complete_visible() or not buffer_changed() or not complete_item then return end

  close_window()

  if not client_with_hover() then return end

  local decoded_user_data = decode_user_data(complete_item['user_data'])
  if decoded_user_data == nil then return end

  set_response_handler()

  return vim.lsp.buf_request(api.nvim_get_current_buf(), 'textDocument/hover', util.make_position_params())
end

local insert_enter_handler = function()
  hover.insert_mode = true
  local timer = vim.loop.new_timer()

  timer:start(100, 80, vim.schedule_wrap(function()
    request_hover()

    if hover.insert_mode == false and timer:is_closing() == false then
      timer:stop()
      timer:close()
    end
  end))
end

local insert_leave_handler = function()
  hover.insert_mode = false
end

return {
  insert_enter_handler = insert_enter_handler,
  insert_leave_handler = insert_leave_handler
}
