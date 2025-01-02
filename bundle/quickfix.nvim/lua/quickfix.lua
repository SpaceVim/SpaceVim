--=============================================================================
-- qf.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local qf_historys = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup('quickfix_mapping', {
    clear = true,
  })

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'qf',
    group = group,
    callback = function(ev)
      vim.keymap.set('n', vim.g.quickfix_mapping_delete or 'dd', function()
        local qflist = vim.fn.getqflist()
        local line = vim.fn.line('.')
        if #qflist >= 1 then
          table.insert(qf_historys, vim.deepcopy(qflist))
          table.remove(qflist, line)
        end
        vim.fn.setqflist(qflist)
        vim.cmd(tostring(line))
      end, { buffer = ev.buf })
    end,
  })

  local function table_remove(t, from, to)
    local rst = {}
    for i = 1, #t, 1 do
      if i < from or i > to then
        rst[#rst + 1] = t[i]
      end
    end
    return rst
  end

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'qf',
    group = group,
    callback = function(ev)
      vim.keymap.set('v', vim.g.quickfix_mapping_visual_delete or 'd', function()
        local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'x', false)
        local qflist = vim.fn.getqflist()
        local from = vim.fn.getpos("'<")[2]
        local to = vim.fn.getpos("'>")[2]
        if from > to then
          from, to = to, from
        end
        local qf = table_remove(qflist, from, to)
        if #qf ~= #qflist and #qflist ~= 0 then
          table.insert(qf_historys, qflist)
        end
        vim.fn.setqflist(qf)
        vim.cmd(tostring(from))
      end, { buffer = ev.buf })
    end,
  })
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'qf',
    group = group,
    callback = function(ev)
      vim.keymap.set('n', vim.g.quickfix_mapping_filter_filename or 'c', function()
        local input_pattern = vim.fn.input('filter pattern:')
        -- vim.cmd('noautocmd normal! :')
        local re = vim.regex(input_pattern)
        local qflist = vim.fn.getqflist()
        local qf = {}
        for _, item in ipairs(qflist) do
          if not re:match_str(vim.fn.bufname(item.bufnr)) then
            table.insert(qf, item)
          end
        end
        if #qf ~= #qflist and #qflist ~= 0 then
          table.insert(qf_historys, qflist)
        end
        vim.fn.setqflist(qf)
      end, { buffer = ev.buf })
    end,
  })

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'qf',
    group = group,
    callback = function(ev)
      vim.keymap.set('n', vim.g.quickfix_mapping_rfilter_filename or 'C', function()
        local input_pattern = vim.fn.input('filter pattern:')
        local re = vim.regex(input_pattern)
        local qf = {}
        local qflist = vim.fn.getqflist()
        for _, item in ipairs(qflist) do
          if re:match_str(vim.fn.bufname(item.bufnr)) then
            table.insert(qf, item)
          end
        end
        if #qf ~= #qflist and #qflist ~= 0 then
          table.insert(qf_historys, qflist)
        end
        vim.fn.setqflist(qf)
      end, { buffer = ev.buf })
    end,
  })
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'qf',
    group = group,
    callback = function(ev)
      vim.keymap.set('n', vim.g.quickfix_mapping_filter_text or 'o', function()
        local input_pattern = vim.fn.input('filter pattern:')
        -- vim.cmd('noautocmd normal! :')
        local re = vim.regex(input_pattern)
        local qf = {}
        local qflist = vim.fn.getqflist()
        for _, item in ipairs(qflist) do
          if not re:match_str(item.text) then
            table.insert(qf, item)
          end
        end
        if #qf ~= #qflist and #qflist ~= 0 then
          table.insert(qf_historys, qflist)
        end
        vim.fn.setqflist(qf)
      end, { buffer = ev.buf })
    end,
  })
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'qf',
    group = group,
    callback = function(ev)
      vim.keymap.set('n', vim.g.quickfix_mapping_rfilter_text or 'O', function()
        local input_pattern = vim.fn.input('filter pattern:')
        -- vim.cmd('noautocmd normal! :')
        local re = vim.regex(input_pattern)
        local qf = {}
        local qflist = vim.fn.getqflist()
        for _, item in ipairs(qflist) do
          if re:match_str(item.text) then
            table.insert(qf, item)
          end
        end
        if #qf ~= #qflist and #qflist ~= 0 then
          table.insert(qf_historys, qflist)
        end
        vim.fn.setqflist(qf)
      end, { buffer = ev.buf })
    end,
  })
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'qf',
    group = group,
    callback = function(ev)
      vim.keymap.set('n', vim.g.quickfix_mapping_undo or 'u', function()
        local qf = table.remove(qf_historys)
        if qf then
          vim.fn.setqflist(qf)
        end
      end, { buffer = ev.buf })
    end,
  })
end

return M
