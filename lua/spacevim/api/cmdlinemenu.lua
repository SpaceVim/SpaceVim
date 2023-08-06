local M = {}
local Key = require('spacevim.api').import('vim.keys')
M.__vim = require('spacevim.api').import('vim')

local function echo(str)
  vim.api.nvim_echo({{str, 'Normal'}}, false, {})
end

local function next_item(list, item)
  local id = vim.fn.index(list, item)
  if id == #list - 1 then
    return list[1]
  else
    return list[id + 2]
  end
end

local function previous_item(list, item)
  local id = vim.fn.index(list, item)
  if id == 0 then
    return list[#list]
  else
    return list[id]
  end
end

local function parse_items(items)
  local is = {}
  local id = 1
  for _, item in ipairs(items) do
    is[id] = item
    is[id][1] = '(' .. id .. ')' .. item[1]
    id = id + 1
  end
  return is
end

local function list_keys(l)
  if #l == 0 then return {} end
  return vim.fn.range(1, #l)
end

function M.menu(items)
  local cancelled = false
  local saved_more = vim.o.more
  local saved_cmdheight = vim.o.cmdheight
  vim.o.more = false
  items = parse_items(items)
  vim.o.cmdheight = #items + 1
  vim.cmd('redrawstatus!')
  local selected = 1
  local exit = false
  local indent = string.rep(' ', 7, '')
  while not exit do
    local menu = 'Cmdline menu: Use j/k/enter and the shortcuts indicated\n'
    local id = 1
    for _, _ in pairs(items) do
      if id == selected then
        menu = menu .. indent .. '>' .. items[id][1] .. '\n'
      else
        menu = menu .. indent .. ' ' .. items[id][1] .. '\n'
      end
      id = id + 1
    end

    vim.cmd('redraw!')
    echo(string.sub(menu, 1, #menu - 1))
    local char = M.__vim.getchar()
    if char == Key.t('<Esc>') or char == Key.t('<C-c>') then
      exit = true
      cancelled = true
      vim.cmd('normal! :')
    elseif vim.fn.index(list_keys(items), tonumber(char)) ~= -1 or char == Key.t('<Cr>') then
      if char ~= Key.t('<Cr>') then
        selected = tonumber(char, 10)
      end
      local value = items[selected][2]
      vim.cmd('normal! :')
      if type(value) == "function" then
        local args = items[selected][3] or {}
        local ok, err = pcall(value, unpack(args))
        if not ok then print(err) end
      elseif type(value) == 'string' then
        vim.cmd(value)
      end
      exit = true
    elseif char == 'j' or char == Key.t('<Tab>') then
      selected = next_item(list_keys(items), selected)
      vim.cmd('normal! :')
    elseif char == 'k' or char == Key.t('<S-Tab>') then
      selected = previous_item(list_keys(items), selected)
      vim.cmd('normal! :')
    else
      vim.cmd('normal! :')
    end
  end
  vim.o.more = saved_more
  vim.o.cmdheight = saved_cmdheight
  vim.cmd('redraw!')
  if cancelled then
    echo('cancelled!')
  end
end

return M
