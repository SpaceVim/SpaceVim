--=============================================================================
-- util.lua
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local color = require('spacevim.api.color')

function M.generate_bar(n, char, m)
  return string.rep(char, math.floor(24 * n / (m or 1)))
end

function M.get_hex_code(t, code)
  return color[t .. '2hex'](unpack(code))
end

function M.get_hsl_l(hex)
  local _, _, l = color.rgb2hsl(color.hex2rgb(hex))
  return l
end

function M.increase(v, step, min, max)
  step = step or 100
  min = min or 0
  max = max or 1
  local sep = (max - min) / step
  v = (math.floor(v / sep + 0.5) + 1) * sep
  if v >= max then
    return max
  elseif v <= min then
    return min
  else
    return v
  end
end

function M.reduce(v, step, min, max)
  step = step or 100
  min = min or 0
  max = max or 1
  local sep = (max - min) / step
  v = (math.floor(v / sep + 0.5) - 1) * sep
  if v >= max then
    return max
  elseif v <= min then
    return min
  else
    return v
  end
end

function M.update_color_code_syntax(r)
  local max = 0
  local regexes = {}
  for _, v in ipairs(r) do
    max = math.max(max, v[1])
  end
  regexes = vim.tbl_map(function(val)
    return val[2] .. string.rep('\\s', max - val[1])
  end, r)
  vim.cmd('syn match SpaceVimPickerCode /' .. table.concat(regexes, '\\|') .. '/')
end

local function get_color(name)
  local c = vim.api.nvim_get_hl(0, { name = name })

  if c.link then
    return get_color(c.link)
  else
    return c
  end
end

function M.set_default_color(formats)
  if #formats == 0 then
    formats = { 'rgb', 'hsl' }
  else
    formats = formats
  end
  local inspect = vim.inspect_pos()
  local hex
  if #inspect.semantic_tokens > 0 then
    local token, priority = {}, 0
    for _, semantic_token in ipairs(inspect.semantic_tokens) do
      if semantic_token.opts.priority > priority then
        priority = semantic_token.opts.priority
        token = semantic_token
      end
    end
    if token then
      local fg = vim.api.nvim_get_hl(0, { name = token.opts.hl_group_link }).fg
      if fg then
        hex = string.format('#%06X', fg)
      end
    end
  elseif #inspect.treesitter > 0 then
    for i = #inspect.treesitter, 1, -1 do
      local fg = vim.api.nvim_get_hl(0, { name = inspect.treesitter[i].hl_group_link }).fg
      if fg then
        hex = string.format('#%06X', fg)
        break
      end
    end
  else
    local name = vim.fn.synIDattr(vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 1), 'name', 'gui')
    local fg = get_color(name).fg
    if fg then
      hex = string.format('#%06X', fg)
    end
  end

  if hex then
    require('cpicker').set_default_color(hex)
    local r, g, b = color.hex2rgb(hex)
    for _, format in ipairs(formats) do
      local ok, f = pcall(require, 'cpicker.formats.' .. format)
      if ok then
        f.on_change('rgb', { r, g, b })
      end
    end
  end
end

function M.get_cursor_hl()
  local inspect = vim.inspect_pos()
  local name, hl
  if #inspect.semantic_tokens > 0 then
    local token, priority = {}, 0
    for _, semantic_token in ipairs(inspect.semantic_tokens) do
      if semantic_token.opts.priority > priority then
        priority = semantic_token.opts.priority
        token = semantic_token
      end
    end
    if token then
      name = token.opts.hl_group_link
      hl = vim.api.nvim_get_hl(0, { name = token.opts.hl_group_link })
    end
  elseif #inspect.treesitter > 0 then
    for i = #inspect.treesitter, 1, -1 do
      name = inspect.treesitter[i].hl_group_link
      hl = vim.api.nvim_get_hl(0, { name = name })
      if hl.fg then
        break
      end
    end
  else
    name = vim.fn.synIDattr(vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 1), 'name', 'gui')
    hl = get_color(name)
  end
  return name, hl
end

function M.read_color_patch()
  if
    vim.fn.filereadable(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/cpicker_color_patch'))
    == 1
  then
    local _his = vim.fn.json_decode( vim.fn.join( vim.fn.readfile(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/cpicker_color_patch'), ''), '' ) )
    if type(_his) == 'table' then
      return _his or {}
    else
      return {}
    end
  else
    return {}
  end
end
function M.update_color_patch(name, hl)
  if vim.fn.isdirectory(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim')) == 0 then
    vim.fn.mkdir(vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim'))
  end
  local patch = M.read_color_patch()
  if not patch[vim.g.colors_name] then
    patch[vim.g.colors_name] = {}
  end
  patch[vim.g.colors_name][name] = hl
  vim.fn.writefile(
    { vim.fn.json_encode(patch) },
    vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/cpicker_color_patch')
  )
end

function M.patch_color(c)
  local patch = M.read_color_patch()
  if patch[c] then
    for name, hl in pairs(patch[c]) do
      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

function M.clear_color_patch()
  local patch = M.read_color_patch()
  patch[vim.g.colors_name] = nil
  vim.fn.writefile(
    { vim.fn.json_encode(patch) },
    vim.fn.expand(vim.g.spacevim_data_dir .. 'SpaceVim/cpicker_color_patch')
  )
  vim.cmd('colorscheme ' .. vim.g.colors_name)
end

return M
