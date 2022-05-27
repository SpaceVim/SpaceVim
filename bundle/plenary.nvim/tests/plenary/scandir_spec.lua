local scan = require "plenary.scandir"
local mock = require "luassert.mock"
local stub = require "luassert.stub"
local eq = assert.are.same

local contains = function(tbl, str)
  for _, v in ipairs(tbl) do
    if v == str then
      return true
    end
  end
  return false
end

local contains_match = function(tbl, str)
  for _, v in ipairs(tbl) do
    if v:match(str) then
      return true
    end
  end
  return false
end

describe("scandir", function()
  describe("can list all files recursive", function()
    it("with cwd", function()
      local dirs = scan.scan_dir "."
      eq("table", type(dirs))
      eq(true, contains(dirs, "./CHANGELOG.md"))
      eq(true, contains(dirs, "./LICENSE"))
      eq(true, contains(dirs, "./lua/plenary/job.lua"))
      eq(false, contains(dirs, "./asdf/asdf/adsf.lua"))
    end)

    it("and callback gets called for each entry", function()
      local count = 0
      local dirs = scan.scan_dir(".", {
        on_insert = function()
          count = count + 1
        end,
      })
      eq("table", type(dirs))
      eq(true, contains(dirs, "./CHANGELOG.md"))
      eq(true, contains(dirs, "./LICENSE"))
      eq(true, contains(dirs, "./lua/plenary/job.lua"))
      eq(false, contains(dirs, "./asdf/asdf/adsf.lua"))
      eq(count, #dirs)
    end)

    it("with multiple paths", function()
      local dirs = scan.scan_dir { "./lua", "./tests" }
      eq("table", type(dirs))
      eq(true, contains(dirs, "./lua/say.lua"))
      eq(true, contains(dirs, "./lua/plenary/job.lua"))
      eq(true, contains(dirs, "./tests/plenary/scandir_spec.lua"))
      eq(false, contains(dirs, "./asdf/asdf/adsf.lua"))
    end)

    it("with hidden files", function()
      local dirs = scan.scan_dir(".", { hidden = true })
      eq("table", type(dirs))
      eq(true, contains(dirs, "./CHANGELOG.md"))
      eq(true, contains(dirs, "./lua/plenary/job.lua"))
      eq(true, contains(dirs, "./.gitignore"))
      eq(false, contains(dirs, "./asdf/asdf/adsf.lua"))
    end)

    it("with add directories", function()
      local dirs = scan.scan_dir(".", { add_dirs = true })
      eq("table", type(dirs))
      eq(true, contains(dirs, "./CHANGELOG.md"))
      eq(true, contains(dirs, "./lua/plenary/job.lua"))
      eq(true, contains(dirs, "./lua"))
      eq(true, contains(dirs, "./tests"))
      eq(false, contains(dirs, "./asdf/asdf/adsf.lua"))
    end)

    it("with only directories", function()
      local dirs = scan.scan_dir(".", { only_dirs = true })
      eq("table", type(dirs))
      eq(false, contains(dirs, "./CHANGELOG.md"))
      eq(false, contains(dirs, "./lua/plenary/job.lua"))
      eq(true, contains(dirs, "./lua"))
      eq(true, contains(dirs, "./tests"))
      eq(false, contains(dirs, "./asdf/asdf/adsf.lua"))
    end)

    it("until depth 1 is reached", function()
      local dirs = scan.scan_dir(".", { depth = 1 })
      eq("table", type(dirs))
      eq(true, contains(dirs, "./CHANGELOG.md"))
      eq(true, contains(dirs, "./README.md"))
      eq(false, contains(dirs, "./lua"))
      eq(false, contains(dirs, "./lua/say.lua"))
      eq(false, contains(dirs, "./lua/plenary/job.lua"))
      eq(false, contains(dirs, "./asdf/asdf/adsf.lua"))
    end)

    it("until depth 1 is reached and with directories", function()
      local dirs = scan.scan_dir(".", { depth = 1, add_dirs = true })
      eq("table", type(dirs))
      eq(true, contains(dirs, "./CHANGELOG.md"))
      eq(true, contains(dirs, "./README.md"))
      eq(true, contains(dirs, "./lua"))
      eq(false, contains(dirs, "./lua/say.lua"))
      eq(false, contains(dirs, "./lua/plenary/job.lua"))
      eq(false, contains(dirs, "./asdf/asdf/adsf.lua"))
    end)

    it("until depth 2 is reached", function()
      local dirs = scan.scan_dir(".", { depth = 2 })
      eq("table", type(dirs))
      eq(true, contains(dirs, "./CHANGELOG.md"))
      eq(true, contains(dirs, "./README.md"))
      eq(true, contains(dirs, "./lua/say.lua"))
      eq(false, contains(dirs, "./lua/plenary/job.lua"))
      eq(false, contains(dirs, "./asdf/asdf/adsf.lua"))
    end)

    it("with respect_gitignore", function()
      vim.cmd ":silent !touch lua/test.so"
      local dirs = scan.scan_dir(".", { respect_gitignore = true })
      vim.cmd ":silent !rm lua/test.so"
      eq("table", type(dirs))
      eq(true, contains(dirs, "./CHANGELOG.md"))
      eq(true, contains(dirs, "./LICENSE"))
      eq(true, contains(dirs, "./lua/plenary/job.lua"))
      eq(false, contains(dirs, "./lua/test.so"))
      eq(false, contains(dirs, "./asdf/asdf/adsf.lua"))
    end)

    it("with search pattern", function()
      local dirs = scan.scan_dir(".", { search_pattern = "filetype" })
      eq("table", type(dirs))
      eq(true, contains(dirs, "./scripts/update_filetypes_from_github.lua"))
      eq(true, contains(dirs, "./lua/plenary/filetype.lua"))
      eq(true, contains(dirs, "./tests/plenary/filetype_spec.lua"))
      eq(true, contains(dirs, "./data/plenary/filetypes/base.lua"))
      eq(true, contains(dirs, "./data/plenary/filetypes/builtin.lua"))
      eq(false, contains(dirs, "./README.md"))
    end)

    it("with callback search pattern", function()
      local dirs = scan.scan_dir(".", {
        search_pattern = function(entry)
          return entry:match "filetype"
        end,
      })
      eq("table", type(dirs))
      eq(true, contains(dirs, "./scripts/update_filetypes_from_github.lua"))
      eq(true, contains(dirs, "./lua/plenary/filetype.lua"))
      eq(true, contains(dirs, "./tests/plenary/filetype_spec.lua"))
      eq(true, contains(dirs, "./data/plenary/filetypes/base.lua"))
      eq(true, contains(dirs, "./data/plenary/filetypes/builtin.lua"))
      eq(false, contains(dirs, "./README.md"))
    end)
  end)

  describe("gitignore", function()
    local Path = require "plenary.path"
    local mock_path, mock_gitignore
    before_each(function()
      mock_path = {
        exists = stub.new().returns(true),
        iter = function()
          local i = 0
          local n = table.getn(mock_gitignore)
          return function()
            i = i + 1
            if i <= n then
              return mock_gitignore[i]
            end
          end
        end,
      }
      Path.new = stub.new().returns(mock_path)
    end)
    after_each(function()
      Path.new:revert()
    end)

    describe("ignores path", function()
      it("when path matches pattern exactly", function()
        mock_gitignore = { "ignored.txt" }
        local should_add = scan.__make_gitignore { "path" }
        eq(false, should_add({ "path" }, "./path/ignored.txt"))
      end)
      it("when path matches * pattern", function()
        mock_gitignore = { "*.txt" }
        local should_add = scan.__make_gitignore { "path" }
        eq(false, should_add({ "path" }, "./path/dir/ignored.txt"))
      end)
      it("when path matches leading ** pattern", function()
        mock_gitignore = { "**/ignored.txt" }
        local should_add = scan.__make_gitignore { "path" }
        eq(false, should_add({ "path" }, "./path/dir/subdir/ignored.txt"))
      end)
      it("when path matches trailing ** pattern", function()
        mock_gitignore = { "/dir/**" }
        local should_add = scan.__make_gitignore { "path" }
        eq(false, should_add({ "path" }, "./path/dir/subdir/ignored.txt"))
      end)
      it("when path matches ? pattern", function()
        mock_gitignore = { "ignore?.txt" }
        local should_add = scan.__make_gitignore { "path" }
        eq(false, should_add({ "path" }, "./path/ignored.txt"))
      end)
    end)

    describe("does not ignore path", function()
      it("when path does not match", function()
        mock_gitignore = { "ignored.txt" }
        local should_add = scan.__make_gitignore { "path" }
        eq(true, should_add({ "path" }, "./path/ok.txt"))
      end)
      it("when path is negated", function()
        mock_gitignore = { "*.txt", "!ok.txt" }
        local should_add = scan.__make_gitignore { "path" }
        eq(true, should_add({ "path" }, "./path/ok.txt"))
      end)
    end)
  end)

  describe("ls", function()
    it("works for cwd", function()
      local dirs = scan.ls "."
      eq("table", type(dirs))
      eq(true, contains_match(dirs, "CHANGELOG.md"))
      eq(true, contains_match(dirs, "LICENSE"))
      eq(true, contains_match(dirs, "README.md"))
      eq(true, contains_match(dirs, "lua"))
      eq(false, contains_match(dirs, "%.git$"))
    end)

    it("works for another directory", function()
      local dirs = scan.ls "./lua"
      eq("table", type(dirs))
      eq(true, contains_match(dirs, "luassert"))
      eq(true, contains_match(dirs, "plenary"))
      eq(true, contains_match(dirs, "say.lua"))
      eq(false, contains_match(dirs, "README.md"))
    end)

    it("works with opts.hidden for cwd", function()
      local dirs = scan.ls(".", { hidden = true })
      eq("table", type(dirs))
      eq(true, contains_match(dirs, "CHANGELOG.md"))
      eq(true, contains_match(dirs, "LICENSE"))
      eq(true, contains_match(dirs, "README.md"))
      eq(true, contains_match(dirs, "lua"))
      eq(true, contains_match(dirs, "%.git$"))
    end)
  end)
end)
