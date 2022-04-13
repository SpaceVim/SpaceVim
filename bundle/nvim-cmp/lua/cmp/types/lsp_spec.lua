local spec = require('cmp.utils.spec')
local lsp = require('cmp.types.lsp')

describe('types.lsp', function()
  before_each(spec.before)
  describe('Position', function()
    vim.fn.setline('1', {
      'あいうえお',
      'かきくけこ',
      'さしすせそ',
    })
    local vim_position, lsp_position

    local bufnr = vim.api.nvim_get_current_buf()
    vim_position = lsp.Position.to_vim(bufnr, { line = 1, character = 3 })
    assert.are.equal(vim_position.row, 2)
    assert.are.equal(vim_position.col, 10)
    lsp_position = lsp.Position.to_lsp(bufnr, vim_position)
    assert.are.equal(lsp_position.line, 1)
    assert.are.equal(lsp_position.character, 3)

    vim_position = lsp.Position.to_vim(bufnr, { line = 1, character = 0 })
    assert.are.equal(vim_position.row, 2)
    assert.are.equal(vim_position.col, 1)
    lsp_position = lsp.Position.to_lsp(bufnr, vim_position)
    assert.are.equal(lsp_position.line, 1)
    assert.are.equal(lsp_position.character, 0)

    vim_position = lsp.Position.to_vim(bufnr, { line = 1, character = 5 })
    assert.are.equal(vim_position.row, 2)
    assert.are.equal(vim_position.col, 16)
    lsp_position = lsp.Position.to_lsp(bufnr, vim_position)
    assert.are.equal(lsp_position.line, 1)
    assert.are.equal(lsp_position.character, 5)

    -- overflow (lsp -> vim)
    vim_position = lsp.Position.to_vim(bufnr, { line = 1, character = 6 })
    assert.are.equal(vim_position.row, 2)
    assert.are.equal(vim_position.col, 16)

    -- overflow(vim -> lsp)
    vim_position.col = vim_position.col + 1
    lsp_position = lsp.Position.to_lsp(bufnr, vim_position)
    assert.are.equal(lsp_position.line, 1)
    assert.are.equal(lsp_position.character, 5)
  end)
end)
