local uv = vim.uv or vim.loop

local M = {}

---@param path string
---@return string buffer
function M.read_file_sync(path)
  -- 292 == 0x444
  local fd = assert(uv.fs_open(path, "r", 292))
  local stat = assert(uv.fs_fstat(fd))
  local buffer = assert(uv.fs_read(fd, stat.size, 0))
  uv.fs_close(fd)
  return buffer
end

---@param list unknown[]
---@return unknown[]
local function deduplicate(list)
  local set = {}
  local new_list = {}
  for _, v in ipairs(list) do
    if not set[v] then
      table.insert(new_list, v)
      set[v] = true
    end
  end
  return new_list
end

---@return string[]
function M.get_dictionaries()
  -- Workaround. vim.opt_global returns now a local value.
  -- https://github.com/neovim/neovim/issues/21506
  ---@type string[]
  local global = vim.split(vim.go.dictionary, ",")
  ---@type string[]
  local local_ = vim.opt_local.dictionary:get()

  local dict = {}
  for _, al in ipairs({ global, local_ }) do
    for _, d in ipairs(al) do
      if vim.fn.filereadable(vim.fn.expand(d)) == 1 then
        table.insert(dict, d)
      end
    end
  end
  dict = deduplicate(dict)
  return dict
end

---@param vector string[]
---@param index integer
---@param key string
---@return boolean
local function ascending_order(vector, index, key)
  return vector[index] >= key
end

---@param vector unknown[]
---@param key string
---@param cb fun(vec: unknown[], idx: integer, key: string): boolean
---@return integer
function M.binary_search(vector, key, cb)
  local left = 0
  local right = #vector
  local isOK = cb or ascending_order

  -- (left, right]
  while right - left > 1 do
    local mid = math.floor((left + right) / 2)
    if isOK(vector, mid, key) then
      right = mid
    else
      left = mid
    end
  end

  return right
end

local timer = {}

local function stop(name)
  if timer[name] then
    timer[name]:stop()
    timer[name]:close()
    timer[name] = nil
  end
end

function M.debounce(name, callback, timeout)
  stop(name)
  timer[name] = uv.new_timer()
  timer[name]:start(
    timeout,
    0,
    vim.schedule_wrap(function()
      stop(name)
      callback()
    end)
  )
end

M.bool_fn = setmetatable({}, {
  __index = function(_, key)
    return function(...)
      local v = vim.fn[key](...)
      if not v or v == 0 or v == "" then
        return false
      elseif type(v) == "table" and next(v) == nil then
        return false
      end
      return true
    end
  end,
})

return M
