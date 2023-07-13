local vim = vim
local events = require("neo-tree.events")
local log = require("neo-tree.log")
local git = require("neo-tree.git")
local utils = require("neo-tree.utils")

local M = {}

local flags = {
  watch_entry = false,
  stat = false,
  recursive = false,
}

local watched = {}

local get_dot_git_folder = function(path, callback)
  if type(callback) == "function" then
    git.get_repository_root(path, function(git_root)
      if git_root then
        local git_folder = utils.path_join(git_root, ".git")
        local stat = vim.loop.fs_stat(git_folder)
        if stat and stat.type == "directory" then
          callback(git_folder, git_root)
        end
      else
        callback(nil, nil)
      end
    end)
  else
    local git_root = git.get_repository_root(path)
    if git_root then
      local git_folder = utils.path_join(git_root, ".git")
      local stat = vim.loop.fs_stat(git_folder)
      if stat and stat.type == "directory" then
        return git_folder, git_root
      end
    end
    return nil, nil
  end
end

M.show_watched = function()
  local items = {}
  for _, handle in pairs(watched) do
    items[handle.path] = handle.references
  end
  log.info("Watched Folders: ", vim.inspect(items))
end

---Watch a directory for changes to it's children. Not recursive.
---@param path string The directory to watch.
---@param custom_callback? function The callback to call when a change is detected.
---@param allow_git_watch? boolean Allow watching of git folders.
M.watch_folder = function(path, custom_callback, allow_git_watch)
  if not allow_git_watch then
    if path:find("/%.git$") or path:find("/%.git/") then
      -- git folders seem to throw off fs events constantly.
      log.debug("watch_folder(path): Skipping git folder: ", path)
      return
    end
  end
  local h = watched[path]
  if h == nil then
    log.trace("Starting new fs watch on: ", path)
    local callback = custom_callback
      or vim.schedule_wrap(function(err, fname)
        if fname and fname:match("^%.null[-]ls_.+") then
          -- null-ls temp file: https://github.com/jose-elias-alvarez/null-ls.nvim/pull/1075
          return
        end
        if err then
          log.error("file_event_callback: ", err)
          return
        end
        events.fire_event(events.FS_EVENT, { afile = path })
      end)
    h = {
      handle = vim.loop.new_fs_event(),
      path = path,
      references = 0,
      active = false,
      callback = callback,
    }
    watched[path] = h
    --w:start(path, flags, callback)
  else
    log.trace("Incrementing references for fs watch on: ", path)
  end
  h.references = h.references + 1
end

M.watch_git_index = function(path, async)
  local function watch_git_folder(git_folder, git_root)
    if git_folder then
      local git_event_callback = vim.schedule_wrap(function(err, fname)
        if fname and fname:match("^.+%.lock$") then
          return
        end
        if fname and fname:match("^%._null-ls_.+") then
          -- null-ls temp file: https://github.com/jose-elias-alvarez/null-ls.nvim/pull/1075
          return
        end
        if err then
          log.error("git_event_callback: ", err)
          return
        end
        events.fire_event(events.GIT_EVENT, { path = fname, repository = git_root })
      end)

      M.watch_folder(git_folder, git_event_callback, true)
    end
  end

  if async then
    get_dot_git_folder(path, watch_git_folder)
  else
    watch_git_folder(get_dot_git_folder(path))
  end
end

M.updated_watched = function()
  for path, w in pairs(watched) do
    if w.references > 0 then
      if not w.active then
        log.trace("References added for fs watch on: ", path, ", starting.")
        w.handle:start(path, flags, w.callback)
        w.active = true
      end
    else
      if w.active then
        log.trace("No more references for fs watch on: ", path, ", stopping.")
        w.handle:stop()
        w.active = false
      end
    end
  end
end

---Stop watching a directory. If there are no more references to the handle,
---it will be destroyed. Otherwise, the reference count will be decremented.
---@param path string The directory to stop watching.
M.unwatch_folder = function(path, callback_id)
  local h = watched[path]
  if h then
    log.trace("Decrementing references for fs watch on: ", path, callback_id)
    h.references = h.references - 1
  else
    log.trace("(unwatch_folder) No fs watch found for: ", path)
  end
end

M.unwatch_git_index = function(path, async)
  local function unwatch_git_folder(git_folder, _)
    if git_folder then
      M.unwatch_folder(git_folder)
    end
  end

  if async then
    get_dot_git_folder(path, unwatch_git_folder)
  else
    unwatch_git_folder(get_dot_git_folder(path))
  end
end

---Stop watching all directories. This is the nuclear option and it affects all
---sources.
M.unwatch_all = function()
  for _, h in pairs(watched) do
    h.handle:stop()
    h.handle = nil
  end
  watched = {}
end

return M
