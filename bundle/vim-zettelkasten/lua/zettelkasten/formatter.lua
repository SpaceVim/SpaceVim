--=============================================================================
-- formatter.lua --- formatter for zk notes browser
-- Copyright (c) 2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local function str2chars(str)
  local t = {}
  for _, k in ipairs(vim.fn.split(str, '\\zs')) do
    table.insert(t, k)
  end
  return t
end

local s_formatters = {
  ['%r'] = function(line)
    return #line.references
  end,
  ['%b'] = function(line)
    return #line.back_references
  end,
  ['%f'] = function(line)
    return vim.fn.fnamemodify(line.file_name, ':t')
  end,
  ['%h'] = function(line)
    if vim.fn.strdisplaywidth(line.title) < 30 then
      return line.title .. string.rep(' ', 30 - vim.fn.strdisplaywidth(line.title))
    else
      local t = ''
      for _, char in ipairs(str2chars(line.title)) do
        if vim.fn.strdisplaywidth(t) + vim.fn.strdisplaywidth(char) <= 27 then
          t = t .. char
        else
          break
        end
      end
      t = t .. '...'
      return t .. string.rep(' ', 30 - vim.fn.strdisplaywidth(t))
    end
  end,
  ['%d'] = function(line)
    return line.id
  end,
  ['%t'] = function(line)
    local tags = {}
    for _, tag in ipairs(line.tags) do
      if vim.tbl_contains(tags, tag.name) == false then
        table.insert(tags, tag.name)
      end
    end

    return table.concat(tags, ' ')
  end,
}

local function get_format_keys(format)
  local matches = {}
  for w in string.gmatch(format, '%%%a') do
    table.insert(matches, w)
  end

  return matches
end

function M.format(lines, format)
  local formatted_lines = {}
  local modifiers = get_format_keys(format)
  for _, line in ipairs(lines) do
    local cmps = format
    for _, modifier in ipairs(modifiers) do
      local rst = s_formatters[modifier](line) or ''
      cmps = string.gsub(cmps, '%' .. modifier, rst)
    end

    table.insert(formatted_lines, cmps)
  end

  return formatted_lines
end

return M
