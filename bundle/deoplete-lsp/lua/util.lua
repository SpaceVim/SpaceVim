--
--------------------------------------------------------------------------------
--         File:  util.lua
--------------------------------------------------------------------------------
--
-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua
--
-- Don't like some conventions here but minimal modifications will make easier to compare with original

local vim = vim
local validate = vim.validate
local api = vim.api

local M = {}

local function ok_or_nil(status, ...)
  if not status then return end
  return ...
end
local function npcall(fn, ...)
  return ok_or_nil(pcall(fn, ...))
end

function M.make_floating_popup_options(width, height, opts)
  validate {
    opts = { opts, 't', true };
  }
  opts = opts or {}
  validate {
    ["opts.offset_x"] = { opts.offset_x, 'n', true };
    ["opts.offset_y"] = { opts.offset_y, 'n', true };
  }

  local lines_above = vim.fn.winline() - 1
  local lines_below = vim.fn.winheight(0) - lines_above

  local col

  if lines_above < lines_below then
    height = math.min(lines_below, height)
  else
    height = math.min(lines_above, height)
  end

  if opts.align == 'right' then
    col = opts.col + opts.width
  else
    col = opts.col - width - 1
  end

  return {
    col = col,
    height = height,
    relative = 'editor',
    row = opts.row,
    focusable = false,
    style = 'minimal',
    width = width,
  }
end

local function find_window_by_var(name, value)
  for _, win in ipairs(api.nvim_list_wins()) do
    if npcall(api.nvim_win_get_var, win, name) == value then
      return win
    end
  end
end

function M.focusable_float(unique_name, fn)
  if npcall(api.nvim_win_get_var, 0, unique_name) then
    return api.nvim_command("wincmd p")
  end

  local bufnr = api.nvim_get_current_buf()

  do
    local win = find_window_by_var(unique_name, bufnr)
    if win then
      api.nvim_win_close(win, true)
    end
  end

  local pbufnr, pwinnr = fn()

  if pbufnr then
    api.nvim_win_set_var(pwinnr, unique_name, bufnr)
    return pbufnr, pwinnr
  end
end

-- Convert markdown into syntax highlighted regions by stripping the code
-- blocks and converting them into highlighted code.
-- This will by default insert a blank line separator after those code block
-- regions to improve readability.
function M.fancy_floating_markdown(contents, opts)
  local pad_left = opts and opts.pad_left
  local pad_right = opts and opts.pad_right
  local stripped = {}
  local highlights = {}

  local max_width
  if opts.align == 'right' then
    local columns = api.nvim_get_option('columns')
    max_width = columns - opts.col - opts.width
  else
    max_width = opts.col - 1
  end

  -- Didn't have time to investigate but this fixes popup offset by one display issue
  max_width = max_width - pad_left - pad_right

  do
    local i = 1
    while i <= #contents do
      local line = contents[i]
      local ft = line:match("^```([a-zA-Z0-9_]*)$")
      if ft then
        local start = #stripped
        i = i + 1
        while i <= #contents do
          line = contents[i]
          if line == "```" then
            i = i + 1
            break
          end
          if #line > max_width then
            while #line > max_width do
              local trimmed_line = string.sub(line, 1, max_width)
              local index = trimmed_line:reverse():find(" ")
              if index == nil or index > #trimmed_line/2 then
                break
              else
                table.insert(stripped, string.sub(line, 1, max_width-index))
                line = string.sub(line, max_width-index+2, #line)
              end
            end
            table.insert(stripped, line)
          else
            table.insert(stripped, line)
          end
          i = i + 1
        end
        table.insert(highlights, {
          ft = ft;
          start = start + 1;
          finish = #stripped + 1 - 1
        })
      else
        if #line > max_width then
          while #line > max_width do
            local trimmed_line = string.sub(line, 1, max_width)
            -- local index = math.max(trimmed_line:reverse():find(" "), trimmed_line:reverse():find("/"))
            local index = trimmed_line:reverse():find(" ")
            if index == nil or index > #trimmed_line/2 then
              break
            else
              table.insert(stripped, string.sub(line, 1, max_width-index))
              line = string.sub(line, max_width-index+2, #line)
            end
          end
          table.insert(stripped, line)
        else
          table.insert(stripped, line)
        end
        i = i + 1
      end
    end
  end

  local width = 0
  for i, v in ipairs(stripped) do
    v = v:gsub("\r", "")
    if pad_left then v = (" "):rep(pad_left)..v end
    if pad_right then v = v..(" "):rep(pad_right) end
    stripped[i] = v
    width = math.max(width, #v)
  end

  if opts.align == 'right' then
    local columns = api.nvim_get_option('columns')
    if opts.col + opts.row + width > columns then
      width = columns - opts.col - opts.width - 1
    end
  else
    if width > opts.col then
      width = opts.col - 1
    end
  end

  local insert_separator = true
  if insert_separator then
    for i, h in ipairs(highlights) do
      h.start = h.start + i - 1
      h.finish = h.finish + i - 1
      if h.finish + 1 <= #stripped then
        table.insert(stripped, h.finish + 1, string.rep("─", width))
      end
    end
  end


  -- Make the floating window.
  local height = #stripped
  local bufnr = api.nvim_create_buf(false, true)
  local winnr
  if vim.g.completion_docked_hover == 1 then
    if height > vim.g.completion_docked_maximum_size then
      height = vim.g.completion_docked_maximum_size
    elseif height < vim.g.completion_docked_minimum_size then
      height = vim.g.completion_docked_minimum_size
    end
    local row
    if vim.fn.winline() > api.nvim_get_option('lines')/2 then
      row = 0
    else
      row = api.nvim_get_option('lines') - height
    end
    winnr = api.nvim_open_win(bufnr, false, {
        col = 0,
        height = height,
        relative = 'editor',
        row = row,
        focusable = true,
        style = 'minimal',
        width = api.nvim_get_option('columns'),
      })
  else
    local opt = M.make_floating_popup_options(width, height, opts)
    if opt.width <= 0 then return end
    winnr = api.nvim_open_win(bufnr, false, opt)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, stripped)

  local cwin = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(winnr)

  vim.cmd("ownsyntax markdown")
  local idx = 1
  local function highlight_region(ft, start, finish)
    if ft == '' then return end
    local name = ft..idx
    idx = idx + 1
    local lang = "@"..ft:upper()
    -- TODO(ashkan): better validation before this.
    if not pcall(vim.cmd, string.format("syntax include %s syntax/%s.vim", lang, ft)) then
      return
    end
    vim.cmd(string.format("syntax region %s start=+\\%%%dl+ end=+\\%%%dl+ contains=%s", name, start, finish + 1, lang))
  end
  for _, h in ipairs(highlights) do
    highlight_region(h.ft, h.start, h.finish)
  end

  vim.api.nvim_set_current_win(cwin)
  return bufnr, winnr
end

local str_utfindex = vim.str_utfindex
local function make_position_param()
  local row, col = unpack(api.nvim_win_get_cursor(0))
  row = row - 1
  local line = api.nvim_buf_get_lines(0, row, row+1, true)[1]
  col = str_utfindex(line, col)
  return { line = row; character = col; }
end

function M.make_position_params()
  return {
    textDocument = M.make_text_document_params();
    position = make_position_param()
  }
end

function M.make_text_document_params()
  return { uri = vim.uri_from_bufnr(0) }
end

return M
