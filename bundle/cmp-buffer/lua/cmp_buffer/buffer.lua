local timer = require('cmp_buffer.timer')

local function clear_table(tbl)
  for k in pairs(tbl) do
    tbl[k] = nil
  end
end

---@class cmp_buffer.Buffer
---@field public bufnr number
---@field public opts cmp_buffer.Options
---@field public regex any
---@field public timer cmp_buffer.Timer
---@field public lines_count number
---@field public timer_current_line number
---@field public lines_words table<number, false|string[]>
---@field public unique_words_curr_line table<string, boolean>
---@field public unique_words_other_lines table<string, boolean>
---@field public unique_words_curr_line_dirty boolean
---@field public unique_words_other_lines_dirty boolean
---@field public last_edit_first_line number
---@field public last_edit_last_line number
---@field public closed boolean
---@field public on_close_cb fun()|nil
---@field public words_distances table<string, number>
---@field public words_distances_last_cursor_row number
---@field public words_distances_dirty boolean
local buffer = {}

-- For some reason requesting this much lines multiple times in chunks leads to
-- much better memory usage than fetching the entire file in one go.
buffer.GET_LINES_CHUNK_SIZE = 1000

---Create new buffer object
---@param bufnr number
---@param opts cmp_buffer.Options
---@return cmp_buffer.Buffer
function buffer.new(bufnr, opts)
  local self = setmetatable({}, { __index = buffer })

  self.bufnr = bufnr
  self.timer = timer.new()
  self.closed = false
  self.on_close_cb = nil

  self.opts = opts
  self.regex = vim.regex(self.opts.keyword_pattern)

  self.lines_count = 0
  self.timer_current_line = -1
  self.lines_words = {}

  self.unique_words_curr_line = {}
  self.unique_words_other_lines = {}
  self.unique_words_curr_line_dirty = true
  self.unique_words_other_lines_dirty = true
  self.last_edit_first_line = 0
  self.last_edit_last_line = 0

  self.words_distances = {}
  self.words_distances_dirty = true
  self.words_distances_last_cursor_row = 0

  return self
end

---Close buffer
function buffer.close(self)
  self.closed = true
  self:stop_indexing_timer()
  self.timer:close()
  self.timer = nil

  self.lines_count = 0
  self.timer_current_line = -1
  self.lines_words = {}

  self.unique_words_curr_line = {}
  self.unique_words_other_lines = {}
  self.unique_words_curr_line_dirty = false
  self.unique_words_other_lines_dirty = false
  self.last_edit_first_line = 0
  self.last_edit_last_line = 0

  self.words_distances = {}
  self.words_distances_dirty = false
  self.words_distances_last_cursor_row = 0

  if self.on_close_cb then
    self.on_close_cb()
  end
end

function buffer.stop_indexing_timer(self)
  self.timer:stop()
  self.timer_current_line = -1
end

function buffer.mark_all_lines_dirty(self)
  self.unique_words_curr_line_dirty = true
  self.unique_words_other_lines_dirty = true
  self.last_edit_first_line = 0
  self.last_edit_last_line = 0
  self.words_distances_dirty = true
end

--- Workaround for https://github.com/neovim/neovim/issues/16729
function buffer.safe_buf_call(self, callback)
  if vim.api.nvim_get_current_buf() == self.bufnr then
    callback()
  else
    vim.api.nvim_buf_call(self.bufnr, callback)
  end
end

function buffer.index_range(self, range_start, range_end, skip_already_indexed)
  self:safe_buf_call(function()
    local chunk_size = self.GET_LINES_CHUNK_SIZE
    local chunk_start = range_start
    while chunk_start < range_end do
      local chunk_end = math.min(chunk_start + chunk_size, range_end)
      local chunk_lines = vim.api.nvim_buf_get_lines(self.bufnr, chunk_start, chunk_end, true)
      for i, line in ipairs(chunk_lines) do
        if not skip_already_indexed or not self.lines_words[chunk_start + i] then
          self:index_line(chunk_start + i, line)
        end
      end
      chunk_start = chunk_end
    end
  end)
end

