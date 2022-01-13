local spec = require('cmp.utils.spec')

local keymap = require('cmp.utils.keymap')

describe('keymap', function()
  before_each(spec.before)

  it('to_keymap', function()
    assert.are.equal(keymap.to_keymap('\n'), '<CR>')
    assert.are.equal(keymap.to_keymap('<CR>'), '<CR>')
    assert.are.equal(keymap.to_keymap('|'), '<Bar>')
  end)

  describe('evacuate', function()
    before_each(spec.before)

    it('expr & register', function()
      vim.api.nvim_buf_set_keymap(0, 'i', '(', [['<C-r>="("<CR>']], {
        expr = true,
        noremap = false,
      })
      local fallback = keymap.evacuate(0, 'i', '(')
      vim.api.nvim_feedkeys('i' .. keymap.t(fallback.keys), fallback.mode .. 'x', true)
      assert.are.same({ '(' }, vim.api.nvim_buf_get_lines(0, 0, -1, true))
    end)

    it('recursive & <Plug> (tpope/vim-endwise)', function()
      vim.api.nvim_buf_set_keymap(0, 'i', '<Plug>(paren-close)', [[)<Left>]], {
        expr = false,
        noremap = true,
      })
      vim.api.nvim_buf_set_keymap(0, 'i', '(', [[(<Plug>(paren-close)]], {
        expr = false,
        noremap = false,
      })
      local fallback = keymap.evacuate(0, 'i', '(')
      vim.api.nvim_feedkeys('i' .. keymap.t(fallback.keys), fallback.mode .. 'x', true)
      assert.are.same({ '()' }, vim.api.nvim_buf_get_lines(0, 0, -1, true))
    end)

    describe('expr & recursive', function()
      before_each(spec.before)

      it('true', function()
        vim.api.nvim_buf_set_keymap(0, 'i', '<Tab>', [[v:true ? '<C-r>="foobar"<CR>' : '<Tab>aiueo']], {
          expr = true,
          noremap = false,
        })
        local fallback = keymap.evacuate(0, 'i', '<Tab>')
        vim.api.nvim_feedkeys('i' .. keymap.t(fallback.keys), fallback.mode .. 'x', true)
        assert.are.same({ 'foobar' }, vim.api.nvim_buf_get_lines(0, 0, -1, true))
      end)
      it('false', function()
        vim.api.nvim_buf_set_keymap(0, 'i', '<Tab>', [[v:false ? '<C-r>="foobar"<CR>' : '<Tab>aiueo']], {
          expr = true,
          noremap = false,
        })
        local fallback = keymap.evacuate(0, 'i', '<Tab>')
        vim.api.nvim_feedkeys('i' .. keymap.t(fallback.keys), fallback.mode .. 'x', true)
        assert.are.same({ '\taiueo' }, vim.api.nvim_buf_get_lines(0, 0, -1, true))
      end)
    end)
  end)
  describe('realworld', function()
    before_each(spec.before)
    it('#226', function()
      keymap.listen('i', '<c-n>', function(_, fallback)
        fallback()
      end)
      vim.api.nvim_feedkeys(keymap.t('iaiueo<CR>a<C-n><C-n>'), 'tx', true)
      assert.are.same({ 'aiueo', 'aiueo' }, vim.api.nvim_buf_get_lines(0, 0, -1, true))
    end)
    it('#414', function()
      keymap.listen('i', '<M-j>', function()
        vim.api.nvim_feedkeys(keymap.t('<C-n>'), 'int', true)
      end)
      vim.api.nvim_feedkeys(keymap.t('iaiueo<CR>a<M-j><M-j>'), 'tx', true)
      assert.are.same({ 'aiueo', 'aiueo' }, vim.api.nvim_buf_get_lines(0, 0, -1, true))
    end)
  end)
end)
