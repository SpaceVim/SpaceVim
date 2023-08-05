local M = {}

local function parse_input(char)
  if char == 27 then
    return ''
  else
    return char
  end
end

local function next_item(list, item)
  local id = vim.fn.index(list, item)
  if id == #list then
    return list[1]
  else
    return list[id]
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
  for _, item in pairs(items) do
    local id = vim.fn.index(items, item) + 1
    is[id] = item
    is[id][1] = '(' .. id .. ')' .. item[1]
  end
  return is
end

function M.menu(items)
  local cancelled = false
  local saved_more = vim.o.more
  local saved_cmdheight = vim.o.cmdheight
  vim.o.more = false
  items = parse_items(items)
  vim.o.cmdheight = #items + 1
  vim.cmd('redrawstatus!')
  local selected = '1'
  local exit = false
  local indent = string.rep(' ', 7, '')
  while not exit do
    local menu = 'Cmdline menu: Use j/k/enter and the shortcuts indicated\n'
    for id, _ in pairs(items) do
      local m = items[id]
      if type(m) == 'table' then
        m = m[1]
      end
      if id == selected then
        menu = menu .. indent .. '>' .. items[id][1] .. '\n'
      else
        menu = menu .. indent .. ' ' .. items[id][1] .. '\n'
      end
    end

    vim.cmd('redraw!')
    vim.api.nvim_echo({ { string.sub(menu, 1, #menu - 2), 'Nornal' } }, false, {})
    local nr = vim.fn.getchar()
    if parse_input(nr) == #'' or nr == 3 then
      exit = false
      cancelled = true
      vim.cmd('normal! :')
    elseif vim.fn.index(vim.fn.keys(items), vim.fn.nr2char(nr)) ~= -1 or nr == 13 then
      if nr ~= 13 then
        selected = vim.fn.nr2char(nr)
      end
      local value = items[selected][1]
      vim.cmd('normal! :')
      if vim.fn.type(value) == 2 then
        local args = vim.fn.get(items[selected], 2, {})
        pcall(value, unpack(args))
      elseif type(value) == 'string' then
        vim.cmd(value)
      end
      exit = true
    elseif vim.fn.nr2char(nr) == 'j' or nr == 9 then
      selected = next_item(vim.fn.keys(items), selected)
      vim.cmd('normal! :')
    elseif vim.fn.nr2char(nr) == 'k' then -- or nr == "\<S-Tab>"
      selected = previous_item(vim.fn.keys(items), selected)
      vim.cmd('normal! :')
    else
      vim.cmd('normal! :')
    end
  end
  vim.o.more = saved_more
  vim.o.cmdheight = saved_cmdheight
  vim.cmd('redraw!')
  if cancelled then
    vim.api.nvim_echo({ { 'cancelled!', 'Normal' } }, false, {})
  end
end

return M
