local M = {}

function M.support_float()
  return vim.fn.exists('*nvim_open_win') == 1
end

function M.opened()
  return vim.fn.win_id2tabwin(M.__winid)[1] == vim.fn.tabpagenr()
end

function M.show()
  if vim.api.nvim_win_is_valid(M.__winid) then
    vim.api.nvim_win_set_config(M.__winid, { hide = false })
  end
end

function M.open_float(sl, ...)
  local hide = select(1, ...)
  if hide == true or hide == false then
  else
    hide = false
  end
  if M.__bufnr == nil or vim.fn.bufexists(M.__bufnr) == 0 then
    M.__bufnr = vim.api.nvim_create_buf(false, true)
  end
  if M.__winid == nil or not M.opened() then
    M.__winid = vim.api.nvim_open_win(M.__bufnr, false, {
      relative = 'editor',
      width = vim.o.columns,
      height = 1,
      -- highlight = 'SpaceVim_statusline_a_bold',
      row = vim.o.lines - 2,
      col = 0,
      hide = hide,
    })
  end
  vim.fn.setwinvar(M.__winid, '&winhighlight', 'Normal:SpaceVim_statusline_a_bold')
  vim.fn.setbufvar(M.__bufnr, '&relativenumber', 0)
  vim.fn.setbufvar(M.__bufnr, '&number', 0)
  vim.fn.setbufvar(M.__bufnr, '&bufhidden', 'wipe')
  vim.fn.setbufvar(M.__bufnr, '&cursorline', 0)
  vim.fn.setbufvar(M.__bufnr, '&modifiable', 1)
  vim.fn.setwinvar(vim.fn.win_id2win(M.__winid), '&cursorline', 0)
  vim.api.nvim_buf_set_virtual_text(M.__bufnr, -1, 0, sl, {})
  vim.fn.setbufvar(M.__bufnr, '&modifiable', 0)
  return M.__winid
end

function M.close_float()
  if M.__winid ~= nil then
    vim.api.nvim_win_close(M.__winid, true)
  end
end

return M
