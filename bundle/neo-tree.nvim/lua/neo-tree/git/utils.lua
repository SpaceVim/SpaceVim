local Job = require("plenary.job")

local utils = require("neo-tree.utils")
local log = require("neo-tree.log")

local M = {}

M.get_repository_root = function(path, callback)
  local args = { "rev-parse", "--show-toplevel" }
  if utils.truthy(path) then
    args = { "-C", path, "rev-parse", "--show-toplevel" }
  end
  if type(callback) == "function" then
    Job:new({
      command = "git",
      args = args,
      enabled_recording = true,
      on_exit = function(self, code, _)
        if code ~= 0 then
          log.trace("GIT ROOT ERROR ", self:stderr_result())
          callback(nil)
          return
        end
        local git_root = self:result()[1]

        if utils.is_windows then
          git_root = utils.windowize_path(git_root)
        end

        log.trace("GIT ROOT for '", path, "' is '", git_root, "'")
        callback(git_root)
      end,
    }):start()
  else
    local ok, git_root = utils.execute_command({ "git", unpack(args) })
    if not ok then
      log.trace("GIT ROOT ERROR ", git_root)
      return nil
    end
    git_root = git_root[1]

    if utils.is_windows then
      git_root = utils.windowize_path(git_root)
    end

    log.trace("GIT ROOT for '", path, "' is '", git_root, "'")
    return git_root
  end
end

local convert_octal_char = function(octal)
  return string.char(tonumber(octal, 8))
end

M.octal_to_utf8 = function(text)
  -- git uses octal encoding for utf-8 filepaths, convert octal back to utf-8
  local success, converted = pcall(string.gsub, text, "\\([0-7][0-7][0-7])", convert_octal_char)
  if success then
    return converted
  else
    return text
  end
end

return M
