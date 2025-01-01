--=============================================================================
-- qf.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup('quickfix_mapping', {
    clear = true,
  })

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'qf',
    group = group,
    callback = function(ev)
      vim.keymap.set('n', 'dd', function()
        local qflist = vim.fn.getqflist()
        local line = vim.fn.line('.')
        table.remove(qflist, line)
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
      vim.keymap.set('v', 'd', function()
        local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'x', false)
        local qflist = vim.fn.getqflist()
        local from = vim.fn.getpos("'<")[2]
        local to = vim.fn.getpos("'>")[2]
        if from > to then
          from, to = to, from
        end
        qflist = table_remove(qflist, from, to)
        vim.fn.setqflist(qflist)
        vim.cmd(tostring(from))
      end, { buffer = ev.buf })
    end,
  })
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'qf',
    group = group,
    callback = function(ev)
      vim.keymap.set('n', 'c', function()
        local input_pattern = vim.fn.input('filter pattern:')
        -- vim.cmd('noautocmd normal! :')
        local re = vim.regex(input_pattern)
        local qf = {}
        for _, item in ipairs(vim.fn.getqflist()) do
          if not re:match_str(vim.fn.bufname(item.bufnr)) then
            table.insert(qf, item)
          end
        end
        vim.fn.setqflist(qf)
      end, { buffer = ev.buf })
    end,
  })
end

return M
