local config = require('cmp.config')
local misc = require('cmp.utils.misc')
local str = require('cmp.utils.str')
local api = require('cmp.utils.api')

---@class cmp.GhostTextView
local ghost_text_view = {}

ghost_text_view.ns = vim.api.nvim_create_namespace('cmp:GHOST_TEXT')

local has_inline = (function()
  return (pcall(function()
    local id = vim.api.nvim_buf_set_extmark(0, ghost_text_view.ns, 0, 0, {
      virt_text = { { ' ', 'Comment' } },
      virt_text_pos = 'inline',
      hl_mode = 'combine',
      ephemeral = false,
    })
    vim.api.nvim_buf_del_extmark(0, ghost_text_view.ns, id)
  end))
end)()

ghost_text_view.new = function()
  local self = setmetatable({}, { __index = ghost_text_view })
  self.win = nil
  self.entry = nil
  self.extmark_id = nil
  vim.api.nvim_set_decoration_provider(ghost_text_view.ns, {
    on_win = function(_, win)
      if self.extmark_id then
        vim.api.nvim_buf_del_extmark(0, ghost_text_view.ns, self.extmark_id)
      end

      if win ~= self.win then
        return false
      end

      local c = config.get().experimental.ghost_text
      if not c then
        return
      end

      if not self.entry then
        return
      end

      local row, col = unpack(vim.api.nvim_win_get_cursor(0))

      local line = vim.api.nvim_get_current_line()
      if not has_inline then
        if string.sub(line, col + 1) ~= '' then
          return
        end
      end

      local text = self.text_gen(self, line, col)
      if #text > 0 then
        self.extmark_id = vim.api.nvim_buf_set_extmark(0, ghost_text_view.ns, row - 1, col, {
          right_gravity = true,
          virt_text = { { text, type(c) == 'table' and c.hl_group or 'Comment' } },
          virt_text_pos = has_inline and 'inline' or 'overlay',
          hl_mode = 'combine',
          ephemeral = false,
        })
      end
    end,
  })
  return self
end

---Generate the ghost text
---  This function calculates the bytes of the entry to display calculating the number
---  of character differences instead of just byte difference.
ghost_text_view.text_gen = function(self, line, cursor_col)
  local word = self.entry:get_insert_text()
  word = str.oneline(word)
  local word_clen = vim.str_utfindex(word)
  local cword = string.sub(line, self.entry:get_offset(), cursor_col)
  local cword_clen = vim.str_utfindex(cword)
  -- Number of characters from entry text (word) to be displayed as ghost thext
  local nchars = word_clen - cword_clen
  -- Missing characters to complete the entry text
  local text
  if nchars > 0 then
    text = string.sub(word, vim.str_byteindex(word, word_clen - nchars) + 1)
  else
    text = ''
  end
  return text
end

---Show ghost text
---@param e cmp.Entry
ghost_text_view.show = function(self, e)
  if not api.is_insert_mode() then
    return
  end
  local c = config.get().experimental.ghost_text
  if not c then
    return
  end
  local changed = e ~= self.entry
  self.win = vim.api.nvim_get_current_win()
  self.entry = e
  if changed then
    misc.redraw(true) -- force invoke decoration provider.
  end
end

ghost_text_view.hide = function(self)
  if self.win and self.entry then
    self.win = nil
    self.entry = nil
    misc.redraw(true) -- force invoke decoration provider.
  end
end

return ghost_text_view