function buffer.start_indexing_timer(self)
  self.lines_count = vim.api.nvim_buf_line_count(self.bufnr)
  self.timer_current_line = 0

  -- Negative values result in an integer overflow in luv (vim.loop), and zero
  -- disables timer repeat, so only intervals larger than 1 are valid.
  local interval = math.max(1, self.opts.indexing_interval)
  self.timer:start(0, interval, function()
    if self.closed then
      self:stop_indexing_timer()
      return
    end

    -- Note that the async indexer is designed to not break even if the user is
    -- editing the file while it is in the process of being indexed. Because
    -- the indexing in watcher must use the synchronous algorithm, we assume
    -- that the data already present in self.lines_words to be correct and
    -- doesn't need refreshing here because even if we do receive text from
    -- nvim_buf_get_lines different from what the watcher has seen so far, it
    -- (the watcher) will catch up on the next on_lines event.

    -- Skip over the already indexed lines
    while self.lines_words[self.timer_current_line + 1] do
      self.timer_current_line = self.timer_current_line + 1
    end

    local batch_start = self.timer_current_line
    local batch_size = self.opts.indexing_batch_size
    -- NOTE: self.lines_count may be modified by the indexer.
    local batch_end = batch_size >= 1 and math.min(batch_start + batch_size, self.lines_count) or self.lines_count
    if batch_end >= self.lines_count then
      self:stop_indexing_timer()
    end
    self.timer_current_line = batch_end
    self:mark_all_lines_dirty()

    self:index_range(batch_start, batch_end, true)
  end)
end

--- watch
function buffer.watch(self)
  self.lines_count = vim.api.nvim_buf_line_count(self.bufnr)

  -- NOTE: As far as I know, indexing in watching can't be done asynchronously
  -- because even built-in commands generate multiple consequent `on_lines`
  -- events, and I'm not even mentioning plugins here. To get accurate results
  -- we would have to either re-index the entire file on throttled events (slow
  -- and looses the benefit of on_lines watching), or put the events in a
  -- queue, which would complicate the plugin a lot. Plus, most changes which
  -- trigger this event will be from regular editing, and so 99% of the time
  -- they will affect only 1-2 lines.
  vim.api.nvim_buf_attach(self.bufnr, false, {
    -- NOTE: line indexes are 0-based and the last line is not inclusive.
    on_lines = function(_, _, _, first_line, old_last_line, new_last_line, _, _, _)
      if self.closed then
        return true
      end

      if old_last_line == new_last_line and first_line == new_last_line then
        -- This condition is really intended as a workaround for
        -- https://github.com/hrsh7th/cmp-buffer/issues/28, but it will also
        -- protect us from completely empty text edits.
        return
      end

      local delta = new_last_line - old_last_line
      local old_lines_count = self.lines_count
      local new_lines_count = old_lines_count + delta
      if new_lines_count == 0 then -- clear
        -- This branch protects against bugs after full-file deletion. If you
        -- do, for example, gdGG, the new_last_line of the event will be zero.
        -- Which is not true, a buffer always contains at least one empty line,
        -- only unloaded buffers contain zero lines.
        new_lines_count = 1
        for i = old_lines_count, 2, -1 do
          self.lines_words[i] = nil
        end
        self.lines_words[1] = {}
      elseif delta > 0 then -- append
        -- Explicitly reserve more slots in the array part of the lines table,
        -- all of them will be filled in the next loop, but in reverse order
        -- (which is why I am concerned about preallocation). Why is there no
        -- built-in function to do this in Lua???
        for i = old_lines_count + 1, new_lines_count do
          self.lines_words[i] = false
        end
        -- Move forwards the unchanged elements in the tail part.
        for i = old_lines_count, old_last_line + 1, -1 do
          self.lines_words[i + delta] = self.lines_words[i]
        end
        -- Fill in new tables for the added lines.
        for i = old_last_line + 1, new_last_line do
          self.lines_words[i] = {}
        end
      elseif delta < 0 then -- remove
        -- Move backwards the unchanged elements in the tail part.
        for i = old_last_line + 1, old_lines_count do
          self.lines_words[i + delta] = self.lines_words[i]
        end
        -- Remove (already copied) tables from the end, in reverse order, so
        -- that we don't make holes in the lines table.
        for i = old_lines_count, new_lines_count + 1, -1 do
          self.lines_words[i] = nil
        end
      end
      self.lines_count = new_lines_count

      -- This branch is support code for handling cases when the user is
      -- editing the buffer while the async indexer is running. It solves the
      -- problem that if new lines are inserted or old lines are deleted, the
      -- indexes of each subsequent line will change, and so the indexer
      -- current position must be adjusted to not accidentally skip any lines.
      if self.timer:is_active() then
        if first_line <= self.timer_current_line and self.timer_current_line < old_last_line then
          -- The indexer was in the area of the current text edit. We will
          -- synchronously index this area it in a moment, so the indexer
          -- should resume from right after the edit range.
          self.timer_current_line = new_last_line
        elseif self.timer_current_line >= old_last_line then
          -- The indexer was somewhere past the current text edit. This means
          -- that the line numbers could have changed, and the indexing
          -- position must be adjusted accordingly.
          self.timer_current_line = self.timer_current_line + delta
        end
      end

      if first_line == self.last_edit_first_line and old_last_line == self.last_edit_last_line and new_last_line == self.last_edit_last_line then
        self.unique_words_curr_line_dirty = true
      else
        self.unique_words_curr_line_dirty = true
        self.unique_words_other_lines_dirty = true
      end
      self.last_edit_first_line = first_line
      self.last_edit_last_line = new_last_line

      self.words_distances_dirty = true

      -- replace lines
      self:index_range(first_line, new_last_line)
    end,

    on_reload = function(_, _)
      if self.closed then
        return true
      end

      clear_table(self.lines_words)

      self:stop_indexing_timer()
      self:start_indexing_timer()
    end,

    on_detach = function(_, _)
      if self.closed then
        return true
      end
      self:close()
    end,
  })
