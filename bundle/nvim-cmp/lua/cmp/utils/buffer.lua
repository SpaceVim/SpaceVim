local buffer = {}

buffer.cache = {}

---@return integer buf
buffer.get = function(name)
  local buf = buffer.cache[name]
  if buf and vim.api.nvim_buf_is_valid(buf) then
    return buf
  else
    return nil
  end
end

---@return integer buf
---@return boolean created_new
buffer.ensure = function(name)
  local created_new = false
  local buf = buffer.get(name)
  if not buf then
    created_new = true
    buf = vim.api.nvim_create_buf(false, true)
    buffer.cache[name] = buf
  end
  return buf, created_new
end

return buffer
