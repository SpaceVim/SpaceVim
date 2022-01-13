local config = require('cmp.config')
local spec = require('cmp.utils.spec')

local source = require('cmp.source')

describe('source', function()
  before_each(spec.before)

  describe('keyword length', function()
    it('not enough', function()
      config.set_buffer({
        completion = {
          keyword_length = 3,
        },
      }, vim.api.nvim_get_current_buf())

      local state = spec.state('', 1, 1)
      local s = source.new('spec', {
        complete = function(_, _, callback)
          callback({ { label = 'spec' } })
        end,
      })
      assert.is.truthy(not s:complete(state.input('a'), function() end))
    end)

    it('enough', function()
      config.set_buffer({
        completion = {
          keyword_length = 3,
        },
      }, vim.api.nvim_get_current_buf())

      local state = spec.state('', 1, 1)
      local s = source.new('spec', {
        complete = function(_, _, callback)
          callback({ { label = 'spec' } })
        end,
      })
      assert.is.truthy(s:complete(state.input('aiu'), function() end))
    end)

    it('enough -> not enough', function()
      config.set_buffer({
        completion = {
          keyword_length = 3,
        },
      }, vim.api.nvim_get_current_buf())

      local state = spec.state('', 1, 1)
      local s = source.new('spec', {
        complete = function(_, _, callback)
          callback({ { label = 'spec' } })
        end,
      })
      assert.is.truthy(s:complete(state.input('aiu'), function() end))
      assert.is.truthy(not s:complete(state.backspace(), function() end))
    end)

    it('continue', function()
      config.set_buffer({
        completion = {
          keyword_length = 3,
        },
      }, vim.api.nvim_get_current_buf())

      local state = spec.state('', 1, 1)
      local s = source.new('spec', {
        complete = function(_, _, callback)
          callback({ { label = 'spec' } })
        end,
      })
      assert.is.truthy(s:complete(state.input('aiu'), function() end))
      assert.is.truthy(not s:complete(state.input('eo'), function() end))
    end)
  end)

  describe('isIncomplete', function()
    it('isIncomplete=true', function()
      local state = spec.state('', 1, 1)
      local s = source.new('spec', {
        complete = function(_, _, callback)
          callback({
            items = { { label = 'spec' } },
            isIncomplete = true,
          })
        end,
      })
      vim.wait(100, function()
        return s.status == source.SourceStatus.COMPLETED
      end, 100, false)
      assert.is.truthy(s:complete(state.input('s'), function() end))
      vim.wait(100, function()
        return s.status == source.SourceStatus.COMPLETED
      end, 100, false)
      assert.is.truthy(s:complete(state.input('p'), function() end))
      vim.wait(100, function()
        return s.status == source.SourceStatus.COMPLETED
      end, 100, false)
      assert.is.truthy(s:complete(state.input('e'), function() end))
      vim.wait(100, function()
        return s.status == source.SourceStatus.COMPLETED
      end, 100, false)
      assert.is.truthy(s:complete(state.input('c'), function() end))
      vim.wait(100, function()
        return s.status == source.SourceStatus.COMPLETED
      end, 100, false)
    end)
  end)
end)
