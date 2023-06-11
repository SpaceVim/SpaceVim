local uv = require('luv')
local Async = require('cmp_dictionary.kit.Async')

local is_windows = uv.os_uname().sysname:lower() == 'windows'

---@see https://github.com/luvit/luvit/blob/master/deps/fs.lua
local IO = {}

---@class cmp_dictionary.kit.IO.UV.Stat
---@field public dev integer
---@field public mode integer
---@field public nlink integer
---@field public uid integer
---@field public gid integer
---@field public rdev integer
---@field public ino integer
---@field public size integer
---@field public blksize integer
---@field public blocks integer
---@field public flags integer
---@field public gen integer
---@field public atime { sec: integer, nsec: integer }
---@field public mtime { sec: integer, nsec: integer }
---@field public ctime { sec: integer, nsec: integer }
---@field public birthtime { sec: integer, nsec: integer }
---@field public type string

---@enum cmp_dictionary.kit.IO.UV.AccessMode
IO.AccessMode = {
  r = 'r',
  rs = 'rs',
  sr = 'sr',
  ['r+'] = 'r+',
  ['rs+'] = 'rs+',
  ['sr+'] = 'sr+',
  w = 'w',
  wx = 'wx',
  xw = 'xw',
  ['w+'] = 'w+',
  ['wx+'] = 'wx+',
  ['xw+'] = 'xw+',
  a = 'a',
  ax = 'ax',
  xa = 'xa',
  ['a+'] = 'a+',
  ['ax+'] = 'ax+',
  ['xa+'] = 'xa+',
}

---@enum cmp_dictionary.kit.IO.WalkStatus
IO.WalkStatus = {
  SkipDir = 1,
  Break = 2,
}

---@type fun(path: string): cmp_dictionary.kit.Async.AsyncTask
IO.fs_stat = Async.promisify(uv.fs_stat)

---@type fun(path: string): cmp_dictionary.kit.Async.AsyncTask
IO.fs_unlink = Async.promisify(uv.fs_unlink)

---@type fun(path: string): cmp_dictionary.kit.Async.AsyncTask
IO.fs_rmdir = Async.promisify(uv.fs_rmdir)

---@type fun(path: string, mode: integer): cmp_dictionary.kit.Async.AsyncTask
IO.fs_mkdir = Async.promisify(uv.fs_mkdir)

---@type fun(from: string, to: string, option?: { excl?: boolean, ficlone?: boolean, ficlone_force?: boolean }): cmp_dictionary.kit.Async.AsyncTask
IO.fs_copyfile = Async.promisify(uv.fs_copyfile)

---@type fun(path: string, flags: cmp_dictionary.kit.IO.UV.AccessMode, mode: integer): cmp_dictionary.kit.Async.AsyncTask
IO.fs_open = Async.promisify(uv.fs_open)

---@type fun(fd: userdata): cmp_dictionary.kit.Async.AsyncTask
IO.fs_close = Async.promisify(uv.fs_close)

---@type fun(fd: userdata, chunk_size: integer, offset?: integer): cmp_dictionary.kit.Async.AsyncTask
IO.fs_read = Async.promisify(uv.fs_read)

---@type fun(fd: userdata, content: string, offset?: integer): cmp_dictionary.kit.Async.AsyncTask
IO.fs_write = Async.promisify(uv.fs_write)

---@type fun(fd: userdata, offset: integer): cmp_dictionary.kit.Async.AsyncTask
IO.fs_ftruncate = Async.promisify(uv.fs_ftruncate)

---@type fun(path: string, chunk_size?: integer): cmp_dictionary.kit.Async.AsyncTask
IO.fs_opendir = Async.promisify(uv.fs_opendir, { callback = 2 })

---@type fun(fd: userdata): cmp_dictionary.kit.Async.AsyncTask
IO.fs_closedir = Async.promisify(uv.fs_closedir)

---@type fun(fd: userdata): cmp_dictionary.kit.Async.AsyncTask
IO.fs_readdir = Async.promisify(uv.fs_readdir)

---@type fun(path: string): cmp_dictionary.kit.Async.AsyncTask
IO.fs_scandir = Async.promisify(uv.fs_scandir)

---@type fun(path: string): cmp_dictionary.kit.Async.AsyncTask
IO.fs_realpath = Async.promisify(uv.fs_realpath)

---Return if the path is directory.
---@param path string
---@return cmp_dictionary.kit.Async.AsyncTask
function IO.is_directory(path)
  path = IO.normalize(path)
  return Async.run(function()
    return IO.fs_stat(path):catch(function()
      return {}
    end):await().type == 'directory'
  end)
