local event = require('cmp.utils.event')
local autocmd = require('cmp.utils.autocmd')
local feedkeys = require('cmp.utils.feedkeys')
local config = require('cmp.config')
local window = require('cmp.utils.window')
local types = require('cmp.types')
local keymap = require('cmp.utils.keymap')
local misc = require('cmp.utils.misc')
local api = require('cmp.utils.api')

---@class cmp.CustomEntriesView
---@field private offset integer
---@field private entries_win cmp.Window
---@field private active boolean
---@field private entries cmp.Entry[]
---@field public event cmp.Event
local wildmenu_entries_view = {}

wildmenu_entries_view.ns = vim.api.nvim_create_namespace('cmp.view.statusline_entries_view')

wildmenu_entries_view.new = function()
  local self = setmetatable({}, { __index = wildmenu_entries_view })
  self.event = event.new()
  self.offset = -1
  self.active = false
  self.entries = {}
  self.offsets = {}
  self.selected_index = 0
  self.entries_win = window.new()

  self.entries_win:option('conceallevel', 2)
  self.entries_win:option('concealcursor', 'n')
  self.entries_win:option('cursorlineopt', 'line')
  self.entries_win:option('foldenable', false)
  self.entries_win:option('wrap', false)
  self.entries_win:option('scrolloff', 0)
  self.entries_win:option('sidescrolloff', 0)
  self.entries_win:option('winhighlight', 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None')
  self.entries_win:buffer_option('tabstop', 1)

  autocmd.subscribe(
    'CompleteChanged',
    vim.schedule_wrap(function()
      if self:visible() and vim.fn.pumvisible() == 1 then
        self:close()
      end
    end)
  )

  vim.api.nvim_set_decoration_provider(wildmenu_entries_view.ns, {
    on_win = function(_, win, buf, _, _)
      if win ~= self.entries_win.win or buf ~= self.entries_win:get_buffer() then
        return
      end

      for i, e in ipairs(self.entries) do
        if e then
          local view = e:get_view(self.offset, buf)
          vim.api.nvim_buf_set_extmark(buf, wildmenu_entries_view.ns, 0, self.offsets[i], {
            end_line = 0,
            end_col = self.offsets[i] + view.abbr.bytes,
            hl_group = view.abbr.hl_group,
            hl_mode = 'combine',
            ephemeral = true,
          })

          if i == self.selected_index then
            vim.api.nvim_buf_set_extmark(buf, wildmenu_entries_view.ns, 0, self.offsets[i], {
              end_line = 0,
              end_col = self.offsets[i] + view.abbr.bytes,
              hl_group = 'PmenuSel',
              hl_mode = 'combine',
              ephemeral = true,
            })
          end

          for _, m in ipairs(e.matches or {}) do
            vim.api.nvim_buf_set_extmark(buf, wildmenu_entries_view.ns, 0, self.offsets[i] + m.word_match_start - 1, {
              end_line = 0,
              end_col = self.offsets[i] + m.word_match_end,
              hl_group = m.fuzzy and 'CmpItemAbbrMatchFuzzy' or 'CmpItemAbbrMatch',
              hl_mode = 'combine',
              ephemeral = true,
            })
          end
        end
      end
    end,
  })
  return self
end

wildmenu_entries_view.close = function(self)
  self.entries_win:close()
end

wildmenu_entries_view.ready = function()
  return vim.fn.pumvisible() == 0
end

wildmenu_entries_view.on_change = function(self)
  self.active = false
end

wildmenu_entries_view.open = function(self, offset, entries)
  self.offset = offset
  self.entries = {}

  -- Apply window options (that might be changed) on the custom completion menu.
  self.entries_win:option('winblend', vim.o.pumblend)

  local dedup = {}
  local preselect = 0
  local i = 1
  for _, e in ipairs(entries) do
    local view = e:get_view(offset, 0)
    if view.dup == 1 or not dedup[e.completion_item.label] then
      dedup[e.completion_item.label] = true
      table.insert(self.entries, e)
      if preselect == 0 and e.completion_item.preselect then
        preselect = i
      end
      i = i + 1
    end
  end

  self.entries_win:open({
    relative = 'editor',
    style = 'minimal',
    row = vim.o.lines - 2,
    col = 0,
    width = vim.o.columns,
    height = 1,
    zindex = 1001,
  })
  self:draw()

  if preselect > 0 and config.get().preselect == types.cmp.PreselectMode.Item then
    self:_select(preselect, { behavior = types.cmp.SelectBehavior.Select })
  elseif not string.match(config.get().completion.completeopt, 'noselect') then
    self:_select(1, { behavior = types.cmp.SelectBehavior.Select })
  else
    self:_select(0, { behavior = types.cmp.SelectBehavior.Select })
  end
end

wildmenu_entries_view.abort = function(self)
  feedkeys.call('', 'n', function()
    self:close()
  end)
end

wildmenu_entries_view.draw = function(self)
  self.offsets = {}

  local entries_buf = self.entries_win:get_buffer()
  local texts = {}
  local offset = 0
  for _, e in ipairs(self.entries) do
    local view = e:get_view(self.offset, entries_buf)
    table.insert(self.offsets, offset)
    table.insert(texts, view.abbr.text)
    offset = offset + view.abbr.bytes + #self:_get_separator()
  end

  vim.api.nvim_buf_set_lines(entries_buf, 0, 1, false, { table.concat(texts, self:_get_separator()) })
  vim.api.nvim_buf_set_option(entries_buf, 'modified', false)

  vim.api.nvim_win_call(0, function()
    misc.redraw()
  end)
end

wildmenu_entries_view.visible = function(self)
  return self.entries_win:visible()
end

wildmenu_entries_view.info = function(self)
  return self.entries_win:info()
end

wildmenu_entries_view.select_next_item = function(self, option)
  if self:visible() then
    local cursor
    if self.selected_index == 0 or self.selected_index == #self.entries then
      cursor = option.count
    else
      cursor = self.selected_index + option.count
    end
    cursor = math.max(math.min(cursor, #self.entries), 0)
    self:_select(cursor, option)
  end
end

wildmenu_entries_view.select_prev_item = function(self, option)
  if self:visible() then
    if self.selected_index == 0 or self.selected_index <= 1 then
      self:_select(#self.entries, option)
    else
      self:_select(math.max(self.selected_index - option.count, 0), option)
    end
  end
end

wildmenu_entries_view.get_offset = function(self)
  if self:visible() then
    return self.offset
  end
  return nil
end

wildmenu_entries_view.get_entries = function(self)
  if self:visible() then
    return self.entries
  end
  return {}
end

wildmenu_entries_view.get_first_entry = function(self)
  if self:visible() then
    return self.entries[1]
  end
end

wildmenu_entries_view.get_selected_entry = function(self)
  if self:visible() and self.active then
    return self.entries[self.selected_index]
  end
end

wildmenu_entries_view.get_active_entry = function(self)
  if self:visible() and self.active then
    return self:get_selected_entry()
  end
end

wildmenu_entries_view._select = function(self, selected_index, option)
  local is_next = self.selected_index < selected_index
  self.selected_index = selected_index
  self.active = (selected_index ~= 0)

  if self.active then
    local e = self:get_active_entry()
    if option.behavior == types.cmp.SelectBehavior.Insert then
      local cursor = api.get_cursor()
      local word = e:get_vim_item(self.offset).word
      vim.api.nvim_feedkeys(keymap.backspace(string.sub(api.get_current_line(), self.offset, cursor[2])) .. word, 'int', true)
    end
    vim.api.nvim_win_call(self.entries_win.win, function()
      local view = e:get_view(self.offset, self.entries_win:get_buffer())
      vim.api.nvim_win_set_cursor(0, { 1, self.offsets[selected_index] + (is_next and view.abbr.bytes or 0) })
      vim.cmd([[redraw!]]) -- Force refresh for vim.api.nvim_set_decoration_provider
    end)
  end

  self.event:emit('change')
end

wildmenu_entries_view._get_separator = function()
  local c = config.get()
  return (c and c.view and c.view.entries and c.view.entries.separator) or '  '
end

return wildmenu_entries_view
