--!/usr/bin/lua
local M = {}

local specified_keys = {}

function M.t(str)
  if vim.api ~= nil and vim.api.nvim_replace_termcodes ~= nil then
    -- https://github.com/neovim/neovim/issues/17369
    local ret = vim.api.nvim_replace_termcodes(str, false, true, true):gsub('\128\254X', '\128')
    return ret
  else
    -- local ret = vim.fn.execute('echon "\\' .. str .. '"')
    -- ret = ret:gsub('<80>', '\128')
    -- return ret
    return vim.eval(string.format('"\\%s"', str))
  end
end

function M.char2name(c)
  if #c == 1 then
    return M.nr2name(vim.fn.char2nr(c))
  end
  return specified_keys[c] or c
end

function M.nr2name(nr)
  if type(nr) == 'number' then
    if nr == 32 then
      return 'SPC'
    elseif nr == 4 then
      return '<C-d>'
    elseif nr == 3 then
      return '<C-c>'
    elseif nr == 9 then
      return '<Tab>'
    elseif nr == 92 then
      return '<Leader>'
    elseif nr == 27 then
      return '<Esc>'
    else
      return vim.fn.nr2char(nr)
    end
  else
    return specified_keys[nr] or ''
  end
end

return M