end

---Read file.
---@param path string
---@param chunk_size? integer
---@return cmp_dictionary.kit.Async.AsyncTask
function IO.read_file(path, chunk_size)
  chunk_size = chunk_size or 1024
  return Async.run(function()
    local stat = IO.fs_stat(path):await()
    local fd = IO.fs_open(path, IO.AccessMode.r, tonumber('755', 8)):await()
    local ok, res = pcall(function()
      local chunks = {}
      local offset = 0
      while offset < stat.size do
        local chunk = IO.fs_read(fd, math.min(chunk_size, stat.size - offset), offset):await()
        if not chunk then
          break
        end
        table.insert(chunks, chunk)
        offset = offset + #chunk
      end
      return table.concat(chunks, ''):sub(1, stat.size - 1) -- remove EOF.
    end)
    IO.fs_close(fd):await()
    if not ok then
      error(res)
    end
    return res
  end)
end

---Write file.
---@param path string
---@param content string
---@param chunk_size? integer
function IO.write_file(path, content, chunk_size)
  chunk_size = chunk_size or 1024
  content = content .. '\n' -- add EOF.
  return Async.run(function()
    local fd = IO.fs_open(path, IO.AccessMode.w, tonumber('755', 8)):await()
    local ok, err = pcall(function()
      local offset = 0
      while offset < #content do
        local chunk = content:sub(offset + 1, offset + chunk_size)
        offset = offset + IO.fs_write(fd, chunk, offset):await()
      end
      IO.fs_ftruncate(fd, offset):await()
    end)
    IO.fs_close(fd):await()
    if not ok then
      error(err)
    end
  end)
end

---Create directory.
---@param path string
---@param mode integer
---@param option? { recursive?: boolean }
function IO.mkdir(path, mode, option)
  path = IO.normalize(path)
  option = option or {}
  option.recursive = option.recursive or false
  return Async.run(function()
    if not option.recursive then
      IO.fs_mkdir(path, mode):await()
    else
      local not_exists = {}
      local current = path
      while current ~= '/' do
        local stat = IO.fs_stat(current):catch(function() end):await()
        if stat then
          break
        end
        table.insert(not_exists, 1, current)
        current = IO.dirname(current)
      end
      for _, dir in ipairs(not_exists) do
        IO.fs_mkdir(dir, mode):await()
      end
    end
  end)
end

---Remove file or directory.
---@param start_path string
---@param option? { recursive?: boolean }
function IO.rm(start_path, option)
  start_path = IO.normalize(start_path)
  option = option or {}
  option.recursive = option.recursive or false
  return Async.run(function()
    local stat = IO.fs_stat(start_path):await()
    if stat.type == 'directory' then
      local children = IO.scandir(start_path):await()
      if not option.recursive and #children > 0 then
        error(('IO.rm: `%s` is a directory and not empty.'):format(start_path))
      end
      IO.walk(start_path, function(err, entry)
        if err then
          error('IO.rm: ' .. tostring(err))
        end
        if entry.type == 'directory' then
          IO.fs_rmdir(entry.path):await()
        else
          IO.fs_unlink(entry.path):await()
        end
      end, { postorder = true }):await()
    else
      IO.fs_unlink(start_path):await()
    end
  end)
end

---Copy file or directory.
---@param from any
---@param to any
---@param option? { recursive?: boolean }
---@return cmp_dictionary.kit.Async.AsyncTask
function IO.cp(from, to, option)
  from = IO.normalize(from)
  to = IO.normalize(to)
  option = option or {}
  option.recursive = option.recursive or false
  return Async.run(function()
    local stat = IO.fs_stat(from):await()
    if stat.type == 'directory' then
      if not option.recursive then
        error(('IO.cp: `%s` is a directory.'):format(from))
      end
      IO.walk(from, function(err, entry)
        if err then
          error('IO.cp: ' .. tostring(err))
        end
        local new_path = entry.path:gsub(vim.pesc(from), to)
        if entry.type == 'directory' then
          IO.mkdir(new_path, tonumber(stat.mode, 10), { recursive = true }):await()
        else
          IO.fs_copyfile(entry.path, new_path):await()
        end
      end):await()
    else
      IO.fs_copyfile(from, to):await()
    end
  end)
end

