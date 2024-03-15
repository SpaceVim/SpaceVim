local buffer = require('cmp_buffer.buffer')

---@class cmp_buffer.Options
---@field public keyword_length number
---@field public keyword_pattern string
---@field public get_bufnrs fun(): number[]
---@field public indexing_batch_size number
---@field public indexing_interval number
---@field public max_indexed_line_length number

---@type cmp_buffer.Options
local defaults = {
  keyword_length = 3,
  keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\%(\w\|á\|Á\|é\|É\|í\|Í\|ó\|Ó\|ú\|Ú\)*\%(-\%(\w\|á\|Á\|é\|É\|í\|Í\|ó\|Ó\|ú\|Ú\)*\)*\)]],
  get_bufnrs = function()
    return { vim.api.nvim_get_current_buf() }
  end,
  indexing_batch_size = 1000,
  indexing_interval = 100,
  max_indexed_line_length = 1024 * 40,
}

local source = {}

source.new = function()
  local self = setmetatable({}, { __index = source })
  self.buffers = {}
  return self
end

---@return cmp_buffer.Options
source._validate_options = function(_, params)
  local opts = vim.tbl_deep_extend('keep', params.option, defaults)
  vim.validate({
    keyword_length = { opts.keyword_length, 'number' },
    keyword_pattern = { opts.keyword_pattern, 'string' },
    get_bufnrs = { opts.get_bufnrs, 'function' },
    indexing_batch_size = { opts.indexing_batch_size, 'number' },
    indexing_interval = { opts.indexing_interval, 'number' },
  })
  return opts
end

source.get_keyword_pattern = function(self, params)
  local opts = self:_validate_options(params)
  return opts.keyword_pattern
end

source.complete = function(self, params, callback)
  local opts = self:_validate_options(params)

  local processing = false
  local bufs = self:_get_buffers(opts)
  for _, buf in ipairs(bufs) do
    if buf.timer:is_active() then
      processing = true
      break
    end
  end

  vim.defer_fn(function()
    local input = string.sub(params.context.cursor_before_line, params.offset)
    local items = {}
    local words = {}
    for _, buf in ipairs(bufs) do
      for _, word_list in ipairs(buf:get_words()) do
        for word, _ in pairs(word_list) do
          if not words[word] and input ~= word then
            words[word] = true
            table.insert(items, {
              label = word,
              dup = 0,
            })
          end
        end
      end
    end

    callback({
      items = items,
      isIncomplete = processing,
    })
  end, processing and 100 or 0)
end

---@param opts cmp_buffer.Options
---@return cmp_buffer.Buffer[]
source._get_buffers = function(self, opts)
  local buffers = {}
  for _, bufnr in ipairs(opts.get_bufnrs()) do
    if not self.buffers[bufnr] then
      local new_buf = buffer.new(bufnr, opts)
      new_buf.on_close_cb = function()
        self.buffers[bufnr] = nil
      end
      new_buf:start_indexing_timer()
      new_buf:watch()
      self.buffers[bufnr] = new_buf
    end
    table.insert(buffers, self.buffers[bufnr])
  end

  return buffers
end

source._get_distance_from_entry = function(self, entry)
  local buf = self.buffers[entry.context.bufnr]
  if buf then
    local distances = buf:get_words_distances(entry.context.cursor.line + 1)
    return distances[entry.completion_item.filterText] or distances[entry.completion_item.label]
  end
end

source.compare_locality = function(self, entry1, entry2)
  if entry1.context ~= entry2.context then
    return
  end
  local dist1 = self:_get_distance_from_entry(entry1) or math.huge
  local dist2 = self:_get_distance_from_entry(entry2) or math.huge
  if dist1 ~= dist2 then
    return dist1 < dist2
  end
end

return source
