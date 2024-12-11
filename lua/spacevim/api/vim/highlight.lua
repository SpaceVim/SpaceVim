local M = {}

M.group2dict = function(name)
  local id = vim.fn.hlID(name)
  if id == 0 then
    return {
      name = '',
      ctermbg = '',
      ctermfg = '',
      bold = '',
      italic = '',
      reverse = '',
      underline = '',
      guibg = '',
      guifg = '',
    }
  end
  local rst = {
    name = vim.fn.synIDattr(id, 'name'),
    ctermbg = vim.fn.synIDattr(id, 'bg', 'cterm'),
    ctermfg = vim.fn.synIDattr(id, 'fg', 'cterm'),
    bold = vim.fn.synIDattr(id, 'bold'),
    italic = vim.fn.synIDattr(id, 'italic'),
    reverse = vim.fn.synIDattr(id, 'reverse'),
    underline = vim.fn.synIDattr(id, 'underline'),
    guibg = vim.fn.tolower(vim.fn.synIDattr(id, 'bg#', 'gui')),
    guifg = vim.fn.tolower(vim.fn.synIDattr(id, 'fg#', 'gui')),
  }
  return rst
end

M.hide_in_normal = function(name)
  local group = M.group2dict(name)
  if vim.fn.empty(group) == 1 then
    return
  end
  local normal = M.group2dict('Normal')
  local guibg = normal.guibg or ''
  local ctermbg = normal.ctermbg or ''
  group.guifg = guibg
  group.guibg = guibg
  group.ctermfg = ctermbg
  group.ctermbg = ctermbg
  group.blend = 100
  M.hi(group)
end

M.hi = function(info)
  if vim.fn.empty(info) == 1 or vim.fn.get(info, 'name', '') == '' then
    return
  end
  vim.cmd('silent! hi clear ' .. info.name)
  local cmd = 'silent hi! ' .. info.name
  if vim.fn.empty(info.ctermbg) == 0 then
    cmd = cmd .. ' ctermbg=' .. info.ctermbg
  end
  if vim.fn.empty(info.ctermfg) == 0 then
    cmd = cmd .. ' ctermfg=' .. info.ctermfg
  end
  if vim.fn.empty(info.guibg) == 0 then
    cmd = cmd .. ' guibg=' .. info.guibg
  end
  if vim.fn.empty(info.guifg) == 0 then
    cmd = cmd .. ' guifg=' .. info.guifg
  end
  local style = {}

  for _, sty in ipairs({ 'bold', 'italic', 'underline', 'reverse' }) do
    if info[sty] == 1 then
      table.insert(style, sty)
    end
  end

  if vim.fn.empty(style) == 0 then
    cmd = cmd .. ' gui=' .. vim.fn.join(style, ',') .. ' cterm=' .. vim.fn.join(style, ',')
  end
  if info.blend then
    cmd = cmd .. ' blend=' .. info.blend
  end
  pcall(vim.cmd, cmd)
end

function M.hi_separator(a, b)
  local hi_a = M.group2dict(a)
  local hi_b = M.group2dict(b)
  local hi_a_b = {
    name = a .. '_' .. b,
    guibg = hi_b.guibg,
    guifg = hi_a.guibg,
    ctermbg = hi_b.ctermbg,
    ctermfg = hi_a.ctermbg,
  }
  local hi_b_a = {
    name = b .. '_' .. a,
    guibg = hi_a.guibg,
    guifg = hi_b.guibg,
    ctermbg = hi_a.ctermbg,
    ctermfg = hi_b.ctermbg,
  }
  M.hi(hi_a_b)
  M.hi(hi_b_a)
end

local function get_color(name)
  local c = vim.api.nvim_get_hl(0, { name = name })

  if c.link then
    return get_color(c.link)
  else
    return c
  end
end


function M.syntax_at(...)
  local lnum = select(1, ...) or vim.fn.line('.')
  local col = select(2, ...) or vim.fn.col('.')
  local inspect = vim.inspect_pos(0, lnum - 1, col - 1)
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

return M
