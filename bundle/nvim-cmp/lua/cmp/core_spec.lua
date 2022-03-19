local spec = require('cmp.utils.spec')
local feedkeys = require('cmp.utils.feedkeys')
local types = require('cmp.types')
local core = require('cmp.core')
local source = require('cmp.source')
local keymap = require('cmp.utils.keymap')
local api = require('cmp.utils.api')

describe('cmp.core', function()
  describe('confirm', function()
    local confirm = function(request, filter, completion_item)
      local c = core.new()
      local s = source.new('spec', {
        complete = function(_, _, callback)
          callback({ completion_item })
        end,
      })
      c:register_source(s)
      feedkeys.call(request, 'n', function()
        c:complete(c:get_context({ reason = types.cmp.ContextReason.Manual }))
        vim.wait(5000, function()
          return #c.sources[s.id].entries > 0
        end)
      end)
      feedkeys.call(filter, 'n', function()
        c:confirm(c.sources[s.id].entries[1], {})
      end)
      local state = {}
      feedkeys.call('', 'x', function()
        feedkeys.call('', 'n', function()
          if api.is_cmdline_mode() then
            state.buffer = { api.get_current_line() }
          else
            state.buffer = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          end
          state.cursor = api.get_cursor()
        end)
      end)
      return state
    end

    describe('insert-mode', function()
      before_each(spec.before)

      it('label', function()
        local state = confirm('iA', 'IU', {
          label = 'AIUEO',
        })
        assert.are.same(state.buffer, { 'AIUEO' })
        assert.are.same(state.cursor, { 1, 5 })
      end)

      it('insertText', function()
        local state = confirm('iA', 'IU', {
          label = 'AIUEO',
          insertText = '_AIUEO_',
        })
        assert.are.same(state.buffer, { '_AIUEO_' })
        assert.are.same(state.cursor, { 1, 7 })
      end)

      it('textEdit', function()
        local state = confirm(keymap.t('i***AEO***<Left><Left><Left><Left><Left>'), 'IU', {
          label = 'AIUEO',
          textEdit = {
            range = {
              start = {
                line = 0,
                character = 3,
              },
              ['end'] = {
                line = 0,
                character = 6,
              },
            },
            newText = 'foo\nbar\nbaz',
          },
        })
        assert.are.same(state.buffer, { '***foo', 'bar', 'baz***' })
        assert.are.same(state.cursor, { 3, 3 })
      end)

      it('insertText & snippet', function()
        local state = confirm('iA', 'IU', {
          label = 'AIUEO',
          insertText = 'AIUEO($0)',
          insertTextFormat = types.lsp.InsertTextFormat.Snippet,
        })
        assert.are.same(state.buffer, { 'AIUEO()' })
        assert.are.same(state.cursor, { 1, 6 })
      end)

      it('textEdit & snippet', function()
        local state = confirm(keymap.t('i***AEO***<Left><Left><Left><Left><Left>'), 'IU', {
          label = 'AIUEO',
          insertTextFormat = types.lsp.InsertTextFormat.Snippet,
          textEdit = {
            range = {
              start = {
                line = 0,
                character = 3,
              },
              ['end'] = {
                line = 0,
                character = 6,
              },
            },
            newText = 'foo\nba$0r\nbaz',
          },
        })
        assert.are.same(state.buffer, { '***foo', 'bar', 'baz***' })
        assert.are.same(state.cursor, { 2, 2 })
      end)
    end)

    describe('cmdline-mode', function()
      before_each(spec.before)

      it('label', function()
        local state = confirm(':A', 'IU', {
          label = 'AIUEO',
        })
        assert.are.same(state.buffer, { 'AIUEO' })
        assert.are.same(state.cursor[2], 5)
      end)

      it('insertText', function()
        local state = confirm(':A', 'IU', {
          label = 'AIUEO',
          insertText = '_AIUEO_',
        })
        assert.are.same(state.buffer, { '_AIUEO_' })
        assert.are.same(state.cursor[2], 7)
      end)

      it('textEdit', function()
        local state = confirm(keymap.t(':***AEO***<Left><Left><Left><Left><Left>'), 'IU', {
          label = 'AIUEO',
          textEdit = {
            range = {
              start = {
                line = 0,
                character = 3,
              },
              ['end'] = {
                line = 0,
                character = 6,
              },
            },
            newText = 'foobarbaz',
          },
        })
        assert.are.same(state.buffer, { '***foobarbaz***' })
        assert.are.same(state.cursor[2], 12)
      end)
    end)
  end)
end)
