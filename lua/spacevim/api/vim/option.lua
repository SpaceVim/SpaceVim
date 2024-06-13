local M = {}

-- this function require neovim v0.8.0+
function M.setlocalopt(buf, win, opts)
  local getinfo
  if vim.api.nvim_get_option_info2 then
    getinfo = function(o)
      return vim.api.nvim_get_option_info2(o, {})
    end
  else
    getinfo = function(o)
      return vim.api.nvim_get_option_info(o)
    end
  end
  for o, value in pairs(opts) do
    local info = getinfo(o)
    if info.scope == 'win' then
      vim.api.nvim_set_option_value(o, value, {
        win = win,
      })
    elseif info.scope == 'buf' then
      vim.api.nvim_set_option_value(o, value, {
        buf = buf,
      })
    end
  end
end

return M
