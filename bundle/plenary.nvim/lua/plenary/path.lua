--- Path.lua
---
--- Goal: Create objects that are extremely similar to Python's `Path` Objects.
--- Reference: https://docs.python.org/3/library/pathlib.html

local bit = require "plenary.bit"
local uv = vim.loop

local F = require "plenary.functional"

local S_IF = {
  -- S_IFDIR  = 0o040000  # directory
  DIR = 0x4000,
  -- S_IFREG  = 0o100000  # regular file
  REG = 0x8000,
}

local path = {}
path.home = vim.loop.os_homedir()

path.sep = (function()
  if jit then
    local os = string.lower(jit.os)
    if os == "linux" or os == "osx" or os == "bsd" then
      return "/"
    else
      return "\\"
    end
  else
    return package.config:sub(1, 1)
  end
end)()

path.root = (function()
  if path.sep == "/" then
    return function()
      return "/"
    end
  else
    return function(base)
      base = base or vim.loop.cwd()
      return base:sub(1, 1) .. ":\\"
    end
  end
end)()

path.S_IF = S_IF

local band = function(reg, value)
  return bit.band(reg, value) == reg
end

local concat_paths = function(...)
  return table.concat({ ... }, path.sep)
end

local function is_root(pathname)
  if path.sep == "\\" then
    return string.match(pathname, "^[A-Z]:\\?$")
  end
  return pathname == "/"
end

local _split_by_separator = (function()
  local formatted = string.format("([^%s]+)", path.sep)
  return function(filepath)
    local t = {}
    for str in string.gmatch(filepath, formatted) do
      table.insert(t, str)
    end
    return t
  end
end)()

local is_uri = function(filename)
  return string.match(filename, "^%w+://") ~= nil
end

local is_absolute = function(filename, sep)
  if sep == "\\" then
    return string.match(filename, "^[A-Z]:\\.*$")
  end
  return string.sub(filename, 1, 1) == sep
end

local function _normalize_path(filename, cwd)
  if is_uri(filename) then
    return filename
  end

  -- handles redundant `./` in the middle
  local redundant = path.sep .. "%." .. path.sep
  if filename:match(redundant) then
    filename = filename:gsub(redundant, path.sep)
  end

  local out_file = filename

  local has = string.find(filename, path.sep .. "..", 1, true) or string.find(filename, ".." .. path.sep, 1, true)

  if has then
    local parts = _split_by_separator(filename)

    local idx = 1
    local initial_up_count = 0

    repeat
      if parts[idx] == ".." then
        if idx == 1 then
          initial_up_count = initial_up_count + 1
        end
        table.remove(parts, idx)
        table.remove(parts, idx - 1)
        if idx > 1 then
          idx = idx - 2
        else
          idx = idx - 1
        end
      end
      idx = idx + 1
    until idx > #parts

    local prefix = ""
    if is_absolute(filename, path.sep) or #_split_by_separator(cwd) == initial_up_count then
      prefix = path.root(filename)
    end

    out_file = prefix .. table.concat(parts, path.sep)
  end

  return out_file
end

local clean = function(pathname)
  if is_uri(pathname) then
    return pathname
  end

  -- Remove double path seps, it's annoying
  pathname = pathname:gsub(path.sep .. path.sep, path.sep)

  -- Remove trailing path sep if not root
  if not is_root(pathname) and pathname:sub(-1) == path.sep then
    return pathname:sub(1, -2)
  end
  return pathname
end

-- S_IFCHR  = 0o020000  # character device
-- S_IFBLK  = 0o060000  # block device
-- S_IFIFO  = 0o010000  # fifo (named pipe)
-- S_IFLNK  = 0o120000  # symbolic link
-- S_IFSOCK = 0o140000  # socket file

---@class Path
local Path = {
  path = path,
}

local check_self = function(self)
  if type(self) == "string" then
    return Path:new(self)
  end

  return self
end

Path.__index = Path

-- TODO: Could use this to not have to call new... not sure
-- Path.__call = Path:new

Path.__div = function(self, other)
  assert(Path.is_path(self))
  assert(Path.is_path(other) or type(other) == "string")

  return self:joinpath(other)
end

Path.__tostring = function(self)
  return self.filename
end

-- TODO: See where we concat the table, and maybe we could make this work.
Path.__concat = function(self, other)
  return self.filename .. other
end

Path.is_path = function(a)
  return getmetatable(a) == Path
end

