local conf = require("telescope.config").values
local Path = require "plenary.path"
local utils = require "telescope.utils"

local uv = vim.loop

---@tag telescope.actions.history
---@config { ["module"] = "telescope.actions.history" }

---@brief [[
--- A base implementation of a prompt history that provides a simple history
--- and can be replaced with a custom implementation.
---
--- For example: We provide a extension for a smart history that uses sql.nvim
--- to map histories to metadata, like the calling picker or cwd.
---
--- So you have a history for:
--- - find_files  project_1
--- - grep_string project_1
--- - live_grep   project_1
--- - find_files  project_2
--- - grep_string project_2
--- - live_grep   project_2
--- - etc
---
--- See https://github.com/nvim-telescope/telescope-smart-history.nvim
---@brief ]]

-- TODO(conni2461): currently not present in plenary path only sync.
-- But sync is just unnecessary here
local write_async = function(path, txt, flag)
  uv.fs_open(path, flag, 438, function(open_err, fd)
    assert(not open_err, open_err)
    uv.fs_write(fd, txt, -1, function(write_err)
      assert(not write_err, write_err)
      uv.fs_close(fd, function(close_err)
        assert(not close_err, close_err)
      end)
    end)
  end)
end

local append_async = function(path, txt)
  write_async(path, txt, "a")
end

local histories = {}

--- Manages prompt history
---@class History @Manages prompt history
---@field enabled boolean: Will indicate if History is enabled or disabled
---@field path string: Will point to the location of the history file
---@field limit string: Will have the limit of the history. Can be nil, if limit is disabled.
---@field content table: History table. Needs to be filled by your own History implementation
---@field index number: Used to keep track of the next or previous index. Default is #content + 1
histories.History = {}
histories.History.__index = histories.History

--- Create a new History
---@param opts table: Defines the behavior of History
---@field init function: Will be called after handling configuration (required)
---@field append function: How to append a new prompt item (required)
---@field reset function: What happens on reset. Will be called when telescope closes (required)
---@field pre_get function: Will be called before a next or previous item will be returned (optional)
function histories.History:new(opts)
  local obj = {}
  if conf.history == false or type(conf.history) ~= "table" then
    obj.enabled = false
    return setmetatable(obj, self)
  end
  obj.enabled = true
  if conf.history.limit then
    obj.limit = conf.history.limit
  end
  obj.path = vim.fn.expand(conf.history.path)
  obj.content = {}
  obj.index = 1

  opts.init(obj)
  obj._reset = opts.reset
  obj._append = opts.append
  obj._pre_get = opts.pre_get

  return setmetatable(obj, self)
end

--- Shorthand to create a new history
function histories.new(...)
  return histories.History:new(...)
end

--- Will reset the history index to the default initial state. Will happen after the picker closed
function histories.History:reset()
  if not self.enabled then
    return
  end
  self._reset(self)
end

--- Append a new line to the history
---@param line string: current line that will be appended
---@param picker table: the current picker object
---@param no_reset boolean: On default it will reset the state at the end. If you don't want to do this set to true
function histories.History:append(line, picker, no_reset)
  if not self.enabled then
    return
  end
  self._append(self, line, picker, no_reset)
end

--- Will return the next history item. Can be nil if there are no next items
---@param line string: the current line
---@param picker table: the current picker object
---@return string: the next history item
function histories.History:get_next(line, picker)
  if not self.enabled then
    utils.notify("History:get_next", {
      msg = "You are cycling to next the history item but history is disabled. Read ':help telescope.defaults.history'",
      level = "WARN",
    })
    return false
  end
  if self._pre_get then
    self._pre_get(self, line, picker)
  end

  local next_idx = self.index + 1
  if next_idx <= #self.content then
    self.index = next_idx
    return self.content[next_idx]
  end
  self.index = #self.content + 1
  return nil
end

--- Will return the previous history item. Can be nil if there are no previous items
---@param line string: the current line
---@param picker table: the current picker object
---@return string: the previous history item
function histories.History:get_prev(line, picker)
  if not self.enabled then
    utils.notify("History:get_prev", {
      msg = "You are cycling to next the history item but history is disabled. Read ':help telescope.defaults.history'",
      level = "WARN",
    })
    return false
  end
  if self._pre_get then
    self._pre_get(self, line, picker)
  end

  local next_idx = self.index - 1
  if self.index == #self.content + 1 then
    if line ~= "" then
      self:append(line, picker, true)
    end
  end
  if next_idx >= 1 then
    self.index = next_idx
    return self.content[next_idx]
  end
  return nil
end

--- A simple implementation of history.
---
--- It will keep one unified history across all pickers.
histories.get_simple_history = function()
  return histories.new {
    init = function(obj)
      local p = Path:new(obj.path)
      if not p:exists() then
        p:touch { parents = true }
      end

      obj.content = Path:new(obj.path):readlines()
      obj.index = #obj.content
      table.remove(obj.content, obj.index)
    end,
    reset = function(self)
      self.index = #self.content + 1
    end,
    append = function(self, line, _, no_reset)
      if line ~= "" then
        if self.content[#self.content] ~= line then
          table.insert(self.content, line)

          local len = #self.content
          if self.limit and len > self.limit then
            local diff = len - self.limit
            for i = diff, 1, -1 do
              table.remove(self.content, i)
            end
            write_async(self.path, table.concat(self.content, "\n") .. "\n", "w")
          else
            append_async(self.path, line .. "\n")
          end
        end
      end
      if not no_reset then
        self:reset()
      end
    end,
  }
end

return histories