---Walk directory entries recursively.
---@param start_path string
---@param callback fun(err: string|nil, entry: { path: string, type: string }): cmp_dictionary.kit.IO.WalkStatus?
---@param option? { postorder?: boolean }
function IO.walk(start_path, callback, option)
  start_path = IO.normalize(start_path)
  option = option or {}
  option.postorder = option.postorder or false
  return Async.run(function()
    local function walk_pre(dir)
      local ok, iter_entries = pcall(function()
        return IO.iter_scandir(dir.path):await()
      end)
      if not ok then
        return callback(iter_entries, dir)
      end
      local status = callback(nil, dir)
      if status == IO.WalkStatus.SkipDir then
        return
      elseif status == IO.WalkStatus.Break then
        return status
      end
      for entry in iter_entries do
        if entry.type == 'directory' then
          if walk_pre(entry) == IO.WalkStatus.Break then
            return IO.WalkStatus.Break
          end
        else
          if callback(nil, entry) == IO.WalkStatus.Break then
            return IO.WalkStatus.Break
          end
        end
      end
    end

    local function walk_post(dir)
      local ok, iter_entries = pcall(function()
        return IO.iter_scandir(dir.path):await()
      end)
      if not ok then
        return callback(iter_entries, dir)
      end
      for entry in iter_entries do
        if entry.type == 'directory' then
          if walk_post(entry) == IO.WalkStatus.Break then
            return IO.WalkStatus.Break
          end
        else
          if callback(nil, entry) == IO.WalkStatus.Break then
            return IO.WalkStatus.Break
          end
        end
      end
      return callback(nil, dir)
    end

    if not IO.is_directory(start_path) then
      error(('IO.walk: `%s` is not a directory.'):format(start_path))
    end
    if option.postorder then
      walk_post({ path = start_path, type = 'directory' })
    else
      walk_pre({ path = start_path, type = 'directory' })
    end
  end)
end

---Scan directory entries.
---@param path string
---@return cmp_dictionary.kit.Async.AsyncTask
function IO.scandir(path)
  path = IO.normalize(path)
  return Async.run(function()
    local fd = IO.fs_scandir(path):await()
    local entries = {}
    while true do
      local name, type = uv.fs_scandir_next(fd)
      if not name then
        break
      end
      table.insert(entries, {
        type = type,
        path = IO.join(path, name),
      })
    end
    return entries
  end)
end

---Scan directory entries.
---@param path any
---@return cmp_dictionary.kit.Async.AsyncTask
function IO.iter_scandir(path)
  path = IO.normalize(path)
  return Async.run(function()
    local fd = IO.fs_scandir(path):await()
    return function()
      local name, type = uv.fs_scandir_next(fd)
      if name then
        return {
          type = type,
          path = IO.join(path, name),
        }
      end
    end
  end)
end

---Return normalized path.
---@param path string
---@return string
function IO.normalize(path)
  if is_windows then
    path = path:gsub('\\', '/')
  end

  -- remove trailing slash.
  if path:sub(-1) == '/' then
    path = path:sub(1, -2)
  end

  -- skip if the path already absolute.
  if IO.is_absolute(path) then
    return path
  end

  -- homedir.
  if path:sub(1, 1) == '~' then
    path = IO.join(uv.os_homedir(), path:sub(2))
  end

  -- absolute.
  if path:sub(1, 1) == '/' then
    return path:sub(-1) == '/' and path:sub(1, -2) or path
  end

  -- resolve relative path.
  local up = uv.cwd()
  up = up:sub(-1) == '/' and up:sub(1, -2) or up
  while true do
    if path:sub(1, 3) == '../' then
      path = path:sub(4)
      up = IO.dirname(up)
    elseif path:sub(1, 2) == './' then
      path = path:sub(3)
    else
      break
    end
  end
  return IO.join(up, path)
end

---Join the paths.
---@param base string
---@param path string
---@return string
function IO.join(base, path)
  if base:sub(-1) == '/' then
    base = base:sub(1, -2)
  end
  return base .. '/' .. path
end

---Return the path of the current working directory.
---@param path string
---@return string
function IO.dirname(path)
  if path:sub(-1) == '/' then
    path = path:sub(1, -2)
  end
  return (path:gsub('/[^/]+$', ''))
end

if is_windows then
  ---Return the path is absolute or not.
  ---@param path string
  ---@return boolean
  function IO.is_absolute(path)
    return path:sub(1, 1) == '/' or path:match('^%a://')
  end
else
  ---Return the path is absolute or not.
  ---@param path string
  ---@return boolean
  function IO.is_absolute(path)
    return path:sub(1, 1) == '/'
  end
end

return IO
