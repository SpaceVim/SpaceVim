local spec = require('cmp.utils.spec')

local context = require('cmp.context')

describe('context', function()
  before_each(spec.before)

  describe('new', function()
    it('middle of text', function()
      vim.fn.setline('1', 'function! s:name() abort')
      vim.bo.filetype = 'vim'
      vim.fn.execute('normal! fm')
      local ctx = context.new()
      assert.are.equal(ctx.filetype, 'vim')
      assert.are.equal(ctx.cursor.row, 1)
      assert.are.equal(ctx.cursor.col, 15)
      assert.are.equal(ctx.cursor_line, 'function! s:name() abort')
    end)

    it('tab indent', function()
      vim.fn.setline('1', '\t\tab')
      vim.bo.filetype = 'vim'
      vim.fn.execute('normal! fb')
      local ctx = context.new()
      assert.are.equal(ctx.filetype, 'vim')
      assert.are.equal(ctx.cursor.row, 1)
      assert.are.equal(ctx.cursor.col, 4)
      assert.are.equal(ctx.cursor_line, '\t\tab')
    end)
  end)
end)
