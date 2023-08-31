local M = {}

function M.setlocalopt(buf, win, opts)
  for o, value in pairs(opts) do
    local info = vim.api.nvim_get_option_info2(o, {})
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
