local Path = require "plenary.path"
local utils = require "telescope.utils"

local eq = assert.are.equal

describe("path_expand()", function()
  it("removes trailing os_sep", function()
    if utils.iswin then
      eq([[C:\Users\a\b]], utils.path_expand [[C:\Users\a\b\]])
    else
      eq("/home/user", utils.path_expand "/home/user/")
    end
  end)

  it("works with root dir", function()
    if utils.iswin then
      eq([[C:\]], utils.path_expand [[C:\]])
    else
      eq("/", utils.path_expand "/")
    end
  end)

  it("works with ~", function()
    eq(vim.loop.os_homedir() .. "/src/foo", utils.path_expand "~/src/foo")
  end)

  it("handles duplicate os_sep", function()
    if utils.iswin then
      eq([[C:\Users\a]], utils.path_expand [[C:\\\Users\\a]])
    else
      eq("/home/user", utils.path_expand "/home///user")
    end
  end)

  it("preserves fake whitespace characters and whitespace", function()
    local path_space = "/home/user/hello world"
    eq(path_space, utils.path_expand(path_space))
    local path_newline = [[/home/user/hello\nworld]]
    eq(path_newline, utils.path_expand(path_newline))
  end)
  describe("early return for uri", function()
    local uris = {
      [[https://www.example.com/index.html]],
      [[ftp://ftp.example.com/files/document.pdf]],
      [[mailto:user@example.com]],
      [[tel:+1234567890]],
      [[file:///home/user/documents/report.docx]],
      [[news:comp.lang.python]],
      [[ldap://ldap.example.com:389/dc=example,dc=com]],
      [[git://github.com/user/repo.git]],
      [[steam://run/123456]],
      [[magnet:?xt=urn:btih:6B4C3343E1C63A1BC36AEB8A3D1F52C4EDEEB096]],
    }

    for _, uri in ipairs(uris) do
      it(uri, function()
        eq(uri, utils.path_expand(uri))
      end)
    end
  end)
end)

describe("is_uri", function()
  describe("detects valid uris", function()
    local uris = {
      [[https://www.example.com/index.html]],
      [[ftp://ftp.example.com/files/document.pdf]],
      [[mailto:user@example.com]],
      [[tel:+1234567890]],
      [[file:///home/user/documents/report.docx]],
      [[news:comp.lang.python]],
      [[ldap://ldap.example.com:389/dc=example,dc=com]],
      [[git://github.com/user/repo.git]],
      [[steam://run/123456]],
      [[magnet:?xt=urn:btih:6B4C3343E1C63A1BC36AEB8A3D1F52C4EDEEB096]],
    }

    for _, uri in ipairs(uris) do
      it(uri, function()
        assert.True(utils.is_uri(uri))
      end)
    end
  end)

  describe("detects invalid uris/paths", function()
    local inputs = {
      "hello",
      "hello:",
      "123",
      "",
    }
    for _, input in ipairs(inputs) do
      it(input, function()
        assert.False(utils.is_uri(input))
      end)
    end
  end)

  describe("handles windows paths", function()
    local paths = {
      [[C:\Users\Usuario\Documents\archivo.txt]],
      [[D:\Projects\project_folder\source_code.py]],
      [[E:\Music\song.mp3]],
    }

    for _, uri in ipairs(paths) do
      it(uri, function()
        assert.False(utils.is_uri(uri))
      end)
    end
  end)

  describe("handles linux paths", function()
    local paths = {
      [[/home/usuario/documents/archivo.txt]],
      [[/var/www/html/index.html]],
      [[/mnt/backup/backup_file.tar.gz]],
    }

    for _, path in ipairs(paths) do
      it(path, function()
        assert.False(utils.is_uri(path))
      end)
    end
  end)

  describe("handles macos paths", function()
    local paths = {
      [[/Users/Usuario/Documents/archivo.txt]],
      [[/Applications/App.app/Contents/MacOS/app_executable]],
      [[/Volumes/ExternalDrive/Data/file.xlsx]],
    }

    for _, path in ipairs(paths) do
      it(path, function()
        assert.False(utils.is_uri(path))
      end)
    end
  end)
end)

describe("transform_path", function()
  local cwd = (function()
    if utils.iswin then
      return [[C:\Users\user\projects\telescope.nvim]]
    else
      return "/home/user/projects/telescope.nvim"
    end
  end)()

  local function new_relpath(unix_path)
    return Path:new(unpack(vim.split(unix_path, "/"))).filename
  end

  local function assert_path(path_display, path, expect)
    local opts = { cwd = cwd, __length = 15 }
    if type(path_display) == "string" then
      opts.path_display = { path_display }
      eq(expect, utils.transform_path(opts, path))
      opts.path_display = { [path_display] = true }
      eq(expect, utils.transform_path(opts, path))
    elseif type(path_display) == "table" then
      opts.path_display = path_display
      eq(expect, utils.transform_path(opts, path))
    elseif path_display == nil then
      eq(expect, utils.transform_path(opts, path))
    end
  end

  it("handles nil path", function()
    assert_path(nil, nil, "")
  end)

  it("returns back uri", function()
    local uri = [[https://www.example.com/index.html]]
    assert_path(nil, uri, uri)
  end)

  it("handles 'hidden' path_display", function()
    eq("", utils.transform_path({ cwd = cwd, path_display = "hidden" }, "foobar"))
    assert_path("hidden", "foobar", "")
  end)

  it("returns relative path for default opts", function()
    local relative = Path:new { "lua", "telescope", "init.lua" }
    local absolute = Path:new { cwd, relative }
    assert_path(nil, absolute.filename, relative.filename)
    assert_path(nil, relative.filename, relative.filename)
  end)

  it("handles 'tail' path_display", function()
    local path = new_relpath "lua/telescope/init.lua"
    assert_path("tail", path, "init.lua")
  end)

  it("handles 'smart' path_display", function()
    local path1 = new_relpath "lua/telescope/init.lua"
    local path2 = new_relpath "lua/telescope/finders.lua"
    local path3 = new_relpath "lua/telescope/finders/async_job_finder.lua"
    local path4 = new_relpath "plugin/telescope.lua"

    assert_path("smart", path1, path1)
    assert_path("smart", path2, new_relpath "../telescope/finders.lua")
    assert_path("smart", path3, new_relpath "../telescope/finders/async_job_finder.lua")
    assert_path("smart", path4, path4)
  end)

  it("handles 'absolute' path_display", function()
    local relative = Path:new { "lua", "telescope", "init.lua" }
    local absolute = Path:new { cwd, relative }

    -- TODO: feels like 'absolute' should turn relative paths to absolute
    -- assert_path("absolute", relative.filename, absolute.filename)
    assert_path("absolute", absolute.filename, absolute.filename)
  end)

  it("handles default 'shorten' path_display", function()
    assert_path("shorten", new_relpath "lua/telescope/init.lua", new_relpath "l/t/init.lua")
  end)

  it("handles 'shorten' with number", function()
    assert_path({ shorten = 2 }, new_relpath "lua/telescope/init.lua", new_relpath "lu/te/init.lua")
  end)

  it("handles 'shorten' with option table", function()
    assert_path({ shorten = { len = 2 } }, new_relpath "lua/telescope/init.lua", new_relpath "lu/te/init.lua")
    assert_path(
      { shorten = { len = 2, exclude = { 1, 3, -1 } } },
      new_relpath "lua/telescope/builtin/init.lua",
      new_relpath "lua/te/builtin/init.lua"
    )
  end)

  it("handles default 'truncate' path_display", function()
    assert_path({ "truncate" }, new_relpath "lua/telescope/init.lua", new_relpath "…scope/init.lua")
  end)
end)
