local spec = require('cmp.utils.spec')
local feedkeys = require('cmp.utils.feedkeys')
local types = require('cmp.types')
local core = require('cmp.core')
local source = require('cmp.source')
local keymap = require('cmp.utils.keymap')
local api = require('cmp.utils.api')

describe('cmp.core', function()
  describe('confirm', function()
    ---@param request string
    ---@param filter string
    ---@param completion_item lsp.CompletionItem
    ---@param option? { position_encoding_kind: lsp.PositionEncodingKind }
    ---@return table
    local confirm = function(request, filter, completion_item, option)
      option = option or {}

      local c = core.new()
      local s = source.new('spec', {
        get_position_encoding_kind = function()
          return option.position_encoding_kind or types.lsp.PositionEncodingKind.UTF16
        end,
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
        c:confirm(c.sources[s.id].entries[1], {}, function() end)
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

      it('#1552', function()
        local state = confirm(keymap.t('ios.'), '', {
          filterText = 'IsPermission',
          insertTextFormat = 2,
          label = 'IsPermission',
          textEdit = {
            newText = 'IsPermission($0)',
            range = {
              ['end'] = {
                character = 3,
                line = 0,
              },
              start = {
                character = 3,
                line = 0,
              },
            },
          },
        })
        assert.are.same(state.buffer, { 'os.IsPermission()' })
        assert.are.same(state.cursor, { 1, 16 })
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

      local char = '🗿'
      for _, case in ipairs({
        {
          encoding = types.lsp.PositionEncodingKind.UTF8,
          char_size = #char,
        },
        {
          encoding = types.lsp.PositionEncodingKind.UTF16,
          char_size = select(2, vim.str_utfindex(char)),
        },
        {
          encoding = types.lsp.PositionEncodingKind.UTF32,
          char_size = select(1, vim.str_utfindex(char)),
        },
      }) do
        it('textEdit & multibyte: ' .. case.encoding, function()
          local state = confirm(keymap.t('i%s:%s%s:%s<Left><Left><Left>'):format(char, char, char, char), char, {
            label = char .. char .. char,
            textEdit = {
              range = {
                start = {
                  line = 0,
                  character = case.char_size + #':',
                },
                ['end'] = {
                  line = 0,
                  character = case.char_size + #':' + case.char_size + case.char_size,
                },
              },
              newText = char .. char .. char .. char .. char,
            },
          }, {
            position_encoding_kind = case.encoding,
          })
          vim.print({ state = state, case = case })
          assert.are.same(state.buffer, { ('%s:%s%s%s%s%s:%s'):format(char, char, char, char, char, char, char) })
          assert.are.same(state.cursor, { 1, #('%s:%s%s%s%s%s'):format(char, char, char, char, char, char) })
        end)
      end
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
            newText = 'AIUEO',
          },
        })
        assert.are.same(state.buffer, { '***AIUEO***' })
        assert.are.same(state.cursor[2], 6)
      end)
    end)
  end)
end)