function Path:new(...)
  local args = { ... }

  if type(self) == "string" then
    table.insert(args, 1, self)
    self = Path
  end

  local path_input
  if #args == 1 then
    path_input = args[1]
  else
    path_input = args
  end

  -- If we already have a Path, it's fine.
  --   Just return it
  if Path.is_path(path_input) then
    return path_input
  end

  -- TODO: Should probably remove and dumb stuff like double seps, periods in the middle, etc.
  local sep = path.sep
  if type(path_input) == "table" then
    sep = path_input.sep or path.sep
    path_input.sep = nil
  end

  local path_string
  if type(path_input) == "table" then
    -- TODO: It's possible this could be done more elegantly with __concat
    --       But I'm unsure of what we'd do to make that happen
    local path_objs = {}
    for _, v in ipairs(path_input) do
      if Path.is_path(v) then
        table.insert(path_objs, v.filename)
      else
        assert(type(v) == "string")
        table.insert(path_objs, v)
      end
    end

    path_string = table.concat(path_objs, sep)
  else
    assert(type(path_input) == "string", vim.inspect(path_input))
    path_string = path_input
  end

  local obj = {
    filename = path_string,

    _sep = sep,

    -- Cached values
    _absolute = uv.fs_realpath(path_string),
    _cwd = uv.fs_realpath ".",
  }

  setmetatable(obj, Path)

  return obj
end

function Path:_fs_filename()
  return self:absolute() or self.filename
end

function Path:_stat()
  return uv.fs_stat(self:_fs_filename()) or {}
  -- local stat = uv.fs_stat(self:absolute())
  -- if not self._absolute then return {} end

  -- if not self._stat_result then
  --   self._stat_result =
  -- end

  -- return self._stat_result
end

function Path:_st_mode()
  return self:_stat().mode or 0
end

function Path:joinpath(...)
  return Path:new(self.filename, ...)
end

function Path:absolute()
  if self:is_absolute() then
    return _normalize_path(self.filename, self._cwd)
  else
    return _normalize_path(self._absolute or table.concat({ self._cwd, self.filename }, self._sep), self._cwd)
  end
end

function Path:exists()
  return not vim.tbl_isempty(self:_stat())
end

function Path:expand()
  if is_uri(self.filename) then
    return self.filename
  end

  -- TODO support windows
  local expanded
  if string.find(self.filename, "~") then
    expanded = string.gsub(self.filename, "^~", vim.loop.os_homedir())
  elseif string.find(self.filename, "^%.") then
    expanded = vim.loop.fs_realpath(self.filename)
    if expanded == nil then
      expanded = vim.fn.fnamemodify(self.filename, ":p")
    end
  elseif string.find(self.filename, "%$") then
    local rep = string.match(self.filename, "([^%$][^/]*)")
    local val = os.getenv(rep)
    if val then
      expanded = string.gsub(string.gsub(self.filename, rep, val), "%$", "")
    else
      expanded = nil
    end
  else
    expanded = self.filename
  end
  return expanded and expanded or error "Path not valid"
end

