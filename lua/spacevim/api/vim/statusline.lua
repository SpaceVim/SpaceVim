local M = {}

function M.support_float()
  return vim.fn.exists('*nvim_open_win') == 1
end

function M.opened()
  return vim.fn.win_id2tabwin(M.__winid)[1] == vim.fn.tabpagenr()
end

function M.show()
  if vim.api.nvim_win_is_valid(M.__winid) and vim.fn.has('nvim-0.10.0') == 1 then
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
    local opt = {
      relative = 'editor',
      width = vim.o.columns,
      height = 1,
      -- highlight = 'SpaceVim_statusline_a_bold',
      row = vim.o.lines - 2,
      col = 0,
    }
    if vim.fn.has('nvim-0.10.0') == 1 then
      opt.hide = hide
    end
    M.__winid = vim.api.nvim_open_win(M.__bufnr, false, opt)
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

function M.check_width(len, sec, winwidth)
  return len + M.len(sec) < winwidth
  
end

function M.len(sec)
  if not sec then return 0 end
  local str = vim.fn.matchstr(sec, '%{.*}')
  if vim.fn.empty(str) == 0 then
    local pos = vim.fn.match(str, '}')
    return vim.fn.len(sec) - vim.fn.len(str) + vim.fn.len(vim.fn.eval(string.sub(str, 3, pos))) + 4
  else
    return vim.fn.len(sec) + 4
  end
end

function M.eval(sec)
  return vim.fn.substitute(sec, '%{.*}', '', 'g')
end

function M.build(left_sections, right_sections, lsep, rsep, fname, tag, hi_a, hi_b, hi_c, hi_z, winwidth)
  local l = '%#' .. hi_a .. '#' .. left_sections[1]
  l = l .. '%#' .. hi_a .. '_' .. hi_b .. '#' .. lsep
  local flag = true
  local len = 0
  for _, sec in ipairs(vim.tbl_filter(function(v)
    return vim.fn.empty(v) == 0
  end, vim.list_slice(left_sections, 2))) do
    if M.check_width(len, sec, winwidth) then
      if flag then
        l = l .. '%#' .. hi_b .. '#' .. sec
        l = l .. '%#' .. hi_b .. '_' .. hi_c .. '#' .. lsep
      else
        l = l .. '%#' .. hi_c .. '#' .. sec
        l = l .. '%#' .. hi_c .. '_' .. hi_b .. '#' .. lsep
      end
      flag = not flag
    end
  end
  l = string.sub(l, 1, #l - #lsep)
  if #right_sections == 0 then
    if flag then
      return l .. '%#' .. hi_c .. '#'
    else
      return l .. '%#' .. hi_b .. '#'
    end
  end
  if M.check_width(len, fname, winwidth) then
    len = len +  M.len(fname)
    if flag then
      l = l .. '%#' .. hi_c .. '_' .. hi_z .. '#' .. lsep .. '%#' .. hi_z .. '#' .. fname .. '%='
    else
      l = l .. '%#' .. hi_b .. '_' .. hi_z .. '#' .. lsep .. '%#' .. hi_z .. '#' .. fname .. '%='
    end
  else
    if flag then
      l = l .. '%#' .. hi_c .. '_' .. hi_z .. '#' .. lsep .. '%='
    else
      l = l .. '%#' .. hi_b .. '_' .. hi_z .. '#' .. lsep .. '%='
    end
  end
  if M.check_width(len, tag, winwidth) and vim.g.spacevim_enable_statusline_tag == 1 then
    l = l .. '%#' .. hi_z .. '#' .. tag
  end
  l = l .. '%#' .. hi_b .. '_' .. hi_z .. '#' .. rsep
  flag = true
  for _, sec in ipairs(vim.tbl_filter(function(v)
    return vim.fn.empty(v) == 0
  end, right_sections)) do
    if M.check_width(len, sec, winwidth) then
      len = len + M.len(sec)
      if flag then
        l = l .. '%#' .. hi_b .. '#' .. sec
        l = l .. '%#' .. hi_c .. '_' .. hi_b .. '#' .. rsep
      else
        l = l .. '%#' .. hi_c .. '#' .. sec
        l = l .. '%#' .. hi_b .. '_' .. hi_c .. '#' .. rsep
      end
      flag = not flag
    end
  end
  l = string.sub(l, 1, #l - #rsep)
  return l
end

return M
