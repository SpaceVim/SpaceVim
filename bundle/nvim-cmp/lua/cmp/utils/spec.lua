local context = require('cmp.context')
local source = require('cmp.source')
local types = require('cmp.types')
local config = require('cmp.config')

local spec = {}

spec.before = function()
  vim.cmd([[
    bdelete!
    enew!
    imapclear
    imapclear <buffer>
    cmapclear
    cmapclear <buffer>
    smapclear
    smapclear <buffer>
    xmapclear
    xmapclear <buffer>
    tmapclear
    tmapclear <buffer>
    setlocal noswapfile
    setlocal virtualedit=all
    setlocal completeopt=menu,menuone,noselect
  ]])
  config.set_global({
    sources = {
      { name = 'spec' },
    },
    snippet = {
      expand = function(args)
        local ctx = context.new()
        vim.api.nvim_buf_set_text(ctx.bufnr, ctx.cursor.row - 1, ctx.cursor.col - 1, ctx.cursor.row - 1, ctx.cursor.col - 1, vim.split(string.gsub(args.body, '%$0', ''), '\n'))
        for i, t in ipairs(vim.split(args.body, '\n')) do
          local s = string.find(t, '$0', 1, true)
          if s then
            if i == 1 then
              vim.api.nvim_win_set_cursor(0, { ctx.cursor.row, ctx.cursor.col + s - 2 })
            else
              vim.api.nvim_win_set_cursor(0, { ctx.cursor.row + i - 1, s - 1 })
            end
            break
          end
        end
      end,
    },
  })
  config.set_cmdline({
    sources = {
      { name = 'spec' },
    },
  }, ':')
end

spec.state = function(text, row, col)
  vim.fn.setline(1, text)
  vim.fn.cursor(row, col)
  local ctx = context.empty()
  local s = source.new('spec', {
    complete = function() end,
  })
  return {
    context = function()
      return ctx
    end,
    source = function()
      return s
    end,
    backspace = function()
      vim.fn.feedkeys('x', 'nx')
      vim.fn.feedkeys('h', 'nx')
      ctx = context.new(ctx, { reason = types.cmp.ContextReason.Auto })
      s:complete(ctx, function() end)
      return ctx
    end,
    input = function(char)
      vim.fn.feedkeys(('i%s'):format(char), 'nx')
      vim.fn.feedkeys(string.rep('l', #char), 'nx')
      ctx.prev_context = nil
      ctx = context.new(ctx, { reason = types.cmp.ContextReason.Auto })
      s:complete(ctx, function() end)
      return ctx
    end,
    manual = function()
      ctx = context.new(ctx, { reason = types.cmp.ContextReason.Manual })
      s:complete(ctx, function() end)
      return ctx
    end,
  }
end

return spec
