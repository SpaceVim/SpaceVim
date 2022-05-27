---@class cmp_buffer.Buffer
---@field public bufnr number
---@field public regex any
---@field public length number
---@field public pattern string
---@field public indexing_chunk_size number
---@field public indexing_interval number
---@field public timer any|nil
---@field public lines_count number
---@field public lines_words table<number, string[]>
---@field public closed boolean
---@field public on_close_cb fun()|nil
local buffer = {}

---Create new buffer object
---@param bufnr number
---@param length number
---@param pattern string
---@return cmp_buffer.Buffer
function buffer.new(bufnr, length, pattern)
  local self = setmetatable({}, { __index = buffer })
  self.bufnr = bufnr
  self.regex = vim.regex(pattern)
  self.length = length
  self.pattern = pattern
  self.indexing_chunk_size = 1000
  self.indexing_interval = 200
  self.timer = nil
  self.lines_count = 0
  self.lines_words = {}
  self.closed = false
  self.on_close_cb = nil
  return self
end

---Close buffer
function buffer.close(self)
  self.closed = true
  self:stop_indexing_timer()
  self.lines_count = 0
  self.lines_words = {}
  if self.on_close_cb then
    self.on_close_cb()
  end
end

function buffer.stop_indexing_timer(self)
  if self.timer and not self.timer:is_closing() then
    self.timer:stop()
    self.timer:close()
  end
  self.timer = nil
end

---Indexing buffer
function buffer.index(self)
  self.lines_count = vim.api.nvim_buf_line_count(self.bufnr)
  for i = 1, self.lines_count do
    self.lines_words[i] = {}
  end

  self:index_range_async(0, self.lines_count)
end

function buffer.index_range(self, range_start, range_end)
  vim.api.nvim_buf_call(self.bufnr, function()
    local lines = vim.api.nvim_buf_get_lines(self.bufnr, range_start, range_end, true)
    for i, line in ipairs(lines) do
      self:index_line(range_start + i, line)
    end
  end)
end

function buffer.index_range_async(self, range_start, range_end)
  local chunk_start = range_start

  local lines = vim.api.nvim_buf_get_lines(self.bufnr, range_start, range_end, true)

  self.timer = vim.loop.new_timer()
  self.timer:start(
    0,
    self.indexing_interval,
    vim.schedule_wrap(function()
      if self.closed then
        return
      end

      local chunk_end = math.min(chunk_start + self.indexing_chunk_size, range_end)
      vim.api.nvim_buf_call(self.bufnr, function()
        for linenr = chunk_start + 1, chunk_end do
          self:index_line(linenr, lines[linenr])
        end
      end)
      chunk_start = chunk_end

      if chunk_end >= range_end then
        self:stop_indexing_timer()
      end
    end)
  )
end

--- watch
function buffer.watch(self)
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
          self.lines_words[i] = vim.NIL
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

      -- replace lines
      self:index_range(first_line, new_last_line)
    end,

    on_reload = function(_, _)
      if self.closed then
        return true
      end

      -- The logic for adjusting lines list on buffer reloads is much simpler
      -- because tables of all lines can be assumed to be fresh.
      local new_lines_count = vim.api.nvim_buf_line_count(self.bufnr)
      if new_lines_count > self.lines_count then -- append
        for i = self.lines_count + 1, new_lines_count do
          self.lines_words[i] = {}
        end
      elseif new_lines_count < self.lines_count then -- remove
        for i = self.lines_count, new_lines_count + 1, -1 do
          self.lines_words[i] = nil
        end
      end
      self.lines_count = new_lines_count

      self:index_range(0, self.lines_count)
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
  for k, _ in ipairs(words) do
    words[k] = nil
  end
  local word_i = 1

  local remaining = line
  while #remaining > 0 do
    -- NOTE: Both start and end indexes here are 0-based (unlike Lua strings),
    -- and the end index is not inclusive.
    local match_start, match_end = self.regex:match_str(remaining)
    if match_start and match_end then
      local word = remaining:sub(match_start + 1, match_end)
      if #word >= self.length then
        words[word_i] = word
        word_i = word_i + 1
      end
      remaining = remaining:sub(match_end + 1)
    else
      break
    end
  end
end

--- get_words
function buffer.get_words(self)
  local words = {}
  for _, line in ipairs(self.lines_words) do
    for _, w in ipairs(line) do
      table.insert(words, w)
    end
  end
  return words
end

return buffer
