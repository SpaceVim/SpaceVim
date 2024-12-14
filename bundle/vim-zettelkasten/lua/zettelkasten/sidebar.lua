--=============================================================================
-- sidebar.lua --- sidebar for zettelkasten plugin
-- Copyright (c) 2019-2024 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local browser = require('zettelkasten.browser')

local M = {}

local folded_keys = {}

local function unique_string_table(t)
  local temp = {}
  for _, k in ipairs(t) do
    temp[k] = true
  end
  local rst = {}
  for m, _ in pairs(temp) do
    table.insert(rst, m)
  end
  return rst
end

-- 按照首字母归类

local function get_sorted_keys(t)
  local keys = {}

  for k, _ in pairs(t) do
    table.insert(keys, k)
  end
  return vim.fn.sort(keys)
end

local function sort_tags(tags)
  local atags = {}

  for _, tag in ipairs(vim.fn.sort(tags)) do
    local k = string.upper(string.sub(tag, 2, 2))
    if atags[k] then
      table.insert(atags[k], tag)
    else
      atags[k] = { tag }
    end
  end

  local lines = {}

  -- ▼ functions
  -- ▶ functions
  for _, k in ipairs(get_sorted_keys(atags)) do
    if #atags[k] > 0 then
      if not folded_keys[k] then
        table.insert(lines, '▼ ' .. k)
        for _, t in ipairs(atags[k]) do
          table.insert(lines, '  ' .. t)
        end
      else
        table.insert(lines, '▶ ' .. k)
      end
    end
  end
  return lines
end

local function update_sidebar_context()
  vim.opt_local.modifiable = true
  local lines = {}
  local result = browser.get_tags()
  for _, tag in ipairs(result) do
    table.insert(lines, tag.name)
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, sort_tags(unique_string_table(lines)))
  vim.opt_local.buflisted = false
  vim.opt_local.modifiable = false
end

function M.open_tag_tree()
  vim.cmd('30vsplit zk://tags_tree')
  vim.opt_local.filetype = 'zktagstree'
  folded_keys = {}
  update_sidebar_context()
end

function M.toggle_folded_key()
  local k = string.sub(vim.fn.getline('.'), 5, 5)
  if folded_keys[k] then
    folded_keys[k] = false
  else
    folded_keys[k] = true
  end
  update_sidebar_context()
end

return M
