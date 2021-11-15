local buffer = {}

buffer.ensure = setmetatable({
  cache = {},
}, {
  __call = function(self, name)
    if not (self.cache[name] and vim.api.nvim_buf_is_valid(self.cache[name])) then
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
      vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
      self.cache[name] = buf
    end
    return self.cache[name]
  end,
})

return buffer