function Path:make_relative(cwd)
  if is_uri(self.filename) then
    return self.filename
  end

  self.filename = clean(self.filename)
  cwd = clean(F.if_nil(cwd, self._cwd, cwd))
  if self.filename == cwd then
    self.filename = "."
  else
    if cwd:sub(#cwd, #cwd) ~= path.sep then
      cwd = cwd .. path.sep
    end

    if self.filename:sub(1, #cwd) == cwd then
      self.filename = self.filename:sub(#cwd + 1, -1)
    end
  end

  return self.filename
end

function Path:normalize(cwd)
  if is_uri(self.filename) then
    return self.filename
  end

  self:make_relative(cwd)

  -- Substitute home directory w/ "~"
  -- string.gsub is not useful here because usernames with dashes at the end
  -- will be seen as a regexp pattern rather than a raw string
  local home = path.home
  if string.sub(path.home, -1) ~= path.sep then
    home = home .. path.sep
  end
  local start, finish = string.find(self.filename, home, 1, true)
  if start == 1 then
    self.filename = "~" .. path.sep .. string.sub(self.filename, (finish + 1), -1)
  end

  return _normalize_path(clean(self.filename), self._cwd)
end

local function shorten_len(filename, len, exclude)
  len = len or 1
  exclude = exclude or { -1 }
  local exc = {}

  -- get parts in a table
  local parts = {}
  local empty_pos = {}
  for m in (filename .. path.sep):gmatch("(.-)" .. path.sep) do
    if m ~= "" then
      parts[#parts + 1] = m
    else
      table.insert(empty_pos, #parts + 1)
    end
  end

  for _, v in pairs(exclude) do
    if v < 0 then
      exc[v + #parts + 1] = true
    else
      exc[v] = true
    end
  end

  local final_path_components = {}
  local count = 1
  for _, match in ipairs(parts) do
    if not exc[count] and #match > len then
      table.insert(final_path_components, string.sub(match, 1, len))
    else
      table.insert(final_path_components, match)
    end
    table.insert(final_path_components, path.sep)
    count = count + 1
  end

  local l = #final_path_components -- so that we don't need to keep calculating length
  table.remove(final_path_components, l) -- remove final slash

  -- add back empty positions
  for i = #empty_pos, 1, -1 do
    table.insert(final_path_components, empty_pos[i], path.sep)
  end

  return table.concat(final_path_components)
end

local shorten = (function()
  if jit and path.sep ~= "\\" then
    local ffi = require "ffi"
    ffi.cdef [[
    typedef unsigned char char_u;
    void shorten_dir(char_u *str);
    ]]
    return function(filename)
      if not filename or is_uri(filename) then
        return filename
      end

      local c_str = ffi.new("char[?]", #filename + 1)
      ffi.copy(c_str, filename)
      ffi.C.shorten_dir(c_str)
      return ffi.string(c_str)
    end
  end
  return function(filename)
    return shorten_len(filename, 1)
  end
end)()

function Path:shorten(len, exclude)
  assert(len ~= 0, "len must be at least 1")
  if (len and len > 1) or exclude ~= nil then
    return shorten_len(self.filename, len, exclude)
  end
  return shorten(self.filename)
end

function Path:mkdir(opts)
  opts = opts or {}

  local mode = opts.mode or 448 -- 0700 -> decimal
  local parents = F.if_nil(opts.parents, false, opts.parents)
  local exists_ok = F.if_nil(opts.exists_ok, true, opts.exists_ok)

  local exists = self:exists()
  if not exists_ok and exists then
    error("FileExistsError:" .. self:absolute())
  end

  -- fs_mkdir returns nil if folder exists
  if not uv.fs_mkdir(self:_fs_filename(), mode) and not exists then
    if parents then
      local dirs = self:_split()
      local processed = ""
      for _, dir in ipairs(dirs) do
        if dir ~= "" then
          local joined = concat_paths(processed, dir)
          if processed == "" and self._sep == "\\" then
            joined = dir
          end
          local stat = uv.fs_stat(joined) or {}
          local file_mode = stat.mode or 0
          if band(S_IF.REG, file_mode) then
            error(string.format("%s is a regular file so we can't mkdir it", joined))
          elseif band(S_IF.DIR, file_mode) then
            processed = joined
          else
            if uv.fs_mkdir(joined, mode) then
              processed = joined
            else
              error("We couldn't mkdir: " .. joined)
            end
          end
        end
      end
    else
      error "FileNotFoundError"
    end
  end

  return true
end

function Path:rmdir()
  if not self:exists() then
    return
  end

  uv.fs_rmdir(self:absolute())
end

function Path:rename(opts)
  opts = opts or {}
  if not opts.new_name or opts.new_name == "" then
    error "Please provide the new name!"
  end

  -- handles `.`, `..`, `./`, and `../`
  if opts.new_name:match "^%.%.?/?\\?.+" then
    opts.new_name = {
      uv.fs_realpath(opts.new_name:sub(1, 3)),
      opts.new_name:sub(4, #opts.new_name),
    }
  end

  local new_path = Path:new(opts.new_name)

  if new_path:exists() then
    error "File or directory already exists!"
  end

  local status = uv.fs_rename(self:absolute(), new_path:absolute())
  self.filename = new_path.filename

  return status
end

--- Copy files or folders with defaults akin to GNU's `cp`.
---@param opts table: options to pass to toggling registered actions
---@field destination string|Path: target file path to copy to
---@field recursive bool: whether to copy folders recursively (default: false)
---@field override bool: whether to override files (default: true)
---@field interactive bool: confirm if copy would override; precedes `override` (default: false)
---@field respect_gitignore bool: skip folders ignored by all detected `gitignore`s (default: false)
---@field hidden bool: whether to add hidden files in recursively copying folders (default: true)
---@field parents bool: whether to create possibly non-existing parent dirs of `opts.destination` (default: false)
---@field exists_ok bool: whether ok if `opts.destination` exists, if so folders are merged (default: true)
---@return table {[Path of destination]: bool} indicating success of copy; nested tables constitute sub dirs
function Path:copy(opts)
  opts = opts or {}
  opts.recursive = F.if_nil(opts.recursive, false, opts.recursive)
  opts.override = F.if_nil(opts.override, true, opts.override)

  local dest = opts.destination
  -- handles `.`, `..`, `./`, and `../`
  if not Path.is_path(dest) then
    if type(dest) == "string" and dest:match "^%.%.?/?\\?.+" then
      dest = {
        uv.fs_realpath(dest:sub(1, 3)),
        dest:sub(4, #dest),
      }
    end
    dest = Path:new(dest)
  end
  -- success is true in case file is copied, false otherwise
  local success = {}
  if not self:is_dir() then
    if opts.interactive and dest:exists() then
      vim.ui.select(
        { "Yes", "No" },
        { prompt = string.format("Overwrite existing %s?", dest:absolute()) },
        function(_, idx)
          success[dest] = uv.fs_copyfile(self:absolute(), dest:absolute(), { excl = not (idx == 1) }) or false
        end
      )
    else
      -- nil: not overriden if `override = false`
      success[dest] = uv.fs_copyfile(self:absolute(), dest:absolute(), { excl = not opts.override }) or false
    end
    return success
  end
  -- dir
  if opts.recursive then
    dest:mkdir {
      parents = F.if_nil(opts.parents, false, opts.parents),
      exists_ok = F.if_nil(opts.exists_ok, true, opts.exists_ok),
    }
    local scan = require "plenary.scandir"
    local data = scan.scan_dir(self.filename, {
      respect_gitignore = F.if_nil(opts.respect_gitignore, false, opts.respect_gitignore),
      hidden = F.if_nil(opts.hidden, true, opts.hidden),
      depth = 1,
      add_dirs = true,
    })
    for _, entry in ipairs(data) do
      local entry_path = Path:new(entry)
      local suffix = table.remove(entry_path:_split())
      local new_dest = dest:joinpath(suffix)
      -- clear destination as it might be Path table otherwise failing w/ extend
      opts.destination = nil
      local new_opts = vim.tbl_deep_extend("force", opts, { destination = new_dest })
      -- nil: not overriden if `override = false`
      success[new_dest] = entry_path:copy(new_opts) or false
    end
    return success
  else
    error(string.format("Warning: %s was not copied as `recursive=false`", self:absolute()))
  end
end

function Path:touch(opts)
  opts = opts or {}

  local mode = opts.mode or 420
  local parents = F.if_nil(opts.parents, false, opts.parents)

  if self:exists() then
    local new_time = os.time()
    uv.fs_utime(self:_fs_filename(), new_time, new_time)
    return
  end

  if parents then
    Path:new(self:parent()):mkdir { parents = true }
  end

  local fd = uv.fs_open(self:_fs_filename(), "w", mode)
  if not fd then
    error("Could not create file: " .. self:_fs_filename())
  end
  uv.fs_close(fd)

  return true
end

function Path:rm(opts)
  opts = opts or {}

  local recursive = F.if_nil(opts.recursive, false, opts.recursive)
  if recursive then
    local scan = require "plenary.scandir"
    local abs = self:absolute()

    -- first unlink all files
    scan.scan_dir(abs, {
      hidden = true,
      on_insert = function(file)
        uv.fs_unlink(file)
      end,
    })

    local dirs = scan.scan_dir(abs, { add_dirs = true, hidden = true })
    -- iterate backwards to clean up remaining dirs
    for i = #dirs, 1, -1 do
      uv.fs_rmdir(dirs[i])
    end

    -- now only abs is missing
    uv.fs_rmdir(abs)
  else
    uv.fs_unlink(self:absolute())
  end
end

-- Path:is_* {{{
function Path:is_dir()
  -- TODO: I wonder when this would be better, if ever.
  -- return self:_stat().type == 'directory'

  return band(S_IF.DIR, self:_st_mode())
end

function Path:is_absolute()
  return is_absolute(self.filename, self._sep)
end
-- }}}

function Path:_split()
  return vim.split(self:absolute(), self._sep)
end

local _get_parent = (function()
  local formatted = string.format("^(.+)%s[^%s]+", path.sep, path.sep)
  return function(abs_path)
    return abs_path:match(formatted)
  end
end)()

function Path:parent()
  return Path:new(_get_parent(self:absolute()) or path.root(self:absolute()))
end

function Path:parents()
  local results = {}
  local cur = self:absolute()
  repeat
    cur = _get_parent(cur)
    table.insert(results, cur)
  until not cur
  table.insert(results, path.root(self:absolute()))
  return results
end

function Path:is_file()
  local stat = uv.fs_stat(self:expand())
  if stat then
    return stat.type == "file" and true or nil
  end
end

-- TODO:
--  Maybe I can use libuv for this?
function Path:open() end

function Path:close() end

function Path:write(txt, flag, mode)
  assert(flag, [[Path:write_text requires a flag! For example: 'w' or 'a']])

  mode = mode or 438

  local fd = assert(uv.fs_open(self:expand(), flag, mode))
  assert(uv.fs_write(fd, txt, -1))
  assert(uv.fs_close(fd))
end

-- TODO: Asyncify this and use vim.wait in the meantime.
--  This will allow other events to happen while we're waiting!
function Path:_read()
  self = check_self(self)

  local fd = assert(uv.fs_open(self:expand(), "r", 438)) -- for some reason test won't pass with absolute
  local stat = assert(uv.fs_fstat(fd))
  local data = assert(uv.fs_read(fd, stat.size, 0))
  assert(uv.fs_close(fd))

  return data
end

function Path:_read_async(callback)
  vim.loop.fs_open(self.filename, "r", 438, function(err_open, fd)
    if err_open then
      print("We tried to open this file but couldn't. We failed with following error message: " .. err_open)
      return
    end
    vim.loop.fs_fstat(fd, function(err_fstat, stat)
      assert(not err_fstat, err_fstat)
      if stat.type ~= "file" then
        return callback ""
      end
      vim.loop.fs_read(fd, stat.size, 0, function(err_read, data)
        assert(not err_read, err_read)
        vim.loop.fs_close(fd, function(err_close)
          assert(not err_close, err_close)
          return callback(data)
        end)
      end)
    end)
  end)
end

function Path:read(callback)
  if callback then
    return self:_read_async(callback)
  end
  return self:_read()
end

function Path:head(lines)
  lines = lines or 10
  self = check_self(self)
  local chunk_size = 256

  local fd = uv.fs_open(self:expand(), "r", 438)
  if not fd then
    return
  end
  local stat = assert(uv.fs_fstat(fd))
  if stat.type ~= "file" then
    uv.fs_close(fd)
    return nil
  end

  local data = ""
  local index, count = 0, 0
  while count < lines and index < stat.size do
    local read_chunk = assert(uv.fs_read(fd, chunk_size, index))

    local i = 0
    for char in read_chunk:gmatch "." do
      if char == "\n" then
        count = count + 1
        if count >= lines then
          break
        end
      end
      index = index + 1
      i = i + 1
    end
    data = data .. read_chunk:sub(1, i)
  end
  assert(uv.fs_close(fd))

  -- Remove potential newline at end of file
  if data:sub(-1) == "\n" then
    data = data:sub(1, -2)
  end

  return data
end

function Path:tail(lines)
  lines = lines or 10
  self = check_self(self)
  local chunk_size = 256

  local fd = uv.fs_open(self:expand(), "r", 438)
  if not fd then
    return
  end
  local stat = assert(uv.fs_fstat(fd))
  if stat.type ~= "file" then
    uv.fs_close(fd)
    return nil
  end

  local data = ""
  local index, count = stat.size - 1, 0
  while count < lines and index > 0 do
    local real_index = index - chunk_size
    if real_index < 0 then
      chunk_size = chunk_size + real_index
      real_index = 0
    end

    local read_chunk = assert(uv.fs_read(fd, chunk_size, real_index))

    local i = #read_chunk
    while i > 0 do
      local char = read_chunk:sub(i, i)
      if char == "\n" then
        count = count + 1
        if count >= lines then
          break
        end
      end
      index = index - 1
      i = i - 1
    end
    data = read_chunk:sub(i + 1, #read_chunk) .. data
  end
  assert(uv.fs_close(fd))

  return data
end

function Path:readlines()
  self = check_self(self)

  local data = self:read()

  data = data:gsub("\r", "")
  return vim.split(data, "\n")
end

function Path:iter()
  local data = self:readlines()
  local i = 0
  local n = #data
  return function()
    i = i + 1
    if i <= n then
      return data[i]
    end
  end
end

function Path:readbyterange(offset, length)
  self = check_self(self)

  local fd = uv.fs_open(self:expand(), "r", 438)
  if not fd then
    return
  end
  local stat = assert(uv.fs_fstat(fd))
  if stat.type ~= "file" then
    uv.fs_close(fd)
    return nil
  end

  if offset < 0 then
    offset = stat.size + offset
    -- Windows fails if offset is < 0 even though offset is defined as signed
    -- http://docs.libuv.org/en/v1.x/fs.html#c.uv_fs_read
    if offset < 0 then
      offset = 0
    end
  end

  local data = ""
  while #data < length do
    local read_chunk = assert(uv.fs_read(fd, length - #data, offset))
    if #read_chunk == 0 then
      break
    end
    data = data .. read_chunk
    offset = offset + #read_chunk
  end

  assert(uv.fs_close(fd))

  return data
end

return Path
