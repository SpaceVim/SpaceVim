local buffer = require('cmp_buffer.buffer')

local defaults = {
  keyword_length = 3,
  keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-]\w*\)*\)]],
  get_bufnrs = function()
    return { vim.api.nvim_get_current_buf() }
  end,
}

local source = {}

source.new = function()
  local self = setmetatable({}, { __index = source })
  self.buffers = {}
  return self
end

source.get_keyword_pattern = function(_, params)
  params.option = vim.tbl_deep_extend('keep', params.option, defaults)
  vim.validate({
    keyword_length = { params.option.keyword_length, 'number', '`opts.keyword_length` must be `number`' },
    keyword_pattern = { params.option.keyword_pattern, 'string', '`opts.keyword_pattern` must be `string`' },
    get_bufnrs = { params.option.get_bufnrs, 'function', '`opts.get_bufnrs` must be `function`' },
  })
  return params.option.keyword_pattern
end

source.complete = function(self, params, callback)
  params.option = vim.tbl_deep_extend('keep', params.option, defaults)
  vim.validate({
    keyword_pattern = { params.option.keyword_pattern, 'string', '`opts.keyword_pattern` must be `string`' },
    get_bufnrs = { params.option.get_bufnrs, 'function', '`opts.get_bufnrs` must be `function`' },
  })

  local processing = false
  local bufs = self:_get_buffers(params)
  for _, buf in ipairs(bufs) do
    if buf.timer then
      processing = true
      break
    end
  end

  vim.defer_fn(function()
    local input = string.sub(params.context.cursor_before_line, params.offset)
    local items = {}
    local words = {}
    for _, buf in ipairs(bufs) do
      for _, word in ipairs(buf:get_words()) do
        if not words[word] and input ~= word then
          words[word] = true
          table.insert(items, {
            label = word,
            dup = 0,
          })
        end
      end
    end

    callback({
      items = items,
      isIncomplete = processing,
    })
  end, processing and 100 or 0)
end

--- _get_bufs
source._get_buffers = function(self, params)
  local buffers = {}
  for _, bufnr in ipairs(params.option.get_bufnrs()) do
    if not self.buffers[bufnr] then
      local new_buf = buffer.new(
        bufnr,
        params.option.keyword_length,
        params.option.keyword_pattern
      )
      new_buf.on_close_cb = function()
        self.buffers[bufnr] = nil
      end
      new_buf:index()
      new_buf:watch()
      self.buffers[bufnr] = new_buf
    end
    table.insert(buffers, self.buffers[bufnr])
  end

  return buffers
end

return source