end

---@param linenr number
---@param line string
function buffer.index_line(self, linenr, line)
  local words = self.lines_words[linenr]
  if not words then
    words = {}
    self.lines_words[linenr] = words
  else
    clear_table(words)
  end
  local word_i = 1

  local remaining = line
  -- The if statement checks the number of bytes in the line string, but slices
  -- it on the number of characters. This is not a problem because the number
  -- of characters is always equal to (if only ASCII characters are used) or
  -- smaller than (if multibyte Unicode characters are used) the number of bytes.
  -- In other words, if the line contains more characters than the max limit,
  -- then it will always contain more bytes than the same limit.
  -- This check is here because calling a Vimscript function is relatively slow.
  if #remaining > self.opts.max_indexed_line_length then
    remaining = vim.fn.strcharpart(line, 0, self.opts.max_indexed_line_length)
  end
  while #remaining > 0 do
    -- NOTE: Both start and end indexes here are 0-based (unlike Lua strings),
    -- and the end index is not inclusive.
    local match_start, match_end = self.regex:match_str(remaining)
    if match_start and match_end then
      local word = remaining:sub(match_start + 1, match_end)
      if #word >= self.opts.keyword_length then
        words[word_i] = word
        word_i = word_i + 1
      end
      remaining = remaining:sub(match_end + 1)
    else
      break
    end
  end
end

function buffer.get_words(self)
  -- NOTE: unique_words are rebuilt on-demand because it is common for the
  -- watcher callback to be fired VERY frequently, and a rebuild needs to go
  -- over ALL lines, not just the changed ones.
  if self.unique_words_other_lines_dirty then
    clear_table(self.unique_words_other_lines)
    self:rebuild_unique_words(self.unique_words_other_lines, 0, self.last_edit_first_line)
    self:rebuild_unique_words(self.unique_words_other_lines, self.last_edit_last_line, self.lines_count)
    self.unique_words_other_lines_dirty = false
  end
  if self.unique_words_curr_line_dirty then
    clear_table(self.unique_words_curr_line)
    self:rebuild_unique_words(self.unique_words_curr_line, self.last_edit_first_line, self.last_edit_last_line)
    self.unique_words_curr_line_dirty = false
  end
  return { self.unique_words_other_lines, self.unique_words_curr_line }
end

--- rebuild_unique_words
function buffer.rebuild_unique_words(self, words_table, range_start, range_end)
  for i = range_start + 1, range_end do
    for _, w in ipairs(self.lines_words[i] or {}) do
      words_table[w] = true
    end
  end
end

---@param cursor_row number
---@return table<string, number>
function buffer.get_words_distances(self, cursor_row)
  if self.words_distances_dirty or cursor_row ~= self.words_distances_last_cursor_row then
    local distances = self.words_distances
    clear_table(distances)
    for i = 1, self.lines_count do
      for _, w in ipairs(self.lines_words[i] or {}) do
        local dist = math.abs(cursor_row - i)
        distances[w] = distances[w] and math.min(distances[w], dist) or dist
      end
    end
    self.words_distances_last_cursor_row = cursor_row
    self.words_distances_dirty = false
  end
  return self.words_distances
end

return buffer
